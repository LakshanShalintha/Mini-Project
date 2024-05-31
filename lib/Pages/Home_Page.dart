import 'package:flutter/material.dart';
import 'package:mini_project/Pages/Sign_Log/LogIn_Page.dart';
import 'package:mini_project/Pages/Sign_Log/SignUp_Page.dart';

import '../CommonParts/AppBar.dart';

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
      appBar: const CustomAppBar(
          title: 'Welcome To AudiRAB'), // Hide the back button
      body: SingleChildScrollView(
        child: Column(
          children: [
            CurvedBackground(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        const SectionHeading(
                            title: 'AudiRAB', showActionButton: false),
                        const SizedBox(height: 20),
                        const Text(
                          'Your additional text goes here'
                              'asugfdgfhwdfjk\n hfjwej ewgih jhwde cnwej'
                              'jdbfhkd shchw dsd hbixhk anxhbsx k \n gcz sbyshjb hcs',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40), // Adding some space between text and image
                        Image.asset(
                          'assets/images/on_boarding/onboard01.png',
                          height: 120,
                          width: 150,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80,),
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
                        MaterialPageRoute(
                            builder: (context) => const SignUp_Page()),
                      ); // Handle SignUp button tap
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.teal, // Change button color
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10), // Change button padding
                      textStyle:
                      const TextStyle(fontSize: 20), // Change font size
                    ),
                    child: const Text('Sign Up'),
                  ),
                  const SizedBox(
                    width: 10,
                    height: 100,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => const LogIn_Page()),
                      ); // Handle LogIn button tap
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blueAccent, // Change button color
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10), // Change button padding
                      textStyle:
                      const TextStyle(fontSize: 20), // Change font size
                    ),
                    child: const Text('Log In'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CurvedBackground extends StatelessWidget {
  final Widget child;

  const CurvedBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400, // Adjust the height as needed
      decoration: const BoxDecoration(
        color: Colors.teal, // New background color
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
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
          const Positioned(
            top: 200,
            left: 0,
            right: 0,
            bottom: 0,
            child: Center(
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: child,
          ),
        ],
      ),
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
    this.backgroundColor = Colors.teal, // New color
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

class SectionHeading extends StatelessWidget {
  final String title;
  final bool showActionButton;

  const SectionHeading({
    required this.title,
    this.showActionButton = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(color: Colors.white), // Adjusted text color
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (showActionButton)
          TextButton(
            onPressed: () {},
            child: const Text('button title'),
          )
      ],
    );
  }
}
