// orders_page.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rail_sahayak/Screens/coolie_booking_info_screen.dart';
import 'package:rail_sahayak/Screens/wheelchair_booking_info_screen.dart';
import 'package:rail_sahayak/Screens/four_wheeler_booking_info_screen.dart';
import 'package:rail_sahayak/Screens/login_screen.dart';

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
      drawer: Drawer(
        elevation: 16.0,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.redAccent, Colors.red],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30,
                      child: Icon(
                        Icons.train,
                        color: Colors.redAccent,
                        size: 36,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Your RailSahayak',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Your rail travel assistant',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'MENU',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.info, color: Colors.redAccent),
                title: const Text(
                  'About Us',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onTap: () => Navigator.pop(context),
                tileColor: Colors.transparent,
                hoverColor: Colors.redAccent.withOpacity(0.1),
              ),
              const SizedBox(height: 5),
              ListTile(
                leading: const Icon(
                  Icons.currency_rupee,
                  color: Colors.redAccent,
                ),
                title: const Text(
                  'Pricing',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onTap: () => Navigator.pop(context),
                tileColor: Colors.transparent,
                hoverColor: Colors.redAccent.withOpacity(0.1),
              ),
              const SizedBox(height: 5),
              ListTile(
                leading: const Icon(Icons.cancel, color: Colors.redAccent),
                title: const Text(
                  'Cancellation',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onTap: () => Navigator.pop(context),
                tileColor: Colors.transparent,
                hoverColor: Colors.redAccent.withOpacity(0.1),
              ),
              const Divider(
                height: 30,
                thickness: 1,
                indent: 16,
                endIndent: 16,
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: const Text(
                  'Logout',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => LoginPage()),
                    (route) => false,
                  );
                },
                tileColor: Colors.transparent,
                hoverColor: Colors.redAccent.withOpacity(0.1),
              ),
            ],
          ),
        ),
      ),
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
