import 'dart:async';
import 'package:final_project/create.dart';
import 'package:final_project/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:final_project/onboarding_page.dart';
import 'package:final_project/service/auth.dart';// Import your onboarding page widget


class SplashScreen extends StatelessWidget {
  final AuthMethods _authMethods = AuthMethods();

  @override
  Widget build(BuildContext context) {
    // Start a timer for 3 seconds
    Timer(Duration(seconds: 3), () {
      // Check if user is authenticated
      _authMethods.getCurrentUser().then((user) {
        if (user != null) {
          // If user is already logged in, navigate to home page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Dashboard()),
          );
        } else {
          // If user is not logged in, navigate to onboarding page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => OnboardingPage()),
          );
        }
      });
    });

    return Scaffold(
      body: Stack(
        children: [
          // Gradient-colored background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [HexColor('#2C6B5A'), HexColor('#44A787')],
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo.png', // Replace 'logo.png' with your PNG file path
                  width: 500, // Adjust the width as needed
                  height: 80, // Adjust the height as needed
                ),
                SizedBox(height: 20), // Adjust the height as needed
                Text(
                  '"Elevate Your Space, Unleash Your Style"',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(
                'Made With \u2764 In India',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
