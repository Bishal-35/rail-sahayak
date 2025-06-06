import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rail_sahayak/Screens/login_screen.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  void _launchPhone(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('Could not launch $phoneNumber');
    }
  }

  void _launchWebsite(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(
        elevation: 16.0,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.redAccent, Colors.red],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30,
                      child: Icon(
                        Icons.train,
                        color: Colors.redAccent,
                        size: 36,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Your RailSahayak',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Your rail travel assistant',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'MENU',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.info, color: Colors.redAccent),
                title: const Text(
                  'About Us',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onTap: () => Navigator.pop(context),
                tileColor: Colors.transparent,
                hoverColor: Colors.redAccent.withOpacity(0.1),
              ),
              const SizedBox(height: 5),
              ListTile(
                leading: const Icon(
                  Icons.currency_rupee,
                  color: Colors.redAccent,
                ),
                title: const Text(
                  'Pricing',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onTap: () => Navigator.pop(context),
                tileColor: Colors.transparent,
                hoverColor: Colors.redAccent.withOpacity(0.1),
              ),
              const SizedBox(height: 5),
              ListTile(
                leading: const Icon(Icons.cancel, color: Colors.redAccent),
                title: const Text(
                  'Cancellation',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onTap: () => Navigator.pop(context),
                tileColor: Colors.transparent,
                hoverColor: Colors.redAccent.withOpacity(0.1),
              ),
              const Divider(
                height: 30,
                thickness: 1,
                indent: 16,
                endIndent: 16,
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: const Text(
                  'Logout',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => LoginPage()),
                    (route) => false,
                  );
                },
                tileColor: Colors.transparent,
                hoverColor: Colors.redAccent.withOpacity(0.1),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.contact_support, color: Colors.redAccent),
            SizedBox(width: 8),
            Text('Contact Us', style: TextStyle(color: Colors.black)),
          ],
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Important Contact Numbers / Help Lines',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 20),
              _buildContactRow('(a) For Suggestion / Complaints:', '139'),
              _buildContactRow('(b) Railway Women Help Line:', '182'),
              _buildContactRow(
                '(c) CSM Incharge Ramesh Prasad Mandal:',
                '9752877088',
              ),
              Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.redAccent, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Icon(Icons.email, color: Colors.redAccent),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final Uri emailUri = Uri(
                              scheme: 'mailto',
                              path: 'rpmandal.mandal0@gmail.com',
                              query: Uri.encodeFull('subject=&body='),
                            );

                            if (await canLaunchUrl(emailUri)) {
                              await launchUrl(
                                emailUri,
                                mode: LaunchMode.externalApplication,
                              );
                            } else {
                              debugPrint('Could not launch email');
                            }
                          },
                          child: const Text(
                            'rpmandal.mandal0@gmail.com',
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _buildContactRow('(d) OC RPF:', '9752877709'),
              _buildContactRow('(e) Commercial Control Raipur:', '9752877998'),
              const SizedBox(height: 20),
              Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.redAccent, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Icon(Icons.language, color: Colors.redAccent),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final Uri url = Uri.parse(
                              'https://railmadad.indianrailways.gov.in',
                            );
                            if (!await launchUrl(
                              url,
                              mode: LaunchMode.externalApplication,
                            )) {
                              debugPrint("Could not launch IRCTC");
                            }
                          },
                          child: const Text(
                            'Website: railmadad.indianrailways.gov.in',
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactRow(String label, String number) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.redAccent, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: GestureDetector(
          onTap: () => _launchPhone(number),
          child: Row(
            children: [
              const Icon(Icons.phone, color: Color.fromARGB(162, 255, 82, 82)),
              const SizedBox(width: 12),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: '$label ',
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                    children: [
                      TextSpan(
                        text: number,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
