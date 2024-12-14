import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:final_project/signup.dart';
import 'package:final_project/dashboard.dart';

class Country {
  final String name;
  final String code;
  final String flag;

  Country({required this.name, required this.code, required this.flag});
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  List<Country> countries = [
    Country(name: 'India', code: '+91', flag: '🇮🇳'),
    Country(name: 'United States', code: '+1', flag: '🇺🇸'),
  ];

  Country? selectedCountry;

  TextEditingController _inputController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final List<TextEditingController> _otpControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());
  final _formKey = GlobalKey<FormState>();

  bool _showOtpInput = false;
  bool _isEmailLogin = false;

  @override
  void initState() {
    super.initState();
    selectedCountry = countries.first;

    // Add listeners to focus nodes
    for (int i = 0; i < _otpFocusNodes.length; i++) {
      _otpControllers[i].addListener(() {
        if (_otpControllers[i].text.length == 1 && i < _otpFocusNodes.length - 1) {
          _otpFocusNodes[i + 1].requestFocus();
        }
      });
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _otpFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  // Function to verify OTP
  void _verifyOtp() {
    String otp = _otpControllers.map((controller) => controller.text).join();
    if (otp.length == 6) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid 6-digit OTP')),
      );
    }
  }

  // Function to handle Google Sign-In
  Future<void> _handleGoogleSignIn() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        // Successful Google Sign-In, navigate to Dashboard
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
        );

      }
    } catch (error) {
      print('Google Sign-In error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In failed. Please try again.')),
      );
    }
  }

  // Function to handle email login
  void _handleEmailLogin() {
    if (_formKey.currentState!.validate()) {
      // Handle email login here
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2A2A2A),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: kToolbarHeight + MediaQuery.of(context).padding.top,
              decoration: BoxDecoration(
                color: Color(0xFF532DE0),
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(47),
                  bottomLeft: Radius.circular(47),
                ),
              ),
            ),
          ),
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 90.0),
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),

                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: kToolbarHeight + MediaQuery.of(context).padding.top),
            child: Container(
              color: Color(0xFF2A2A2A),
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 2.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/login.gif', // Update this with the correct path to your image
                              width: 150,
                              height: 150,
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              _isEmailLogin ? 'Enter Email and Password' : 'Enter Phone Number',
                              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          _isEmailLogin
                              ? 'We will verify your email and password.'
                              : 'We might save and send a verification code to this phone number.',
                          style: TextStyle(fontSize: 14.0, color: Colors.white54),
                        ),
                        SizedBox(height: 8.0),
                        if (_isEmailLogin) ...[
                          TextFormField(
                            controller: _emailController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Enter Email',
                              hintStyle: TextStyle(color: Colors.white30),
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Color(0xFF3A3A3A),
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 8.0),
                          TextFormField(
                            controller: _passwordController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Enter Password',
                              hintStyle: TextStyle(color: Colors.white30),
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Color(0xFF3A3A3A),
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                        ] else ...[
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 5, top: 5, right: 2, bottom: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.white),
                                ),
                                height: 50,
                                width: 110,
                                child: DropdownButton<Country>(
                                  value: selectedCountry,
                                  icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: TextStyle(color: Colors.white, fontSize: 18),
                                  underline: Container(),
                                  dropdownColor: Color.fromRGBO(255, 255, 255, 0.50),
                                  onChanged: (Country? newValue) {
                                    setState(() {
                                      selectedCountry = newValue;
                                    });
                                  },
                                  items: countries.map<DropdownMenuItem<Country>>((Country value) {
                                    return DropdownMenuItem<Country>(
                                      value: value,
                                      child: Row(
                                        children: [
                                          Text(value.flag),
                                          SizedBox(width: 8),
                                          Text(value.code),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              SizedBox(width: 12.0),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.white),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: TextFormField(
                                      controller: _inputController,
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        hintText: 'Enter Phone Number',
                                        hintStyle: TextStyle(color: Colors.white30),
                                        border: InputBorder.none,
                                      ),
                                      keyboardType: TextInputType.phone,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(10),
                                      ],
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your phone number';
                                        } else if (value.length != 10) {
                                          return 'Phone number must be exactly 10 digits';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (_showOtpInput && !_isEmailLogin) ...[
                          SizedBox(height: 20.0),
                          Text(
                            'Enter OTP',
                            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(6, (index) {
                              return Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: TextFormField(
                                  controller: _otpControllers[index],
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(bottom: 16.0),
                                    hintStyle: TextStyle(color: Colors.white),
                                  ),
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(1),
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  focusNode: _otpFocusNodes[index],
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      if (index < _otpControllers.length - 1) {
                                        _otpFocusNodes[index + 1].requestFocus();
                                      }
                                    } else {
                                      if (index > 0) {
                                        _otpFocusNodes[index - 1].requestFocus();
                                      }
                                    }
                                  },
                                ),
                              );
                            }),
                          ),
                        ],
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (!_isEmailLogin) {
                                if (!_showOtpInput) {
                                  setState(() {
                                    _showOtpInput = true;
                                  });
                                } else {
                                  _verifyOtp();
                                }
                              } else {
                                _handleEmailLogin();
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF532DE0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              _isEmailLogin ? 'LOGIN NOW' : (_showOtpInput ? 'VERIFY OTP' : 'LOGIN NOW'),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 4.0),
                                height: 1,
                                color: Colors.white30,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'OR',
                                style: TextStyle(color: Colors.white54),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 4.0),
                                height: 1,
                                color: Colors.white30,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              child: IconButton(
                                icon: Image.asset('assets/google_logo.png'),
                                color: Colors.white,
                                onPressed: _handleGoogleSignIn,
                              ),
                            ),
                            SizedBox(width: 16.0),
                            CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: IconButton(
                                icon: Icon(_isEmailLogin ? Icons.phone : Icons.email),
                                color: Colors.white,
                                onPressed: () {
                                  setState(() {
                                    _isEmailLogin = !_isEmailLogin;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.0),
                        Center(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
                            },
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(color: Colors.white),
                                children: [
                                  TextSpan(
                                    text: "Don't have an account? ",
                                  ),
                                  TextSpan(
                                    text: "Sign up now",
                                    style: TextStyle(color: Color(0xFF532DE0)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
    title: 'Login Demo',
    home: LoginPage(),
  ));
}
