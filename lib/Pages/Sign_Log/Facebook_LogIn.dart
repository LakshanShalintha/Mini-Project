import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FacebookLoginPage(),
    );
  }
}

class FacebookLoginPage extends StatefulWidget {
  @override
  _FacebookLoginPageState createState() => _FacebookLoginPageState();
}

class _FacebookLoginPageState extends State<FacebookLoginPage> {
  String _selectedLanguage = 'English';

  Map<String, Map<String, String>> _localizedValues = {
    'English': {
      'login': 'Log in',
      'forgot_password': 'Forgot password?',
      'create_account': 'Create new account',
      'meta': 'Meta',
      'mobile_or_email': 'Mobile number or email',
      'password': 'Password',
    },
    'Sinhala': {
      'login': 'ඇතුල් වන්න',
      'forgot_password': 'මුරපදය අමතක වුණාද?',
      'create_account': 'නව ගිණුමක් තනන්න',
      'meta': 'මෙටා',
      'mobile_or_email': 'ජංගම දුරකථන අංකය හෝ විද්‍යුත් තැපෑල',
      'password': 'මුරපදය',
    },
    'Tamil': {
      'login': 'உள் நுழை',
      'forgot_password': 'கடவுச்சொல்லை மறந்துவிட்டீர்களா?',
      'create_account': 'புதிய கணக்கை உருவாக்கவும்',
      'meta': 'மெட்டா',
      'mobile_or_email': 'மொபைல் எண் அல்லது மின்னஞ்சல்',
      'password': 'கடவுச்சொல்',
    },

  };

  @override
  Widget build(BuildContext context) {
    var localizedTexts = _localizedValues[_selectedLanguage];

    return Scaffold(
      resizeToAvoidBottomInset: true, // Ensure the Scaffold resizes when the keyboard appears
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height, // Set container height to screen height
        padding: EdgeInsets.symmetric(horizontal: 32.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView( // Add SingleChildScrollView
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40.0),
              DropdownButton<String>(
                value: _selectedLanguage,
                dropdownColor: Colors.white,
                style: TextStyle(color: Colors.white),
                icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                items: <String>['English', 'Sinhala', 'Tamil']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(color: Colors.black)),
                  );
                }).toList(),
                onChanged: (String? newValue) { // Update the callback to accept nullable String
                  setState(() {
                    _selectedLanguage = newValue!;
                  });
                },
              ),
              SizedBox(height: 20.0), // Add some spacing here
              Icon(
                Icons.facebook,
                size: 100.0,
                color: Colors.white,
              ),
              SizedBox(height: 40.0),
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: localizedTexts!['mobile_or_email'],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: localizedTexts['password'],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
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
                  localizedTexts['login']!,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextButton(
                onPressed: () {},
                child: Text(
                  localizedTexts['forgot_password']!,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 60.0), // Add some spacing here
              Divider(color: Colors.white54),
              TextButton(
                onPressed: () {},
                child: Text(
                  localizedTexts['create_account']!,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                localizedTexts['meta']!,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
