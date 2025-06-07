// orders_page.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rail_sahayak/Screens/coolie_booking_info_screen.dart';
import 'package:rail_sahayak/Screens/wheelchair_booking_info_screen.dart';
import 'package:rail_sahayak/Screens/four_wheeler_booking_info_screen.dart';
import 'package:rail_sahayak/Screens/login_screen.dart';
import 'package:rail_sahayak/widgets/app_drawer.dart'; // Add import for AppDrawer

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const AppDrawer(), // Replace with AppDrawer component
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min, // This helps with centering
          children: const [
            Icon(Icons.bookmark, color: Colors.redAccent),
            SizedBox(width: 8),
            Text('My Bookings', style: TextStyle(color: Colors.black)),
          ],
        ),
        centerTitle: true, // Center the title in the AppBar
        iconTheme: const IconThemeData(color: Colors.black),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.redAccent,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.redAccent,
          tabs: [
            Tab(text: "Coolie Bookings"),
            Tab(text: "Wheelchair Bookings"),
            Tab(text: "4-Wheeler Bookings"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Coolie Bookings Tab
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('coolie_bookings')
                .where('id', isEqualTo: userId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());

              final bookings = snapshot.data!.docs;

              if (bookings.isEmpty) {
                return Center(child: Text("No coolie bookings found"));
              }

              return ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final data = bookings[index].data() as Map<String, dynamic>;
                  // Add the document ID to the data
                  data['doc_id'] = bookings[index].id;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              CoolieBookingInfoScreen(bookingData: data),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.orange),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Coolie Requested",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Status : ${data['status'] ?? 'Out to destination'}",
                              style: TextStyle(
                                color: data['status'] == 'Cancelled'
                                    ? Colors.red
                                    : Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text("Pickup : ${data['pickupPoint'] ?? 'N/A'}"),
                            Text("Drop : ${data['dropPoint'] ?? 'N/A'}"),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Icon(Icons.arrow_forward_ios),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),

          // Wheelchair Bookings Tab
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('wheelchair_bookings')
                .where('userId', isEqualTo: userId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());

              final bookings = snapshot.data!.docs;

              if (bookings.isEmpty) {
                return Center(child: Text("No wheelchair bookings found"));
              }

              return ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final data = bookings[index].data() as Map<String, dynamic>;
                  // Add the document ID to the data
                  data['doc_id'] = bookings[index].id;

                  // Format journey date
                  String formattedDate = '';
                  if (data['journeyDate'] != null) {
                    final timestamp = data['journeyDate'] as Timestamp;
                    final date = timestamp.toDate();
                    formattedDate = "${date.day}/${date.month}/${date.year}";
                  }

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              WheelchairBookingInfoScreen(bookingData: data),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.teal),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.accessible, color: Colors.teal),
                                SizedBox(width: 8),
                                Text(
                                  "Wheelchair Requested",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Status : ${data['status'] ?? 'Pending'}",
                              style: TextStyle(
                                color: data['status'] == 'Cancelled'
                                    ? Colors.red
                                    : Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text("Station: ${data['station'] ?? 'N/A'}"),
                            Text("Date: $formattedDate"),
                            Text("Platform: ${data['platform'] ?? 'N/A'}"),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Icon(Icons.arrow_forward_ios),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),

          // 4-Wheeler Cart Bookings Tab
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('fourwheeler_bookings')
                .where('userId', isEqualTo: userId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());

              final bookings = snapshot.data!.docs;

              if (bookings.isEmpty) {
                return Center(child: Text("No 4-wheeler cart bookings found"));
              }

              return ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final data = bookings[index].data() as Map<String, dynamic>;
                  // Add the document ID to the data
                  data['doc_id'] = bookings[index].id;

                  // Format journey date
                  String formattedDate = '';
                  if (data['journeyDate'] != null) {
                    final timestamp = data['journeyDate'] as Timestamp;
                    final date = timestamp.toDate();
                    formattedDate = "${date.day}/${date.month}/${date.year}";
                  }

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              FourWheelerBookingInfoScreen(bookingData: data),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.orange),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.electric_rickshaw,
                                  color: Colors.orange,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "4-Wheeler Cart Requested",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Status : ${data['status'] ?? 'Pending'}",
                              style: TextStyle(
                                color: data['status'] == 'Cancelled'
                                    ? Colors.red
                                    : Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text("Station: ${data['station'] ?? 'N/A'}"),
                            Text("Date: $formattedDate"),
                            Text("Platform: ${data['platform'] ?? 'N/A'}"),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Icon(Icons.arrow_forward_ios),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
