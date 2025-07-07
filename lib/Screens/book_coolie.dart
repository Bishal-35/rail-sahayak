import 'dart:async'; // Add this import for Timer
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookCoolie extends StatefulWidget {
  final String? selectedStation;

  const BookCoolie({super.key, this.selectedStation});

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
  void initState() {
    super.initState();
    // Initialize with the station passed from HomeScreen
    _selectedStation = widget.selectedStation;
  }

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
      // Removed "Platform No.4"
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

  // Add a method to generate unique bill numbers
  String _generateUniqueBillNo() {
    // Get current timestamp for uniqueness
    final now = DateTime.now();
    final timestamp = now.millisecondsSinceEpoch.toString();

    // Generate 4 random digits
    final random = timestamp.substring(timestamp.length - 4);

    // Create a formatted bill number with date components and random digits
    return 'RS${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-$random';
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

    print(message);

    final user = FirebaseAuth.instance.currentUser;

    try {
      setState(() {
        isLoading = true;
      });

      // Create a timeout to ensure loading state is reset
      bool operationCompleted = false;
      Timer(Duration(seconds: 20), () {
        if (!operationCompleted && isLoading) {
          print("Submit operation timed out - resetting UI");
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Network operation timed out. Please check your connection and try again.',
              ),
              backgroundColor: Colors.orange,
            ),
          );
        }
      });

      // Try to ensure all coolies have queue fields
      try {
        await _ensureAllCooliesHaveQueueFields();
      } catch (e) {
        print("Error ensuring queue fields: $e");
        // Continue anyway - this shouldn't block booking
      }

      print("Checking for available coolies...");

      try {
        // Try to find available coolies with proper queue ordering
        final QuerySnapshot availableCoolies = await FirebaseFirestore.instance
            .collection('coolie_list')
            .where('Available', isEqualTo: true)
            .orderBy('last_available_time')
            .limit(10)
            .get();

        print("Found ${availableCoolies.docs.length} available coolies");

        // If a coolie is available, use it
        if (availableCoolies.docs.isNotEmpty) {
          final DocumentSnapshot selectedCoolie = availableCoolies.docs.first;
          operationCompleted = true;
          await processBooking(
            selectedCoolie,
            FirebaseAuth.instance.currentUser,
          );
          return;
        }
      } catch (e) {
        print("Error finding available coolies: $e");
        // Continue to try other options
      }

      // Try to find coolies with expired availability
      try {
        print("Checking for coolies with expired status...");

        // Get coolies where Available=false
        final QuerySnapshot potentialCoolies = await FirebaseFirestore.instance
            .collection('coolie_list')
            .where('Available', isEqualTo: false)
            .limit(10)
            .get();

        // Manually filter for expired timeouts
        final now = Timestamp.now();
        final availableDocs = potentialCoolies.docs.where((doc) {
          final availableAt = doc['available_at'] as Timestamp?;
          return availableAt != null && availableAt.compareTo(now) < 0;
        }).toList();

        if (availableDocs.isNotEmpty) {
          print("Found coolie with expired timeout");
          final selectedDoc = availableDocs.first;

          // Update their status first
          await FirebaseFirestore.instance
              .collection('coolie_list')
              .doc(selectedDoc.id)
              .update({'Available': true, 'passenger_assigned': null});

          // Then proceed with booking
          operationCompleted = true;
          await processBooking(selectedDoc, FirebaseAuth.instance.currentUser);
          return;
        }
      } catch (e) {
        print("Error checking for expired coolies: $e");
        // Continue to final option
      }

      // Mark operation as completed even if we didn't find a coolie
      operationCompleted = true;

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
      print('Error details: $e');
      print('Stack trace: $stackTrace');

      // ALWAYS reset loading state on error
      setState(() {
        isLoading = false;
      });

      // Show appropriate error message
      String errorMessage = 'Failed to send request.';

      if (e is FirebaseException) {
        errorMessage = 'Firebase error: ${e.message}';
      } else if (e.toString().contains('network')) {
        errorMessage = 'Network error. Please check your connection.';
      } else {
        errorMessage = 'Error: ${e.toString()}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: Duration(seconds: 5),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Make sure all coolies have the required fields for queue management
  Future<void> _ensureAllCooliesHaveQueueFields() async {
    try {
      print("Ensuring all coolies have queue fields...");

      // Get all coolies
      final QuerySnapshot allCoolies = await FirebaseFirestore.instance
          .collection('coolie_list')
          .get();

      print("Found ${allCoolies.docs.length} total coolies in database");

      // For each coolie without last_available_time, add it
      for (var doc in allCoolies.docs) {
        if (doc.data() is Map<String, dynamic>) {
          final data = doc.data() as Map<String, dynamic>;

          // Ensure all required fields exist
          bool updateNeeded = false;
          Map<String, dynamic> updates = {};

          if (!data.containsKey('last_available_time')) {
            updateNeeded = true;
            // Generate a random time in the past few hours to distribute coolies
            final random = DateTime.now().subtract(
              Duration(minutes: doc.id.hashCode % 120),
            );
            updates['last_available_time'] = Timestamp.fromDate(random);
          }

          // Make sure name and phone exist and are not empty
          if (!data.containsKey('Name') ||
              data['Name'] == null ||
              data['Name'] == '') {
            updateNeeded = true;
            updates['Name'] = 'Sahayak ${doc.id.substring(0, 4)}';
          }

          if (!data.containsKey('Phone_number') ||
              data['Phone_number'] == null ||
              data['Phone_number'] == '') {
            updateNeeded = true;
            updates['Phone_number'] = '98765${doc.id.substring(0, 5)}';
          }

          if (!data.containsKey('Available')) {
            updateNeeded = true;
            updates['Available'] = true;
          }

          if (updateNeeded) {
            try {
              print("Updating coolie ${doc.id} with missing fields");
              await FirebaseFirestore.instance
                  .collection('coolie_list')
                  .doc(doc.id)
                  .update(updates);
            } catch (e) {
              // Just log and continue - don't let one update failure stop the process
              print("Failed to update coolie ${doc.id}: $e");
            }
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
    // Add a timeout for the whole process
    bool operationCompleted = false;

    // Create a timer to ensure we don't get stuck in a loading state
    Timer? timeoutTimer = Timer(Duration(seconds: 15), () {
      if (!operationCompleted) {
        print("Booking operation timed out - resetting UI");
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Operation timed out. Please try again.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    });

    try {
      final String coolieId = selectedCoolie.id;

      // Get coolie data with fallbacks for missing values
      final coolieData = selectedCoolie.data() as Map<String, dynamic>? ?? {};

      // Use null-aware operators to handle missing data gracefully
      String coolieName = coolieData['Name'] ?? 'Unknown Sahayak';
      String cooliePhone = coolieData['Phone_number'] ?? 'No Phone Number';
      String coolieBillNo = coolieData['Bill_no'] ?? _generateUniqueBillNo();

      print("Processing booking with coolie: $coolieName ($cooliePhone)");

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
        'bill_number': coolieBillNo,
        'status': 'Arriving at Your Location',
        'service_type': 'coolie', // Add service type for API
      };

      // Try to create the booking document with timeout handling
      final docRef = FirebaseFirestore.instance
          .collection('coolie_bookings')
          .doc();
      bookingData['doc_id'] = docRef.id;

      await docRef.set(bookingData);

      // Create a copy for API with serializable values
      Map<String, dynamic> apiBookingData = Map.from(bookingData);
      if (apiBookingData.containsKey('timestamp')) {
        apiBookingData.remove(
          'timestamp',
        ); // Remove server timestamp as it can't be serialized
      }

      // Send to API endpoint
      final response = await http.post(
        Uri.parse(
          'https://rail-sahayak-api-612894814147.us-central1.run.app/create',
        ),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(apiBookingData),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // API call successful
        print('Data successfully sent to API');
      } else {
        // API call failed but Firebase succeeded
        print('Warning: API call failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
        // Continue execution since Firebase succeeded
      }

      // Calculate timestamp for 30 minutes from now
      DateTime now = DateTime.now();
      DateTime availableAt = now.add(Duration(minutes: 30));

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

      // Create a new timer for this coolie
      _coolieTimers[coolieId] = Timer(Duration(minutes: 30), () async {
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
            await FirebaseFirestore.instance
                .collection('coolie_list')
                .doc(coolieId)
                .update({
                  'Available': true,
                  'passenger_assigned': null,
                  'last_available_time': Timestamp.now(),
                });
          }

          _coolieTimers.remove(coolieId);
        } catch (e) {
          print('Error updating coolie status: $e');
        }
      });

      // Mark operation as completed to prevent timeout handling
      operationCompleted = true;
      timeoutTimer?.cancel();

      setState(() {
        isLoading = false;
      });

      // Show success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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
    } catch (e) {
      // Cancel the timeout timer if there's an error
      timeoutTimer?.cancel();

      print('Error in processBooking: $e');
      // Always reset loading state on error
      setState(() {
        isLoading = false;
      });

      // Show error to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
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

            // Display selected station instead of dropdown
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.redAccent),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Station: ${_selectedStation ?? "Please select a station from home screen"}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (_selectedStation == null)
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Go Back'),
                    ),
                ],
              ),
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
                    controller: _trainNameNumberController,
                    decoration: InputDecoration(
                      border: borderStyle,
                      enabledBorder: borderStyle,
                      focusedBorder: borderStyle,
                      labelText: 'Train Name/Number',
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
                  backgroundColor: Colors.redAccent, // Always keep red color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.0,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Processing...',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                    : Text(
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
