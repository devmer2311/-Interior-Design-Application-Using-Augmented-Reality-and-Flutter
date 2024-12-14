import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:final_project/verify.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 2);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.white), // Corrected icon name
        onPressed: () => Navigator.of(context).pop(),
      ),
      backgroundColor: Color(0xFF2A2A2A),
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
      ..color = Colors.white
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

class MyPhone extends StatefulWidget {
  const MyPhone({Key? key}) : super(key: key);
  static String verify = "";

  @override
  State<MyPhone> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<MyPhone> {
  TextEditingController phoneNumberController = TextEditingController();
  var phone = "";
  bool isButtonEnabled = false;

  @override
  void initState() {
    phoneNumberController.text = "+91";
    super.initState();
    phoneNumberController.addListener(validatePhoneNumber);
    validatePhoneNumber(); // Initially validate phone number
  }

  @override
  void dispose() {
    phoneNumberController.removeListener(validatePhoneNumber);
    phoneNumberController.dispose();
    super.dispose();
  }

  void validatePhoneNumber() {
    setState(() {
      isButtonEnabled = phoneNumberController.text.length == 13;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2A2A2A),
      appBar: CustomAppBar(),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/verify.gif',
                width: 365,
                height: 265,
              ),
              SizedBox(height: 25),
              Text(
                "Phone Verification",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "We Need to Register Your Phone Before Getting Started !",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  // Text(
                  //   '+91', // Example country code for the United States
                  //   style: TextStyle(
                  //     fontSize: 16,
                  //     color: Colors.white,
                  //   ),
                  // ),
                  // SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        onChanged: (value) {
                          phone = value;
                        },
                        controller: phoneNumberController,
                        style: TextStyle(color: Colors.white),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(
                              13), // Limit to 10 characters
                        ],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Phone Number",
                          hintStyle: TextStyle(color: Color(0xFF797878)),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              if (isButtonEnabled) // Only show the button if isButtonEnabled is true
                SizedBox(
                  height: 45,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.verifyPhoneNumber(
                        phoneNumber: '${phoneNumberController.text}',
                        verificationCompleted:
                            (PhoneAuthCredential credential) {},
                        verificationFailed: (FirebaseAuthException e) {},
                        codeSent: (String verificationId, int? resendToken) {
                          MyPhone.verify = verificationId;
                          Navigator.pushNamed(context, "verify");
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {},
                      );
                      // Navigator.pushNamed(context, 'verify');
                    },
                    child: Text("Send The Code"),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFF532DE0)),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MyPhone(),
  ));
}
