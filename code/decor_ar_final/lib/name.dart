
import 'package:flutter/material.dart';
import 'package:final_project/option.dart'; // Import the Option.dart file

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

class Name extends StatefulWidget {
  @override
  _NameState createState() => _NameState();
}

class _NameState extends State<Name> {
  TextEditingController _nameController = TextEditingController();
  bool _isNameEntered = false; // Track whether the name is entered or not

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(), // Set the custom app bar
      backgroundColor: Color(0xFF2A2A2A), // Set the background color to grey
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 20.0), // Add padding only to the bottom
              child: Center( // Center the icon horizontally
                child: Icon(
                  Icons.person_outline, // Add the icon above the text
                  color: Colors.white,
                  size: 100, // Set the size of the icon
                ),
              ),
            ),
            SizedBox(height: 10), // Add space between the icon and the text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "What's\nYour Name ??", // Break the statement after "What's" on a new line
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left, // Align text to the left side
              ),
            ),
            SizedBox(height: 20), // Adding space between the two texts
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: _nameController,
                style: TextStyle(color: Colors.white),
                onChanged: (value) {
                  setState(() {
                    _isNameEntered = value.isNotEmpty; // Update name entered status
                  });
                },
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20), // Adding space below the TextField
            Visibility(
              visible: _isNameEntered, // Show only if name is entered
              child: Center(
                child: SizedBox(
                  width: 200, // Set the width of the button
                  child: FloatingActionButton(
                    onPressed: () {
                      String name = _nameController.text;
                      // Navigate to the Option.dart file with slide animation
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 500),
                          pageBuilder: (_, __, ___) => Option(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            var begin = Offset(1.0, 0.0);
                            var end = Offset.zero;
                            var curve = Curves.easeInOut;
                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);
                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    backgroundColor: Color(0xFF532DE0), // Set the color of the surrounding box to purple
                    child: Text(
                      "Next",
                      style: TextStyle(color: Colors.white, fontSize: 20), // Increase font size
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(
    home: Name(),
  ));
}
