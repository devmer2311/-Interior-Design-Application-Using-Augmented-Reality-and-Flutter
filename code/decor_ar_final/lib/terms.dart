import 'package:flutter/material.dart';
import 'dashboard.dart'; // Import your dashboard.dart file

void main() {
  runApp(MaterialApp(
    home: Terms(),
  ));
}

class Terms extends StatefulWidget {
  @override
  _TermsState createState() => _TermsState();
}

class _TermsState extends State<Terms> {
  // Function to navigate to the dashboard
  void _navigateToDashboard() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Dashboard()), // Use Dashboard widget from dashboard.dart
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2A2A2A), // Background color
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove backward arrow
        backgroundColor: Colors.transparent, // Transparent app bar
        elevation: 0, // No shadow
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                    child: Text(
                      'Terms & Conditions',
                      style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold), // Text color and bold
                      textAlign: TextAlign.start, // Align to the start (left)
                    ),
                  ),
                  SizedBox(height: 8), // Add space between the heading and update text
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      'Updated On 27/04/2024',
                      style: TextStyle(color: Colors.grey), // Update text color
                    ),
                  ),
                  SizedBox(height: 25), // Add space below the "Updated On" text
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      '1. Acceptance of Terms',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold), // Heading font size and bold
                    ),
                  ),
                  SizedBox(height: 8), // Add space between the heading and text
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      'By using this AR interior design app ("the App"), you agree to be bound by these Terms and Conditions.',
                      style: TextStyle(color: Colors.grey), // Text color
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      '2. License',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold), // Heading font size and bold
                    ),
                  ),
                  SizedBox(height: 8), // Add space between the heading and text
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      'We grant you a limited, non-exclusive, non-transferable, revocable license to use the App solely for your personal, non-commercial purposes.',
                      style: TextStyle(color: Colors.grey), // Text color
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      '3. User Conduct',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold), // Heading font size and bold
                    ),
                  ),
                  SizedBox(height: 8), // Add space between the heading and text
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      'You agree not to use the App for any unlawful or prohibited purpose, and you will comply with all applicable laws and regulations.',
                      style: TextStyle(color: Colors.grey), // Text color
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      '4. Intellectual Property',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold), // Heading font size and bold
                    ),
                  ),
                  SizedBox(height: 8), // Add space between the heading and text
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      'All content, including but not limited to designs, images, graphics, logos, and text, are the property of the App or its licensors and are protected by intellectual property laws.',
                      style: TextStyle(color: Colors.grey), // Text color
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      '5. Privacy Policy',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold), // Heading font size and bold
                    ),
                  ),
                  SizedBox(height: 8), // Add space between the heading and text
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      'Our Privacy Policy outlines how we collect, use, and disclose your personal information. By using the App, you consent to the collection and use of your information as described in the Privacy Policy.',
                      style: TextStyle(color: Colors.grey), // Text color
                    ),
                  ),
                  SizedBox(height: 20), // Add space between the text and other content
                ],
              ),
            ),
          ),
          // Button Widget
          GestureDetector(
            onTap: _navigateToDashboard, // Navigate to the dashboard on tap
            child: Container(
              width: double.infinity, // Make the button span the full width
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Color(0xFF532DE0), // Button color
                borderRadius: BorderRadius.circular(10), // Rounded corners
              ),
              child: Center(
                child: Text(
                  'Agree and Continue',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
