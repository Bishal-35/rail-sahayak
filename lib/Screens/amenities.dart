import 'package:flutter/material.dart';

class AmenitiesScreen extends StatefulWidget {
  final String stationName;

  const AmenitiesScreen({super.key, required this.stationName});

  @override
  State<AmenitiesScreen> createState() => _AmenitiesScreenState();
}

class _AmenitiesScreenState extends State<AmenitiesScreen> {
  late Map<String, String> amenityDescriptions;

  final Map<String, String> raipurAmenities = {
    "FOB RAMP AND ESCALATORS":
        """•  FOOT OVER BRIDGE BSP END - NEAR POLE NO. 07-08
•  FOOT OVER BRIDGE NEAR GATE NO 02 - NEAR POLE NO. 18-19
•  LIFT (03 NOS) - 01 NEAR GATE NO.02 NEAR POLE NO. 21-22, 02 FOB AT PF 02/03, 03 FOB AT PF 05/06
•  FOOT OVER BRIDGE NEW - NEAR POLE NO. 24-25
•  FOOT OVER BRIDGE DURG END - NEAR POLE NO. 34-35
•  ESCALATOR UPWARD AND DOWNWARD - 01 NOS OUTSIDE GATE NO. 02, 01 NOS PF 07 GUDIYARI SIDE""",

    "SAHYOG COUNTER": """•  SAHYOG COUNTER - GATE NO. 02""",

    "CLOAK ROOM": """•  CLOAK ROOM - NEAR POLE NO. 23 """,

    "AKSHITA BUBBLES (ONLY FOR UNACCOMPANIED LADIES)":
        """•  AKSHITA (ONLY FOR LADIES) - NEAR POLE NO. 30-31 """,

    "LOUNGES AND WAITING HALL":
        """•  UPPER CLASS WAITING GENTS - NEAR POLE NO. 17-18
•  UPPER CLASS WAITING LADIES - NEAR POLE NO. 17-18
•  SECOND CLASS WAITING HALL GENTS - NEAR POLE NO. 19-20
•  SECOND CLASS WAITING HALL LADIES - NEAR POLE NO. 18-19
•  VIP-LOUNGE - NEAR POLE NO. 13-14
•  RETIRING ROOM (03 NOS AC, 02 NOS NON AC) - UPSTAIRS NEAR POLE NO. 15-16
•  DORMITORY (08 BEDS) - UPSTAIRS NEAR POLE NO. 15-16
•  AC DORMITORY (14 BEDS) - UPSTAIRS PRS BUILDING
•  OPEN WAITING AREA GENTS - NEAR POLE NO. 31-32
""",

    "RAIL PARCEL AND MAIL SERVICE ":
        """•  RAIL MAIL SERVICE - NEAR POLE NO. 09-11
•  PARCEL OFFICE OUTSIDE PLATFORM MAIN SIDE - IN FRONT OF EXIT GATE PF PF 1A""",

    "TOILET": """•  TOILET - PAY & USE TOILET ALL WAITING HALL""",

    "PARKING FACILITIES":
        """•  TWO WHEELER PARKING - NEAR ENTRANCE OF STATION AREA GURUDWARA SIDE
•  FOUR WHEELER PARKING - IN FRONT OF STATION BUILDING GATE NO. 02
•  FOUR WHEELER PARKING (PREMIUM) - IN FRONT OF VIP GATE, GATE NO. 01""",

    "ATM": """•  ATM(SBI,PNB,BOB) 03 NOS - NEAR BOOKING COUNTER""",

    "DY STATION SUPERINTENDENT OFFICE":
        """•  DY STATION SUPERINTENDED - NEAR POLE NO. 11-12""",

    "STATION MANAGER OFFICE": """•  STATION MANAGER - NEAR POLE NO. 12-13""",

    "CHIEF TICKET INSPECTOR OFFICE":
        """•  CHIEF TICKET INSPECTOR STATION - NEAR POLE NO. 12-13
•  BATTERY OPERATED CAR FOR DIVYANG SENIOR CITIZEN 01 NOS - NEAR TWO WHEELER PARKING""",

    "TICKET FACILITIES": """•  UTS & PRS COUNTER - NEAR TWO WHEELER PARKING """,

    "CONCOURSE AREA (ATM)": """•  SBI BANK - STATE BANK OF INDIA
•  UBI BANK - UNION BANK OF INDIA
•  BOB BANK - BANK OF BARODA
•  PSB BANK - PUNJAB AND SIND BANK""",
  };

  final Map<String, String> durgAmenities = {
    "PARKING FACILITIES":
        """•  TWO WHEELER PARKING - NEAR ENTRANCE AND EXIT GATE OF THE STATION
•  TWO WHEELER PARKING (PREMIUM) - IN CIRCULATING AREA BEHIND BOOKING OFFICE BUILDING
•  FOUR WHEELER PARKING - NEAR ENTRANCE AND EXIT GATE OF THE STATION
•  FOUR WHEELER PARKING (PREMIUM) - IN CIRCULATING AREA BEHIND THE EXIT OF THE STATION BUILDING""",

    "TICKETING FACILITIES":
        """•  PASSENGER RESERVATION SYSTEM PRS & UTS COUNTER -
     1. IN CIRCULATING AREA NEAR STATION ENTRY GATE CITY SIDE
     2. IN CIRCULATING AREA NEAR STATION ENTRY GATE GUDHIYARI PF-7 SIDE
     3. AT CENTRAL ENTRY GATE
•  SAHYOG COUNTER - AT CONCOURSE AREA""",

    "FOB RAMP AND ESCALATORS":
        """•  FOOT OVER BRIDGE RAIPUR END - AT PF-01 NEAR POLE NO. 22
•  FOOT OVER BRIDGE NGP END - AT PF-01 NEAR POLE NO. 31
•  ESCALATOR UPWARD AND DOWNWARD - AT PF-01 NGP END BEHIND FOOT OVER BRIDGE
•  LIFT (03 NOS) - AT FOOT OVER BRIDGE NGP END
•  FOOT OVER BRIDGE (PF-04 & PF-05 TO ...) - AT PF-04 & 05 R-END""",

    "RAIL PARCEL AND MAIL SERVICE": """•  RAIL MAIL SERVICE - AT PF-01
•  PARCEL OFFICE OUTSIDE PLATFORM MAIN SIDE - AT NGP END OF THE STATION BUILDING""",

    "LOUNGES AND WAITING HALL":
        """•  VIP-LOUNGE - AT PF-01 NEAR POLE NO. 24 & 25
•  RETIRING ROOM (02 NO. AC, 07 NO. NON AC) - AT 1ST FLOOR OF THE STATION BUILDING
•  DORMITORY (02 BEDS) - AT 1ST FLOOR OF THE STATION BUILDING
•  UPPER CLASS WAITING GENTS - AT 1ST FLOOR OF THE STATION BUILDING
•  UPPER CLASS WAITING LADIES - AT 1ST FLOOR OF THE STATION BUILDING
•  SECOND CLASS WAITING HALL - AT PF-01 NEAR POLE NO. 28
•  OPEN WAITING AREA - AT CONCOURSE AREA""",

    "TOILET": """•  PAY & USE TOILET INSIDE THE WAITING HALL
•  FREE LADIES AND GENTS TOILETS AT PLATFORM NO. 1""",

    "CLOAK ROOM": """•  CLOAK ROOM - AT PARCEL OFFICE NEAR POLE NO. 30 & 31""",

    "AKSHITA BUBBLES (ONLY FOR UNACCOMPANIED LADIES)":
        """•  AKSHITA - NEAR POLE NO. 28 & 29 AT PF-01""",

    "DY STATION SUPERINTENDENT OFFICE":
        """•  DY STATION SUPERINTENDENT OFFICE - AT PF-01 NEAR POLE NO. 25""",

    "STATION MANAGER OFFICE":
        """•  STATION MANAGER OFFICE - AT PF-01 NEAR POLE NO. 24""",

    "CHIEF TICKET INSPECTOR OFFICE":
        """•  CHIEF TICKET INSPECTOR OFFICE - AT PF-01 NEAR POLE NO. 25""",

    "CONCOURSE AREA (ATM)": """•  SBI BANK - STATE BANK OF INDIA
•  UBI BANK - UNION BANK OF INDIA
•  BOB BANK - BANK OF BARODA
•  PSB BANK - PUNJAB & SIND BANK""",

    "GRP OFFICE": """•  GRP OFFICE - AT PF-01 NEAR POLE NO. 22""",

    "STATION SUPERINTENDENT (COMMERCIAL)":
        """•  STATION SUPERINTENDENT (COMMERCIAL) - AT PF-01 NEAR POLE NO. 24""",

    "BATTERY OPERATED CAR FOR DIVYANG SENIOR CITIZEN":
        """•  BATTERY OPERATED CAR FOR DIVYANG SENIOR CITIZEN (01 NOS) - NEAR EXIT GATE BEHIND STATION MODEL IN CONCOURSE AREA""",

    "DISABILITY ASSIST DEVICES":
        """•  04-WHEEL CHAIR, 1-RAMP, 1-STRETCHER AT ENQUIRY OFFICE - AT PF-01 NEAR POLE NO. 26""",
  };

  @override
  void initState() {
    super.initState();
    if (widget.stationName.toLowerCase() == 'raipur') {
      amenityDescriptions = raipurAmenities;
    } else if (widget.stationName.toLowerCase() == 'durg') {
      amenityDescriptions = durgAmenities;
    } else {
      amenityDescriptions = {}; // Default empty for unknown station
    }
  }

  void _showAmenityDialog(String title, String description) {
    // Parse the description to separate individual bullet points
    List<String> bulletPoints = description
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .map(
          (line) => line.trim().startsWith('•')
              ? line.substring(1).trim()
              : line.trim(),
        )
        .toList();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFFFFFDE7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.all(20),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.orange),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
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

              // Display each bullet point with proper styling and dynamic bullets
              ...bulletPoints
                  .map(
                    (point) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 6, right: 8),
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Colors.brown,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              point,
                              style: const TextStyle(fontSize: 14, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),

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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final titles = amenityDescriptions.keys.toList();

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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Passenger Amenities at ${widget.stationName} Station",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Find all available facilities at the station',
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
      body: amenityDescriptions.isEmpty
          ? const Center(child: Text("No data available for this station"))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2,
                children: titles.map((title) {
                  return GestureDetector(
                    onTap: () =>
                        _showAmenityDialog(title, amenityDescriptions[title]!),
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
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.brown,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
    );
  }
}
