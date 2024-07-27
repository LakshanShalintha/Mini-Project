import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Forgot_pass extends StatefulWidget {
  const Forgot_pass({Key? key}) : super(key: key);

  @override
  _Forgot_passState createState() => _Forgot_passState();
}

class _Forgot_passState extends State<Forgot_pass> {
  TextEditingController emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isSendingEmail = false;

  Future<void> sendPasswordResetEmail() async {
    setState(() {
      _isSendingEmail = true;
    });
    try {
      await _auth.sendPasswordResetEmail(email: emailController.text.trim());
      showSuccessDialog();
    } on FirebaseAuthException catch (e) {
      print('Error: $e');
      showErrorDialog('Error', e.message ?? 'Failed to send reset email. Please try again.');
    } catch (e) {
      print('Error: $e');
      showErrorDialog('Error', 'An unexpected error occurred. Please try again.');
    } finally {
      setState(() {
        _isSendingEmail = false;
      });
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

  void showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Password Reset Email Sent'),
          content: const Text(
              'A password reset email has been sent. Please check your email.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Go back to the login screen
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
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                "Forgot Password!",
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                "Enter your email address to reset password",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "E-mail",
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isSendingEmail ? null : sendPasswordResetEmail,
                style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.blue),
                  minimumSize:
                  MaterialStateProperty.all<Size>(const Size(200, 50)),
                ),
                child: _isSendingEmail
                    ? CircularProgressIndicator()
                    : const Text(
                  "Submit",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
