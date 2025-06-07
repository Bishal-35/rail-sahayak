import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rail_sahayak/Screens/login_screen.dart';
import 'package:rail_sahayak/Screens/contact_us_screen.dart';
import 'package:rail_sahayak/Screens/price_info_screen.dart';
import 'package:rail_sahayak/Screens/about_us_screen.dart'; // Add import for AboutUsScreen

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                    child: Icon(Icons.train, color: Colors.redAccent, size: 36),
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
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PriceInfoScreen(),
                  ),
                );
              },
              tileColor: Colors.transparent,
              hoverColor: Colors.redAccent.withOpacity(0.1),
            ),
            const SizedBox(height: 5),
            ListTile(
              leading: const Icon(
                Icons.contact_phone_rounded,
                color: Colors.redAccent,
              ),
              title: const Text(
                'Contact Us',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ContactUsScreen(),
                  ),
                );
              },
              tileColor: Colors.transparent,
              hoverColor: Colors.redAccent.withOpacity(0.1),
            ),
            const SizedBox(height: 5),
            ListTile(
              leading: const Icon(Icons.info, color: Colors.redAccent),
              title: const Text(
                'About Us',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutUsScreen(),
                  ),
                );
              },
              tileColor: Colors.transparent,
              hoverColor: Colors.redAccent.withOpacity(0.1),
            ),

            const Divider(height: 30, thickness: 1, indent: 16, endIndent: 16),
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
    );
  }
}
