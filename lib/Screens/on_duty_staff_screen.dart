import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OnDutyStaffScreen extends StatefulWidget {
  final String stationName;

  const OnDutyStaffScreen({super.key, required this.stationName});

  @override
  State<OnDutyStaffScreen> createState() => _OnDutyStaffScreenState();
}

class _OnDutyStaffScreenState extends State<OnDutyStaffScreen> {
  late List<List<String>> staffData;

  @override
  void initState() {
    super.initState();
    staffData = getStaffData(widget.stationName);
  }

  List<List<String>> getStaffData(String station) {
    if (station.toLowerCase() == 'raipur') {
      return [
        ['Chief Station Manager', 'Shri R P Mandal', '9752877088'],
        // ['Station Manager', 'Shri S. Bala', '97525 96048'],
        // ['Station Manager', 'Shri N. K Sahu', '80859 53413'],
        // ['Station Manager', 'Shri N. K. Thakur', '98932 82944'],
        [
          'Station Suptd.(Commercial)',
          'Shri Amar Kumar Phutane (Incharge)',
          '9109112682',
        ],
        ['Station Suptd.(Commercial)', 'Shri Satyendra Singh', '9752877990'],
        // [
        //   'Divisional Chief Ticket Inspector',
        //   'Shri Artta Trana Jena',
        //   '9179032799',
        // ],
        // ['Chief Ticket Inspector', 'Shri B. C. Alda', '9179043964'],
      ];
    } else if (station.toLowerCase() == 'durg') {
      return [
        ['Chief Station Manager', 'Shri Lakhbeer Singh Munghera', '9752877068'],
        // ['Station Manager', 'Shri S. K. Dubey', '7566556687'],
        // ['Dy. Station Manager', 'Shri T. Jaipal', '9752596063'],
        // ['Station Manager', 'Shri Manoj Kumar', '9752096157'],
        // ['Dy. Station Manager', 'Shri Shankar Kumar Choudhary', '9098122312'],
        ['Station Suptd.(Commercial)', 'Shri Pramod Sharma', '9109112682'],
        // ['Chief Ticket Inspector', 'Shri A. K. Sharma (Station)', '9179034585'],
      ];
    }
    return [];
  }

  void _showStaffDialog(int index) {
    final staff = staffData[index];
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFFFFFDE7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.all(20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person_outline, color: Colors.orange),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    staff[0],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.brown,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: Colors.brown, height: 1),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.orange,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Name: ${staff[1]}',
                      style: const TextStyle(fontSize: 14, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final Uri phoneUri = Uri(scheme: 'tel', path: staff[2]);
                      if (await canLaunchUrl(phoneUri)) {
                        await launchUrl(phoneUri);
                      } else {
                        // Handle error
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Could not launch phone app"),
                            ),
                          );
                        }
                      }
                      Navigator.of(
                        context,
                      ).pop(); // Close dialog after initiating call
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.call,
                        color: Colors.green,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      staff[2],
                      style: const TextStyle(fontSize: 14, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Close"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: Icon(Icons.people, color: Colors.white, size: 28),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Staff at ${widget.stationName} Station',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Contact station staff for assistance',
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
      body: staffData.isEmpty
          ? const Center(child: Text("No data available for this station"))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                itemCount: staffData.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 2,
                ),
                itemBuilder: (context, index) {
                  final staff = staffData[index];
                  return GestureDetector(
                    onTap: () => _showStaffDialog(index),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 4,
                            offset: const Offset(2, 2),
                          ),
                        ],
                        border: Border.all(color: Colors.brown.shade200),
                      ),
                      child: Center(
                        child: Text(
                          staff[0],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.brown,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
