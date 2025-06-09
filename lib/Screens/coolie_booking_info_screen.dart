import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class CoolieBookingInfoScreen extends StatefulWidget {
  final Map<String, dynamic> bookingData;

  const CoolieBookingInfoScreen({super.key, required this.bookingData});

  @override
  _CoolieBookingInfoScreenState createState() =>
      _CoolieBookingInfoScreenState();
}

class _CoolieBookingInfoScreenState extends State<CoolieBookingInfoScreen> {
  void _makePhoneCall(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.platformDefault);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _updateStatus(String newStatus) async {
    final bookingId = widget.bookingData['doc_id'];
    if (bookingId != null) {
      await FirebaseFirestore.instance
          .collection('coolie_bookings')
          .doc(bookingId)
          .update({'status': newStatus});
    }
  }

  void _showCancelConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            "Cancel Booking",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange,
            ),
          ),
          content: Text(
            "Are you sure you want to cancel your booking?",
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("No", style: TextStyle(color: Colors.black87)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _updateStatus('Cancelled').then((_) {
                  // Show confirmation that order status was updated
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Booking successfully cancelled'),
                      backgroundColor: Colors.deepOrange,
                      duration: Duration(seconds: 3),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                });
              },
              child: Text("Yes", style: TextStyle(color: Colors.white)),
            ),
          ],
          actionsPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
        );
      },
    );
  }

  Future<void> _checkAndUpdateBookingStatus(Map<String, dynamic> data) async {
    final bookingId = widget.bookingData['doc_id'];
    final currentStatus = data['status'];

    // Only process if status isn't already complete or cancelled
    if (currentStatus != 'Service Complete' && currentStatus != 'Cancelled') {
      // Get the booking timestamp
      final Timestamp? bookingTimestamp = data['timestamp'] as Timestamp?;

      if (bookingTimestamp != null) {
        final bookingTime = bookingTimestamp.toDate();
        final currentTime = DateTime.now();

        // Check if 30 minutes have passed
        if (currentTime.difference(bookingTime).inMinutes >= 30) {
          // Auto-update to completed
          await FirebaseFirestore.instance
              .collection('coolie_bookings')
              .doc(bookingId)
              .update({'status': 'Service Complete'});
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingId = widget.bookingData['doc_id'];
    final phoneNumber = widget.bookingData['coolie_number'] ?? '';

    return Scaffold(
      appBar: AppBar(title: Text("Coolie Information")),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('coolie_bookings')
            .doc(bookingId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          final data = snapshot.data!.data() as Map<String, dynamic>?;

          if (data == null) return Center(child: Text("No data found."));

          // Check if booking is over 30 minutes old and update status if needed
          _checkAndUpdateBookingStatus(data);

          final currentStatus = data['status'] ?? 'Arriving at the Location';

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(height: 12),

                /// Dynamic Status and Phone Call
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "Status: $currentStatus",
                        style: TextStyle(
                          fontSize: 18,
                          color: currentStatus == 'Cancelled'
                              ? Colors.red
                              : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.call, color: Colors.black),
                      onPressed: () {
                        if (phoneNumber.isNotEmpty) {
                          _makePhoneCall(phoneNumber);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Phone number not available"),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),

                SizedBox(height: 12),
                infoRow(
                  Icons.person,
                  "Coolie Name : ${data['coolie_name'] ?? ''}",
                ),
                infoRow(
                  Icons.confirmation_number,
                  "Batch Id : ${data['batch_id'] ?? ''}",
                ),
                infoRow(
                  Icons.receipt,
                  "Bill Number: ${data['bill_number'] ?? ''}",
                ),
                infoRow(
                  Icons.phone,
                  "Phone Number: ${data['coolie_number'] ?? ''}",
                ),
                infoRow(
                  Icons.train,
                  "Coach Number : ${data['coachNumber'] ?? ''}",
                ),
                infoRow(
                  Icons.access_time,
                  "Booking Time : ${data['time'] ?? ''}",
                ),
                infoRow(
                  Icons.location_on,
                  "Pickup ${data['pickupPoint'] ?? ''}",
                ),
                infoRow(Icons.currency_rupee, "Amount : ${data['fee'] ?? ''}"),
                infoRow(
                  Icons.assignment,
                  "Service Request : ${data['Category'] ?? 'COOLIE'}",
                ),
                infoRow(
                  Icons.location_on_outlined,
                  "Drop Point : ${data['dropPoint'] ?? ''}",
                ),
                infoRow(Icons.line_weight, "Weight : ${data['weight'] ?? ''}"),
                // infoRow(
                //   Icons.confirmation_number_rounded,
                //   "Booking Id: ${data['id'] ?? ''}",
                // ),
                infoRow(
                  Icons.train,
                  "Train Name/Train Number: ${data['trainNameNumber'] ?? ''}",
                ),
                SizedBox(height: 20),

                /// Action Button based on Status
                if (currentStatus == 'Arriving at Your Location')
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => _updateStatus('Coolie Arrived'),
                      child: Text(
                        "Coolie Arrived",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                else if (currentStatus == 'Coolie Arrived')
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => _updateStatus('Service Complete'),
                      child: Text(
                        "Service Complete",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                else if (currentStatus == 'Service Complete')
                  Text('Service Completed'),
                SizedBox(height: 20),

                if (currentStatus != 'Service Complete' &&
                    currentStatus != 'Cancelled')
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => _showCancelConfirmationDialog(),
                      child: Text(
                        "Cancel Booking",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                if (currentStatus == 'Cancelled')
                  Center(
                    child: Text(
                      'Booking Cancelled',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 20),
          SizedBox(width: 8),
          Flexible(child: Text(text, style: TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
