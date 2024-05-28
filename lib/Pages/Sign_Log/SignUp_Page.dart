import 'package:flutter/material.dart';
import 'package:mini_project/Pages/Home_Page.dart';
import 'package:http/http.dart' as http;
import 'LogIn_Page.dart';

class SignUp_Page extends StatefulWidget {
  const SignUp_Page({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUp_Page> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  String phoneNumberErrorText = '';
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool rememberMe = false;

  Future<void> signUp() async {
    // Your backend endpoint URL
    String url = 'http://127.0.0.1:8000/api/signup/';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'name': firstNameController.text,
          'email': emailController.text,
          'phone_number': phoneNumberController.text,
          'password': passwordController.text,
        },
      );

      if (response.statusCode == 201) {
        // Request successful
        print('Sign up successful');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        // Request failed
        print('Sign up failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Error occurred
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/on_boarding/onboard03.jfif'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Align(
                        alignment: Alignment(-1, -0.5),
                        child: Padding(
                          padding: EdgeInsets.only(top: 50.0, left: 130),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: const Alignment(0, 0.06),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 15.0,
                          ),
                          child: TextField(
                            controller: firstNameController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.person),
                              hintText: 'User Name',
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
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 2.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: const Alignment(0, 0.06),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 15.0,
                          ),
                          child: TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.email),
                              hintText: 'Email',
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
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 2.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: const Alignment(0, 0.06),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 15.0,
                          ),
                          child: TextField(
                            controller: phoneNumberController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.phone),
                              hintText: 'Phone Number',
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
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 2.5,
                              ),
                            ),
                            onChanged: (value) {
                              if (!RegExp(r'^[0-9]*$').hasMatch(value)) {
                                setState(() {
                                  phoneNumberErrorText =
                                  'Please enter a valid phone number';
                                });
                              } else {
                                setState(() {
                                  phoneNumberErrorText = '';
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      if (phoneNumberErrorText.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 5.0,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              phoneNumberErrorText,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      Align(
                        alignment: const Alignment(0, 0.06),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 15.0,
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
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 2.5,
                              ),
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
                      Align(
                        alignment: const Alignment(0, 0.06),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 15.0),
                          child: TextField(
                            controller: confirmPasswordController,
                            obscureText: !_showConfirmPassword,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock),
                              hintText: 'Confirm Password',
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
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 2.5,
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _showConfirmPassword = !_showConfirmPassword;
                                  });
                                },
                                child: Icon(
                                  _showConfirmPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 5.0,
                        ),
                        child: Row(
                          children: [
                            Checkbox(
                              value: rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  rememberMe = value!;
                                });
                              },
                            ),
                            Text(
                              'Remember Me',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (firstNameController.text.isEmpty ||
                              emailController.text.isEmpty ||
                              phoneNumberController.text.isEmpty ||
                              passwordController.text.isEmpty ||
                              confirmPasswordController.text.isEmpty) {
                            // Show error message if any required field is empty
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Error'),
                                  content: const Text(
                                      'Please fill in all required fields.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else if (phoneNumberErrorText.isNotEmpty) {
                            // Show error message if phone number is invalid
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Error'),
                                  content: Text(phoneNumberErrorText),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else if (passwordController.text !=
                              confirmPasswordController.text) {
                            // Show error message if passwords do not match
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Error'),
                                  content: const Text(
                                      'Passwords do not match.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            // All fields are filled, phone number is valid, and passwords match, proceed with sign-up
                            signUp();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 80,
                      ),
                      const Text(
                        "If you already have an account,",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LogIn_Page(),
                            ),
                          );
                        },
                        child: const Text(
                          'LogIn',
                          style: TextStyle(
                            color: Color.fromARGB(255, 18, 76, 236),
                            decoration: TextDecoration.underline,
                            decorationColor: Color.fromARGB(255, 18, 76, 236),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
