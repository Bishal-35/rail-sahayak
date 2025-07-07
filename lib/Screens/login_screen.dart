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
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

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
        String errorMessage = 'Verification failed.';

        // Provide more specific error messages based on the error code
        if (e.code == 'too-many-requests') {
          errorMessage =
              'Too many attempts. Your device is temporarily blocked. Please try again after some time (usually 1-2 hours).';
        } else if (e.code == 'invalid-phone-number') {
          errorMessage =
              'The phone number format is incorrect. Please check and try again.';
        } else if (e.code == 'quota-exceeded') {
          errorMessage =
              'Service temporarily unavailable. Please try again later.';
        } else if (e.code == 'captcha-check-failed') {
          errorMessage = 'Captcha verification failed. Please try again.';
        } else {
          errorMessage = 'Verification failed. ${e.message}';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            duration: Duration(seconds: 5),
            backgroundColor: Colors.redAccent,
          ),
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
    if (otpController.text.trim().length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid 6-digit OTP')),
      );
      return;
    }

    setState(() => isLoading = true);
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otpController.text.trim(),
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      checkUserNameAndNavigate();
    } catch (e) {
      String errorMessage = 'Invalid OTP. Try again.';

      if (e is FirebaseAuthException) {
        if (e.code == 'too-many-requests') {
          errorMessage =
              'Too many failed attempts. Your device is temporarily blocked. Please try again after some time (usually 1-2 hours).';
        } else if (e.code == 'invalid-verification-code') {
          errorMessage =
              'The verification code is invalid. Please check and try again.';
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: Duration(seconds: 5),
          backgroundColor: Colors.redAccent,
        ),
      );
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

        if (userDoc.exists) {
          final userData = userDoc.data()!;
          
          // Check if any required field is missing
          bool hasName = userData.containsKey('name') && 
                        userData['name'] != null && 
                        userData['name'].toString().trim().isNotEmpty;
                        
          bool hasEmail = userData.containsKey('email') && 
                        userData['email'] != null && 
                        userData['email'].toString().trim().isNotEmpty;
                        
          bool hasAddress = userData.containsKey('address') && 
                          userData['address'] != null && 
                          userData['address'].toString().trim().isNotEmpty;
          
          // Pre-fill existing data for update
          if (hasName) nameController.text = userData['name'];
          if (hasEmail) emailController.text = userData['email'];
          if (hasAddress) addressController.text = userData['address'];
          
          if (hasName && hasEmail && hasAddress) {
            navigateToMainScreen();
          } else {
            // Show dialog to collect missing information
            showUserDetailsDialog(
              missingName: !hasName,
              missingEmail: !hasEmail, 
              missingAddress: !hasAddress
            );
          }
        } else {
          // No user document exists, show the full details dialog
          showUserDetailsDialog(missingName: true, missingEmail: true, missingAddress: true);
        }
      } catch (e) {
        // If there's an error retrieving the user document, show the full details dialog
        showUserDetailsDialog(missingName: true, missingEmail: true, missingAddress: true);
      }
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Authentication failed. Please try again.')),
      );
    }
  }

  void showUserDetailsDialog({
    required bool missingName, 
    required bool missingEmail, 
    required bool missingAddress
  }) {
    // Create a message about missing fields
    String message = 'Please complete your profile by providing the ';
    List<String> missingFields = [];
    if (missingName) missingFields.add('name');
    if (missingEmail) missingFields.add('email');
    if (missingAddress) missingFields.add('address');
    
    message += missingFields.join(', ');
    message += ' to continue.';

    // Get screen size for responsive sizing
    final screenSize = MediaQuery.of(context).size;
    final dialogWidth = screenSize.width * 0.85 < 450 ? screenSize.width * 0.85 : 450.0;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false, // Prevent back button from dismissing
        child: Dialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: 20.0, 
            vertical: 24.0
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: dialogWidth,
            constraints: BoxConstraints(
              maxHeight: screenSize.height * 0.7,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Dialog header
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.person, color: Colors.redAccent),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Complete Your Profile',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Dialog content
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          message,
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 16),
                        if (missingName || nameController.text.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(bottom: 12),
                            child: TextField(
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
                                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              ),
                              textCapitalization: TextCapitalization.words,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                        if (missingEmail || emailController.text.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(bottom: 12),
                            child: TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                hintText: 'Your email address',
                                prefixIcon: Icon(
                                  Icons.email_outlined,
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
                                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                        if (missingAddress || addressController.text.isNotEmpty)
                          TextField(
                            controller: addressController,
                            decoration: InputDecoration(
                              hintText: 'Your address',
                              prefixIcon: Icon(
                                Icons.location_on_outlined,
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
                              contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            ),
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.streetAddress,
                            textInputAction: TextInputAction.done,
                            maxLines: 2,
                            minLines: 1,
                            onSubmitted: (_) => validateAndSaveDetails(context),
                          ),
                      ],
                    ),
                  ),
                ),
                // Dialog actions
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () => validateAndSaveDetails(context),
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    setState(() => isLoading = false);
  }

  void validateAndSaveDetails(BuildContext context) async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final address = addressController.text.trim();

    // Validate name (always required)
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your name')),
      );
      return;
    }

    if (name.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Name must be at least 3 characters long')),
      );
      return;
    }

    // Validate email (now required)
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your email address')),
      );
      return;
    }
    
    if (!email.contains('@') || !email.contains('.')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid email address')),
      );
      return;
    }

    // Validate address (now required)
    if (address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your address')),
      );
      return;
    }
    
    if (address.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a more detailed address')),
      );
      return;
    }

    setState(() => isLoading = true);
    await saveUserDetails();

    if (mounted) {
      Navigator.of(context).pop();
      navigateToMainScreen();
    }
  }

  Future<void> saveUserDetails() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = {
        'name': nameController.text.trim(),
        'phone': user.phoneNumber,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Add email and address only if they are provided
      final email = emailController.text.trim();
      if (email.isNotEmpty) {
        userData['email'] = email;
      }

      final address = addressController.text.trim();
      if (address.isNotEmpty) {
        userData['address'] = address;
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(userData, SetOptions(merge: true));
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
