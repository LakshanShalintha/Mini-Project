import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Home_Page.dart';
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
  String emailErrorText = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signUp() async {
    if (firstNameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        phoneNumberController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty &&
        phoneNumberErrorText.isEmpty &&
        passwordController.text == confirmPasswordController.text) {
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        print('Sign up successful');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } catch (e) {
        print('Sign up failed: $e');
        showErrorDialog('Sign up failed', e.toString());
      }
    } else {
      // Do not proceed with sign-up, display error messages
      if (firstNameController.text.isEmpty ||
          emailController.text.isEmpty ||
          phoneNumberController.text.isEmpty ||
          passwordController.text.isEmpty ||
          confirmPasswordController.text.isEmpty) {
        showErrorDialog('Error', 'Please fill in all required fields.');
      } else if (phoneNumberErrorText.isNotEmpty) {
        showErrorDialog('Error', phoneNumberErrorText);
      } else if (passwordController.text != confirmPasswordController.text) {
        showErrorDialog('Error', 'Passwords do not match.');
      }
    }
  }

  void showErrorDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF131313), Color(0xFF312E2E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
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
                          padding: EdgeInsets.only(top: 80.0, left: 30),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
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
                              prefixIcon: const Icon(Icons.person, color: Colors.black),
                              hintText: 'User Name',
                              hintStyle: const TextStyle(color: Colors.black),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  color: Colors.black, // Border color
                                  width: 2.0, // Border width
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
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
                          child: Column(
                            children: [
                              TextField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.email, color: Colors.black),
                                  hintText: 'Email',
                                  hintStyle: const TextStyle(color: Colors.black),
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                      color: Colors.black, // Border color
                                      width: 2.0, // Border width
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 2.5,
                                  ),
                                  errorText: emailErrorText.isNotEmpty ? emailErrorText : null,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    if (!RegExp(
                                      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$',
                                    ).hasMatch(value)) {
                                      emailErrorText = 'Please enter a valid email address';
                                    } else {
                                      emailErrorText = '';
                                    }
                                  });
                                },
                              ),
                            ],
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
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10), // Limit input to 10 digits
                              FilteringTextInputFormatter.digitsOnly, // Allow only digits
                            ],
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.phone, color: Colors.black),
                              hintText: 'Phone Number',
                              hintStyle: const TextStyle(color: Colors.black),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  color: Colors.black, // Border color
                                  width: 2.0, // Border width
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 2.5,
                              ),
                            ),
                            onChanged: (value) {
                              if (!RegExp(r'^[0-9]*$').hasMatch(value)) {
                                setState(() {
                                  phoneNumberErrorText = 'Please enter a valid phone number';
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
                              prefixIcon: const Icon(Icons.lock, color: Colors.black),
                              hintText: 'Password',
                              hintStyle: const TextStyle(color: Colors.black),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  color: Colors.black, // Border color
                                  width: 2.0, // Border width
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
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
                                  color: Colors.black,
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
                            horizontal: 20.0,
                            vertical: 15.0,
                          ),
                          child: TextField(
                            controller: confirmPasswordController,
                            obscureText: !_showConfirmPassword,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock, color: Colors.black),
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
                              fillColor: Colors.white,
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
                                  color: Colors.black,
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
                              activeColor: Colors.white,
                              checkColor: Colors.black,
                            ),
                            Text(
                              'Remember Me',
                              style: TextStyle(
                                color: Colors.white,
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
                            showErrorDialog('Error', 'Please fill in all required fields.');
                          } else if (phoneNumberErrorText.isNotEmpty) {
                            // Show error message if phone number is invalid
                            showErrorDialog('Error', phoneNumberErrorText);
                          } else if (passwordController.text != confirmPasswordController.text) {
                            // Show error message if passwords do not match
                            showErrorDialog('Error', 'Passwords do not match.');
                          } else {
                            // All fields are filled, phone number is valid, and passwords match, proceed with sign-up
                            signUp();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(color: Colors.black, width: 1),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                 // This spacer will push the content above it to the top
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "If you already have an account",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 5),
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
                              color: Color.fromARGB(255, 47, 87, 199),
                            ),
                          ),
                        ),
                      ],
                    ),
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
