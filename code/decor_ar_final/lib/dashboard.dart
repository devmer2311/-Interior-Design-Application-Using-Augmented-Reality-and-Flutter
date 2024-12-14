import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:final_project/profile.dart';
import 'dashboard.dart'; // Importing the dashboard file
import 'package:final_project/blog.dart';
import 'package:final_project/category.dart';
import 'package:image_picker/image_picker.dart';
import "package:intl/intl.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'calculate.dart';
import 'item.dart';
import 'view.dart';
import 'local_and_web_objects_widget.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(MaterialApp(
    home: Dashboard(),
  ));
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}


class _DashboardState extends State<Dashboard> {


  final ImagePicker _picker = ImagePicker();

  get calculatedCost => null;

  Future<void> _openCamera(BuildContext context) async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        // You can now use the photo, for example, navigate to a new screen to display it
        print('Image Path: ${photo.path}');
      }
    } catch (e) {
      print('Error opening camera: $e');
    }
  }
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else if (hour < 20) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }
  String userName = 'User'; // Default value while fetching the name

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    try {
      // Get the current user's UID
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Fetch user data from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('User')
            .doc(user.email)
            .get();

        setState(() {
          userName = userDoc['name'] ?? 'User'; // Retrieve the 'name' field from Firestore
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        userName = 'User';
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.gif'), // Path to your GIF file
            fit: BoxFit.cover, // Adjusts the image to cover the entire background
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF532DE0),
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(70),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 50),
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 30),
                          title: Text(
                            'Hello, $userName',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            _getGreeting(),
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white54,
                            ),
                          ),
                          trailing: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey, width: 2), // Adding border
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => MyProfile()));
                              },


                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage: AssetImage('assets/user_image.png'),

                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Create New Space',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Capture and design your room with camera.',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 20),
                                Container(
                                  width: 125,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Image.asset('assets/ds1.png', fit: BoxFit.cover),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Container(
                              alignment: Alignment.centerLeft,
                              width: double.infinity,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 3,
                                        blurRadius: 7,
                                        offset: Offset(0, 3),
                                      ),
                                      BoxShadow(
                                        color: Color(0xFF383535FF), // Adjusted shadow color
                                        offset: Offset(0, 3),
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      // Add your action here
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor: Color(0xFF532DE0),
                                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        // Replace this Icon with your custom icon
                                        Icon(
                                          Icons.add_circle_outline,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'Create',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      SizedBox(width: 20), // Adding space before Box 1
                      Container(
                        width: 150,
                        height: 153,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.topLeft, // Aligning to top left
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10), // Adding padding for spacing
                              child: Text(
                                'My Spaces',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 5), // Adding space between headings
                            Padding(
                              padding: const EdgeInsets.only(left: 10), // Adding space to the left side of the text
                              child: Text(
                                'Check Your Saved Design',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14, // Smaller font size
                                ),
                              ),
                            ),
                            Spacer(), // Add Spacer to push the button to the bottom
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 3,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                    BoxShadow(
                                      color: Color(0xFF383535FF), // Adjusted shadow color
                                      offset: Offset(0, 3),
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    // Add your action here
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ViewPage(),
                                      ),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: Color(0xFF532DE0),
                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Replace this Icon with your custom icon
                                      Icon(
                                        Icons.remove_red_eye,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'View',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10), // Adding space above the button
                          ],
                        ),
                      ),
                      SizedBox(width: 10),

                    ],
                  ),
                  // Add more widgets here for the rest of the screen
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0), // Add padding to the bottom box
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 2.6,
                    colors: [Color(0xFF1C2A9F), Color(0xFF2F2B2B)],
                  ),
                ),
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Dashboard()), // Navigate to dashboard.dart
                        );
                      },
                      child: Icon(Icons.home_filled, color: Colors.white), // Replaced with home_filled icon
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Category()), // Navigate to CategoryPage
                        );
                      },
                      child: Icon(Icons.category_outlined, color: Colors.white),
                    ),
// Changed to shopping_cart icon
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF532DE0), // Change the color to whatever you like
                      ),
                      padding: EdgeInsets.all(15),

                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LocalAndWebObjectsWidget()), // Navigate to blog.dart
                          );
                        },
                          child: Icon(Icons.camera_alt, color: Colors.white, size: 28)
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => BlogPage()), // Navigate to blog.dart
                          );
                        },
                        child: Icon(Icons.trending_up, color: Colors.white)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyProfile()), // Navigate to profile.dart
                        );
                      },
                      child: Icon(Icons.person_outline, color: Colors.white), // Changed to person_outline icon
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
