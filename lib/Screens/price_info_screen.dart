import 'package:flutter/material.dart';
import '../Screens/book_coolie.dart';

class PriceInfoScreen extends StatelessWidget {
  const PriceInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
                child: Icon(
                  Icons.currency_rupee_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Pricing',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Official sahayak service rates',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color.fromARGB(255, 221, 221, 221),
                        fontWeight: FontWeight.w300,
                      ),
                      maxLines: 1,
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
            preferredSize: const Size.fromHeight(48.0),
            child: Column(
              children: [
                Container(
                  height: 6.0,
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(5),
                    ),
                  ),
                ),
                const TabBar(
                  tabs: [
                    Tab(text: 'Raipur Station'),
                    Tab(text: 'Durg Station'),
                  ],
                  indicatorColor: Colors.white,
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white54,
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: MaterialStatePropertyAll(
                    Color.fromARGB(81, 252, 47, 47),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Builder(builder: (context) => _buildRaipurStationView(context)),
            Builder(builder: (context) => _buildDurgStationView(context)),
          ],
        ),
      ),
    );
  }

  // Raipur station view (replacing All stations view)
  Widget _buildRaipurStationView(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Raipur Station - Sahayak Charges',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Official rates for sahayak services at Raipur railway station',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 24),

          // Station info card
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 24),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.redAccent, Colors.red],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.train, color: Colors.white, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'Raipur Junction (R)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Station Category: NSG-2',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Station Code: R',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Division: Raipur, South East Central Railway',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),

          // Raipur Porter Charges Table
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Table(
                border: TableBorder.all(color: Colors.grey.shade300, width: 1),
                columnWidths: const {
                  0: FlexColumnWidth(0.7), // Sl. No.
                  1: FlexColumnWidth(3.5), // Description
                  2: FlexColumnWidth(2), // Charge
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  // Table Header
                  TableRow(
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.9),
                    ),
                    children: [
                      _buildHeaderCell('Sl.\nNo.'),
                      _buildHeaderCell('Description'),
                      _buildHeaderCell('Charges (in ₹)'),
                    ],
                  ),

                  // Raipur Station Specific Rows
                  TableRow(
                    children: [
                      _buildCell('1.', alignment: Alignment.center),
                      _buildCell(
                        'Rates for per head load per trip up to 40 Kgs. or part there of',
                        alignment: Alignment.centerLeft,
                      ),
                      _buildCell('100/-', alignment: Alignment.center),
                    ],
                  ),

                  TableRow(
                    children: [
                      _buildCell('2.', alignment: Alignment.center),
                      _buildCell(
                        'Waiting charges\n(First 30 minutes free and next 30 minutes or part thereof)',
                        alignment: Alignment.centerLeft,
                      ),
                      _buildCell('60/-', alignment: Alignment.center),
                    ],
                  ),

                  TableRow(
                    children: [
                      _buildCell('3.', alignment: Alignment.center),
                      _buildCell(
                        'Rates for wheeled barrows.\nWt. up to 160 kg. (Two wheeler or four wheeled)',
                        alignment: Alignment.centerLeft,
                      ),
                      _buildCell('120/-', alignment: Alignment.center),
                    ],
                  ),

                  TableRow(
                    children: [
                      _buildCell('4.', alignment: Alignment.center),
                      _buildCell(
                        'Rates for carrying sick or disabled person by wheel chair or stretcher by two person',
                        alignment: Alignment.centerLeft,
                      ),
                      _buildCell('100/-', alignment: Alignment.center),
                    ],
                  ),

                  TableRow(
                    children: [
                      _buildCell('5.', alignment: Alignment.center),
                      _buildCell(
                        'Rates for carrying sick or disabled person by four persons',
                        alignment: Alignment.centerLeft,
                      ),
                      _buildCell('150/-', alignment: Alignment.center),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Availability info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade700),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Raipur station has approximately 50 licensed porters available from 4:30 AM to 11:30 PM daily.',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Text(
              'N. B.:- The term head load means a quantity of one or more package a man can reasonably '
              'be expected to carry i.e. weight up to 40 kgs.',
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            ),
          ),

          const SizedBox(height: 32),

          // Commented out Contact Information section
          /*
          const Text(
            'Contact Information',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '• Station Manager: 0771-2235574\n'
            '• Railway Police: 0771-2235479\n'
            '• Porter Supervisor: Available at Main Entrance',
            style: TextStyle(fontSize: 14),
          ),
          */
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to BookCoolie without any parameters
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => BookCoolie()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Book your Sahayak',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Durg station specific view
  Widget _buildDurgStationView(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Durg Station - Sahayak Charges',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Official rates for sahayak services at Durg railway station',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 24),

          // Station info card
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 24),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.redAccent, Colors.red],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.train, color: Colors.white, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'Durg Junction (DURG)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Station Category: NSG-2',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Station Code: DURG',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Division: Raipur, South East Central Railway',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),

          // Durg Porter Charges Table
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Table(
                border: TableBorder.all(color: Colors.grey.shade300, width: 1),
                columnWidths: const {
                  0: FlexColumnWidth(0.7), // Sl. No.
                  1: FlexColumnWidth(3.5), // Description
                  2: FlexColumnWidth(2), // Charge
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  // Table Header
                  TableRow(
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.9),
                    ),
                    children: [
                      _buildHeaderCell('Sl.\nNo.'),
                      _buildHeaderCell('Description'),
                      _buildHeaderCell('Charges (in ₹)'),
                    ],
                  ),

                  // Durg Station Specific Rows
                  TableRow(
                    children: [
                      _buildCell('1.', alignment: Alignment.center),
                      _buildCell(
                        'Rates for per head load per trip up to 40 Kgs. or part there of',
                        alignment: Alignment.centerLeft,
                      ),
                      _buildCell('80/-', alignment: Alignment.center),
                    ],
                  ),

                  TableRow(
                    children: [
                      _buildCell('2.', alignment: Alignment.center),
                      _buildCell(
                        'Waiting charges\n(First 30 minutes free and next 30 minutes or part thereof)',
                        alignment: Alignment.centerLeft,
                      ),
                      _buildCell('50/-', alignment: Alignment.center),
                    ],
                  ),

                  TableRow(
                    children: [
                      _buildCell('3.', alignment: Alignment.center),
                      _buildCell(
                        'Rates for wheeled barrows.\nWt. up to 160 kg. (Two wheeler or four wheeled)',
                        alignment: Alignment.centerLeft,
                      ),
                      _buildCell('80/-', alignment: Alignment.center),
                    ],
                  ),

                  TableRow(
                    children: [
                      _buildCell('4.', alignment: Alignment.center),
                      _buildCell(
                        'Rates for carrying sick or disabled person by wheel chair or stretcher by two person',
                        alignment: Alignment.centerLeft,
                      ),
                      _buildCell('100/-', alignment: Alignment.center),
                    ],
                  ),

                  TableRow(
                    children: [
                      _buildCell('5.', alignment: Alignment.center),
                      _buildCell(
                        'Rates for carrying sick or disabled person by four persons',
                        alignment: Alignment.centerLeft,
                      ),
                      _buildCell('150/-', alignment: Alignment.center),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Availability info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade700),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Durg station has approximately 35 licensed porters available from 5:00 AM to 11:00 PM daily.',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Commented out Contact Information section
          /*
          const Text(
            'Contact Information',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '• Station Manager: 0788-2322425\n'
            '• Railway Police: 0788-2322635\n'
            '• Porter Supervisor: Available at Platform 1 entrance',
            style: TextStyle(fontSize: 14),
          ),
          */
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to BookCoolie without any parameters
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => BookCoolie()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Book your Sahayak',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for building table rows with multiple stations
  TableRow _buildRowWithMultipleStations({
    required String slNo,
    required String description,
    required List<Map<String, String>> stations,
  }) {
    List<TableRow> stationRows = [];

    // First station row with sl no and description
    stationRows.add(
      TableRow(
        children: [
          _buildCell(
            slNo,
            rowSpan: stations.length,
            alignment: Alignment.center,
          ),
          _buildCell(
            description,
            rowSpan: stations.length,
            alignment: Alignment.centerLeft,
          ),
          _buildCell(stations[0]['name']!, alignment: Alignment.center),
          _buildCell(stations[0]['charge']!, alignment: Alignment.center),
        ],
      ),
    );

    // Remaining station rows
    for (int i = 1; i < stations.length; i++) {
      stationRows.add(
        TableRow(
          children: [
            _buildCell(stations[i]['name']!, alignment: Alignment.center),
            _buildCell(stations[i]['charge']!, alignment: Alignment.center),
          ],
        ),
      );
    }

    return stationRows[0];
  }

  Widget _buildHeaderCell(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      color: Colors.redAccent,
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCell(
    String text, {
    Alignment alignment = Alignment.center,
    int rowSpan = 1,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      height: rowSpan > 1 ? 50.0 * rowSpan : null,
      alignment: alignment,
      child: Text(text),
    );
  }

  Widget _buildEmptyCell() {
    return Container();
  }
}
