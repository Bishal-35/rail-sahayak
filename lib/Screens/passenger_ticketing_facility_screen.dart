import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this import

class PassengerTicketingFacilityScreen extends StatefulWidget {
  final String stationName;

  const PassengerTicketingFacilityScreen({Key? key, required this.stationName})
    : super(key: key);

  @override
  State<PassengerTicketingFacilityScreen> createState() =>
      _PassengerTicketingFacilityScreenState();
}

class _PassengerTicketingFacilityScreenState
    extends State<PassengerTicketingFacilityScreen>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;
  Map<String, dynamic> ticketingData = {};
  List<Map<String, dynamic>> countersList = [];
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  // Custom colors for a cohesive theme
  final Color primaryColor = Colors.redAccent;
  final Color secondaryColor = Colors.red.shade800;
  final Color backgroundColor = const Color(0xFFFFF1F0);
  final Color cardColor = Colors.white;
  final Color textColor = Colors.black87;
  final Color accentColor = Colors.amber;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchTicketingFacilities();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchTicketingFacilities() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Default data in case Firestore doesn't have specific data
      Map<String, dynamic> defaultData = {
        'general_info': 'Ticketing facilities are available at this station.',
        'opening_hours': '06:00 AM - 10:00 PM',
        'counters': [
          {
            'name': 'General Ticketing Counter',
            'location': 'Main Entrance',
            'services': 'Regular tickets, Platform tickets',
            'timings': '24 hours',
          },
          {
            'name': 'Reservation Counter',
            'location': 'Near Platform 1',
            'services': 'Reserved tickets, Tatkal tickets',
            'timings': '08:00 AM - 08:00 PM',
          },
        ],
      };

      // Special case for Durg station with hardcoded data
      if (widget.stationName == 'Durg') {
        ticketingData = {
          'general_info':
              'Complete ticketing facilities available at Durg station including PRS, UTS counters, ATVMs and YTSKs.',
          'opening_hours': 'Standard railway hours for all counters',
        };

        countersList = [
          // Consolidated PRS Counter
          {
            'name': 'PRS Counters (All Locations)',
            'location': 'Circulating Area',
            'services': 'Reserved tickets, Tatkal tickets',
            'timings': 'Standard hours',
            'locations': [
              {
                'name': 'Circulating Area',
                'details': '2 nos of PRS Counters for reserved ticketing',
              },
            ],
          },

          // Consolidated UTS Counter
          {
            'name': 'UTS Counters (All Locations)',
            'location': 'Station Building',
            'services': 'Unreserved tickets, Platform tickets',
            'timings': 'Standard hours',
            'locations': [
              {
                'name': 'Main Station Building',
                'details':
                    '5 UTS Counters including separate counter for Divyangjan',
              },
            ],
          },
        ];

        // Set isLoading to false and return early for Durg
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Special case for Raipur station with hardcoded data from the provided information
      if (widget.stationName == 'Raipur') {
        ticketingData = {
          'general_info':
              'Complete ticketing facilities available at Raipur station including PRS, UTS counters, ATVMs and YTSKs.',
          'opening_hours':
              'Standard railway hours for all counters (Some counters operate 24/7)',
        };

        countersList = [
          // Consolidated PRS Counter with multiple locations
          {
            'name': 'PRS Counters (All Locations)',
            'location': 'Multiple locations across station',
            'services': 'Reserved tickets, Tatkal tickets, Cancellations',
            'timings': 'Standard hours',
            'locations': [
              {
                'name': 'Concourse Area (PF1)',
                'details':
                    'Counter no.1 for handicapped, ladies and sr. citizens, counter no.2 for PRS cancellation and current ticketing',
              },
              {
                'name': 'Main Center (Near Two Wheeler Parking)',
                'details': '2 counters for reserved ticketing',
              },
              {
                'name': 'Gudhiyari Side',
                'details': '1 counter for reserved ticketing',
              },
            ],
          },

          // Consolidated UTS Counter with multiple locations
          {
            'name': 'UTS Counters (All Locations)',
            'location': 'Multiple locations across station',
            'services': 'Unreserved tickets, Platform tickets',
            'timings': 'Standard hours',
            'locations': [
              {
                'name': 'Main Gate',
                'details':
                    'Total 8 counters with specialized services including dedicated counter for handicapped, ladies and senior citizens',
              },
              {'name': 'Concourse Area (PF1)', 'details': 'Unreserved tickets'},
              {
                'name': 'City Side (Circulating Area)',
                'details': 'Unreserved tickets',
              },
              {
                'name': 'PF7 Side (Circulating Area)',
                'details': 'Unreserved tickets',
              },
            ],
          },
        ];

        // Set isLoading to false and return early for Raipur
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Try to fetch station-specific data
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('station_ticketing')
          .where('station_name', isEqualTo: widget.stationName)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data() as Map<String, dynamic>;
        ticketingData = {
          'general_info': data['general_info'] ?? defaultData['general_info'],
          'opening_hours':
              data['opening_hours'] ?? defaultData['opening_hours'],
        };

        if (data.containsKey('counters') && data['counters'] is List) {
          countersList = List<Map<String, dynamic>>.from(
            (data['counters'] as List).map((counter) => counter),
          );
        } else {
          countersList = List<Map<String, dynamic>>.from(
            defaultData['counters'],
          );
        }
      } else {
        // Use default data if no specific data found
        ticketingData = {
          'general_info': defaultData['general_info'],
          'opening_hours': defaultData['opening_hours'],
        };
        countersList = List<Map<String, dynamic>>.from(defaultData['counters']);
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching ticketing facilities: $e");
      setState(() {
        isLoading = false;
        // Set default data on error
        ticketingData = {
          'general_info': 'Information currently unavailable.',
          'opening_hours': 'Please check at the station.',
        };
        countersList = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Group counters by type for better organization
    List<Map<String, dynamic>> prsCounters = [];
    List<Map<String, dynamic>> utsCounters = [];

    // Separate PRS and UTS counters for grouped display
    if (countersList.isNotEmpty) {
      for (var counter in countersList) {
        if (counter['name'].toString().contains('PRS')) {
          prsCounters.add(counter);
        } else if (counter['name'].toString().contains('UTS')) {
          utsCounters.add(counter);
        }
      }
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        titleSpacing: 0, // Reduce padding to zero
        title: Text(
          'Passenger Ticketing Facilities',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              _showInfoDialog(context);
            },
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
        ),
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: primaryColor),
                  const SizedBox(height: 16),
                  Text(
                    'Loading ticketing information...',
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : SafeArea(
              child: NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          _buildStationHeader(),
                          const SizedBox(height: 16),
                          _buildGeneralInfoCard(),
                        ],
                      ),
                    ),
                    SliverAppBar(
                      backgroundColor: backgroundColor,
                      pinned: true,
                      automaticallyImplyLeading: false,
                      titleSpacing: 0,
                      toolbarHeight: 60,
                      title: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        alignment: Alignment.centerLeft,
                        child: _buildSectionHeader('Ticketing Facilities'),
                      ),
                    ),
                  ];
                },
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: countersList.isEmpty
                      ? _buildEmptyState()
                      : Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: cardColor,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: primaryColor.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: TabBar(
                                controller: _tabController,
                                indicatorColor: primaryColor,
                                indicatorWeight: 3,
                                labelColor: primaryColor,
                                unselectedLabelColor: textColor.withOpacity(
                                  0.7,
                                ),
                                labelStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                tabs: const [
                                  Tab(
                                    icon: Icon(Icons.confirmation_number),
                                    text: 'TICKETING',
                                  ),
                                  Tab(
                                    icon: Icon(Icons.settings_suggest),
                                    text: 'OTHER SERVICES',
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  // Ticketing Tab
                                  ListView(
                                    padding: EdgeInsets.zero,
                                    children: [
                                      if (prsCounters.isNotEmpty) ...[
                                        _buildServiceTypeHeader(
                                          'PRS - Passenger Reservation System',
                                          Icons.business_center,
                                        ),
                                        const SizedBox(height: 8),
                                        ...prsCounters.map(
                                          (counter) =>
                                              _buildAnimatedCounterCard(
                                                counter,
                                              ),
                                        ),
                                        const SizedBox(height: 16),
                                      ],
                                      if (utsCounters.isNotEmpty) ...[
                                        _buildServiceTypeHeader(
                                          'UTS - Unreserved Ticketing System',
                                          Icons.confirmation_number_outlined,
                                        ),
                                        const SizedBox(height: 8),
                                        ...utsCounters.map(
                                          (counter) =>
                                              _buildAnimatedCounterCard(
                                                counter,
                                              ),
                                        ),
                                        const SizedBox(height: 16),
                                      ],
                                      if (countersList.length >
                                          (prsCounters.length +
                                              utsCounters.length)) ...[
                                        _buildServiceTypeHeader(
                                          'Other Ticketing Services',
                                          Icons.more_horiz,
                                        ),
                                        const SizedBox(height: 8),
                                        ...countersList
                                            .where(
                                              (counter) =>
                                                  !counter['name']
                                                      .toString()
                                                      .contains('PRS') &&
                                                  !counter['name']
                                                      .toString()
                                                      .contains('UTS'),
                                            )
                                            .map(
                                              (counter) =>
                                                  _buildAnimatedCounterCard(
                                                    counter,
                                                  ),
                                            ),
                                      ],
                                      const SizedBox(height: 24),
                                      _buildDigitalOptionsCard(),
                                      const SizedBox(height: 24),
                                    ],
                                  ),

                                  // Other Services Tab (ATVM, YTSK)
                                  ListView(
                                    padding: EdgeInsets.zero,
                                    children: [
                                      if (widget.stationName == 'Raipur') ...[
                                        _buildServiceTypeHeader(
                                          'Automatic Ticket Vending Machines',
                                          Icons.point_of_sale,
                                        ),
                                        const SizedBox(height: 8),
                                        _buildATVMCard(),
                                        const SizedBox(height: 24),
                                        _buildServiceTypeHeader(
                                          'Yatri Ticket Suvidha Kendra (YTSK)',
                                          Icons.store_mall_directory,
                                        ),
                                        const SizedBox(height: 8),
                                        _buildYTSKCard(),
                                      ] else if (widget.stationName ==
                                          'Durg') ...[
                                        _buildServiceTypeHeader(
                                          'Automatic Ticket Vending Machines',
                                          Icons.point_of_sale,
                                        ),
                                        const SizedBox(height: 8),
                                        _buildATVMCard(),
                                        const SizedBox(height: 24),
                                        _buildServiceTypeHeader(
                                          'Yatri Ticket Suvidha Kendra (YTSK)',
                                          Icons.store_mall_directory,
                                        ),
                                        const SizedBox(height: 8),
                                        _buildYTSKCard(),
                                      ] else
                                        _buildEmptyState(
                                          message:
                                              'No additional services available for ${widget.stationName} station',
                                        ),
                                      const SizedBox(height: 24),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
    );
  }

  // New styled widgets
  Widget _buildStationHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.train, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.stationName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Railway Station',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.access_time_filled,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Ticketing Hours: ${ticketingData['opening_hours']}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralInfoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: primaryColor),
                const SizedBox(width: 8),
                Text(
                  'General Information',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              ticketingData['general_info'] ?? 'Information not available',
              style: TextStyle(fontSize: 15, color: textColor, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: primaryColor,
      ),
    );
  }

  Widget _buildServiceTypeHeader(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: primaryColor.withOpacity(0.2), width: 1),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: primaryColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedCounterCard(Map<String, dynamic> counter) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: primaryColor.withOpacity(0.1), width: 1),
        ),
        elevation: 2,
        shadowColor: primaryColor.withOpacity(0.1),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [Colors.white, primaryColor.withOpacity(0.05)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      counter['name'].toString().contains('PRS')
                          ? Icons.business_center
                          : Icons.confirmation_number_outlined,
                      color: primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        counter['name'] ?? 'Ticketing Counter',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRowEnhanced(
                      Icons.location_on,
                      'Location',
                      counter['location'] ?? 'Main station area',
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRowEnhanced(
                      Icons.access_time,
                      'Timings',
                      counter['timings'] ?? 'Standard hours',
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRowEnhanced(
                      Icons.support_agent,
                      'Services',
                      counter['services'] ?? 'Regular ticketing services',
                    ),

                    // Display multiple locations if they exist
                    if (counter.containsKey('locations') &&
                        counter['locations'] is List &&
                        (counter['locations'] as List).isNotEmpty) ...[
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 8),
                      Text(
                        'Available at:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: primaryColor.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(12),
                          itemCount: (counter['locations'] as List).length,
                          separatorBuilder: (context, index) => Divider(
                            height: 16,
                            color: primaryColor.withOpacity(0.1),
                          ),
                          itemBuilder: (context, index) {
                            final location =
                                (counter['locations'] as List)[index];
                            return _buildLocationItem(
                              location['name'] ?? 'Location',
                              location['details'] ?? 'No details available',
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // New helper method to display individual location items
  Widget _buildLocationItem(String name, String details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.place, size: 16, color: primaryColor),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: Text(
            details,
            style: TextStyle(
              fontSize: 13,
              color: textColor.withOpacity(0.8),
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRowEnhanced(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: primaryColor, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: textColor.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(fontSize: 14, color: textColor, height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState({String? message}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: primaryColor.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            message ?? 'No ticketing information available',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: textColor.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              fetchTicketingFacilities();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDigitalOptionsCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      shadowColor: primaryColor.withOpacity(0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.phone_android, color: primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Digital Ticketing Options',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDigitalOptionEnhanced(
                  'IRCTC Mobile App',
                  'Book reserved tickets online through the official IRCTC app',
                  Icons.phone_android,
                  'https://play.google.com/store/apps/details?id=cris.org.in.prs.ima',
                ),
                const Divider(height: 24),
                _buildDigitalOptionEnhanced(
                  'UTS Mobile App',
                  'Book unreserved tickets online and avoid queues',
                  Icons.train,
                  'https://play.google.com/store/apps/details?id=com.cris.utsmobile',
                ),
                const Divider(height: 24),
                _buildDigitalOptionEnhanced(
                  'Automatic Ticket Vending Machines (ATVM)',
                  'Self-service ticket machines available at the station',
                  Icons.point_of_sale,
                  null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDigitalOptionEnhanced(
    String title,
    String description,
    IconData icon,
    String? url,
  ) {
    return InkWell(
      onTap: url != null ? () => _launchURL(url) : null,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: primaryColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: textColor.withOpacity(0.8),
                      height: 1.4,
                    ),
                  ),
                  if (url != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.open_in_new, size: 14, color: primaryColor),
                        const SizedBox(width: 4),
                        Text(
                          'Open App',
                          style: TextStyle(
                            fontSize: 12,
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildATVMCard() {
    if (widget.stationName != 'Raipur' && widget.stationName != 'Durg') {
      return const SizedBox.shrink();
    }

    // For Durg station
    if (widget.stationName == 'Durg') {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 2,
        shadowColor: primaryColor.withOpacity(0.1),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Container(
                color: primaryColor.withOpacity(0.1),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.point_of_sale,
                              color: primaryColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'ATVM Locations',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildATVMLocationRowEnhanced(
                    'Concourse Area',
                    '1 Near Booking Office',
                  ),
                  const Divider(height: 24),
                  _buildATVMLocationRowEnhanced(
                    'Concourse Area',
                    '1 Near Enquiry Office',
                  ),
                  const Divider(height: 24),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: accentColor.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ATVM Facilitators available:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildFacilitatorChip('Sri G. Achuta Rao'),
                            _buildFacilitatorChip('Ku. Tulsi Manikpuri'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // For Raipur station (existing code)
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      shadowColor: primaryColor.withOpacity(0.1),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Container(
              color: primaryColor.withOpacity(0.1),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.point_of_sale, color: primaryColor),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'ATVM Locations',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildATVMLocationRowEnhanced(
                  'Concourse Area',
                  '2 Nos Near Booking Office',
                ),
                const Divider(height: 24),
                _buildATVMLocationRowEnhanced(
                  '1A Platform',
                  '2 Nos, near Exit Gate',
                ),
                const Divider(height: 24),
                _buildATVMLocationRowEnhanced('VIP Gate', '1 Nos'),
                const Divider(height: 24),
                _buildATVMLocationRowEnhanced(
                  'Gudhiyari Booking Office',
                  '1 Nos',
                ),
                const Divider(height: 24),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: accentColor.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ATVM Facilitators available:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildFacilitatorChip('Sri Premnath Sah'),
                          _buildFacilitatorChip('Shri A. Ramanjaiya'),
                          _buildFacilitatorChip('Sri Chigulla Leela Rao'),
                          _buildFacilitatorChip('Sri Shivnarayan Jagdalla'),
                          _buildFacilitatorChip('Sri K. Mohan Rao'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildATVMLocationRowEnhanced(String location, String count) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.location_on, color: primaryColor, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                location,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                count,
                style: TextStyle(
                  fontSize: 14,
                  color: textColor.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFacilitatorChip(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryColor.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.person, size: 16, color: primaryColor),
          const SizedBox(width: 8),
          Text(name, style: TextStyle(fontSize: 13, color: textColor)),
        ],
      ),
    );
  }

  Widget _buildYTSKCard() {
    if (widget.stationName != 'Raipur' && widget.stationName != 'Durg') {
      return const SizedBox.shrink();
    }

    // For Durg station
    if (widget.stationName == 'Durg') {
      List<Map<String, dynamic>> ytskData = [
        {
          'name': 'Prashant Agrawal',
          'period': '11/11/2024 to 10/11/2027',
          'address': '122, MPHB Complex, Maliya Nagar, Durg (CG)',
        },
        {
          'name': 'Smt. Sabina Begum',
          'period': '03/02/2025 to 02/02/2028',
          'address': 'Near Naj Manzil, Takia Para, Durg (CG)',
        },
        {
          'name': 'Sri Manoj Gupta',
          'period': '03/05/2022 to 02/05/2025',
          'address': 'Shop No. E1/10, Supela Chowk, Bhilai (C.G.)',
          'additionalInfo': [
            'Additional counter: HPCL Petrol Pump Sector -10, Bhilai (CG)',
            'Additional counter period: 05/08/2022 to 04/08/2025',
          ],
        },
      ];

      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 2,
        shadowColor: primaryColor.withOpacity(0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.store, color: primaryColor),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'YTSK Centers',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Yatri Ticket Suvidha Kendra (YTSK) are ticketing centers operated by authorized agents to provide reserved tickets to passengers',
                      style: TextStyle(
                        fontSize: 14,
                        color: textColor,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListView.separated(
              padding: const EdgeInsets.all(16),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: ytskData.length,
              separatorBuilder: (context, index) => const Divider(height: 24),
              itemBuilder: (context, index) {
                final data = ytskData[index];
                return _buildYTSKItemEnhanced(
                  data['name'],
                  data['period'],
                  data['address'],
                  additionalInfo: data['additionalInfo'],
                );
              },
            ),
          ],
        ),
      );
    }

    // For Raipur station (existing code)
    List<Map<String, dynamic>> ytskData = [
      {
        'name': 'Sri Anil Kumar Tiwari',
        'period': '29/10/2024 to 28/10/2027',
        'address': 'Near Agrasen Chowk, Samata Colony, Raipur(CG)',
      },
      {
        'name': 'Shri Jayanti Lal Thakkar',
        'period': '22/11/2024 to 21/11/2027',
        'address': '17 - Pithalia Complex, Fafadih Chowk/ Raipur',
      },
      {
        'name': 'Shri Ashok Virani',
        'period': '22/11/2024 to 21/11/2027',
        'address':
            'HOT LINE Travels, No.- 32, 1st floor, Vijeta Complex, Shastri Bazar Raipur CG',
      },
      {
        'name': 'Shri Dinesh Lalwani',
        'period': '22/11/2024 to 21/11/2027',
        'address':
            'Shop no. B-8, 1st Floor, Mahesh Parisar, behind LIC building, Pandri, Raipur (CG)',
        'additionalInfo': [
          'Additional counter: Canal Chowk, Katora Talab, Raipur (CG)',
          'Additional counter period: 06/02/2025 to 05/02/2028',
        ],
      },
      {
        'name': 'Sri Murari Lal Agrawal',
        'period': '21/02/2025 to 20/02/2028',
        'address': 'Rawanbatha, near Akashwani, Raipur (CG)',
      },
      {
        'name': 'Shri Bharat Kumar Kriplani',
        'period': '13/03/2024 to 12/03/2027',
        'address': 'Mekahara Chowk, Jail Road, Raipur(CG)',
      },
      {
        'name': 'Shri Amar Arya',
        'period': '06/03/2025 to 05/03/2028',
        'address': 'Amlidehi Raipur',
      },
      {
        'name': 'Shri Manish Chandnani',
        'period': 'Under installation',
        'address': 'Jagannath Complex, Tikra Para, Raipur (CG)',
      },
    ];

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      shadowColor: primaryColor.withOpacity(0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.store, color: primaryColor),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'YTSK Centers',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Yatri Ticket Suvidha Kendra (YTSK) are ticketing centers operated by authorized agents to provide reserved tickets to passengers',
                    style: TextStyle(
                      fontSize: 14,
                      color: textColor,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListView.separated(
            padding: const EdgeInsets.all(16),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: ytskData.length,
            separatorBuilder: (context, index) => const Divider(height: 24),
            itemBuilder: (context, index) {
              final data = ytskData[index];
              return _buildYTSKItemEnhanced(
                data['name'],
                data['period'],
                data['address'],
                additionalInfo: data['additionalInfo'],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildYTSKItemEnhanced(
    String name,
    String period,
    String address, {
    List<String>? additionalInfo,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              Icon(Icons.person, color: primaryColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.date_range, color: primaryColor, size: 14),
                const SizedBox(width: 4),
                Text(
                  period,
                  style: TextStyle(
                    fontSize: 12,
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on, color: primaryColor, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  address,
                  style: TextStyle(fontSize: 14, color: textColor, height: 1.4),
                ),
              ),
            ],
          ),
          if (additionalInfo != null && additionalInfo.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.only(left: 24),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: accentColor.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: additionalInfo
                    .map(
                      (info) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.arrow_right,
                              size: 16,
                              color: primaryColor,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                info,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: textColor,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'About Ticketing Facilities',
            style: TextStyle(color: primaryColor),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildInfoDialogItem(
                  'PRS',
                  'Passenger Reservation System - For booking reserved tickets',
                  Icons.business_center,
                ),
                const SizedBox(height: 16),
                _buildInfoDialogItem(
                  'UTS',
                  'Unreserved Ticketing System - For booking general tickets',
                  Icons.confirmation_number,
                ),
                const SizedBox(height: 16),
                _buildInfoDialogItem(
                  'ATVM',
                  'Automatic Ticket Vending Machine - Self-service ticket machines',
                  Icons.point_of_sale,
                ),
                const SizedBox(height: 16),
                _buildInfoDialogItem(
                  'YTSK',
                  'Yatri Ticket Suvidha Kendra - Authorized ticketing agents',
                  Icons.store,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Got it', style: TextStyle(color: primaryColor)),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }

  Widget _buildInfoDialogItem(String title, String description, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: primaryColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: textColor.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not launch $url')));
      }
    } catch (e) {
      print('Error launching URL: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error launching URL: $e')));
    }
  }
}
