import 'package:flutter/material.dart';
import '../Home/Home_Screen.dart';
import 'Forgot/Forgot_pass.dart';
import 'SignUp_Page.dart';

class LogIn_Page extends StatefulWidget {
  const LogIn_Page({Key? key}) : super(key: key);

  @override
  _LogIn_PageState createState() => _LogIn_PageState();
}

class _LogIn_PageState extends State<LogIn_Page> {
  bool _showPassword = false; // Define _showPassword here
  bool _rememberMe = false; // Define _rememberMe here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const SizedBox(width: 8), // Spacing
            const SizedBox(width: 8), // Spacing
            const Text('Audio Books', style: TextStyle(fontSize: 25.0)),
          ],
        ),
        backgroundColor: Colors.greenAccent,
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to login page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignUp_Page()),
              );
            },
            icon: const Icon(Icons.login),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 0.1),
              const Center(
                child: Image(
                  height: 50,
                  image: AssetImage("assets/logos/login.png"),
                ),
              ),
              const SizedBox(height: 0.01),
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
                        "LogIn",
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
                                color: Colors.blue,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              prefixIcon: Icon(Icons.person),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            obscureText: !_showPassword,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: const TextStyle(
                                color: Colors.blue,
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
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const Forgot_pass()),
                                  );
                                },
                                child: const Text("Forgot Password",
                                  style: TextStyle(
                                    fontSize: 15,fontWeight: FontWeight.bold,color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue),
                                minimumSize:
                                MaterialStateProperty.all<Size>(const Size(200, 50)),
                              ),
                              child: const Text(
                                "LogIn",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Divider(
                            color: Colors.red,
                            thickness: 0.5,
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
                            thickness: 0.5,
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
    home: LogIn_Page(),
  ));
}
