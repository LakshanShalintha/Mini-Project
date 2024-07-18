import 'package:flutter/material.dart';
import 'package:mini_project/Pages/Sign_Log/LogIn_Page.dart';
import 'package:mini_project/Pages/Sign_Log/SignUp_Page.dart';

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
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Home_Page/Home page.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 1),
              SizedBox(height: 5,),
              const Text(
                'AudiRAB',
                style: TextStyle(
                  fontSize: 46,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50), // Space between the title and the new text
              const Text(
                  "Welcome to AudiRAB!",
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                      "Join us and unlock a universe of captivating audiobooks. "
                      "Sign in \n or create an account to explore \n an endless library of stories, "
                      "\n from timeless classics to modern masterpieces. Begin your auditory adventure with us today!",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,// Decrease the space between words
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 50,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    // Sign Up Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const SignUp_Page()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 80),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Log In Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const LogIn_Page()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF837E47),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 88),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Log In',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
