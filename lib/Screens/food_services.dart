import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FoodStall {
  final String division;
  final String stallNumber;
  final String stallType;
  final String station;
  final String platformNumber;
  final String contractEndDate;
  final String contractStartDate;
  final String licenseeName;
  final String contactNumber; // Added phone number field

  FoodStall({
    required this.division,
    required this.stallNumber,
    required this.stallType,
    required this.station,
    required this.platformNumber,
    this.contractEndDate = '',
    this.contractStartDate = '',
    this.licenseeName = '',
    this.contactNumber = '', // Initialize with empty string
  });

  // Factory constructor to create a FoodStall from Firebase document
  factory FoodStall.fromFirestore(Map<String, dynamic> data) {
    return FoodStall(
      division: data['division'] ?? '',
      stallNumber: data['stallNo'] ?? '',
      stallType: data['stallType'] ?? '',
      station:
          data['stationName'] ??
          data['stationId'] ??
          '', // Try to use stationName if available
      platformNumber: data['location'] ?? '',
      contractEndDate: data['contractEndDate'] ?? '',
      contractStartDate: data['contractStartDate'] ?? '',
      licenseeName: data['licenseeName'] ?? '',
      contactNumber:
          data['contactNumber'] ?? '', // Added phone number extraction
    );
  }
}

class FoodServices extends StatefulWidget {
  final String stationName;

  const FoodServices({super.key, required this.stationName});

  @override
  State<FoodServices> createState() => _FoodServicesState();
}

class _FoodServicesState extends State<FoodServices> {
  String? _selectedStallType;
  String? _selectedPlatform;
  List<FoodStall> _allFoodStalls = [];
  bool _isLoading = true;
  String _errorMessage = '';

  final List<String> _stallTypes = [
    'All Types',
    'Tea Stall',
    'Trolley',
    'Milk Stall',
    'Juice Stall',
    'MPS',
  ];

  // Add a station mapping to convert IDs to station names
  Map<String, String> _stationIdToName = {
    'HqpI5uy1J7nJuyy6AvWV': 'Raipur',
    'Gyq0FfwYR5LtLtH7jix5': 'Durg',
    // Add more mappings as needed
  };

  @override
  void initState() {
    super.initState();
    // Only fetch from Firebase, no fallback
    _fetchFoodStalls();
  }

  // Method to fetch food stalls from Firebase
  Future<void> _fetchFoodStalls() async {
    try {
      print('Attempting to fetch food stalls from Firebase...');
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final collectionRef = FirebaseFirestore.instance.collection(
        'admin_food_services',
      );
      final QuerySnapshot stallsSnapshot = await collectionRef.get();

      print('Fetched ${stallsSnapshot.docs.length} food stalls');

      // Convert documents to FoodStall objects
      final List<FoodStall> stalls = [];
      for (var doc in stallsSnapshot.docs) {
        try {
          final data = doc.data() as Map<String, dynamic>;

          // Map station IDs to station names if needed
          if (data['stationId'] != null &&
              _stationIdToName.containsKey(data['stationId'])) {
            data['stationName'] = _stationIdToName[data['stationId']];
          }

          stalls.add(FoodStall.fromFirestore(data));
        } catch (e) {
          print('Error parsing stall document: $e');
        }
      }

      // Debug: Print sample data to understand format
      if (stalls.isNotEmpty) {
        print('Sample stall data: ');
        print('Station: ${stalls[0].station}');
        print('StallType: ${stalls[0].stallType}');
        print('Platform: ${stalls[0].platformNumber}');
      }

      setState(() {
        _allFoodStalls = stalls;
        _isLoading = false;
      });

      print('Successfully loaded ${_allFoodStalls.length} food stalls');
      print('Filtered stalls count: ${filteredStalls.length}');
    } catch (e) {
      print('Error fetching food stalls: $e');
      setState(() {
        _errorMessage = 'Failed to load data: $e';
        _isLoading = false;
      });
    }
  }

  // Method to get available platforms for the current station
  List<String> get _availablePlatforms {
    final Set<String> normalizedPlatforms = {};
    final Map<String, String> normalizedToDisplay = {};

    // Add All Platforms as the first option
    normalizedToDisplay['all'] = 'All Platforms';

    for (var stall in _allFoodStalls) {
      if (stall.station == widget.stationName) {
        // Normalize the platform number
        String normalizedPlatform = _normalizePlatformNumber(
          stall.platformNumber,
        );

        // Special cases handling
        if (normalizedPlatform == 'con') normalizedPlatform = 'concourse';
        if (normalizedPlatform == 'gud.' || normalizedPlatform == 'gud.end')
          normalizedPlatform = 'gudiyari_end';

        // Add to the set of normalized platforms
        normalizedPlatforms.add(normalizedPlatform);

        // Store a display version (use the first occurrence as the display format)
        if (!normalizedToDisplay.containsKey(normalizedPlatform)) {
          // Format platform number for display
          String displayName = stall.platformNumber;
          if (!displayName.toLowerCase().contains('platform') &&
              !displayName.toLowerCase().contains('pf')) {
            displayName = 'Platform $displayName';
          }
          normalizedToDisplay[normalizedPlatform] = displayName;
        }
      }
    }

    // Create a list with All Platforms first, followed by alphabetically sorted platforms
    List<String> result = ['All Platforms'];

    // Add other platforms in sorted order
    List<String> sortedNormalizedPlatforms = normalizedPlatforms.toList()
      ..sort();
    for (var normalizedPlatform in sortedNormalizedPlatforms) {
      result.add(normalizedToDisplay[normalizedPlatform]!);
    }

    return result;
  }

  List<FoodStall> get filteredStalls {
    return _allFoodStalls.where((stall) {
      // Print debug info for first few stalls to understand filtering
      if (_allFoodStalls.indexOf(stall) < 5) {
        print(
          'Filtering stall: station=${stall.station}, requested=${widget.stationName}',
        );
      }

      // Check if this is a station ID and map it if needed
      String stationName = stall.station;
      if (_stationIdToName.containsKey(stall.station)) {
        stationName = _stationIdToName[stall.station]!;
      }

      // Modified filter logic to be more flexible
      String normalizedStallStation = stationName.trim().toLowerCase();
      String normalizedRequestedStation = widget.stationName
          .trim()
          .toLowerCase();

      // Match station name (more flexible matching)
      if (!normalizedStallStation.contains(normalizedRequestedStation) &&
          !normalizedRequestedStation.contains(normalizedStallStation)) {
        return false;
      }

      // Filter by selected stall type if not 'All Types' - now case insensitive
      if (_selectedStallType != null &&
          _selectedStallType != 'All Types' &&
          stall.stallType.toLowerCase() != _selectedStallType!.toLowerCase()) {
        return false;
      }

      // Filter by selected platform if not 'All Platforms' - now case insensitive
      if (_selectedPlatform != null && _selectedPlatform != 'All Platforms') {
        String normalizedStallPlatform = _normalizePlatformNumber(
          stall.platformNumber,
        );
        String normalizedSelectedPlatform = _normalizePlatformNumber(
          _selectedPlatform!,
        );
        if (normalizedStallPlatform.toLowerCase() !=
            normalizedSelectedPlatform.toLowerCase()) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  // Helper method to normalize platform numbers
  String _normalizePlatformNumber(String platform) {
    // Remove "PF", "Platform", spaces, hyphens and convert to lowercase for consistent matching
    String normalized = platform
        .toLowerCase()
        .replaceAll('pf', '')
        .replaceAll('platform', '')
        .replaceAll(' ', '')
        .replaceAll('-', '')
        .trim();

    // Special cases for common platform numbers - make case insensitive
    if (normalized == "1") {
      return "1";
    } else if (normalized.toLowerCase() == "1a") {
      return "1a"; // Return lowercase for consistency
    } else if (normalized == "2&3" || normalized == "2and3") {
      return "2&3";
    } else if (normalized == "4&5" || normalized == "4and5") {
      return "4&5";
    } else if (normalized == "5&6" || normalized == "5and6") {
      return "5&6";
    }

    return normalized;
  }

  // Group stalls by platform for better organization
  Map<String, List<FoodStall>> get groupedStalls {
    final Map<String, List<FoodStall>> result = {};
    final Map<String, String> normalizedToOriginal = {};

    for (var stall in filteredStalls) {
      // Normalize the platform number
      String normalizedPlatform = _normalizePlatformNumber(
        stall.platformNumber,
      );

      // Special cases
      if (normalizedPlatform == 'con') normalizedPlatform = 'concourse';
      if (normalizedPlatform == 'gud.' || normalizedPlatform == 'gud.end')
        normalizedPlatform = 'gudiyari_end';

      // Store the original format for display
      if (!normalizedToOriginal.containsKey(normalizedPlatform)) {
        // Format for display: use PF prefix if missing
        String displayName = stall.platformNumber;
        if (!displayName.toLowerCase().contains('platform') &&
            !displayName.toLowerCase().contains('pf') &&
            !displayName.toLowerCase().contains('con') &&
            !displayName.toLowerCase().contains('gud')) {
          displayName = 'Platform $displayName';
        }
        normalizedToOriginal[normalizedPlatform] = displayName;
      }

      // Group by normalized platform
      if (!result.containsKey(normalizedPlatform)) {
        result[normalizedPlatform] = [];
      }
      result[normalizedPlatform]!.add(stall);
    }

    // Convert back to a map with display platform names
    final Map<String, List<FoodStall>> displayResult = {};
    result.forEach((normalizedKey, stalls) {
      displayResult[normalizedToOriginal[normalizedKey]!] = stalls;
    });

    return displayResult;
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
              child: Icon(Icons.restaurant, color: Colors.white, size: 28),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Food Services',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Find food stalls at various platforms',
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
      body: Container(
        color: const Color(0xFFF8F8F8),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.redAccent),
              )
            : Column(
                children: [
                  // Filter controls
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Platform filter dropdown
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            isExpanded: true, // Make dropdown use full width
                            decoration: InputDecoration(
                              labelText: 'Platform',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            value: _selectedPlatform ?? 'All Platforms',
                            items: _availablePlatforms.map((platform) {
                              return DropdownMenuItem(
                                value: platform,
                                child: Text(
                                  platform,
                                  overflow: TextOverflow
                                      .ellipsis, // Handle text overflow
                                  style: const TextStyle(fontSize: 14),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedPlatform = value == 'All Platforms'
                                    ? null
                                    : value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Stall type filter dropdown
                        Expanded(
                          // Added Expanded to ensure proper sizing
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Stall Type',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            value: _selectedStallType ?? 'All Types',
                            items: _stallTypes.map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedStallType = value == 'All Types'
                                    ? null
                                    : value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Stall List
                  Expanded(
                    child: groupedStalls.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.no_food,
                                  color: Colors.grey,
                                  size: 64,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No food stalls available at ${widget.stationName}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                if (_errorMessage.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                    ),
                                    child: Text(
                                      _errorMessage,
                                      style: const TextStyle(
                                        color: Colors.redAccent,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                  onPressed: _fetchFoodStalls,
                                  icon: const Icon(Icons.refresh),
                                  label: const Text("Refresh Data"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SingleChildScrollView(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Summary card - use widget.stationName
                                Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.amber.shade50,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.restaurant_menu,
                                          color: Colors.amber.shade700,
                                          size: 28,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${widget.stationName} Station Food Stalls',
                                              style: const TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.redAccent,
                                              ),
                                            ),
                                            const SizedBox(height: 1),
                                            Text(
                                              '${filteredStalls.length} stalls available',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color:
                                                    Colors.redAccent.shade100,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Display stalls grouped by platform
                                ...groupedStalls.entries.map(
                                  (entry) => _buildPlatformSection(
                                    entry.key,
                                    entry.value,
                                  ),
                                ),

                                const SizedBox(height: 12),
                                _buildInfoNote(),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildPlatformSection(String platformNumber, List<FoodStall> stalls) {
    // Get unique stall types in this platform
    final stallTypeGroups = <String, List<FoodStall>>{};
    for (var stall in stalls) {
      if (!stallTypeGroups.containsKey(stall.stallType)) {
        stallTypeGroups[stall.stallType] = [];
      }
      stallTypeGroups[stall.stallType]!.add(stall);
    }

    // Format platform number for display
    String displayPlatform = platformNumber;
    if (!platformNumber.toLowerCase().contains('platform') &&
        !platformNumber.toLowerCase().contains('pf')) {
      displayPlatform = 'Platform $platformNumber';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10, top: 20),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.shade100),
          ),
          child: Row(
            children: [
              Icon(Icons.location_on, color: Colors.blue.shade700),
              const SizedBox(width: 8),
              Text(
                displayPlatform.isEmpty ? 'Unknown Platform' : displayPlatform,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
            ],
          ),
        ),

        // Display stalls grouped by type
        ...stallTypeGroups.entries.map(
          (typeEntry) => _buildStallTypeGroup(typeEntry.key, typeEntry.value),
        ),
      ],
    );
  }

  Widget _buildStallTypeGroup(String stallType, List<FoodStall> stalls) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getIconForStallType(stallType),
                  color: Colors.orange.shade700,
                ),
                const SizedBox(width: 8),
                Text(
                  stallType,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: stalls.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              return _buildStallItem(stalls[index]);
            },
          ),
        ],
      ),
    );
  }

  IconData _getIconForStallType(String stallType) {
    switch (stallType) {
      case 'Tea Stall':
        return Icons.local_cafe;
      case 'Trolley':
        return Icons.shopping_cart;
      case 'Milk Stall':
        return Icons.emoji_food_beverage;
      case 'Juice Stall':
        return Icons.local_drink;
      case 'MPS':
        return Icons.fastfood;
      default:
        return Icons.restaurant;
    }
  }

  Widget _buildStallItem(FoodStall stall) {
    // Map station ID to name for display if needed
    String displayStation = stall.station;
    if (_stationIdToName.containsKey(stall.station)) {
      displayStation = _stationIdToName[stall.station]!;
    }

    return ListTile(
      title: Text(
        'Stall ${stall.stallNumber.isEmpty ? 'Unnamed' : '#' + stall.stallNumber}',
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text('${stall.stallType} • Platform ${stall.platformNumber}'),
      leading: CircleAvatar(
        backgroundColor: Colors.orange.shade100,
        child: Icon(
          _getIconForStallType(stall.stallType),
          color: Colors.orange.shade800,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        _showStallDetails(stall);
      },
    );
  }

  void _showStallDetails(FoodStall stall) {
    // Map station ID to name for display if needed
    String displayStation = stall.station;
    if (_stationIdToName.containsKey(stall.station)) {
      displayStation = _stationIdToName[stall.station]!;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(_getIconForStallType(stall.stallType), color: Colors.orange),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Stall ${stall.stallNumber.isEmpty ? 'Unnamed' : '#' + stall.stallNumber}',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Type', stall.stallType),
            _buildDetailRow('Platform', stall.platformNumber),
            // Removed Station and Division rows
            _buildDetailRow('Licensee', stall.licenseeName),
            _buildDetailRow(
              'Phone',
              stall.contactNumber,
              isPhone: true,
            ), // Added phone field with call capability
            _buildDetailRow('Contract Start', stall.contractStartDate),
            _buildDetailRow('Contract End', stall.contractEndDate),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isPhone = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: isPhone && value.isNotEmpty
                ? InkWell(
                    onTap: () async {
                      final Uri phoneUri = Uri(scheme: 'tel', path: value);
                      if (await canLaunchUrl(phoneUri)) {
                        await launchUrl(phoneUri);
                      }
                    },
                    child: Row(
                      children: [
                        Text(
                          value,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.call, size: 16, color: Colors.blue),
                      ],
                    ),
                  )
                : Text(
                    value.isEmpty ? 'N/A' : value,
                    style: const TextStyle(fontSize: 16),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoNote() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: Colors.blue.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Food Service Information',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 6),
                Text(
                  'Stalls opening hours may vary. Most stalls are available from 5 AM to 11 PM. Pricing is as per railway standards displayed at each stall.',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
