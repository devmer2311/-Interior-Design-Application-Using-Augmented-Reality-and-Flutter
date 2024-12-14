import 'package:flutter/material.dart';
import 'package:final_project/dashboard.dart';
import 'package:final_project/terms.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: true, // This will show the back arrow
      iconTheme: IconThemeData(color: Colors.white), // Change arrow color to white
      backgroundColor: Color(0xFF2A2A2A), // Change background color of app bar
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(2.0),
        child: CustomPaint(
          size: Size(MediaQuery.of(context).size.width, 2),
          painter: ArrowLinePainter(),
        ),
      ),
    );
  }
}

class ArrowLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white // Color of the line
      ..strokeWidth = 2.0;

    final Offset start = Offset(0, size.height);
    final Offset end = Offset(size.width, size.height);

    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class Option extends StatefulWidget {
  @override
  _OptionState createState() => _OptionState();
}

class _OptionState extends State<Option> {
  int selectedOption = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Color(0xFF2A2A2A), // Add background color for the body
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start, // Aligns widgets to the top
        crossAxisAlignment: CrossAxisAlignment.start, // Aligns text to the left
        children: [
          SizedBox(height: 60), // Add some space above "Are You?"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Are You ??',
                    style: TextStyle(
                      color: Colors.white, // Set text color to white
                      fontSize: 28, // Adjust font size
                      fontWeight: FontWeight.bold, // Set font weight to bold
                    ),
                  ),
                  SizedBox(height: 8), // Add space between "Are You?" and "Select one option"
                  Text(
                    'Select one option',
                    style: TextStyle(
                      color: Color(0xFF9095A0),
                      fontSize: 14, // Set font size to 12
                    ),
                  ),
                  SizedBox(height: 16), // Add space between "Select one option" and boxes
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedOption = 0;
                      });
                    },
                    child: RoundedBox(
                      text: 'Home Owner',
                      isSelected: selectedOption == 0,
                      icon: Icons.home, // Add the icon for Home Owner
                    ),
                  ),
                  SizedBox(height: 20), // Add space between boxes
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedOption = 1;
                      });
                    },
                    child: RoundedBox(
                      text: 'Interior Designer',
                      isSelected: selectedOption == 1,
                      icon: Icons.design_services, // Add the icon for Interior Designer
                    ),
                  ),
                  SizedBox(height: 20), // Add space between boxes
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedOption = 2;
                      });
                    },
                    child: RoundedBox(
                      text: 'Architects/Builders',
                      isSelected: selectedOption == 2,
                      icon: Icons.architecture, // Add the icon for Architects/Builders
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10), // Decrease space between "Are You?" and buttons
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end, // Aligns widgets to the bottom
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Terms()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF532DE0), // Button background color
                      minimumSize: Size(double.infinity, 50), // Full width button
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        color: Colors.white, // Button text color
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 2), // Decrease space between buttons
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Terms()),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Colors.transparent, // Transparent background color
                  ),
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: Colors.white, // Text color
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RoundedBox extends StatelessWidget {
  final String text;
  final bool isSelected;
  final IconData icon;

  const RoundedBox({Key? key, required this.text, required this.isSelected, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: double.infinity, // Make the box fill the width
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isSelected ? Colors.white : Color(0xFF03120E), // Set background color to white if selected, else #03120E
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected ? Color(0xFF03120E) : Colors.white, // Set icon color to black if selected, else white
                ),
                SizedBox(width: 8),
                Text(
                  text,
                  style: TextStyle(
                    color: isSelected ? Color(0xFF03120E) : Colors.white, // Set text color to black if selected, else white
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (isSelected)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white, // Set circle color
                ),
              ),
            ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Option(),
  ));
}
