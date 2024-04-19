import 'package:flutter/material.dart';
import 'Sign_Log/LogIn_Page.dart';
import 'Sign_Log/SignUp_Page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  const HomePage({super.key});

  get google => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            PopupMenuButton(
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                const PopupMenuItem(
                  value: 'search',
                  child: Text('Search'),
                ),
                const PopupMenuItem(
                  value: 'menu',
                  child: Text('Menu'),
                ),
                const PopupMenuItem(
                  value: 'log',
                  child: Text('Log'),
                ),
                const PopupMenuItem(
                  value: 'sign',
                  child: Text('Sign'),
                ),
              ],
              onSelected: (value) {
                // Handle item selection
                switch (value) {
                  case 'search':
                  // Navigate to search page
                    break;
                  case 'menu':
                  // Handle menu action
                    break;
                  case 'log':
                  // Navigate to login page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LogIn_Page()),
                    );
                    break;
                  case 'sign':
                  // Navigate to sign up page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUp_Page()),
                    );
                    break;
                }
              },
              icon: const Icon(Icons.menu),
              onOpened: () {}, // Menu icon
            ),
            const SizedBox(width: 8), // Spacing
            const SizedBox(width: 8), // Spacing
            const Text('Audio Books', style: TextStyle(fontSize: 25.0)),
          ],
        ),
        backgroundColor: Colors.greenAccent,
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to sign up page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignUp_Page()),
              );
            },
            icon: const Icon(Icons.person_add),
          ),
          IconButton(
            onPressed: () {
              // Navigate to login page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LogIn_Page()),
              );
            },
            icon: const Icon(Icons.login),
          ),
        ],
      ),
      backgroundColor: Colors.red[200],
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/Home_Page/onboard03.png"),
            fit:BoxFit.cover,
          ),

        ),
      ),
    );
  }
}
