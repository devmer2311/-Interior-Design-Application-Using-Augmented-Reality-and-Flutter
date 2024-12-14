import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firebase Firestore
import 'package:flutter/services.dart'; // Import for input formatters

// Define the ContactPage widget
class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _subjectController = TextEditingController();

  final _emailFocusNode = FocusNode();
  final _messageFocusNode = FocusNode();
  final _nameFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _subjectFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // Add listeners to focus nodes
    _emailFocusNode.addListener(() => _clearValidationErrors(_emailFocusNode));
    _messageFocusNode.addListener(() => _clearValidationErrors(_messageFocusNode));
    _nameFocusNode.addListener(() => _clearValidationErrors(_nameFocusNode));
    _phoneFocusNode.addListener(() => _clearValidationErrors(_phoneFocusNode));
    _subjectFocusNode.addListener(() => _clearValidationErrors(_subjectFocusNode));
  }

  @override
  void dispose() {
    // Dispose controllers and focus nodes
    _emailController.dispose();
    _messageController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _subjectController.dispose();
    _emailFocusNode.dispose();
    _messageFocusNode.dispose();
    _nameFocusNode.dispose();
    _phoneFocusNode.dispose();
    _subjectFocusNode.dispose();
    super.dispose();
  }

  void _clearValidationErrors(FocusNode focusNode) {
    if (!focusNode.hasFocus) {
      return;
    }
    // Revalidate the form
    setState(() {
      _formKey.currentState?.validate();
    });
  }

  // Method to save contact data to Firebase
  Future<void> _saveContact() async {
    if (_formKey.currentState?.validate() ?? false) {
      final contact = {
        'email': _emailController.text,
        'message': _messageController.text,
        'name': _nameController.text,
        'phone': _phoneController.text,
        'subject': _subjectController.text,
        'status': 'pending', // Set status to empty
        'timestamp': DateTime.now(), // Capture the current timestamp
      };

      try {
        await FirebaseFirestore.instance.collection('contact').add(contact); // Save to 'contact' collection
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Submitted Successfully. We Will resolve your problem soon.')),
        );
        // Clear the form fields after successful submission
        _emailController.clear();
        _messageController.clear();
        _nameController.clear();
        _phoneController.clear();
        _subjectController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save contact information')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2A2A2A),
      appBar: AppBar(
        title: Text(
          'Contact Us',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF532DE0),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.0), // Space above the image
            Center(
              child: Image.asset(
                'assets/contact_image.png', // Replace with the path to your image asset
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _subjectController,
                      focusNode: _subjectFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Subject',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(),
                      ),
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a subject';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 8.0),
                    TextFormField(
                      controller: _nameController,
                      focusNode: _nameFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(),
                      ),
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 8.0),
                    TextFormField(
                      controller: _emailController,
                      focusNode: _emailFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(),
                      ),
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 8.0),
                    TextFormField(
                      controller: _phoneController,
                      focusNode: _phoneFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Phone',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(),
                      ),
                      style: TextStyle(color: Colors.white),
                      keyboardType: TextInputType.phone, // Open numeric keyboard
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly, // Allow only digits
                        LengthLimitingTextInputFormatter(10), // Restrict to 10 digits
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty || value.length != 10) {
                          return 'Please enter a 10-digit phone number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _messageController,
                      focusNode: _messageFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Message',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(),
                      ),
                      style: TextStyle(color: Colors.white),
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a message';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _saveContact,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Submit',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF532DE0)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
