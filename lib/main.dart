import 'package:flutter/material.dart';
import 'Pages/Home_Page.dart'; // Assuming Home_Page.dart contains HomePage widget

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingPage(),
    );
  }
}

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int _currentPageIndex = 0;

  final List<String> _imagePaths = [
    "assets/images/on_boarding/onboard01.jpg",
    "assets/images/on_boarding/onboard02.png",
    "assets/images/on_boarding/onboard03.jpg",
  ];

  void _nextPage() {
    setState(() {
      if (_currentPageIndex < _imagePaths.length - 1) {
        _currentPageIndex++;
      }
    });
  }

  void _previousPage() {
    setState(() {
      if (_currentPageIndex > 0) {
        _currentPageIndex--;
      }
    });
  }

  void _finishOnboarding() {
    // Navigate to the next page or perform any action when onboarding is completed
    // For example, you can use Navigator.pushReplacement() to navigate to a new page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()), // Corrected from Home() to HomePage()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black12,
        title: const Text("Wellcome to AudiRAB",
          style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 20),
        ),
        actions: [
          TextButton(
            onPressed: _finishOnboarding,
            child: const Text(
              "Skip",
              style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 15),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: PageView.builder(
              itemCount: _imagePaths.length,
              itemBuilder: (context, index) {
                return Image.asset(
                  _imagePaths[index],
                  fit: BoxFit.cover,
                );
              },
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
              controller: PageController(
                initialPage: _currentPageIndex,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_currentPageIndex > 0)
                ElevatedButton(
                  onPressed: _previousPage,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                  ),
                  child: const Text(
                    "Previous",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              const SizedBox(width: 20.0),
              ElevatedButton(
                onPressed: _currentPageIndex < _imagePaths.length - 1
                    ? _nextPage
                    : _finishOnboarding,
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                ),
                child: Text(
                  _currentPageIndex < _imagePaths.length - 1
                      ? "Next"
                      : "Finish",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}



