import 'dart:async';

import 'package:flutter/material.dart';
import 'package:final_project/signup.dart';
import 'package:final_project/widgets/onboarding_card.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  static final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  final List<Widget> _onBoardingPages = [
    const OnboardingCard(
      image: "assets/intro1.png",
      title: "Immersive AR Experience",
      description: "Step into a world where design ideas come to life.",
      buttonText: "",
    ),
    const OnboardingCard(
      image: "assets/inro2.png",
      title: "Trendy Interior Ideas",
      description: "Stay Updated With The Latest Design Inspirations. ",
      buttonText: "",
    ),
    OnboardingCard(
      image: "assets/intro3.png",
      title: "Expense Estimation",
      description: "Get Accurate Cost Projections for Your Dream Space.",
      buttonText: "Get Started",
      isLastCard: true,
      onPressed: (context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignUpPage()),
        );
      },
    ),
  ];

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_currentPage < _onBoardingPages.length - 1) {
        _currentPage++;
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2A2A2A),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                children: _onBoardingPages,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
              ),
            ),
            if (_currentPage != 2) // Only show the page indicator for the first two pages
              SizedBox(
                height: 20.0,
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: 3, // Total number of pages with indicator
                  effect: WormEffect(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
