import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rail_sahayak/Screens/TrainTimingsScreen.dart';
import 'package:rail_sahayak/Screens/amenities.dart';
import 'package:rail_sahayak/Screens/baby_food_screen.dart';
import 'package:rail_sahayak/Screens/book_coolie.dart';
import 'package:rail_sahayak/Screens/wheel_chair.dart';
import 'package:rail_sahayak/Screens/food_services.dart';
import 'package:rail_sahayak/Screens/login_screen.dart';
import 'package:rail_sahayak/Screens/on_duty_staff_screen.dart';
import 'package:rail_sahayak/Screens/four_wheeler_cart.dart';
import 'package:rail_sahayak/Screens/passenger_help_screen.dart';
import 'package:rail_sahayak/Screens/more_services_screen.dart';
import 'package:rail_sahayak/widgets/app_drawer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rail_sahayak/Screens/passenger_ticketing_facility_screen.dart';
import 'package:rail_sahayak/Screens/shop_enjoy_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedStation = 'Select Station';
  List<String> stations = [
    'Raipur',
    'Durg',
  ]; // Initialize with hardcoded values
  bool isLoadingStations = false; // Only for stations loading
  bool isScreenLoading =
      false; // Keep this false to show the screen immediately

  @override
  void initState() {
    super.initState();
    fetchStations();
  }

  Future<void> fetchStations() async {
    setState(() {
      isLoadingStations = true;
    });

    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('admin_stations')
          .get();

      List<String> fetchedStations = [];
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('name') && data['name'] != null) {
          fetchedStations.add(data['name']);
        }
      }

      setState(() {
        stations = fetchedStations;
        isLoadingStations = false;
      });
    } catch (e) {
      debugPrint("Error fetching stations: $e");
      setState(() {
        isLoadingStations = false;
        // Already using fallback stations, no need to set them again
      });

      // Show error only as a debug print, don't disrupt the user with an error message
      debugPrint("Failed to load stations: $e");
    }
  }

  void _bookTrain() async {
    final Uri url = Uri.parse('https://www.irctc.co.in/nget/train-search');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint("Could not launch IRCTC");
    }
  }

  void _bookRetiringRoom() async {
    final Uri url = Uri.parse('https://www.rr.irctc.co.in/home');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint("Could not launch IRCTC");
    }
  }

  void _trainRunningInfo() async {
    final Uri url = Uri.parse('https://enquiry.indianrail.gov.in/mntes/');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint("Could not launch IRCTC");
    }
  }

  void _uts() async {
    final Uri url = Uri.parse(
      'https://play.google.com/store/apps/details?id=com.cris.utsmobile&hl=en_IN&pli=1',
    );
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint("Could not launch UTS website");
    }
  }

  void _passengerAmenities() async {
    if (selectedStation != 'Select Station') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AmenitiesScreen(stationName: selectedStation),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a station first")),
      );
    }
  }

  void _trainTimings() async {
    if (selectedStation != 'Select Station') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TrainTimingsScreen(stationName: selectedStation),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a station first")),
      );
    }
  }

  void _ondutystaff() async {
    if (selectedStation != 'Select Station') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OnDutyStaffScreen(stationName: selectedStation),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a station first")),
      );
    }
  }

  //uts icon
  Widget buildServiceCard(
    String title,
    dynamic iconOrImage,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, // Set to minimize vertical space
            children: [
              iconOrImage is IconData
                  ? Icon(
                      iconOrImage,
                      color: Colors.redAccent,
                      size: 28,
                    ) // Reduced size slightly
                  : Image.asset(iconOrImage, width: 28, height: 28),
              const SizedBox(height: 4), // Reduced spacing
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2, // Limit to 2 lines
                overflow:
                    TextOverflow.ellipsis, // Add ellipsis for text overflow
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12, // Smaller font size
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.redAccent,
          ),
        ),
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: children,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1F0),
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min, // This helps with centering
          children: const [
            Icon(Icons.train, color: Colors.redAccent),
            SizedBox(width: 8),
            Text('RailSahayak', style: TextStyle(color: Colors.black)),
          ],
        ),
        centerTitle: true, // Center the title in the AppBar
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            const SizedBox(height: 10),
            const Text(
              "Welcome to",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
            const Text(
              "RailSahayak",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Your one-stop solution for all railway station services. Book, explore, and get assistance with ease.",
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 20),

            /// Enhanced Station Selection Dropdown with colorful design
            Stack(
              alignment: Alignment.centerRight,
              children: [
                DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    hint: Row(
                      children: const [
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Select Station',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    items: stations
                        .map(
                          (item) => DropdownMenuItem<String>(
                            value: item,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: item == selectedStation
                                      ? [
                                          Colors.redAccent.shade100,
                                          Colors.redAccent.shade400,
                                        ]
                                      : [
                                          Colors.transparent,
                                          Colors.transparent,
                                        ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.train,
                                    color: item == selectedStation
                                        ? Colors.white
                                        : Colors.redAccent,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    item,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: item == selectedStation
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    value: selectedStation == 'Select Station'
                        ? null
                        : selectedStation,
                    onChanged: (value) {
                      setState(() {
                        selectedStation = value!;
                      });
                    },
                    buttonStyleData: ButtonStyleData(
                      height: 50,
                      width: double.infinity,
                      padding: const EdgeInsets.only(left: 14, right: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          colors: [Colors.redAccent, Colors.red],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.redAccent.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      elevation: 2,
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                      iconSize: 24,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.redAccent.withOpacity(0.2),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.redAccent.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      elevation: 8,
                      scrollbarTheme: ScrollbarThemeData(
                        radius: const Radius.circular(40),
                        thickness: MaterialStateProperty.all(6),
                        thumbVisibility: MaterialStateProperty.all(true),
                        thumbColor: MaterialStateProperty.all(Colors.redAccent),
                      ),
                    ),
                    menuItemStyleData: MenuItemStyleData(
                      height: 50,
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      selectedMenuItemBuilder: (context, child) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.redAccent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: child,
                        );
                      },
                    ),
                    customButton: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          colors: [Colors.redAccent, Colors.red],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.redAccent.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 20,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              selectedStation == 'Select Station'
                                  ? 'Select Station'
                                  : selectedStation,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          isLoadingStations
                              ? Container(
                                  width: 24,
                                  height: 24,
                                  padding: const EdgeInsets.all(2),
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                  size: 24,
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            /// Section 1 - Services at Your Station
            buildSection("Station Services", [
              buildServiceCard("Book a Coolie", Icons.luggage, () {
                if (selectedStation != 'Select Station') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          BookCoolie(selectedStation: selectedStation),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please select a station first"),
                    ),
                  );
                }
              }),
              buildServiceCard("Wheel Chair", Icons.accessible, () {
                if (selectedStation != 'Select Station') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          WheelChair(selectedStation: selectedStation),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please select a station first"),
                    ),
                  );
                }
              }),
              buildServiceCard("4-Wheeler Cart", Icons.electric_rickshaw, () {
                if (selectedStation != 'Select Station') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          FourWheelerCart(selectedStation: selectedStation),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please select a station first"),
                    ),
                  );
                }
              }),
              // buildServiceCard("Retiring Room", Icons.hotel, _bookRetiringRoom),
              buildServiceCard("Food Services", Icons.restaurant, () {
                if (selectedStation != 'Select Station') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          FoodServices(stationName: selectedStation),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please select a station first"),
                    ),
                  );
                }
              }),
              buildServiceCard("Shop & Enjoy", Icons.shopping_bag, () {
                if (selectedStation != 'Select Station') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ShopEnjoyScreen(stationName: selectedStation),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please select a station first"),
                    ),
                  );
                }
              }),
              buildServiceCard("Baby Food", Icons.child_care, () {
                if (selectedStation != 'Select Station') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          BabyFoodScreen(stationName: selectedStation),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please select a station first"),
                    ),
                  );
                }
              }),
              buildServiceCard("Passenger Help", Icons.person, () {
                if (selectedStation != 'Select Station') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          PassengerHelpScreen(stationName: selectedStation),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please select a station first"),
                    ),
                  );
                }
              }),
              buildServiceCard(
                "Passenger Ticketing Facilities",
                Icons.wallet_travel_sharp,
                () {
                  if (selectedStation != 'Select Station') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PassengerTicketingFacilityScreen(
                          stationName: selectedStation,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please select a station first"),
                      ),
                    );
                  }
                },
              ),
              buildServiceCard("More Services", Icons.more_horiz, () {
                if (selectedStation != 'Select Station') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          MoreServicesScreen(stationName: selectedStation),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please select a station first"),
                    ),
                  );
                }
              }),
            ]),

            /// Section 2 - Station Guide
            buildSection("Station Guide", [
              buildServiceCard("Amenities", Icons.info, _passengerAmenities),
              buildServiceCard("Duty Staff", Icons.group, _ondutystaff),
              buildServiceCard("Guide Map", Icons.map, () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text("Coming Soon")));
              }),
              buildServiceCard(
                "Train Timings",
                Icons.access_time,
                _trainTimings,
              ),
              buildServiceCard("Other Info", Icons.info_outline, () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text("Coming Soon")));
              }),
            ]),

            /// Section 3 - Travel Services
            buildSection("Travel Services", [
              buildServiceCard(
                "Train Tickets",
                "assets/images/irctc.png",
                _bookTrain,
              ),
              buildServiceCard(
                "Retiring Room",
                "assets/images/irctc-logo.png",
                _bookRetiringRoom,
              ),
              buildServiceCard(
                "Running Info",
                "assets/images/ir.png",
                _trainRunningInfo,
              ),
              buildServiceCard("UTS", "assets/images/uts.webp", _uts),
            ]),
          ],
        ),
      ),
    );
  }
}
