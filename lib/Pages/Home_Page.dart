import 'package:flutter/material.dart';
import 'package:mini_project/Pages/Sign_Log/LogIn_Page.dart';
import 'package:mini_project/Pages/Sign_Log/SignUp_Page.dart';

import '../CommonParts/Nav_Menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Audio Book App',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: CustomCurvedEdges(),
              child: Container(
                color: Colors.blue,
                padding: const EdgeInsets.all(0),
                child: SizedBox(
                  height: 400,
                  child: Stack(
                    children: [
                      Positioned(
                        top: -150,
                        right: -250,
                        child: CircularContainer(
                          backgroundColor: Colors.white70.withOpacity(0.1),
                        ),
                      ),
                      Positioned(
                        top: 100,
                        right: -300,
                        child: CircularContainer(
                          backgroundColor: Colors.white70.withOpacity(0.1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Add SignUp and LogIn buttons
            Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const SignUp_Page()),
                      );// Handle SignUp button tap
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green, // Change font color
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Change button padding
                      textStyle: const TextStyle(fontSize: 20), // Change font size
                    ),
                    child: const Text('Sign Up'),
                  ),
                  const SizedBox(width: 20, height: 500,),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const LogIn_Page()),
                      );// Handle LogIn button tap
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue, // Change font color
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Change button padding
                      textStyle: const TextStyle(fontSize: 20), // Change font size
                    ),
                    child: const Text('Log In'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NavMenu(),
    );
  }
}

class CircularContainer extends StatelessWidget {
  const CircularContainer({
    Key? key,
    this.child,
    this.width = 400,
    this.height = 400,
    this.radius = 400,
    this.padding = 0,
    this.backgroundColor = Colors.blueAccent,
  }) : super(key: key);

  final double? width;
  final double? height;
  final double radius;
  final double padding;
  final Widget? child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: backgroundColor,
      ),
      child: child,
    );
  }
}

class CustomCurvedEdges extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);

    final firstCurveStart = Offset(0, size.height - 20);
    final firstCurveEnd = Offset(40, size.height - 20);
    path.quadraticBezierTo(firstCurveStart.dx, firstCurveStart.dy, firstCurveEnd.dx, firstCurveEnd.dy);

    final secondCurveStart = Offset(0, size.height - 20);
    final secondCurveEnd = Offset(size.width - 40, size.height - 20);
    path.quadraticBezierTo(secondCurveStart.dx, secondCurveStart.dy, secondCurveEnd.dx, secondCurveEnd.dy);

    final thirdCurveStart = Offset(size.width, size.height - 20);
    final thirdCurveEnd = Offset(size.width, size.height);
    path.quadraticBezierTo(thirdCurveStart.dx, thirdCurveStart.dy, thirdCurveEnd.dx, thirdCurveEnd.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
