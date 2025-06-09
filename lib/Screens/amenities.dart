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
    "Good Approach Road":
        """•  Good Approach Road is Available for Pickup and Drop at Entry Gate - City Side & PF-7 SIDE""",

    "Parking Facilities":
        """•  TWO WHEELER PARKING - NEAR ENTRANCE OF STATION AREA GURUDWARA SIDE
•  FOUR WHEELER PARKING - IN FRONT OF STATION BUILDING GATE NO 02
•  FOUR WHEELER PARKING (PREMIUM) - IN FRONT OF VIP GATE, GATE NO. 01""",

    "Laungs & Waiting Halls":
        """•  VIP-LOUNGE - COLUMN NO-13-14 (Near Gate no - 1 at Platform - 1)
•  RETIRING ROOM (03 NOS AC, 02 NOS NON-AC) - UPSTAIRS COLUMN NO 15-16 (VIP Gate at Platform - 1)
•  DORMITORY(08 BEDS) - UPSTAIRS COLUMN NO 15-16 (VIP Gate at Platform - 1)
•  UPPER CLASS WAITING GENTS - COLUMN NO. 17-18 (Between Gate no 1 & 2 at Platform - 1)
•  UPPER CLASS WAITING LADIES - COLUMN NO. 17-18 (Between Gate no 1 & 2 at Platform - 1)
•  ORH - Up Stairs VIP Gate
•  SECOND CLASS WAITING HALL GENTS - COLUMN NO. 19-20 (Between Gate no 1 & 2 at Platform - 1)
•  AC DORMITORY (14 BEDS) - UP STAIRS PRS BUILDING (Durg End)
•  SECOND CLASS WAITING HALL LADIES - COLUMN NO.18-19 (Between Gate no 1 & 2 at Platform - 1)""",

    "Lifts, Escalators & FOB":
        """•  Foot Over Bridge - COLUMN NO. 18-19 (Near Gate No 02)
•  Foot Over Bridge BSP End - COLUMN NO. 07-08
•  Foot Over Bridge New - COLUMN NO. 24-25 (Durg End)
•  Foot Over Bridge Durg End - COLUMN NO. 34-35 (Durg End)
•  Escalator Upward and Downward - 01 NOS OUT-SIDE GATE NO 02 01 NOS PF 07 GUDIYARI SIDE
•  Lift (03 Nos) - 01 - NEAR GATE NO.02 COLUMN 21-22, 02 - FOB AT PF 02/03, 03 - FOB AT PF 05/06""",

    "Sahyog (Enquiry) Counter": """•  Sahyog Counter - GATE NO-02""",

    "ATM Facilities":
        """•  ATM(SBI,PNB,BOB) 03 Nos - NEAR BOOKING COUNTER (Gate no -2, Concourse Area)""",

    "Cloak Facilities": """•  Cloak Room - COLUMN NO. 23 (Near Gate no - 2)""",

    "Akshita Bubble (Only for Ladies)":
        """•  Akshita (Only for Ladies) - COLUMN NO. 30-31 (Durg End)""",

    "Parcel and Rail-Mail Service":
        """•  Rail Mail Service - COLUMN NO. 09-11 (BSP End at Platform - 1)
•  Parcel Office Outside Platform Main Side - IN FRONT OF EXIT GATE OF PF 1A""",

    "Water Booths & Water Cooler": "",

    "PAY & USE TOILET": """•  PAY & USE TOILET - ALL WAITING HALL""",

    "Toilets & Urinal":
        """•  Ladies Urinal at Platform - 1 - 3 at BSP End & 1 at Durg End
•  Gents Urinal at Platform - 1 - 6 at BSP End & 6 at Durg End
•  Ladies Urinal at Platform - 1A - 2 at Durg End
•  Gents Urinal at Platform - 1A - 1 at Durg End
•  Ladies Urinal at Platform - 2/3 - 2 at BSP
•  Gents Urinal at Platform - 2/3 - 2 at BSP
•  Gents Urinal at Platform - 5/6 - 2 at BSP End
•  Ladies Urinal at Platform - 7 - 1 at BSP End
•  Gents Urinal at Platform - 7 - 2 at BSP End & 2 at Durg End
•  Ladies Toilet at Platform - 1 - 1 at Durg End
•  Ladies Toilet at Platform - 1A - 1 at Durg End
•  Gents Toilet at Platform - 1A - 2 at Durg End
•  Ladies Toilet at Platform - 5/6 - 1 at BSP End
•  Gents Toilet at Platform - 5/6 - 1 at BSP End
•  Ladies Toilet at Platform - 7 - 1 at BSP End & 1 at Durg End
•  Gents Toilet at Platform - 7 - 1 at BSP End & 1 at Durg End""",

    "Divyang Toilet":
        """•  Divyang Toilet at Platform - 1A - 1 at Middle of the Platform 1A
•  Divyang Toilet at Platform - 2/3 - 1 at Durg End
•  Divyang Toilet at Platform - 5/6 - 1 at Durg End""",
  };

  final Map<String, String> durgAmenities = {
    "Good Approach Road":
        "•  Two nos Approach Road available with Drop and Go facility",

    "Parking Facilities":
        """•  Paid Parking facility, separate for Two and Four wheelers available
•  Free Parking for Divyangjans with Ramp facility near Porch Area is available""",

    "Lounges & Waiting Halls": """•  VIP-LOUNGE - AT PF-01 NEAR POLE NO. 24 & 25
•  RETIRING ROOM (02 NO. AC, 07 NO. NON AC) - AT 1ST FLOOR OF THE STATION BUILDING
•  DORMITORY (02 BEDS) - AT 1ST FLOOR OF THE STATION BUILDING
•  UPPER CLASS WAITING GENTS - AT 1ST FLOOR OF THE STATION BUILDING
•  UPPER CLASS WAITING LADIES - AT 1ST FLOOR OF THE STATION BUILDING
•  SECOND CLASS WAITING HALL - AT PF-01 NEAR POLE NO. 28
•  OPEN WAITING AREA - AT CONCOURSE AREA""",

    "Lifts, Escalators & FOB":
        """•  Foot Over Bridge Raipur End - AT PF-01 NEAR POLE NO. 22
•  Foot Over Bridge NGP End - AT PF-01 NEAR POLE NO. 31
•  Escalator Upward and Downward - AT PF-01 NGP END BEHIND FOOT OVER BRIDGE
•  Lift (03 Nos) - AT FOOT OVER BRIDGE NGP END
•  Foot Over Bridge (PF-04 & PF-05 to ...) - AT PF-04 & 05 R-END""",

    "Sahyog (Enquiry) Counter": """•  Sahyog Counter - AT CONCOURSE AREA""",

    "ATM Facilities": """•  SBI Bank - STATE BANK OF INDIA
•  UBI Bank - UNION BANK OF INDIA
•  BOB Bank - BANK OF BARODA
•  PSB Bank - PUNJAB & SIND BANK""",

    "Cloak Facilities":
        """•  Cloak Room - AT PARCEL OFFICE NEAR POLE NO. 30 & 31""",

    "Akshita Bubble (Only for Ladies)":
        """•  Akshita - NEAR POLE NO. 28 & 29 AT PF-01""",

    "Parcel and Rail-Mail Service": """•  Rail Mail Service - AT PF-01
•  Parcel Office Outside Platform Main Side - AT NGP END OF THE STATION BUILDING""",

    "Water Booths & Water Cooler":
        """•  06 nos of Water Cooler available at PF - 1
    •  09 nos of Water Cooler available at PF - 2&3
    •  05 nos of Water Cooler available at PF - 4&5
    •  01 nos of Water Cooler available nearby retiring room no 9
    •  01 nos of Water Cooler available at PRS Office""",

    "PAY & USE TOILET":
        """•  01 Toilet set each (seperate for male and female passengers) towards Nagpur end and Raipur end at PF -01
    •  01 Toilet seteach (seperate for male and female passengers) at PF - 2&3
    •  01 Toilet set each (seperate for male and female passengers) at PF - 4&5""",

    "Toilets & Urinal":
        """•  FREE LADIES AND GENTS TOILETS AT PLATFORM NO. 1""",

    "Divyang Toilet":
        """•  Free Divyangjan Toilet in Second Class Waiting Hall at PF -1""",
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
