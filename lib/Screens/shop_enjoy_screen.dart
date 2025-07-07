import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
          'location': 'Raipur Railway Station',
          'category': 'Food',
          'openingHours': '7:00 AM - 10:00 PM',
          'contactNumber': '7771867176',
        },
        {
          'id': '2',
          'name': 'LEMON TADKA',
          'description': 'Fresh and tangy food options.',
          'location':
              'Inside Hotel Le Roi Complex, City Railway Station, Raipur',
          'category': 'Food',
          'openingHours': '6:00 AM - 11:00 PM',
          'contactNumber': '77730 13037',
        },
        {
          'id': '3',
          'name': 'AVR JUICE CENTRE',
          'description': 'Refreshing juices and beverages.',
          'location': 'Raipur Railway Station',
          'category': 'Food',
          'openingHours': '5:00 AM - 11:00 PM',
          'contactNumber': '7771867176',
        },
        {
          'id': '4',
          'name': 'POHEWALA',
          'description': 'Specializing in poha and breakfast items.',
          'location': 'Raipur Railway Station',
          'category': 'Food',
          'openingHours': '6:00 AM - 10:00 PM',
          'contactNumber': '93019 23838',
        },
        {
          'id': '5',
          'name': 'MARIO STALL',
          'description': 'Italian and continental food options.',
          'location':
              'Shop No. 4, Multi-Function Complex, Platform No. 1 Near Reservation Counter, Raipur',
          'category': 'Food',
          'openingHours': '10:00 AM - 10:00 PM',
          'contactNumber': '93019 23838',
        },
        {
          'id': '6',
          'name': 'PADHARO SA',
          'description': 'Authentic Rajasthani Thali and traditional meals.',
          'location':
              'Shop no. 7, Hotel le Roi complex, Raipur Railway Station',
          'category': 'Food',
          'openingHours': '7:00 AM - 9:00 PM',
          'contactNumber': '98736 44389',
        },
        {
          'id': '7',
          'name': 'CAFÉ COFFEE DAY',
          'description': 'Premium coffee and snacks chain.',
          'location': 'MFC Center, Railway Station',
          'category': 'Food',
          'openingHours': '6:00 AM - 10:00 PM',
          'contactNumber': '63713 69956',
        },
        {
          'id': '8',
          'name': 'DOMINO\'S PIZZA',
          'description':
              'Popular pizza chain offering a variety of pizzas and sides.',
          'location':
              'Shop No 11 Ground Floor Multifunctional Complex, Raipur Railway Station',
          'category': 'Food',
          'openingHours': '10:00 AM - 10:00 PM',
          'contactNumber': '97701 36122',
        },
        {
          'id': '9',
          'name': 'HOTEL LE ROI',
          'description':
              'Full-service hotel with dining options at the railway station.',
          'location': 'Railway Station, Raipur',
          'category': 'Accommodation & Food',
          'openingHours': '24 Hours',
          'contactNumber': '77730 13037',
        },
        {
          'id': '10',
          'name': 'MASSAGE CHAIRS - BRAHMAGOPAL FOODS',
          'description':
              'Premium automatic massage chairs with multiple massage programs to relax and rejuvenate during your wait time. Pay per use service.',
          'location': 'Platform 1 (240 Sq Ft)',
          'category': 'Massage Chair',
          'openingHours': '24 Hours',
          'contactNumber': '98765 43210',
          // 'image': 'assets/images/massage_chair_brahmagopal.png',
          'contractor': 'M/s Brahmagopal Foods, Bhilai',
        },
        {
          'id': '11',
          'name': 'MASSAGE CHAIRS - PUNAM ENTERPRISES',
          'description':
              'Zero gravity full body massage chairs with advanced features like heat therapy and air compression massage.',
          'location': 'Platform 7 (240 Sq Ft)',
          'category': 'Massage Chair',
          'openingHours': '5:00 AM - 11:00 PM',
          'contactNumber': '77889 00123',
          // 'image': 'assets/images/massage_chair_punam.png',
          'contractor': 'PUNAM ENTERPRISES-PUNE',
          'contractPeriod': '30.12.24 - 29.12.27',
        },
        {
          'id': '12',
          'name': 'SHOE SHINE SERVICE',
          'description':
              'Professional shoe cleaning and polishing services for travelers. Quick service while you wait.',
          'location': 'Available throughout the station',
          'category': 'Shoe Care',
          'openingHours': '6:00 AM - 10:00 PM',
          'contactNumber': '85432 10987',
          // 'image': 'assets/images/shoe_shine_logo.png',
          'contractor': 'YASH KHAROLE',
        },
      ];
    } else if (widget.stationName == 'Durg') {
      shopsList = [
        // {
        //   'id': '1',
        //   'name': 'Gift Gallery',
        //   'description':
        //       'Unique gift items and souvenirs to remember your journey.',
        //   'location': 'Main Building, Shop No. 5',
        //   'category': 'Gifts',
        //   'openingHours': '8:00 AM - 8:00 PM',
        //   'contactNumber': '9876543210',
        // },
        // {
        //   'id': '2',
        //   'name': 'MediCare',
        //   'description':
        //       'Essential medicines and healthcare products for travelers.',
        //   'location': 'Near Ticket Counter, Shop No. 3',
        //   'category': 'Pharmacy',
        //   'openingHours': '24 Hours',
        //   'contactNumber': '8765432109',
        // },
        // {
        //   'id': '3',
        //   'name': 'Tasty Treats',
        //   'description':
        //       'Local snacks and confectionery items to enjoy during your journey.',
        //   'location': 'Platform 1, End Corner',
        //   'category': 'Food',
        //   'openingHours': '6:00 AM - 11:00 PM',
        //   'contactNumber': '7654321098',
        // },
        {
          'id': '1',
          'name': 'MASSAGE CHAIRS - BRAHMAGOPAL FOODS',
          'description':
              'Premium automatic massage chairs with multiple massage programs to relax and rejuvenate during your wait time. Pay per use service.',
          'location': 'Platform 1',
          'category': 'Massage Chair',
          'openingHours': '24 Hours',
          'contactNumber': '98765 43210',
          // 'image': 'assets/images/massage_chair_brahmagopal.png',
          'contractor': 'M/s Brahmagopal Foods, Bhilai',
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (shop.containsKey('image') &&
                                shop['image'] != null)
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 12.0,
                                  bottom: 8.0,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: _buildImage(shop['image']),
                                ),
                              ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (shop.containsKey('contractor'))
                          _buildInfoRow(
                            Icons.business,
                            "Contractor: ${shop['contractor']}",
                          ),
                        if (shop.containsKey('contractPeriod'))
                          _buildInfoRow(
                            Icons.date_range,
                            "Contract Period: ${shop['contractPeriod']}",
                          ),
                        if (shop['category'].toString().toLowerCase() ==
                                'massage chair' &&
                            shop.containsKey('pricePerSession'))
                          _buildInfoRow(
                            Icons.monetization_on,
                            shop['pricePerSession'],
                          ),
                        if (shop['category'].toString().toLowerCase() ==
                                'shoe care' &&
                            shop.containsKey('pricePerService'))
                          _buildInfoRow(
                            Icons.monetization_on,
                            shop['pricePerService'],
                          ),
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
    final bool isPhoneNumber = icon == Icons.phone;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: isPhoneNumber
                ? InkWell(
                    onTap: () => _makePhoneCall(text),
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
                : Text(text, style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    // Remove any non-digit characters from the phone number
    final String formattedNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');
    final Uri phoneUri = Uri(scheme: 'tel', path: formattedNumber);

    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not launch phone app for $phoneNumber'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error launching phone app: $e')));
    }
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
      case 'massage chair':
        return Icons
            .airline_seat_recline_extra; // Better icon for massage chair - shows a reclining seat
      case 'shoe care':
        return Icons.cleaning_services;
      default:
        return Icons.store;
    }
  }

  // Add a helper method to build the appropriate image widget
  Widget _buildImage(String imagePath) {
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      // Load from network for URLs
      return Image.network(
        imagePath,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: 60,
          height: 60,
          color: Colors.grey[200],
          child: Icon(Icons.image_not_supported, color: Colors.grey),
        ),
      );
    } else {
      // Load from assets for local paths
      return Image.asset(
        imagePath,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: 60,
          height: 60,
          color: Colors.grey[200],
          child: Icon(Icons.broken_image, color: Colors.grey),
        ),
      );
    }
  }
}
