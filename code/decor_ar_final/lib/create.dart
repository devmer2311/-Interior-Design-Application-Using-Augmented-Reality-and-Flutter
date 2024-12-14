import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Import fluttertoast
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:final_project/dashboard.dart';
import 'package:final_project/option.dart'; // Import the dashboard page

class CreateUserPage extends StatefulWidget {
  final String? googleName;
  final String? googleEmail;
  final String? phoneNumber;

  const CreateUserPage({Key? key, this.googleName, this.googleEmail, this.phoneNumber}) : super(key: key);

  @override
  _CreateUserPageState createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  // FocusNode for password field
  FocusNode passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Autofill the fields if signing up with Google
    nameController.text = widget.googleName ?? "";
    emailController.text = widget.googleEmail ?? "";
    phoneController.text = widget.phoneNumber ?? "+91"; // Set default value
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2A2A2A), // Set background color
      appBar: AppBar(
        title: const Text("Create User", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF2A2A2A),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                focusNode: passwordFocusNode,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  _validatePassword(value);
                },
              ),
              const SizedBox(height: 5),
              Visibility(
                visible: _isPasswordValid(passwordController.text),
                child: const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    "Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, one digit, and one special character.",
                    style: TextStyle(color: Colors.red, fontSize: 12.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: phoneController,
                enabled: true,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Call addUser method when button is pressed
                  addUserToDatabase();
                },
                child: const Text("Sign Up", style: TextStyle(color: Colors.white)),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF532DE0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to validate password strength
  void _validatePassword(String value) {
    setState(() {});
  }

  // Check if password is valid
  bool _isPasswordValid(String password) {
    // Password strength criteria
    RegExp passwordRegex = RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*()_+={}\[\]|;:,.<>?]).{8,}$');
    return !passwordRegex.hasMatch(password);
  }

  // Method to add user details to the database
  // Method to add user details to the database
  void addUserToDatabase() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    String phone = phoneController.text.trim();

    // Validate input fields before adding to the database
    if (name.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        phone.isNotEmpty) {
      // Check if passwords match
      if (password != confirmPassword) {
        _showSnackbar("Passwords do not match");
        return;
      }

      // Check if phone number is valid
      if (phone.length != 13) {
        _showSnackbar("Phone number should be +91 followed by 10 digits");
        return;
      }

      try {
        // Check if a user with the same email or phone number already exists
        QuerySnapshot existingUsers = await FirebaseFirestore.instance
            .collection('User')
            .where('email', isEqualTo: email)
            .get();

        if (existingUsers.docs.isNotEmpty) {
          // User already exists
          Fluttertoast.showToast(
            msg: "Already signed up with this email",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
          return;
        }

        // Generate a unique document ID
        String userId = FirebaseFirestore.instance.collection('User').doc().id;

        // Save user details to Firestore with the specified document ID
        await FirebaseFirestore.instance.collection('User').doc(userId).set({
          'userID': userId, // Set the userID field as the document ID
          'name': name,
          'email': email,
          'password': password, // Store password (consider hashing for production)
          'phone': phone,
        });

        print("User ID: $userId");

        // Show success message and navigate to the next page
        Fluttertoast.showToast(
          msg: "Account Created Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Option()), // Navigate to the next page
        );
      } catch (e) {
        _showSnackbar("Failed to create account: $e");
      }
    } else {
      _showSnackbar("All fields are required");
    }
  }




  // Method to show snackbar with a message
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
