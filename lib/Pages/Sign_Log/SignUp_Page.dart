import 'package:cloud_firestore/cloud_firestore.dart';
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

  String firstNameErrorText = '';
  String emailErrorText = '';
  String phoneNumberErrorText = '';
  String passwordErrorText = '';
  String confirmPasswordErrorText = '';
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool rememberMe = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signUp() async {
    setState(() {
      firstNameErrorText = firstNameController.text.isEmpty ? 'Please enter your first name' : '';
      emailErrorText = emailController.text.isEmpty ? 'Please enter a valid email address' : '';
      phoneNumberErrorText = phoneNumberController.text.isEmpty ? 'Please enter a valid phone number' : '';
      passwordErrorText = passwordController.text.isEmpty ? 'Please enter a password' : '';
      confirmPasswordErrorText = confirmPasswordController.text.isEmpty ? 'Please confirm your password' : '';

      if (passwordController.text != confirmPasswordController.text) {
        confirmPasswordErrorText = 'Passwords do not match';
      }
    });

    if (firstNameErrorText.isEmpty &&
        emailErrorText.isEmpty &&
        phoneNumberErrorText.isEmpty &&
        passwordErrorText.isEmpty &&
        confirmPasswordErrorText.isEmpty) {
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // Add user data to Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'firstName': firstNameController.text,
          'email': emailController.text,
          'phoneNumber': phoneNumberController.text,
        });

        print('Sign up successful');
        showSuccessDialog();
      } catch (e) {
        print('Sign up failed: $e');
        showErrorDialog('Sign up failed', cleanErrorMessage(e.toString()));
      }
    }
  }

  String cleanErrorMessage(String errorMessage) {
    // Remove the prefix (e.g., "[firebase_auth/weak-password] ")
    final prefixEnd = errorMessage.indexOf(']') + 1;
    if (prefixEnd > 0) {
      return errorMessage.substring(prefixEnd).trim();
    }
    return errorMessage;
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
              child: const Text('OK',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  void showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Sign Up Successful',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 25),
            ),
          ),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.5, // 70% of screen width
            height: MediaQuery.of(context).size.height * 0.03, // 30% of screen height
            child: Center(
              child: Text(
                'Thank you for signing up! \n Now you can log in to your account',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF131313), Color(0xFF312E2E)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
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
                            child: Column(
                              children: [
                                TextField(
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
                                    errorText: firstNameErrorText.isNotEmpty ? firstNameErrorText : null,
                                    errorStyle: const TextStyle(color: Colors.white), // Set error text color to white
                                  ),
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
                                    errorStyle: const TextStyle(color: Colors.white), // Set error text color to white
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
                            child: Column(
                              children: [
                                TextField(
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
                                    errorText: phoneNumberErrorText.isNotEmpty ? phoneNumberErrorText : null,
                                    errorStyle: const TextStyle(color: Colors.white), // Set error text color to white
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      if (!RegExp(r'^[0-9]*$').hasMatch(value)) {
                                        phoneNumberErrorText = 'Please enter a valid phone number';
                                      } else {
                                        phoneNumberErrorText = '';
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
                            child: Column(
                              children: [
                                TextField(
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
                                        _showPassword ? Icons.visibility : Icons.visibility_off,
                                        color: Colors.black,
                                      ),
                                    ),
                                    errorText: passwordErrorText.isNotEmpty ? passwordErrorText : null,
                                    errorStyle: const TextStyle(color: Colors.white), // Set error text color to white
                                  ),
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
                            child: Column(
                              children: [
                                TextField(
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
                                        _showConfirmPassword ? Icons.visibility : Icons.visibility_off,
                                        color: Colors.black,
                                      ),
                                    ),
                                    errorText: confirmPasswordErrorText.isNotEmpty ? confirmPasswordErrorText : null,
                                    errorStyle: const TextStyle(color: Colors.white), // Set error text color to white
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 5.0,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            signUp();
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
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "If you already have an account ",
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
                                      color: Color.fromARGB(255, 48, 83, 182),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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