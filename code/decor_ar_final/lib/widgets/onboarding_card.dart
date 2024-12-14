import 'package:flutter/material.dart';

class OnboardingCard extends StatelessWidget {
  final String image, title, description, buttonText;
  final bool isLastCard;
  final Function(BuildContext)? onPressed;

  const OnboardingCard({
    Key? key,
    required this.image,
    required this.title,
    required this.description,
    required this.buttonText,
    this.isLastCard = false,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A), // set the background color here
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              image,
              fit: BoxFit.contain,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  description,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    color: Color(0xFF9095A0),
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 60,
            child: isLastCard
                ? ElevatedButton(
              onPressed: () {
                onPressed?.call(context); // Call onPressed callback with context
              },
              // Call onPressed callback
              child: Text(
                buttonText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF532DE0), // Change button color
              ),
            )
                : Container(), // Empty container for non-last cards
          ),
        ],
      ),
    );
  }
}
