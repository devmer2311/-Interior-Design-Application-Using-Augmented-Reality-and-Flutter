import 'package:final_project/dashboard.dart';
import 'package:final_project/login.dart';
import 'package:final_project/onboarding_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:final_project/splash_screen.dart';
import 'package:final_project/phone.dart';
import 'package:final_project/verify.dart';
import 'package:final_project/name.dart';
import 'package:final_project/login.dart';
import 'package:final_project/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DecorAR Studio',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
      routes: {
        '/onboarding': (context) => OnboardingPage(),
        '/phone': (context) => MyPhone(),
        'verify': (context) => MyVerify(),
        'name': (context) => Name(),
        'dashboard': (context) => Dashboard(),
        'login': (context) => LoginPage()
      }, // Show splash screen first
    );
  }
}
