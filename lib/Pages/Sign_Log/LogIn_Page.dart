import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart'; // Import Google Sign-In
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:shared_preferences/shared_preferences.dart';
import '../Home/Home_Screen.dart';
import 'Forgot/Forgot_pass.dart';
import 'SignUp_Page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LogIn_Page extends StatefulWidget {
  const LogIn_Page({Key? key}) : super(key: key);

  @override
  _LogIn_PageState createState() => _LogIn_PageState();
}

class _LogIn_PageState extends State<LogIn_Page> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool rememberMe = false;
  bool _showPassword = false;
  String emailErrorText = '';
  String passwordErrorText = '';

  @override
  void initState() {
    super.initState();
    _loadEmail();
  }

  Future<void> _loadEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      emailController.text = prefs.getString('email') ?? '';
      rememberMe = prefs.getBool('rememberMe') ?? false;
    });
  }

  Future<void> _saveEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      await prefs.setString('email', emailController.text.trim());
    } else {
      await prefs.remove('email');
    }
    await prefs.setBool('rememberMe', rememberMe);
  }

  Future<void> signIn() async {
    if (emailController.text.trim().isEmpty || passwordController.text.trim().isEmpty) {
      setState(() {
        if (emailController.text.trim().isEmpty) {
          emailErrorText = 'Please fill in this field';
        } else {
          emailErrorText = '';
        }
        if (passwordController.text.trim().isEmpty) {
          passwordErrorText = 'Please fill in this field';
        } else {
          passwordErrorText = '';
        }
      });
      return;
    }

    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      await _saveEmail(); // Save email if remember me is checked
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String message;
      if (emailController.text.trim().isEmpty || passwordController.text.trim().isEmpty) {
        message = 'Please fill in all fields.';
      } else if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      } else {
        message = 'Invalid Email or Password!';
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Login Error', textAlign: TextAlign.center),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: const Text('OK', style: TextStyle(color: Colors.black)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return; // User canceled the sign-in
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);

      // Store user info in Firestore
      User? user = userCredential.user;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': user.email,
          'name': user.displayName,
          // Add other user info if needed
        });
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Sign in with Google failed. Please try again.';
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Login Error'),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
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
                        const SizedBox(height: 130.0),
                        const Align(
                          alignment: Alignment(-1, -0.5),
                          child: Padding(
                            padding: EdgeInsets.only(left: 30.0),
                            child: Text(
                              'Log In',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: const Alignment(0, 0.06),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
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
                                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
                                    errorText: emailErrorText.isNotEmpty ? emailErrorText : null,
                                    errorStyle: const TextStyle(color: Colors.white), // Set error text color to white
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      if (!RegExp(r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                                        emailErrorText = 'Please enter a valid email address';
                                      } else {
                                        emailErrorText = '';
                                      }
                                    });
                                  },
                                ),
                                SizedBox(height: 15),
                                TextField(
                                  controller: passwordController,
                                  obscureText: !_showPassword,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.lock, color: Colors.black),
                                    hintText: 'Password',
                                    hintStyle: const TextStyle(color: Colors.black),
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _showPassword = !_showPassword;
                                        });
                                      },
                                      child: Icon(_showPassword ? Icons.visibility : Icons.visibility_off, color: Colors.black),
                                    ),
                                    errorText: passwordErrorText.isNotEmpty ? passwordErrorText : null,
                                    errorStyle: const TextStyle(color: Colors.white), // Set error text color to white
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
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
                                  activeColor: Colors.white,
                                  checkColor: Colors.black,
                                ),
                              ),
                              const Expanded(
                                flex: 4,
                                child: Text(
                                  'Remember Me',
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Forgot_pass()));
                                },
                                child: const Text(
                                  'Forgot Password?',
                                  style: TextStyle(fontSize: 14, color: Colors.redAccent),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            signIn();
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
                            'Log In',
                            style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const SizedBox(width: 80),
                                  const Text(
                                    "Don't have an account?",
                                    style: TextStyle(fontSize: 13, color: Colors.white),
                                  ),
                                  const SizedBox(width: 20),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUp_Page()));
                                    },
                                    child: const Text(
                                      'SignUp',
                                      style: TextStyle(color: Colors.lightBlue),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Divider(
                                      color: Colors.white,
                                      thickness: 1.5,
                                      indent: 35,
                                      endIndent: 5,
                                    ),
                                  ),
                                  Text(
                                    "or",
                                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                  Flexible(
                                    child: Divider(
                                      color: Colors.white,
                                      thickness: 1.5,
                                      indent: 5,
                                      endIndent: 35,
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
                                signInWithGoogle(); // Call Google sign-in method
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                  child: IconButton(
                                    onPressed: signInWithGoogle,
                                    icon: const Icon(FontAwesomeIcons.google, size: 30, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Handle Facebook login
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      /*Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FacebookLoginPage()),
                                      );*/
                                    },
                                    icon: const Icon(FontAwesomeIcons.facebookF, size: 30, color: Colors.white),
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
        ),
      ),
    );
  }
}
