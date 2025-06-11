import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PassengerHelpScreen extends StatefulWidget {
  final String stationName;

  const PassengerHelpScreen({Key? key, required this.stationName})
    : super(key: key);

  @override
  State<PassengerHelpScreen> createState() => _PassengerHelpScreenState();
}

class _PassengerHelpScreenState extends State<PassengerHelpScreen> {
  late Map<String, List<List<String>>> groupedStaffData;

  @override
  void initState() {
    super.initState();
    groupedStaffData = getGroupedStaffData(widget.stationName);
  }

  Map<String, List<List<String>>> getGroupedStaffData(String station) {
    Map<String, List<List<String>>> result = {};

    List<List<String>> allStaff = [];
    if (station.toLowerCase() == 'raipur') {
      allStaff = [
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
      allStaff = [
        ['Chief Station Manager', 'Shri Lakhbeer Singh Munghera', '9752877068'],
        // ['Station Manager', 'Shri S. K. Dubey', '7566556687'],
        // ['Dy. Station Manager', 'Shri T. Jaipal', '9752596063'],
        // ['Station Manager', 'Shri Manoj Kumar', '9752096157'],
        // ['Dy. Station Manager', 'Shri Shankar Kumar Choudhary', '9098122312'],
        ['Station Suptd.(Commercial)', 'Shri Pramod Sharma', '9109112682'],
        // ['Chief Ticket Inspector', 'Shri A. K. Sharma (Station)', '9179034585'],
      ];
    }

    // Group staff by designation
    for (var staff in allStaff) {
      String designation = staff[0];
      if (!result.containsKey(designation)) {
        result[designation] = [];
      }
      result[designation]!.add(staff);
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    // Convert map to a list of entries for stable iteration
    final List<MapEntry<String, List<List<String>>>> entries = groupedStaffData
        .entries
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F8), // Subtle light red background
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
              child: Icon(Icons.person_pin, color: Colors.white, size: 28),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Passenger Help - ${widget.stationName}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Support services for passengers',
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
      body: entries.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.support_agent_outlined,
                    size: 60,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No help services available for ${widget.stationName}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                final designation = entry.key;
                final staffList = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Designation header
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.redAccent.shade200,
                              Colors.redAccent,
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _getIconForDesignation(designation),
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              designation,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Staff members in this group
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: staffList.length,
                      itemBuilder: (context, staffIndex) {
                        final staff = staffList[staffIndex];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: Colors.red.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.redAccent.withOpacity(
                                          0.1,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.person,
                                        size: 16,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        staff[1],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  height: 20,
                                  color: Colors.red.withOpacity(0.2),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.call,
                                        size: 16,
                                        color: Colors.green,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      staff[2],
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const Spacer(),
                                    OutlinedButton.icon(
                                      onPressed: () async {
                                        // Clean the phone number to ensure it's properly formatted
                                        final phoneNumber = staff[2]
                                            .trim()
                                            .replaceAll(' ', '');

                                        try {
                                          // Try the standard tel: URI scheme first
                                          final Uri phoneUri = Uri(
                                            scheme: 'tel',
                                            path: phoneNumber,
                                          );

                                          if (await canLaunchUrl(phoneUri)) {
                                            await launchUrl(phoneUri);
                                          } else {
                                            // First fallback - try with different URI format
                                            final String telUrl =
                                                'tel:$phoneNumber';
                                            if (await canLaunchUrl(
                                              Uri.parse(telUrl),
                                            )) {
                                              await launchUrl(
                                                Uri.parse(telUrl),
                                              );
                                            } else {
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      "Unable to make calls on this device. Please dial $phoneNumber manually.",
                                                    ),
                                                    action: SnackBarAction(
                                                      label: 'Copy',
                                                      onPressed: () {
                                                        // Copy to clipboard functionality could be added here
                                                      },
                                                    ),
                                                  ),
                                                );
                                              }
                                            }
                                          }
                                        } catch (e) {
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "Error launching phone app: $e",
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                      },
                                      icon: const Icon(Icons.call, size: 16),
                                      label: const Text('Call'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.redAccent,
                                        side: const BorderSide(
                                          color: Colors.redAccent,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    // Divider between groups
                    if (index < entries.length - 1)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.redAccent.withOpacity(0.3),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
    );
  }

  IconData _getIconForDesignation(String designation) {
    if (designation.toLowerCase().contains('manager')) {
      return Icons.business_center;
    } else if (designation.toLowerCase().contains('chief')) {
      return Icons.verified_user;
    } else if (designation.toLowerCase().contains('inspector')) {
      return Icons.assignment_ind;
    } else if (designation.toLowerCase().contains('commercial')) {
      return Icons.store;
    } else {
      return Icons.work;
    }
  }
}
