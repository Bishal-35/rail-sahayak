import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FoodStall {
  final String division;
  final String stallNumber;
  final String stallType;
  final String station;
  final String platformNumber;

  FoodStall({
    required this.division,
    required this.stallNumber,
    required this.stallType,
    required this.station,
    required this.platformNumber,
  });
}

class FoodServices extends StatefulWidget {
  final String stationName; // Add parameter to receive station name

  const FoodServices({
    super.key,
    required this.stationName,
  }); // Update constructor

  @override
  State<FoodServices> createState() => _FoodServicesState();
}

class _FoodServicesState extends State<FoodServices> {
  String? _selectedStallType;
  String? _selectedPlatform; // Add new state variable for platform filter
  final List<String> _stallTypes = [
    'All Types',
    'Tea Stall',
    'Trolley',
    'Milk Stall',
    'Juice Stall',
    'MPS',
  ];

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

  // List of all food stalls based on the data provided
  final List<FoodStall> _allFoodStalls = [
    // Raipur station stalls
    FoodStall(
      division: 'Raipur',
      stallNumber: 'A1',
      stallType: 'Tea Stall',
      station: 'Raipur',
      platformNumber: 'PF1',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'A11',
      stallType: 'Tea Stall',
      station: 'Raipur',
      platformNumber: 'CON',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'A3',
      stallType: 'Tea Stall',
      station: 'Raipur',
      platformNumber: 'PF1',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'A4',
      stallType: 'Tea Stall',
      station: 'Raipur',
      platformNumber: 'PF1',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'A5',
      stallType: 'Tea Stall',
      station: 'Raipur',
      platformNumber: 'PF1',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'A6',
      stallType: 'Tea Stall',
      station: 'Raipur',
      platformNumber: 'PF1',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'B1',
      stallType: 'Tea Stall',
      station: 'Raipur',
      platformNumber: 'PF2&3',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'B2',
      stallType: 'Tea Stall',
      station: 'Raipur',
      platformNumber: 'PF2&3',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'B3',
      stallType: 'Tea Stall',
      station: 'Raipur',
      platformNumber: 'PF2&3',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'B4',
      stallType: 'Tea Stall',
      station: 'Raipur',
      platformNumber: 'PF2&3',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'B6',
      stallType: 'Tea Stall',
      station: 'Raipur',
      platformNumber: 'PF2&3',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'C1',
      stallType: 'Tea Stall',
      station: 'Raipur',
      platformNumber: 'PF5&6',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'C2',
      stallType: 'Tea Stall',
      station: 'Raipur',
      platformNumber: 'PF5&6',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'C3',
      stallType: 'Tea Stall',
      station: 'Raipur',
      platformNumber: 'PF5&6',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'C4',
      stallType: 'Tea Stall',
      station: 'Raipur',
      platformNumber: 'PF5&6',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'C5',
      stallType: 'Tea Stall',
      station: 'Raipur',
      platformNumber: 'PF5&6',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'G1',
      stallType: 'Tea Stall',
      station: 'Raipur',
      platformNumber: 'Gud.',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'D1',
      stallType: 'Tea Stall',
      station: 'Raipur',
      platformNumber: 'PF1A',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'JB-3',
      stallType: 'Juice Stall',
      station: 'Raipur',
      platformNumber: 'PF2&3',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'B-5',
      stallType: 'Tea Stall',
      station: 'Raipur',
      platformNumber: 'PF2&3',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'C-8',
      stallType: 'Tea Stall',
      station: 'Raipur',
      platformNumber: 'PF5&6',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'A-2',
      stallType: 'Tea Stall',
      station: 'Raipur',
      platformNumber: 'PF1',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'TA1',
      stallType: 'Trolley',
      station: 'Raipur',
      platformNumber: 'PF1',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'TA2',
      stallType: 'Trolley',
      station: 'Raipur',
      platformNumber: 'PF1',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'TA3',
      stallType: 'Trolley',
      station: 'Raipur',
      platformNumber: 'PF1',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'TA4',
      stallType: 'Trolley',
      station: 'Raipur',
      platformNumber: 'PF1',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'TAE-1',
      stallType: 'Trolley',
      station: 'Raipur',
      platformNumber: 'PF1A',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'TB1',
      stallType: 'Trolley',
      station: 'Raipur',
      platformNumber: 'PF2&3',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'TB2',
      stallType: 'Trolley',
      station: 'Raipur',
      platformNumber: 'PF2&3',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'TC1',
      stallType: 'Trolley',
      station: 'Raipur',
      platformNumber: 'PF5&6',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'TC2',
      stallType: 'Trolley',
      station: 'Raipur',
      platformNumber: 'PF5&6',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'TC3',
      stallType: 'Trolley',
      station: 'Raipur',
      platformNumber: 'PF5&6',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'MS-1',
      stallType: 'Milk Stall',
      station: 'Raipur',
      platformNumber: '1',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'MS-2',
      stallType: 'Milk Stall',
      station: 'Raipur',
      platformNumber: '1',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'MS-3',
      stallType: 'Milk Stall',
      station: 'Raipur',
      platformNumber: '2&3',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'MS-4',
      stallType: 'Milk Stall',
      station: 'Raipur',
      platformNumber: '5&6',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'MS-5',
      stallType: 'Milk Stall',
      station: 'Raipur',
      platformNumber: '2&3',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'MS-6',
      stallType: 'Milk Stall',
      station: 'Raipur',
      platformNumber: '5&6',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'JB-6',
      stallType: 'Juice Stall',
      station: 'Raipur',
      platformNumber: '5&6',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'MS-7',
      stallType: 'Milk Stall',
      station: 'Raipur',
      platformNumber: 'Gud. End',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'G-1',
      stallType: 'Tea Stall',
      station: 'Raipur',
      platformNumber: 'Gud. End',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'MPS1',
      stallType: 'MPS',
      station: 'Raipur',
      platformNumber: '1',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'MPS2',
      stallType: 'MPS',
      station: 'Raipur',
      platformNumber: '1',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'MPS3',
      stallType: 'MPS',
      station: 'Raipur',
      platformNumber: '1',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'MPS4',
      stallType: 'MPS',
      station: 'Raipur',
      platformNumber: '5&6',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'MPS5',
      stallType: 'MPS',
      station: 'Raipur',
      platformNumber: '5&6',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'MPS6',
      stallType: 'MPS',
      station: 'Raipur',
      platformNumber: '2&3',
    ),

    // Durg station stalls
    FoodStall(
      division: 'Raipur',
      stallNumber: 'A1',
      stallType: 'Tea Stall',
      station: 'Durg',
      platformNumber: 'PF1',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'A2',
      stallType: 'Tea Stall',
      station: 'Durg',
      platformNumber: 'PF1',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'A3',
      stallType: 'Tea Stall',
      station: 'Durg',
      platformNumber: 'PF1',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'A4',
      stallType: 'Tea Stall',
      station: 'Durg',
      platformNumber: 'PF1',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'A5',
      stallType: 'Tea Stall',
      station: 'Durg',
      platformNumber: 'PF1',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'A6',
      stallType: 'Tea Stall',
      station: 'Durg',
      platformNumber: 'PF1',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'B1',
      stallType: 'Tea Stall',
      station: 'Durg',
      platformNumber: 'PF2&3',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'B2',
      stallType: 'Tea Stall',
      station: 'Durg',
      platformNumber: 'PF2&3',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'B3',
      stallType: 'Tea Stall',
      station: 'Durg',
      platformNumber: 'PF2&3',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'B4',
      stallType: 'Tea Stall',
      station: 'Durg',
      platformNumber: 'PF2&3',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'B5',
      stallType: 'Tea Stall',
      station: 'Durg',
      platformNumber: 'PF2&3',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'B6',
      stallType: 'Tea Stall',
      station: 'Durg',
      platformNumber: 'PF2&3',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'C1',
      stallType: 'Tea Stall',
      station: 'Durg',
      platformNumber: 'PF-4&5',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'C2',
      stallType: 'Tea Stall',
      station: 'Durg',
      platformNumber: 'PF-4&5',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'B-7',
      stallType: 'Tea Stall',
      station: 'Durg',
      platformNumber: 'PF-2&3',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'D-1',
      stallType: 'Tea Stall',
      station: 'Durg',
      platformNumber: 'CON',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'TA1',
      stallType: 'Trolley',
      station: 'Durg',
      platformNumber: 'PF1',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'TA2',
      stallType: 'Trolley',
      station: 'Durg',
      platformNumber: 'PF1',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'TA3',
      stallType: 'Trolley',
      station: 'Durg',
      platformNumber: 'PF1',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'TA4',
      stallType: 'Trolley',
      station: 'Durg',
      platformNumber: 'PF1',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'TB1',
      stallType: 'Trolley',
      station: 'Durg',
      platformNumber: 'PF2&3',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'TB2',
      stallType: 'Trolley',
      station: 'Durg',
      platformNumber: 'PF2&3',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'TB3',
      stallType: 'Trolley',
      station: 'Durg',
      platformNumber: 'PF2&3',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'MS-1',
      stallType: 'Milk Stall',
      station: 'Durg',
      platformNumber: '1',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'MS-2',
      stallType: 'Milk Stall',
      station: 'Durg',
      platformNumber: '2&3',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'MS-3',
      stallType: 'Milk Stall',
      station: 'Durg',
      platformNumber: '4&5',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'MS-6',
      stallType: 'Milk Stall',
      station: 'Durg',
      platformNumber: '4&5',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'JB-1',
      stallType: 'Juice Stall',
      station: 'Durg',
      platformNumber: '1',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'MPS3',
      stallType: 'MPS',
      station: 'Durg',
      platformNumber: '2&3',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'MPS4',
      stallType: 'MPS',
      station: 'Durg',
      platformNumber: '4&5',
    ),

    // Other station stalls
    FoodStall(
      division: 'Raipur',
      stallNumber: 'A2',
      stallType: 'Tea Stall',
      station: 'BYT',
      platformNumber: 'PF1&2',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'C-1',
      stallType: 'Tea Stall',
      station: 'BYT',
      platformNumber: 'PF-5',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'MPS-3',
      stallType: 'MPS',
      station: 'BYT',
      platformNumber: 'PF-2&3',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'B2',
      stallType: 'Tea Stall',
      station: 'BYT',
      platformNumber: 'PF3&4',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'MS-2',
      stallType: 'Milk Stall',
      station: 'BYT',
      platformNumber: '3&4',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'MPS1',
      stallType: 'MPS',
      station: 'BYT',
      platformNumber: '',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'A1',
      stallType: 'Tea Stall',
      station: 'Tilda',
      platformNumber: 'PF1',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'MPS-2',
      stallType: 'MPS Stall',
      station: 'Tilda',
      platformNumber: 'PF-2&3',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'MS-1',
      stallType: 'Milk Stall',
      station: 'BPHB',
      platformNumber: '1',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'MS-2',
      stallType: 'Milk Stall',
      station: 'BPHB',
      platformNumber: '2&3',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'MPS-1',
      stallType: 'MPS',
      station: 'BPHB',
      platformNumber: '1',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: '',
      stallType: 'Tea Stall',
      station: 'BYL',
      platformNumber: '1',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: '',
      stallType: 'Tea Stall',
      station: 'HN',
      platformNumber: '1',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: '',
      stallType: 'Tea Stall',
      station: 'DRZ',
      platformNumber: '1',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: '',
      stallType: 'Tea Stall',
      station: 'BXA',
      platformNumber: '1',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: '',
      stallType: 'Tea Stall',
      station: 'NPI',
      platformNumber: '1',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: '',
      stallType: 'Tea Stall',
      station: 'CHBT',
      platformNumber: '1',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: '',
      stallType: 'Tea Stall',
      station: 'MXA',
      platformNumber: '1',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: '',
      stallType: 'Tea Stall',
      station: 'GDZ',
      platformNumber: '1',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: '',
      stallType: 'Tea Stall',
      station: 'BPTP',
      platformNumber: '1',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'URK-1',
      stallType: 'Tea Stall',
      station: 'URK',
      platformNumber: '1',
    ),
    FoodStall(
      division: 'Raipur',
      stallNumber: 'BIA-3',
      stallType: 'Tea Stall',
      station: 'BIA',
      platformNumber: '1',
    ),
  ];

  List<FoodStall> get filteredStalls {
    return _allFoodStalls.where((stall) {
      // Only show stalls for Raipur and Durg
      if (stall.station != 'Raipur' && stall.station != 'Durg') {
        return false;
      }

      // Filter by station from parameter instead of selected station
      if (stall.station != widget.stationName) {
        return false;
      }

      // Filter by selected stall type if not 'All Types'
      if (_selectedStallType != null &&
          _selectedStallType != 'All Types' &&
          stall.stallType != _selectedStallType) {
        return false;
      }

      // Filter by selected platform if not 'All Platforms'
      if (_selectedPlatform != null && _selectedPlatform != 'All Platforms') {
        String normalizedStallPlatform = _normalizePlatformNumber(
          stall.platformNumber,
        );
        String normalizedSelectedPlatform = _normalizePlatformNumber(
          _selectedPlatform!,
        );
        if (normalizedStallPlatform != normalizedSelectedPlatform) {
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

    // Special cases for common platform numbers
    if (normalized == "1") {
      return "1";
    } else if (normalized == "1a" || normalized == "1A") {
      return "1A";
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
        child: Column(
          children: [
            // Filter controls - place dropdowns side by side
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
                // Changed from Column to Row
                children: [
                  // Platform filter dropdown
                  Expanded(
                    // Added Expanded to ensure proper sizing
                    child: DropdownButtonFormField<String>(
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
                          child: Text(platform),
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
                  const SizedBox(width: 12), // Changed from height to width
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
                        return DropdownMenuItem(value: type, child: Text(type));
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
                  ? const Center(
                      child: Text(
                        'No food stalls available for this selection',
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
                                    borderRadius: BorderRadius.circular(8),
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
                                          color: Colors.redAccent.shade100,
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
                            (entry) =>
                                _buildPlatformSection(entry.key, entry.value),
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
            _buildDetailRow('Station', stall.station),
            _buildDetailRow('Division', stall.division),
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

  Widget _buildDetailRow(String label, String value) {
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
            child: Text(
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
