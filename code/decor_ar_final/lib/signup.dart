import 'package:flutter/material.dart';
import 'package:final_project/phone.dart';
import 'package:final_project/login.dart';
import 'package:final_project/service/auth.dart';
import 'package:video_player/video_player.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: preferredSize.height + MediaQuery.of(context).padding.top,
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
          automaticallyImplyLeading: false,// Make the AppBar background transparent
          elevation: 0,
          title: Text(
                'Join Us',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            centerTitle: true,

        ),

      ],
    );
  }
}

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with RouteAware {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/Video1.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play(); // Start playing the video automatically
      })
      ..setLooping(true)
      ..setVolume(0.1);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ModalRoute<Object?>? route = ModalRoute.of(context);
    if (route != null) {
      routeObserver.subscribe(this, route as PageRoute<Object?>);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // This method is called when the current route is popped and comes back to foreground.
    _controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(),
    backgroundColor: Color(0xFF2A2A2A),
    body: SingleChildScrollView(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
    SizedBox(height: 20),
    Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: _controller.value.isInitialized
    ? ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: Container(
    height: 300,
    width: MediaQuery.of(context).size.width - 40,
    child: AspectRatio(
    aspectRatio: _controller.value.aspectRatio,
    child: VideoPlayer(_controller),
    ),
    ),
    )
        : Container(
    height: 200,
    width: MediaQuery.of(context).size.width - 40,
    color: Colors.black,
    child: Center(child: CircularProgressIndicator()),
    ),
    ),
    SizedBox(height: 20),
    buildButton(
    context,
    onPressed: () {
    _controller.pause();
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => MyPhone()),
    );
    },
    icon: Icons.phone,
    text: 'Sign Up with Phone Number',
    ),
    SizedBox(height: 5),
    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Expanded(
    child: Container(
    height: 1,
    color: Colors.white30,
    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    ),
    ),
    Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Text(
    'OR',
    style: TextStyle(
    color: Colors.white54,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    ),
    ),
    ),
    Expanded(
    child: Container(
    height: 1,
    color: Colors.white30,
    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    ),
    ),
    ],
    ),
    SizedBox(height: 5),
    buildButton(
    context,
    onPressed: () {
    _controller.pause();
    AuthMethods().signInWithGoogle(context);
    },
    icon: Icons.account_circle,
    text: 'Sign Up with Google',
    imageAsset: 'assets/google_logo.png',
    ),
    SizedBox(height: 10),
    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Text(
    'Already have an Account?',
    style: TextStyle(
    color: Colors.white,
    fontSize: 15,
    ),
    ),
    SizedBox(width: 10),
    GestureDetector(
    onTap: () {
    _controller.pause();
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => LoginPage()),
    );
    },
    child: Container(
    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(25),
    color: Color(0xFF5D43AB),
    ),
    child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
    Icon(
    Icons.login,
    color: Colors.white,
    ),
    SizedBox(width: 5),
    Text(
    'Log In',
    style: TextStyle(
    color: Colors.white,
    fontSize: 16,
    ),
    ),
    ],
    ),
    ),
    ),
    ],
    ),
    SizedBox(height: 70),
    Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
    style: TextStyle(color: Colors.white),
    children: [
    TextSpan(
    text: ' ',
    ),
    WidgetSpan(
    child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 2.0),
    child: Icon(
    Icons.check_circle,
    color: Colors.green,
    size: 16, // Adjust the size of the icon as needed
    ),
    ),
    ),
    TextSpan(
    text: ' By Signing Up or Signing In, You Agree To Our ',
    ),
    TextSpan(
    text: 'Terms of Use',
    style: TextStyle(
    color: Colors.blue,
    decoration: TextDecoration.underline,
    ),
    ),
    TextSpan(
    text: ' and ',
    ),
    TextSpan(
    text: 'Privacy Policy',
    style: TextStyle(
    color: Colors.blue,
    decoration: TextDecoration.underline
    ),
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

  Widget buildButton(BuildContext context,
      {required VoidCallback onPressed,
        required IconData icon,
        required String text,
        String? imageAsset}) {
    return Container(
      width: double.infinity,
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF2A2A2A)),
          side: MaterialStateProperty.all<BorderSide>(
              BorderSide(color: Colors.white)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imageAsset != null)
              Image.asset(imageAsset, height: 24)
            else
              Icon(icon, color: Colors.white),
            SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SignUpPage(),
    navigatorObservers: [routeObserver],
  ));
}
