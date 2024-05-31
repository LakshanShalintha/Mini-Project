import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../Home/Home_Screen.dart';
import 'Forgot/Forgot_pass.dart';
import 'SignUp_Page.dart';

class LogIn_Page extends StatefulWidget {
  const LogIn_Page({Key? key}) : super(key: key);

  @override
  _LogIn_PageState createState() => _LogIn_PageState();
}

class _LogIn_PageState extends State<LogIn_Page> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool rememberMe = false;
  bool _showPassword = false;

  Future<void> signIn() async {
    String url = 'http://10.0.2.2:8000/login/';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'email': usernameController.text,
          'password': passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final userId = responseData['user_id'];
        print(userId);
        print('Sign in successful');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        final responseData = jsonDecode(response.body);
        print('Sign in failed: ${responseData['message']}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign in failed: ${responseData['message']}')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue,
              Colors.green,
              Colors.yellow,
            ],
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Align(
                    alignment: Alignment(-1, -0.5),
                    child: Padding(
                      padding: EdgeInsets.only(left: 30.0),
                      child: Text(
                        'Log In',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 58, 57, 57),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: const Alignment(0, 0.06),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 20.0),
                      child: TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person),
                          hintText: 'Username',
                          hintStyle: const TextStyle(color: Colors.black),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: Colors.black, // Border color
                              width: 2.0, // Border width
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),

                  //Password
                  Align(
                    alignment: const Alignment(0, 0.06),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 20.0,
                      ),
                      child: TextField(
                        controller: passwordController,
                        obscureText: !_showPassword,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock),
                          hintText: 'Password',
                          hintStyle: const TextStyle(color: Colors.black),
                          border: const OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: Colors.black, // Border color
                              width: 2.0, // Border width
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.5),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _showPassword = !_showPassword;
                              });
                            },
                            child: Icon(
                              _showPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 0),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 5.0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Checkbox(
                            value: rememberMe,
                            onChanged: (value) {
                              setState(() {
                                rememberMe = value!;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text(
                            'Remember Me',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Forgot_pass()),
                            );
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.redAccent,
                              decoration: TextDecoration.underline,
                              decorationColor: Color.fromARGB(255, 18, 76, 236),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),


                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                      );// Handle button tap
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.black, width: 1), // Black border
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: const Text(
                      'Log In',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 80),
                            const Text("Don't have an account?"),
                            const SizedBox(width: 20),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const SignUp_Page()),
                                );
                              },
                              child: const Text(
                                'SignUp',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 18, 76, 236),
                                  decoration: TextDecoration.underline,
                                  decorationColor: Color.fromARGB(255, 18, 76, 236),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Divider(
                                color: Colors.red,
                                thickness: 1.5,
                                indent: 60,
                                endIndent: 5,
                              ),
                            ),
                            Text(
                              "or",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            Flexible(
                              child: Divider(
                                color: Colors.red,
                                thickness: 1.5,
                                indent: 5,
                                endIndent: 60,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          const googleUrl = 'https://www.google.com';
                          if (await canLaunch(googleUrl)) {
                            await launch(googleUrl);
                          } else {
                            throw 'Could not launch $googleUrl';
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.zero,
                            ),
                            child: IconButton(
                              onPressed: () {
                                // Handle Google login
                              },
                              icon: Image(
                                width: 50,
                                height: 40,
                                image: AssetImage("assets/logos/google.png"),
                              ),
                            ),
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          // Handle Google login
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.zero,
                            ),
                            child: IconButton(
                              onPressed: () {
                                // Handle Facebook login
                              },
                              icon: Image(
                                width: 50,
                                height: 40,
                                image: AssetImage("assets/logos/facebook.png"),
                              ),
                            ),
                          ),
                        ),

                      ),
                    ],
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
