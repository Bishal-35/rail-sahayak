import 'dart:async'; // Add this import for Timer
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class BookCoolie extends StatefulWidget {
  const BookCoolie({super.key});

  @override
  State<BookCoolie> createState() => _BookCoolieState();
}

class _BookCoolieState extends State<BookCoolie> {
  String? _selectedTime;
  final List<String> _stations = ["Raipur", "Durg"];
  String? _selectedStation;

  //init twilio

  bool isLoading = false;
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _numberOfCooliesController =
      TextEditingController(text: "1");
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _trainNameNumberController =
      TextEditingController(); // Merged field
  final TextEditingController _coachNumberController = TextEditingController();
  final TextEditingController _seatNumberController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  // Add a map to store active timers for coolies
  final Map<String, Timer> _coolieTimers = {};

  @override
  void dispose() {
    // Cancel all active timers when disposing the widget
    _coolieTimers.forEach((key, timer) {
      timer.cancel();
    });
    _coolieTimers.clear();

    _weightController.dispose();
    _numberOfCooliesController.dispose();
    _trainNameNumberController.dispose(); // Dispose merged controller
    _coachNumberController.dispose();
    _seatNumberController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  // Location lists for each station
  final Map<String, List<String>> _stationLocations = {
    "Raipur": [
      "Central Entrance Gate",
      "VIP Entrance gate",
      "A1 Entrance Gate",
      "Central Entry Gate PF-7 Side",
      "Platform No.1",
      "Platform No.2",
      "Platform No.3",
      "Platform No.4",
      "Platform No.5",
      "Platform No.6",
      "Platform No.7",
    ],
    "Durg": [
      "Main Entrance Gate",
      "Platform No.1",
      "Platform No.2",
      "Platform No.3",
      "Platform No.4",
      "Platform No.5",
      "Platform No.6",
    ],
  };

  // Get filtered locations based on selected station
  List<String> get _filteredLocations {
    if (_selectedStation == null) return [];
    return _stationLocations[_selectedStation] ?? [];
  }

  String? _pickupPoint;
  String? _dropPoint;
  int? _fee;

  void _onWeightChanged(String value) {
    if (value.isNotEmpty) {
      try {
        int weight = int.parse(value);
        _calculateFee();
      } catch (e) {
        setState(() {
          _fee = null;
        });
      }
    } else {
      setState(() {
        _fee = null;
      });
    }
  }

  void _onCoolieCountChanged(String value) {
    _calculateFee();
  }

  void _calculateFee() {
    if (_weightController.text.isNotEmpty) {
      try {
        int weight = int.parse(_weightController.text);
        int coolieCount = int.parse(
          _numberOfCooliesController.text.isEmpty
              ? "1"
              : _numberOfCooliesController.text,
        );

        setState(() {
          // Calculate fee: 100 Rs per 40 kg (or part thereof) multiplied by number of coolies
          int units = (weight / 40).ceil(); // Round up to handle partial units
          _fee = units * 100 * coolieCount;
        });
      } catch (e) {
        setState(() {
          _fee = null;
        });
      }
    } else {
      setState(() {
        _fee = null;
      });
    }
  }

  void _submitBooking() async {
    // Debug information to check values
    print("Pickup Point: $_pickupPoint");
    print("Drop Point: $_dropPoint");
    print("Station: $_selectedStation");
    print("Weight: ${_weightController.text}");
    print("Selected Time: $_selectedTime");
    print("Name: ${_nameController.text}");
    print(
      "Train Name/Number: ${_trainNameNumberController.text}",
    ); // Updated log
    print("Coach Number: ${_coachNumberController.text}");
    print("Seat Number: ${_seatNumberController.text}");
    print("Number of Coolies: ${_numberOfCooliesController.text}");

    // Add specific field checks to identify the missing field
    List<String> missingFields = [];

    if (_pickupPoint == null) missingFields.add("Pickup Point");
    if (_dropPoint == null) missingFields.add("Drop Point");
    if (_selectedStation == null) missingFields.add("Station");
    if (_weightController.text.isEmpty) missingFields.add("Weight");
    if (_selectedTime == null) missingFields.add("Time");
    if (_nameController.text.isEmpty) missingFields.add("Name");
    if (_trainNameNumberController.text.isEmpty)
      missingFields.add("Train Name/Number"); // Updated validation
    if (_coachNumberController.text.isEmpty) missingFields.add("Coach Number");
    if (_seatNumberController.text.isEmpty) missingFields.add("Seat Number");
    if (_numberOfCooliesController.text.isEmpty)
      missingFields.add("Number of Coolies");

    if (missingFields.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Missing fields: ${missingFields.join(", ")}'),
          duration: Duration(seconds: 5),
        ),
      );
      return;
    }

    String message =
        '''
      You have a Passenger:

      Pickup Point: $_pickupPoint
      Drop Point: $_dropPoint
      Time: $_selectedTime
      Train Name: ${_trainNameNumberController.text}
      Coach: ${_coachNumberController.text}
      Seat: ${_seatNumberController.text}
      Weight: ${_weightController.text} kg
      Fee: ₹$_fee
      ''';

    // TwilioResponse response = await twilioFlutter.sendSMS(
    //   toNumber: '+919560952125',
    //   messageBody: message,
    // );
    print(message);

    // TwilioResponse response = await twilioFlutter.sendSMS(
    //     toNumber: '+919560952125',
    //     messageBody:
    //         'You have a Passenger - Pickup Point:$_pickupPoint , Drop point: $_dropPoint at:_$_selectedTime, Train Number:${_trainNumberController.text}, Train name:${_trainNameController.text}, Fee:₹$_fee');
    // print(response.responseCode);

    // print('Twilio Response Code: ${response.responseCode}');
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('Request sent!')),
    // );
    final user = FirebaseAuth.instance.currentUser;

    // if (user != null) {
    //   user.uid;
    // }

    try {
      setState(() {
        isLoading = true;
      });

      // First ensure all coolies have the last_available_time field
      await _ensureAllCooliesHaveQueueFields();

      // Try to find available coolies with proper queue ordering
      final QuerySnapshot availableCoolies = await FirebaseFirestore.instance
          .collection('coolie_list')
          .where('Available', isEqualTo: true)
          .limit(10) // Get more coolies to see what's available
          .get();

      print("Found ${availableCoolies.docs.length} available coolies");

      // Log all available coolies for debugging
      availableCoolies.docs.forEach((doc) {
        print("Coolie ID: ${doc.id}, Name: ${doc['Name']}");
      });

      // If a coolie is available, use it
      if (availableCoolies.docs.isNotEmpty) {
        final DocumentSnapshot selectedCoolie = availableCoolies.docs.first;
        await processBooking(selectedCoolie, user);
        return;
      }

      // Option 2: If no explicitly available coolies, check for those with expired availability
      // But without using a composite index
      try {
        // Get coolies where Available=false (limit to a reasonable number to avoid large queries)
        final QuerySnapshot potentialCoolies = await FirebaseFirestore.instance
            .collection('coolie_list')
            .where('Available', isEqualTo: false)
            .limit(10)
            .get();

        // Manually filter the results on the client side
        final now = Timestamp.now();
        final availableDocs = potentialCoolies.docs.where((doc) {
          // Check if available_at exists and is in the past
          final availableAt = doc['available_at'] as Timestamp?;
          return availableAt != null &&
              availableAt.compareTo(now) <
                  0; // ← HERE: Checking if timeout has expired
        }).toList();

        if (availableDocs.isNotEmpty) {
          // Get the first coolie that's available
          final selectedDoc = availableDocs.first;

          // First update their status to Available=true since their timeout has expired
          await FirebaseFirestore.instance
              .collection('coolie_list')
              .doc(selectedDoc.id)
              .update({'Available': true, 'passenger_assigned': null});

          // Then proceed with booking
          await processBooking(selectedDoc, user);
          return;
        }
      } catch (innerError) {
        print('Error in second query: $innerError');
        // Continue to show the no coolies available message
      }

      // If we get here, no coolies are available
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No Sahayaks available at the moment.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } catch (e, stackTrace) {
      // Print detailed error information to the console for debugging
      print('Error details: $e');
      print('Stack trace: $stackTrace');

      // Set loading state to false
      setState(() {
        isLoading = false;
      });

      // Show a more informative error message
      String errorMessage = 'Failed to send request.';

      // Check for specific error types to provide better messages
      if (e is FirebaseException) {
        errorMessage = 'Firebase error: ${e.message}';
      } else if (e.toString().contains('network')) {
        // Check if the error message contains network-related text
        errorMessage = 'Network error. Please check your connection.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), duration: Duration(seconds: 5)),
      );
    }
  }

  // Make sure all coolies have the required fields for queue management
  Future<void> _ensureAllCooliesHaveQueueFields() async {
    try {
      // Get all coolies
      final QuerySnapshot allCoolies = await FirebaseFirestore.instance
          .collection('coolie_list')
          .get();

      // For each coolie without last_available_time, add it
      for (var doc in allCoolies.docs) {
        if (doc.data() is Map<String, dynamic>) {
          final data = doc.data() as Map<String, dynamic>;

          // If coolie doesn't have the queue field, add it with a random time
          // to distribute them in the queue
          if (!data.containsKey('last_available_time')) {
            // Generate a random time in the past few hours to distribute coolies
            final random = DateTime.now().subtract(
              Duration(minutes: doc.id.hashCode % 120),
            );

            await FirebaseFirestore.instance
                .collection('coolie_list')
                .doc(doc.id)
                .update({
                  'last_available_time': Timestamp.fromDate(random),
                  // Make sure Available is properly set
                  'Available': data['Available'] ?? true,
                });

            print("Added queue field to coolie ${doc.id}");
          }
        }
      }
    } catch (e) {
      print("Error initializing coolie queue fields: $e");
    }
  }

  // Helper method to process a booking with a selected coolie
  Future<void> processBooking(
    DocumentSnapshot selectedCoolie,
    User? user,
  ) async {
    final String coolieId = selectedCoolie.id;
    String coolieName = selectedCoolie['Name'];
    String cooliePhone = selectedCoolie['Phone_number'];
    String coolieBillNo = selectedCoolie['Bill_no'];

    Map<String, dynamic> bookingData = {
      'id': user?.uid,
      'pickupPoint': _pickupPoint,
      'dropPoint': _dropPoint,
      'time': _selectedTime.toString(),
      'name': _nameController.text,
      'trainNameNumber': _trainNameNumberController.text,
      'coachNumber': _coachNumberController.text,
      'seatNumber': _seatNumberController.text,
      'weight': _weightController.text,
      'numberOfCoolies': _numberOfCooliesController.text,
      'fee': _fee,
      'timestamp': FieldValue.serverTimestamp(),
      'coolie_assigned': coolieId,
      'coolie_name': coolieName,
      'coolie_number': cooliePhone,
      'coolie_bill_number': coolieBillNo,
      'status': 'Arriving at Your Location',
    };

    final docRef = FirebaseFirestore.instance
        .collection('coolie_bookings')
        .doc();
    bookingData['doc_id'] = docRef.id;

    await docRef.set(bookingData);

    // Calculate timestamp for 30 minutes from now
    DateTime now = DateTime.now();
    DateTime availableAt = now.add(
      Duration(minutes: 2), // Changed from 2 to 30 minutes
    );

    // Update coolie's document with available_at timestamp
    await FirebaseFirestore.instance
        .collection('coolie_list')
        .doc(coolieId)
        .update({
          'Available': false,
          'passenger_assigned': user?.uid,
          'available_at': Timestamp.fromDate(availableAt),
        });

    // Set a timer to update the coolie's status after the timeout period
    if (_coolieTimers.containsKey(coolieId)) {
      _coolieTimers[coolieId]?.cancel();
    }

    // Create a new timer - this is our simple client-side approach
    _coolieTimers[coolieId] = Timer(
      Duration(minutes: 2), // Set to 30 minutes
      () async {
        try {
          // First check if the coolie is still assigned to this booking
          final coolieDoc = await FirebaseFirestore.instance
              .collection('coolie_list')
              .doc(coolieId)
              .get();

          if (coolieDoc.exists &&
              coolieDoc['passenger_assigned'] == user?.uid) {
            // Only update if the coolie is still assigned to this user
            print(
              'Timer expired for coolie $coolieId - marking as available and adding to end of queue',
            );

            // When the timer expires, make the coolie available but put them at the end of the queue
            // by setting their 'last_available_time' to now
            await FirebaseFirestore.instance
                .collection('coolie_list')
                .doc(coolieId)
                .update({
                  'Available': true,
                  'passenger_assigned': null,
                  'last_available_time':
                      Timestamp.now(), // Current time to place at end of queue
                });
          }

          _coolieTimers.remove(coolieId);
        } catch (e) {
          print('Error updating coolie status: $e');
        }
      },
    );

    setState(() {
      isLoading = false;
    });

    // Show success dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 16),
            const Text(
              'Your Sahayak has been booked!',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 12),
            Text('Name: $coolieName'),
            Text('Phone Number: $cooliePhone'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.luggage, color: Colors.white, size: 28),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Book a Sahayak',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Let us help with your luggage',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color.fromARGB(255, 221, 221, 221),
                      fontWeight: FontWeight.w300,
                    ),
                    maxLines: 4,
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.redAccent,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(8.0),
          child: Container(
            height: 6.0,
            decoration: const BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
            ),
          ),
        ),

        // PREVIOUS APP BAR STYLE - Kept for reference
        // This was the original style before matching with wheelchair page
        /*
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Book a Sahayak',
          style: TextStyle(
            color: Colors.redAccent,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        */
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Fields with * are mandatory',
              style: TextStyle(color: Colors.red, fontSize: 14),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: 'Passenger Name',
                      border: borderStyle,
                      enabledBorder: borderStyle,
                      focusedBorder: borderStyle,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _selectedStation,
              decoration: InputDecoration(
                border: borderStyle,
                enabledBorder: borderStyle,
                focusedBorder: borderStyle,
                labelText: 'Select Station *',
              ),
              items: _stations
                  .map(
                    (station) =>
                        DropdownMenuItem(value: station, child: Text(station)),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedStation = value;
                  // Reset pickup and drop points when station changes
                  _pickupPoint = null;
                  _dropPoint = null;
                });
              },
            ),

            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _pickupPoint,
              decoration: InputDecoration(
                border: borderStyle,
                enabledBorder: borderStyle,
                focusedBorder: borderStyle,
                labelText: 'Select Pickup Point *',
              ),
              items: _filteredLocations
                  .where((loc) => loc != _dropPoint) // Filter out selected drop
                  .map(
                    (location) => DropdownMenuItem(
                      value: location,
                      child: Text(location),
                    ),
                  )
                  .toList(),
              onChanged: _selectedStation == null
                  ? null
                  : (value) {
                      setState(() {
                        _pickupPoint = value;
                        if (_pickupPoint == _dropPoint) _dropPoint = null;
                      });
                    },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _dropPoint,
              decoration: InputDecoration(
                border: borderStyle,
                enabledBorder: borderStyle,
                focusedBorder: borderStyle,
                labelText: 'Select Drop Point *',
              ),
              items: _filteredLocations
                  .where(
                    (loc) => loc != _pickupPoint,
                  ) // Filter out selected pickup
                  .map(
                    (location) => DropdownMenuItem(
                      value: location,
                      child: Text(location),
                    ),
                  )
                  .toList(),
              onChanged: _selectedStation == null
                  ? null
                  : (value) {
                      setState(() {
                        _dropPoint = value;
                        if (_pickupPoint == _dropPoint) _pickupPoint = null;
                      });
                    },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: 'Weight of Luggage (kg)',
                      border: borderStyle,
                      enabledBorder: borderStyle,
                      focusedBorder: borderStyle,
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.info_outline,
                          color: const Color.fromARGB(255, 252, 98, 98),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Price Structure'),
                                content: Text(
                                  'Each Sahayak (coolie) costs ₹100 per 40kg of luggage.\n\n'
                                  'For example:\n'
                                  '• 1-40kg with 1 Sahayak = ₹100\n'
                                  '• 41-80kg with 1 Sahayak = ₹200\n'
                                  '• 1-40kg with 2 Sahayaks = ₹200\n'
                                  '• 41-80kg with 2 Sahayaks = ₹400\n\n'
                                  'The total price will be calculated based on both weight and number of Sahayaks required.',
                                ),
                                actions: [
                                  TextButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                    onChanged: _onWeightChanged,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _numberOfCooliesController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: 'Number of Coolies Required',
                      border: borderStyle,
                      enabledBorder: borderStyle,
                      focusedBorder: borderStyle,
                    ),
                    onChanged: _onCoolieCountChanged,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller:
                        _trainNameNumberController, // Updated controller
                    decoration: InputDecoration(
                      border: borderStyle,
                      enabledBorder: borderStyle,
                      focusedBorder: borderStyle,
                      labelText: 'Train Name/Number', // Updated label
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _timeController,
                    readOnly: true, // Prevents keyboard from showing
                    decoration: InputDecoration(
                      border: borderStyle,
                      enabledBorder: borderStyle,
                      focusedBorder: borderStyle,
                      labelText: 'Select Time *',
                    ),
                    onTap: () async {
                      final TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        setState(() {
                          final hour = pickedTime.hourOfPeriod
                              .toString()
                              .padLeft(2, '0');
                          final minute = pickedTime.minute.toString().padLeft(
                            2,
                            '0',
                          );
                          final period = pickedTime.period == DayPeriod.am
                              ? 'AM'
                              : 'PM';
                          _timeController.text = '$hour:$minute $period';
                          _selectedTime = '$hour:$minute $period';
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _coachNumberController,
                    decoration: InputDecoration(
                      border: borderStyle,
                      enabledBorder: borderStyle,
                      focusedBorder: borderStyle,
                      labelText: 'Coach No.',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _seatNumberController,
                    decoration: InputDecoration(
                      border: borderStyle,
                      enabledBorder: borderStyle,
                      focusedBorder: borderStyle,
                      labelText: 'Seat No.',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Fee Calculated: ₹${_fee ?? "--"}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: isLoading ? null : _submitBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isLoading ? Colors.grey : Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
