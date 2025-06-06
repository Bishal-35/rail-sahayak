import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class WheelchairBookingInfoScreen extends StatefulWidget {
  final Map<String, dynamic> bookingData;

  const WheelchairBookingInfoScreen({super.key, required this.bookingData});

  @override
  _WheelchairBookingInfoScreenState createState() =>
      _WheelchairBookingInfoScreenState();
}

class _WheelchairBookingInfoScreenState
    extends State<WheelchairBookingInfoScreen> {
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
          .collection('wheelchair_bookings')
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
            "Are you sure you want to cancel your wheelchair booking?",
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
                      content: Text(
                        'Wheelchair booking successfully cancelled',
                      ),
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

  @override
  Widget build(BuildContext context) {
    final bookingId = widget.bookingData['doc_id'];
    final phoneNumber = widget.bookingData['phone'] ?? '';

    return Scaffold(
      appBar: AppBar(title: Text("Wheelchair Booking Information")),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('wheelchair_bookings')
            .doc(bookingId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          final data = snapshot.data!.data() as Map<String, dynamic>?;

          if (data == null) return Center(child: Text("No data found."));

          final currentStatus = data['status'] ?? 'Preparing';

          // Format the journey date
          String journeyDate = '';
          if (data['journeyDate'] != null) {
            final timestamp = data['journeyDate'] as Timestamp;
            final date = timestamp.toDate();
            journeyDate = "${date.day}/${date.month}/${date.year}";
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(height: 12),

                // Dynamic Status and Phone Call
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
                infoRow(Icons.person, "Name : ${data['name'] ?? ''}"),
                infoRow(Icons.phone, "Phone : ${data['phone'] ?? ''}"),
                infoRow(
                  Icons.confirmation_number,
                  "PNR : ${data['pnr'] ?? 'Not provided'}",
                ),
                infoRow(Icons.train, "Train : ${data['train'] ?? ''}"),
                infoRow(
                  Icons.airline_seat_recline_normal_outlined,
                  "Coach : ${data['coach'] ?? 'Not provided'}, Seat: ${data['seat'] ?? 'Not provided'}",
                ),
                infoRow(Icons.calendar_today, "Journey Date : $journeyDate"),
                infoRow(
                  Icons.access_time,
                  "Arrival Time : ${data['arrivalTime'] ?? ''}",
                ),
                infoRow(
                  Icons.location_on,
                  "Platform : ${data['platform'] ?? ''}",
                ),
                if (data['specialInstructions'] != null &&
                    data['specialInstructions'].toString().isNotEmpty)
                  infoRow(
                    Icons.notes,
                    "Special Instructions : ${data['specialInstructions']}",
                  ),
                infoRow(Icons.place, "Station : ${data['station'] ?? ''}"),
                SizedBox(height: 20),

                // Action Button based on Status
                if (currentStatus == 'pending')
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
                      onPressed: () => _updateStatus('Wheelchair Assigned'),
                      child: Text(
                        "Wheelchair Assigned",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                else if (currentStatus == 'Wheelchair Assigned')
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
