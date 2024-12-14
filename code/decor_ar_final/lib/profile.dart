import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/contact_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart'; // Import GoogleSignIn
import 'package:final_project/signup.dart';
import 'view.dart';
import 'package:final_project/edit_profile.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import SvgPicture
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'dart:io';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  bool _isDarkMode = false;
  bool _isTextBlack = false;
  String? _userName;
  String? _userEmail;
  String? documentId; // The document ID of the user
  User? _currentUser;
  String? _profileImageUrl;
  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    // Get the current user from FirebaseAuth
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && user.email != null) {
      print("User Email: ${user.email}");

      try {
        // Use the currentUserEmail to retrieve the user's document from Firestore
        final querySnapshot = await FirebaseFirestore.instance
            .collection('User')
            .where('email', isEqualTo: user.email)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Fetch the user's name and email from the document
          final userDoc = querySnapshot.docs.first;
          setState(() {
            _userName = userDoc.data()['name'];
            _userEmail = userDoc.data()['email'];
            _profileImageUrl = userDoc.data()['profile_image'];
          });

          print("User document found. Name: $_userName, Email: $_userEmail");
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






  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SignUpPage()),
          (route) => false,
    );
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
      _isTextBlack = !_isTextBlack;
    });
  }

  void _navigateToEditProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProfile()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? Colors.white : Color(0xFF2A2A2A),
      appBar: AppBar(
        backgroundColor: Color(0xFF532DE0),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.white,
          ),
        ),
        title: Center(
          child: Text(
            'Profile',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Colors.white,
            ),
          ),
        ),

        
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
                      child: _profileImageUrl != null
                          ? Image.network(_profileImageUrl!) // Display the profile image from URL
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
                          _navigateToEditProfile(context);
                        },
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  _userName ?? 'Loading...',  // Display the user's name or a loading message
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _isTextBlack ? Colors.black : Colors.white,
                  ),
                ),

              ),
              Center(
                child: Text(
                  _userEmail ?? 'Loading...',  // Display the user's email or a loading message
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: _isTextBlack ? Colors.black : Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    _navigateToEditProfile(context);
                  },
                  child: const Text(
                    'Edit Profile',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF532DE0),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ProfileMenuWidget(
                title: 'My Spaces',
                textColor: _isTextBlack ? Colors.black : Colors.white,
                icon: Icons.design_services_outlined,
                onPress: () {
                  // Add your action here
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewPage(),
                    ),
                  );
                },
                iconColor: _isTextBlack ? Colors.black : Colors.white,
              ),
              ProfileMenuWidget(
                title: 'Contact Us',
                textColor: _isTextBlack ? Colors.black : Colors.white,
                icon: Icons.contact_support_outlined,
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContactPage(),
                    ),
                  );
                },
                iconColor: _isTextBlack ? Colors.black : Colors.white,
              ),
              const SizedBox(height: 10),
              ProfileMenuWidget(
                title: 'Log Out',
                icon: Icons.logout_outlined,
                onPress: () {
                  _logout(context);
                },
                textColor: Colors.red,
                iconColor: _isTextBlack ? Colors.black : Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
    required this.iconColor,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.white.withOpacity(0.1),
        ),
        child: Icon(
          icon,
          color: iconColor,
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: textColor ?? Colors.white,
          fontSize: 18.0,
        ),
      ),
      trailing: endIcon
          ? Container(
        width: 30,
        height: 30,
        child: Icon(
          CupertinoIcons.forward,
          size: 18.0,
          color: iconColor,
        ),
      )
          : null,
    );
  }
}
