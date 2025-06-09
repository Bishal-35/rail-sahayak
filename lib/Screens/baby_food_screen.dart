import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BabyFoodScreen extends StatefulWidget {
  final String stationName;

  const BabyFoodScreen({Key? key, required this.stationName}) : super(key: key);

  @override
  State<BabyFoodScreen> createState() => _BabyFoodScreenState();
}

class _BabyFoodScreenState extends State<BabyFoodScreen> {
  late List<Map<String, dynamic>> babyFoodProviders;

  @override
  void initState() {
    super.initState();
    // Initialize static data based on station name
    initializeStaticData();
  }

  void initializeStaticData() {
    // Information about baby food availability at all stations
    babyFoodProviders = [
      {
        'id': 'general',
        'name': 'Railway Station Baby Food Information',
        'contact': '',
        'location': 'All stalls at Railway Station',
        'available': true,
        'items': ['Hot Water', 'Tetra Pack Milk', 'CERELAC FOOD'],
        'description':
            'Baby Food Is Available At All the stalls at Railway Station. Rates are as per MRP.',
      },
    ];
  }

  void _callProvider(String contact) async {
    final Uri url = Uri.parse('tel:$contact');
    if (!await launchUrl(url)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not launch phone dialer")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1F0),
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
              child: Icon(Icons.child_care, color: Colors.white, size: 28),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Baby Food Services',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Available at all railway station stalls',
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
      body: babyFoodProviders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.child_care, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    "No baby food services available at ${widget.stationName} station",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Please check back later or contact station staff for assistance",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // const Icon(
                            //   Icons.child_care,
                            //   color: Colors.redAccent,
                            //   size: 28,
                            // ),
                            // const SizedBox(width: 8),
                            Text(
                              'Baby Food at ${widget.stationName} Station',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                        // const SizedBox(height: 8),
                        // const Text(
                        //   'Baby Food Is Available At All the stalls at Railway Station',
                        //   style: TextStyle(
                        //     fontSize: 16,
                        //     fontWeight: FontWeight.w500,
                        //   ),
                        // ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Icon(
                              Icons.location_on,
                              color: Colors.redAccent,
                              size: 22,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Available at: ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'All stalls at Railway Station',
                                style: TextStyle(fontSize: 16),
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ],
                        ),
                        // const SizedBox(height: 6),
                        // const Text(
                        //   'All stalls at Railway Station',
                        //   style: TextStyle(fontSize: 16),
                        // ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Items section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.restaurant,
                              color: Colors.redAccent,
                              size: 22,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Available Items:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ...babyFoodProviders[0]['items'].map<Widget>((item) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  item,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          );
                        }).toList(),

                        // Note section moved inside the items container
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.blue.shade200,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.info_outline,
                                color: Colors.blue,
                                size: 24,
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Note: Rates are as per MRP',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(207, 0, 0, 0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Help section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.support_agent,
                              color: Colors.redAccent,
                              size: 22,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Need Assistance?',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'For more information about baby food services, please contact the station manager or information desk.',
                          style: TextStyle(fontSize: 15),
                        ),
                        // const SizedBox(height: 16),
                        // SizedBox(
                        //   width: double.infinity,
                        //   child: ElevatedButton.icon(
                        //     style: ElevatedButton.styleFrom(
                        //       backgroundColor: Colors.redAccent,
                        //       padding: const EdgeInsets.symmetric(vertical: 12),
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(8),
                        //       ),
                        //     ),
                        //     onPressed: () {
                        //       ScaffoldMessenger.of(context).showSnackBar(
                        //         const SnackBar(
                        //           content: Text(
                        //             "Contact station master for help",
                        //           ),
                        //         ),
                        //       );
                        //     },
                        //     icon: const Icon(
                        //       Icons.help_outline,
                        //       color: Colors.white,
                        //     ),
                        //     label: const Text(
                        //       "Get Help",
                        //       style: TextStyle(
                        //         fontSize: 16,
                        //         color: Colors.white,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
