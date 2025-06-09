import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'; // Add this import for TapGestureRecognizer
import 'package:url_launcher/url_launcher.dart'; // You'll need to add this package to pubspec.yaml

class MoreServicesScreen extends StatefulWidget {
  final String stationName;

  const MoreServicesScreen({Key? key, required this.stationName})
    : super(key: key);

  @override
  State<MoreServicesScreen> createState() => _MoreServicesScreenState();
}

class _MoreServicesScreenState extends State<MoreServicesScreen> {
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
              child: Icon(
                Icons.more_vert_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'More Services',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Additional services at ${widget.stationName}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color.fromARGB(255, 221, 221, 221),
                      fontWeight: FontWeight.w300,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.redAccent, Colors.red.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.redAccent.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.accessibility_new,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Divyangjan Services',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Special facilities available at ${widget.stationName} station',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Services grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio:
                    1.0, // Changed from 0.9 to 1.0 for better proportions
                children: [
                  _buildEnhancedCard(
                    'Wheel Chair, Ramp & Stretcher',
                    Icons.wheelchair_pickup_rounded,
                    'Available with station master office',
                    () {
                      _showDetailsDialog(
                        context,
                        'Wheel Chair, Ramp & Stretcher',
                        'Available with station master office\n\n• 04-Wheel Chair\n• 1-Ramp\n• 1-Stretcher\n\nColumn No. 12-13 (Between CTI/Station & CSM Office)',
                        Icons.wheelchair_pickup_rounded,
                      );
                    },
                  ),
                  _buildEnhancedCard(
                    'Battery Operated Car',
                    Icons.electric_rickshaw,
                    'For Divyang passengers',
                    () {
                      _showDetailsDialog(
                        context,
                        'Battery Operated Car',
                        'Battery Operated Car for Divyang passengers, Senior Citizen\n\n• 1-Battery Operated Car',
                        Icons.electric_rickshaw,
                      );
                    },
                  ),
                  _buildEnhancedCard(
                    'Divyangjan Railway Concession ID Card System',
                    Icons.card_membership_rounded,
                    'ID Card',
                    () {
                      _showDetailsDialog(
                        context,
                        'Divyangjan Railway Concession ID Card System',
                        'Web-based \'Divyangjan Railway Concession ID Card System\' for the benefit of Divyangjan (Persons with disabilities) beneficiaries availing railway concession.\n\nIn order to reduce the hardships being experienced by the \'Divyangjans\' to get photo identity cards, to obviate the need of physical commute to Divisional Office and also to reduce the processing time, the Raipur Division launched Web-based \'Divyangjan Railway Concession ID Card System\'.\n\nDivyangjan Beneficiaries can now apply for ID Cards through this online Web application.\n\nUnder this new system, Divyangjan residing in the jurisdiction of Raipur Division can now directly submit their application to Railway authorities online for obtaining Divyangjan concession photo ID cards.\n\nThe web-based application service will be available at the official page of the Commercial Department Website https://divyangjanid.indianrail.gov.in/member-registration',
                        Icons.card_membership_rounded,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(String title, IconData icon, VoidCallback onTap) {
    // Keep this method for backward compatibility if needed
    return _buildEnhancedCard(title, icon, '', onTap);
  }

  Widget _buildSimpleCard(String title, IconData icon, VoidCallback onTap) {
    // Keep this method for backward compatibility if needed
    return _buildEnhancedCard(title, icon, '', onTap);
  }

  Widget _buildEnhancedCard(
    String title,
    IconData icon,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Color(0xFFFFF0F0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.redAccent.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon with background
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.redAccent.withOpacity(0.2),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(icon, size: 24, color: Colors.redAccent),
                  ),
                  const SizedBox(height: 8),
                  // Title
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Removed subtitle display
                  const Spacer(),
                  // Button indicator
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Details',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Icon(
                            Icons.arrow_forward,
                            size: 10,
                            color: Colors.redAccent,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Add this new method for showing details dialog
  void _showDetailsDialog(
    BuildContext context,
    String title,
    String details,
    IconData icon,
  ) {
    // Check if the details contain a URL and format it for clickable display
    Widget detailsWidget;

    if (details.contains('https://')) {
      // Find the index of the URL
      int urlStartIndex = details.indexOf('https://');
      // Find the closing parenthesis, but don't include it in the URL
      int urlEndIndex = details.indexOf(')', urlStartIndex);
      if (urlEndIndex == -1) {
        urlEndIndex = details.length;
      }

      // Extract the URL - making sure to exclude the closing parenthesis
      String url = details.substring(urlStartIndex, urlEndIndex);
      // Clean up the URL if it has any whitespace
      url = url.trim();

      // Create a RichText widget with clickable URL
      detailsWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            details.substring(0, urlStartIndex),
            style: const TextStyle(fontSize: 16),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: url,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      try {
                        final Uri uri = Uri.parse(url);
                        if (!await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        )) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Could not launch $url - Please add url_launcher package',
                              ),
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
                      } catch (e) {
                        print('Error launching URL: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error launching URL: $e'),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }
                    },
                ),
                TextSpan(
                  text: details.substring(urlEndIndex),
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      detailsWidget = Text(details, style: const TextStyle(fontSize: 16));
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.redAccent, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Container(
            width: double.maxFinite,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Service Details:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  detailsWidget,

                  // Add Apply Now button for Divyangjan Railway Concession ID Card System
                  if (title == 'Divyangjan Railway Concession ID Card System')
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Center(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final Uri uri = Uri.parse(
                              'https://divyangjanid.indianrail.gov.in/member-registration',
                            );
                            try {
                              if (!await launchUrl(
                                uri,
                                mode: LaunchMode.externalApplication,
                              )) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Could not launch registration page',
                                    ),
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              }
                            } catch (e) {
                              print('Error launching URL: $e');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error launching URL: $e'),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.app_registration),
                          label: const Text('Apply Now'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
