import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase Storage
import 'dart:io';


class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  XFile? _selectedImage; // Store the selected image
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _updateUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        String? imageUrl;
        if (_selectedImage != null) {
          // Upload the selected image to Firebase Storage
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('user_images')
              .child('${user.uid}.jpg');
          await storageRef.putFile(File(_selectedImage!.path));
          imageUrl = await storageRef.getDownloadURL();
        }

        // Update Firestore
        await FirebaseFirestore.instance
            .collection('User')
            .where('email', isEqualTo: user.email)
            .get()
            .then((querySnapshot) async {
          if (querySnapshot.docs.isNotEmpty) {
            final userDoc = querySnapshot.docs.first;
            final updatedData = {
              'name': _nameController.text,
              'phone': _phoneController.text,
              if (imageUrl != null) 'profile_image': imageUrl, // Save the image URL
            };

            await userDoc.reference.update(updatedData);

            // Optionally update the email
            if (_emailController.text != user.email) {
              await user.updateEmail(_emailController.text);
            }

            _showSavedSuccessfullySnackbar(context);
          }
        });
      } catch (e) {
        print("Error updating user data: $e");
      }
    } else {
      print("No authenticated user found.");
    }
  }
  void _showSavedSuccessfullySnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profile updated successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }
  void _navigateToCamera(BuildContext context) async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = pickedImage;
      });
      // Optionally, update the profile image URL in Firebase Storage here
      _updateUserProfile();
    }
  }

  void _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && user.email != null) {
      try {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('User')
            .where('email', isEqualTo: user.email)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final userDoc = querySnapshot.docs.first;
          setState(() {
            _nameController.text = userDoc.data()['name'] ?? '';
            _emailController.text = userDoc.data()['email'] ?? '';
            _phoneController.text = userDoc.data()['phone'] ?? '';
            // For password, handle it separately since it shouldn't be fetched directly
          });
          print("User document found.");
        } else {
          print("User document does not exist in Firestore.");
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    } else {
      print("No authenticated user found or email is null.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2A2A2A),
      appBar: AppBar(
        backgroundColor: Color(0xFF2A2A2A),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.white,
          ),
        ),
        title: Text(
          'Edit Profile',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: Colors.white, // Adjust text color
          ),
        ),
        centerTitle: true, // Align the title to the center
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: _selectedImage != null
                          ? Image.file(File(_selectedImage!.path))
                          : Image.asset('assets/user_image.png'),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Color(0xFF532DE0),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          _navigateToCamera(context);
                        },
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white, // Use the provided icon color
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      style: TextStyle(color: Colors.white), // Set text color
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        labelStyle: TextStyle(color: Colors.white), // Set label color
                        prefixIcon: Icon(Icons.person_outline, color: Colors.white), // Set icon color
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ), // Set border color
                          borderRadius: BorderRadius.circular(100.0), // Set border radius
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      style: TextStyle(color: Colors.white), // Set text color
                      decoration: InputDecoration(
                        labelText: 'E-Mail',
                        labelStyle: TextStyle(color: Colors.white), // Set label color
                        prefixIcon: Icon(Icons.mail_outline, color: Colors.white), // Set icon color
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ), // Set border color
                          borderRadius: BorderRadius.circular(100.0), // Set border radius
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _phoneController,
                      style: TextStyle(color: Colors.white), // Set text color
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        labelStyle: TextStyle(color: Colors.white), // Set label color
                        prefixIcon: Icon(Icons.phone_outlined, color: Colors.white), // Set icon color
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ), // Set border color
                          borderRadius: BorderRadius.circular(100.0), // Set border radius
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      style: TextStyle(color: Colors.white), // Set text color
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.white), // Set label color
                        prefixIcon: Icon(Icons.fingerprint_outlined, color: Colors.white), // Set icon color
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ), // Set border color
                          borderRadius: BorderRadius.circular(100.0), // Set border radius
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText ? Icons.visibility_off : Icons.visibility,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscureText,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF532DE0), // Button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                      ),
                      onPressed: () {
                        _updateUserProfile();
                      },
                      child: Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
