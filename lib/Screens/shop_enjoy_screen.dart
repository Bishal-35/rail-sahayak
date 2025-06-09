import 'package:flutter/material.dart';

class ShopEnjoyScreen extends StatefulWidget {
  final String stationName;

  const ShopEnjoyScreen({Key? key, required this.stationName})
    : super(key: key);

  @override
  State<ShopEnjoyScreen> createState() => _ShopEnjoyScreenState();
}

class _ShopEnjoyScreenState extends State<ShopEnjoyScreen> {
  List<Map<String, dynamic>> shopsList = [];

  @override
  void initState() {
    super.initState();
    initializeShopsList();
  }

  void initializeShopsList() {
    // Hardcoded shops data based on station name
    if (widget.stationName == 'Raipur') {
      shopsList = [
        {
          'id': '1',
          'name': 'PUNJABI DHABA',
          'description': 'Authentic Punjabi cuisine for travelers.',
          'location': 'MFC BUILDING, RAIPUR RAILWAY STATION',
          'category': 'Food',
          'openingHours': '7:00 AM - 10:00 PM',
          'contactNumber': 'RAJU AGRAWAL',
        },
        {
          'id': '2',
          'name': 'LEMON TADKA',
          'description': 'Fresh and tangy food options.',
          'location': 'MFC BUILDING, RAIPUR RAILWAY STATION',
          'category': 'Food',
          'openingHours': '6:00 AM - 11:00 PM',
          'contactNumber': 'HOTEL LE ROI',
        },
        {
          'id': '3',
          'name': 'AVR TEA STALL',
          'description': 'Refreshing tea and light snacks.',
          'location': 'MFC BUILDING, RAIPUR RAILWAY STATION',
          'category': 'Food',
          'openingHours': '5:00 AM - 11:00 PM',
          'contactNumber': 'ROSHAN RATRE',
        },
        {
          'id': '4',
          'name': 'POHEWALA',
          'description': 'Specializing in poha and breakfast items.',
          'location': 'MFC BUILDING, RAIPUR RAILWAY STATION',
          'category': 'Food',
          'openingHours': '6:00 AM - 10:00 PM',
          'contactNumber': 'DARSHAN PATEL',
        },
        {
          'id': '5',
          'name': 'MARIOS',
          'description': 'Italian and continental food options.',
          'location': 'MFC BUILDING, RAIPUR RAILWAY STATION',
          'category': 'Food',
          'openingHours': '10:00 AM - 10:00 PM',
          'contactNumber': 'VINOD MOTWANI',
        },
        {
          'id': '6',
          'name': 'PADHAROSA',
          'description': 'Traditional Indian meals and snacks.',
          'location': 'MFC BUILDING, RAIPUR RAILWAY STATION',
          'category': 'Food',
          'openingHours': '7:00 AM - 9:00 PM',
          'contactNumber': 'RITESH AGRAWAL',
        },
        {
          'id': '7',
          'name': 'CAFÉ COFFEE DAY',
          'description': 'Premium coffee and snacks chain.',
          'location': 'MFC BUILDING, RAIPUR RAILWAY STATION',
          'category': 'Food',
          'openingHours': '6:00 AM - 10:00 PM',
          'contactNumber': 'Not available',
        },
      ];
    } else if (widget.stationName == 'Durg') {
      shopsList = [
        {
          'id': '1',
          'name': 'Gift Gallery',
          'description':
              'Unique gift items and souvenirs to remember your journey.',
          'location': 'Main Building, Shop No. 5',
          'category': 'Gifts',
          'openingHours': '8:00 AM - 8:00 PM',
          'contactNumber': '9876543210',
        },
        {
          'id': '2',
          'name': 'MediCare',
          'description':
              'Essential medicines and healthcare products for travelers.',
          'location': 'Near Ticket Counter, Shop No. 3',
          'category': 'Pharmacy',
          'openingHours': '24 Hours',
          'contactNumber': '8765432109',
        },
        {
          'id': '3',
          'name': 'Tasty Treats',
          'description':
              'Local snacks and confectionery items to enjoy during your journey.',
          'location': 'Platform 1, End Corner',
          'category': 'Food',
          'openingHours': '6:00 AM - 11:00 PM',
          'contactNumber': '7654321098',
        },
      ];
    } else {
      // For other stations, empty list or default data
      shopsList = [];
    }

    setState(() {});
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
              child: Icon(Icons.shopping_bag, color: Colors.white, size: 28),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Shop & Enjoy',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Shops at ${widget.stationName}',
                    style: const TextStyle(
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
      body: shopsList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shopping_bag_outlined,
                    size: 70,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No shops available at ${widget.stationName}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: shopsList.length,
              itemBuilder: (context, index) {
                final shop = shopsList[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _getCategoryIcon(shop['category']),
                              color: Colors.redAccent,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              shop['category'],
                              style: const TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          shop['name'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          shop['description'],
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(Icons.location_on, shop['location']),
                        _buildInfoRow(Icons.access_time, shop['openingHours']),
                        _buildInfoRow(Icons.phone, shop['contactNumber']),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant;
      case 'clothing':
        return Icons.shopping_bag;
      case 'books':
        return Icons.book;
      case 'electronics':
        return Icons.devices;
      case 'gifts':
        return Icons.card_giftcard;
      case 'pharmacy':
        return Icons.local_pharmacy;
      default:
        return Icons.store;
    }
  }
}
