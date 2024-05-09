import 'package:flutter/material.dart';
import 'package:mini_project/Pages/Sign_Log/Verify_email.dart';

import 'LogIn_Page.dart';

class SignUp_Page extends StatefulWidget {
  const SignUp_Page({Key? key}) : super(key: key);

  @override
  _SignUp_PageState createState() => _SignUp_PageState();
}

class _SignUp_PageState extends State<SignUp_Page> {
  bool _showPassword = false;
  bool _rememberMe = false; // Define _rememberMe here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            SizedBox(width: 8), // Spacing
            SizedBox(width: 8), // Spacing
            Text('Audio Books', style: TextStyle(fontSize: 25.0)),
          ],
        ),
        backgroundColor: Colors.purpleAccent,

      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black26, // Green color for the container
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Center(
                      child: Text(
                        "SignUp",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Form(
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Username',
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              prefixIcon: Icon(Icons.person),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              prefixIcon: Icon(Icons.email),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            obscureText: !_showPassword,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              prefixIcon: const Icon(Icons.lock),
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
                          const SizedBox(height: 10),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // Toggle the checkbox value
                                      setState(() {
                                        _rememberMe = !_rememberMe;
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Checkbox(
                                          value: _rememberMe,
                                          onChanged: (value) {
                                            // Toggle the checkbox value
                                            setState(() {
                                              _rememberMe = value!;
                                            });
                                          },
                                        ),
                                        const Text("Remember Me"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => const Verify_email()),
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.purpleAccent),
                                minimumSize:
                                MaterialStateProperty.all<Size>(const Size(200, 50)),
                              ),
                              child: const Text(
                                "SignUp",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => const LogIn_Page()),
                              );
                            },
                            child: Text(
                              'Already have an account? Log In',
                              style: TextStyle(color: Color.fromARGB(255, 25, 26, 13)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Row(
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
                        Text("or",
                          style: TextStyle(
                            fontSize: 30,fontWeight: FontWeight.bold,color: Colors.green,
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
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.zero,
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Image(
                              width: 50,
                              height: 40,
                              image: AssetImage("assets/logos/facebook.png"),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.zero,
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Image(
                              width: 50,
                              height: 40,
                              image: AssetImage("assets/logos/google.png"),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.zero,
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Image(
                              width: 47,
                              height: 55,
                              image: AssetImage("assets/logos/switer.png"),
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
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: SignUp_Page(),
  ));
}
