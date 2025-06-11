import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rail_sahayak/Screens/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  bool isLoading = false;
  bool otpSent = false;
  String verificationId = '';
  int? resendToken;

  Future<void> sendOTP({bool isResend = false}) async {
    final phone = phoneController.text.trim();
    if (phone.isEmpty || phone.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid 10-digit phone number.')),
      );
      return;
    }

    setState(() => isLoading = true);

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91$phone',
      forceResendingToken: isResend ? resendToken : null,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        navigateToMainScreen();
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification failed. ${e.message}')),
        );
        setState(() => isLoading = false);
      },
      codeSent: (String verId, int? token) {
        setState(() {
          verificationId = verId;
          resendToken = token;
          otpSent = true;
          isLoading = false;
        });
      },
      codeAutoRetrievalTimeout: (String verId) {
        verificationId = verId;
      },
      timeout: Duration(seconds: 60),
    );
  }

  Future<void> verifyOTP() async {
    setState(() => isLoading = true);
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otpController.text.trim(),
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      checkUserNameAndNavigate();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Invalid OTP. Try again.')));
      setState(() => isLoading = false);
    }
  }

  Future<void> checkUserNameAndNavigate() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists &&
            userDoc.data()!.containsKey('name') &&
            userDoc.data()!['name'] != null &&
            userDoc.data()!['name'].toString().trim().isNotEmpty) {
          navigateToMainScreen();
        } else {
          showNameInputDialog();
        }
      } catch (e) {
        // If there's an error retrieving the user document, show the name input dialog
        showNameInputDialog();
      }
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Authentication failed. Please try again.')),
      );
    }
  }

  void showNameInputDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false, // Prevent back button from dismissing
        child: AlertDialog(
          title: Row(
            children: [
              Icon(Icons.person, color: Colors.redAccent),
              SizedBox(width: 10),
              Text(
                'Enter Your Name',
                style: TextStyle(color: Colors.redAccent),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Please enter your name to continue. This is required to provide you personalized services.',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Your full name',
                  prefixIcon: Icon(
                    Icons.person_outline,
                    color: Colors.redAccent,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.redAccent, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => validateAndSaveName(context),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => validateAndSaveName(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text('Continue', style: TextStyle(color: Colors.white)),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
    setState(() => isLoading = false);
  }

  void validateAndSaveName(BuildContext context) async {
    final name = nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter your name')));
      return;
    }

    if (name.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Name must be at least 3 characters long')),
      );
      return;
    }

    setState(() => isLoading = true);
    await saveUserName();

    if (mounted) {
      Navigator.of(context).pop();
      navigateToMainScreen();
    }
  }

  Future<void> saveUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && nameController.text.trim().isNotEmpty) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': nameController.text.trim(),
        'phone': user.phoneNumber,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }

  void navigateToMainScreen() {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    }
  }

  // void editPhoneNumber() {
  //   setState(() {
  //     otpSent = false;
  //     otpController.clear();
  //     verificationId = '';
  //     resendToken = null;
  //     isLoading = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      backgroundColor: Color(0xFFFFF1F1),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.train, color: Colors.redAccent, size: 36),
                  SizedBox(width: 8),
                  Text(
                    "RailSahayak",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),
              Text(
                otpSent ? "Enter OTP" : "Login with Phone",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
              SizedBox(height: 32),

              // Phone Input
              if (!otpSent)
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.phone),
                    hintText: 'Phone number (without +91)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),

              // OTP Input
              if (otpSent)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: otpController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        hintText: 'Enter OTP',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: isLoading
                              ? null
                              : () => sendOTP(isResend: true),
                          child: Text("Resend OTP"),
                        ),
                      ],
                    ),
                  ],
                ),

              SizedBox(height: 20),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : otpSent
                      ? verifyOTP
                      : () => sendOTP(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isLoading ? Colors.grey : Colors.redAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          otpSent ? 'Verify OTP' : 'Send OTP',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
              ),

              // Bypass Login Button - Commented out for production
              /* 
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                  onPressed: () {
                    // Skip login and go directly to main screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.skip_next, size: 20),
                      SizedBox(width: 8),
                      Text(
                        "Skip Login (Dev Mode)",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),

              // Temporary Bypass Text
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Temporary bypass for development",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              */
              SizedBox(height: 24),
              Text(
                "You will receive a 6-digit code on your phone.",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
