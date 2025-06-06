import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rail_sahayak/Screens/login_screen.dart';

class FeedbackComplaintScreen extends StatefulWidget {
  const FeedbackComplaintScreen({super.key});

  @override
  State<FeedbackComplaintScreen> createState() =>
      _FeedbackComplaintScreenState();
}

class _FeedbackComplaintScreenState extends State<FeedbackComplaintScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _submissionType;
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final List<String> _submissionTypes = [
    'Complaint',
    'Feedback',
    'Suggestion',
    'Issue',
  ];

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false, // prevents dismissing on outside touch
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            contentPadding: const EdgeInsets.all(20),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle_outline, color: Colors.green, size: 60),
                const SizedBox(height: 15),
                const Text(
                  'Thank You',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'We\'ll get back to you soon',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: const Text('Close'),
                ),
              ],
            ),
          );
        },
      );
      // Perform submit logic
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Feedback/Complaint submitted successfully!')),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
            Icon(Icons.feedback, color: Colors.redAccent),
            SizedBox(width: 8),
            Text(
              'Feedback & Complaints',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenWidth < 600 ? screenWidth : 500,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'We value your input. Please use this form to share your feedback or report any issues.',
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 20),

                  // Submission Type
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Type of Submission',
                      border: OutlineInputBorder(),
                    ),
                    value: _submissionType,
                    items: _submissionTypes.map((type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _submissionType = value;
                      });
                    },
                    validator: (value) => value == null
                        ? 'Please select a submission type'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // Subject
                  TextFormField(
                    controller: _subjectController,
                    decoration: const InputDecoration(
                      labelText: 'Subject',
                      hintText: 'e.g., Suggestion for Platform X',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter a subject'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // Description
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 6,
                    maxLength: 1000,
                    decoration: const InputDecoration(
                      labelText: 'Detailed Description',
                      hintText: 'Please provide as much detail as possible...',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter a description'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // Name
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name (Optional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Email
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email Address (Optional for follow-up)',
                      hintText: 'your.email@example.com',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 24),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Submit Feedback/Complaint',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 253, 253),
                        ),
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
}
