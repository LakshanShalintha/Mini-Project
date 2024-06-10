import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GmailLoginPage(),
    );
  }
}

class GmailLoginPage extends StatefulWidget {
  @override
  _GmailLoginPageState createState() => _GmailLoginPageState();
}

class _GmailLoginPageState extends State<GmailLoginPage> {
  String _selectedLanguage = 'English';

  // Localized strings for different languages
  Map<String, Map<String, String>> localizedStrings = {
    'English': {
      'signIn': 'Sign in',
      'toContinue': 'to continue to Admin console',
      'emailOrPhone': 'Email or phone',
      'forgotEmail': 'Forgot email?',
      'login': 'Login',
      'createAccount': 'Create account',
      'next': 'Next',  // Corrected key to 'next'
    },
    'Sinhala': {
      'signIn': 'ඇතුල්වන්න',
      'toContinue': 'පරිපාලන console එකට පැමිණීමට',
      'emailOrPhone': 'ඊමේල් හෝ දුරකථන',
      'forgotEmail': 'ඊමේල් අමතකද?',
      'login': 'ඇතුල්වන්න',
      'createAccount': 'ගිණුමක් සාදන්න',
      'next': 'ඊළඟ',  // Added corresponding value for 'next'
    },
    'Tamil': {
      'signIn': 'உள்நுழைய',
      'toContinue': 'நிர்வாகக் console-க்கு தொடர',
      'emailOrPhone': 'மின்னஞ்சல் அல்லது தொலைபேசி',
      'forgotEmail': 'மின்னஞ்சல் மறந்துவிட்டதா?',
      'login': 'உள்நுழைய',
      'createAccount': 'கணக்கை உருவாக்கு',
      'next': 'அடுத்தது',  // Added corresponding value for 'next'
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Image.asset(
                  'assets/logos/google.png', // Make sure to add Google logo in assets
                  height: 100,
                ),
                SizedBox(height: 20),
                Text(
                  localizedStrings[_selectedLanguage]!['signIn']!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  localizedStrings[_selectedLanguage]!['toContinue']!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: localizedStrings[_selectedLanguage]!['emailOrPhone']!,
                  ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      // Handle forgot email
                    },
                    child: Text(localizedStrings[_selectedLanguage]!['forgotEmail']!),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1877F2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 100.0),
                  ),
                  child: Text(
                    localizedStrings[_selectedLanguage]!['next']!,  // Corrected key to 'next'
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    // Handle create account
                  },
                  child: Text(localizedStrings[_selectedLanguage]!['createAccount']!),
                ),
                SizedBox(height: 20),
                DropdownButton<String>(
                  value: _selectedLanguage,
                  dropdownColor: Colors.white,
                  style: TextStyle(color: Colors.black),
                  icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                  items: <String>['English', 'Sinhala', 'Tamil']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedLanguage = newValue!;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
