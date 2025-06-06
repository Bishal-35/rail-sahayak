import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class FourWheelerCart extends StatefulWidget {
  const FourWheelerCart({Key? key}) : super(key: key);

  @override
  State<FourWheelerCart> createState() => _FourWheelerCartState();
}

class _FourWheelerCartState extends State<FourWheelerCart> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pnrController = TextEditingController();
  final TextEditingController _trainController = TextEditingController();
  final TextEditingController _luggageCountController = TextEditingController();
  final TextEditingController _coachController = TextEditingController();
  final TextEditingController _seatController = TextEditingController();
  final TextEditingController _platformController = TextEditingController();
  final TextEditingController _specialInstructionsController =
      TextEditingController();

  String? _selectedStation;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isLoading = false;

  // List of stations - update with your actual station list
  final List<String> stations = ['Raipur', 'Durg'];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userData.exists && userData.data() != null) {
        Map<String, dynamic> data = userData.data() as Map<String, dynamic>;
        setState(() {
          _nameController.text = data['name'] ?? '';
          _phoneController.text = data['phone'] ?? '';
        });
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _bookFourWheelerCart() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          // Add the booking to Firestore
          DocumentReference docRef = await FirebaseFirestore.instance
              .collection('fourwheeler_bookings')
              .add({
                'userId': user.uid,
                'station': _selectedStation,
                'name': _nameController.text,
                'phone': _phoneController.text,
                'pnr': _pnrController.text,
                'train': _trainController.text,
                'luggageCount': _luggageCountController.text,
                'coach': _coachController.text,
                'seat': _seatController.text,
                'journeyDate': Timestamp.fromDate(_selectedDate),
                'arrivalTime': '${_selectedTime.hour}:${_selectedTime.minute}',
                'platform': _platformController.text,
                'specialInstructions': _specialInstructionsController.text,
                'status': 'pending',
                'createdAt': FieldValue.serverTimestamp(),
              });

          // Update the document with its own ID
          await docRef.update({'doc_id': docRef.id});

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('4-Wheeler Cart booked successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
              child: Icon(
                Icons.electric_rickshaw,
                color: Colors.white,
                size: 28,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '4-Wheeler Cart Service',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Book 4-Wheeler Cart for Passengers',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Station Selection
                    const Text('Select Station'),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        hintText: 'Select the station',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      icon: const Icon(Icons.arrow_drop_down),
                      isExpanded: true,
                      value: _selectedStation,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a station';
                        }
                        return null;
                      },
                      items: stations.map((station) {
                        return DropdownMenuItem(
                          value: station,
                          child: Text(station),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedStation = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Name and Phone fields in a row
                    Row(
                      children: [
                        // Full Name
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Full Name'),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  hintText: 'e.g. John Doe',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Phone Number
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Phone Number'),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _phoneController,
                                decoration: InputDecoration(
                                  hintText: 'e.g. 9876543210',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                ),
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your phone number';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // PNR and Train Number/Name - Responsive Layout
                    LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth > 600) {
                          // Wide screen - use Row layout
                          return Row(
                            children: [
                              // PNR Number
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('PNR Number (Optional)'),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      controller: _pnrController,
                                      decoration: InputDecoration(
                                        hintText: '10-digit PNR',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 14,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Train Number/Name
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Train Number / Name'),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      controller: _trainController,
                                      decoration: InputDecoration(
                                        hintText: 'e.g. 12345 / Express',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 14,
                                            ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter train number or name';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        } else {
                          // Narrow screen - use Column layout
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // PNR Number
                              const Text('PNR Number (Optional)'),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _pnrController,
                                decoration: InputDecoration(
                                  hintText: '10-digit PNR',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Train Number/Name
                              const Text('Train Number / Train Name'),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _trainController,
                                decoration: InputDecoration(
                                  hintText: 'e.g. 12345 / Rajdhani Express',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter train number or name';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // Coach and Seat Number in a row
                    Row(
                      children: [
                        // Coach Number
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Coach Number (Optional)'),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _coachController,
                                decoration: InputDecoration(
                                  hintText: 'e.g. S6',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Seat Number
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Seat Number (Optional)'),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _seatController,
                                decoration: InputDecoration(
                                  hintText: 'e.g. 32',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Luggage Count and Platform Number - Equal width with perfect alignment
                    Row(
                      children: [
                        // Number of Luggage Items
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Fixed height container for label
                              SizedBox(
                                height: 20,
                                child: const Text(
                                  'Number of Passengers',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 48,
                                child: TextFormField(
                                  controller: _luggageCountController,
                                  decoration: InputDecoration(
                                    hintText: 'e.g. 5',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter number of passengers';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Platform Number
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Fixed height container for label
                              SizedBox(
                                height: 20,
                                child: const Text(
                                  'Platform Number',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 48,
                                child: TextFormField(
                                  controller: _platformController,
                                  decoration: InputDecoration(
                                    hintText: 'e.g. 3A',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter platform number';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Date and Time in a row
                    Row(
                      children: [
                        // Date of Journey
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Date of Journey'),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () => _selectDate(context),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        DateFormat(
                                          'dd/MM/yyyy',
                                        ).format(_selectedDate),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const Icon(
                                        Icons.calendar_today,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Time of Arrival
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Time of Arrival'),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () => _selectTime(context),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _selectedTime.format(context),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const Icon(Icons.access_time, size: 20),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Special Instructions
                    const Text('Special Instructions (Optional)'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _specialInstructionsController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Any specific requests or information...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Book 4-Wheeler Cart Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _bookFourWheelerCart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Book 4-Wheeler Cart',
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
            ),
          ],
        ),
      ),
    );
  }
}
