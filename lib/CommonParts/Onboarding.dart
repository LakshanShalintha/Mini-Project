import 'package:flutter/material.dart';
import '../Pages/Home_Page.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Initialize contents with a list of onboarding items
    List<OnboardingItem> contents = [
      OnboardingItem(
        onBoarding: const AssetImage("assets/images/on_boarding/onboard01.png"),
        // title: "",
        description: "Your Gateway to the World of Audiobooks\n"
            "Step into a world where stories come to life, where every page is an adventure,\n"
            "and every word is a journey!",
      ),
      OnboardingItem(
        onBoarding: const AssetImage("assets/images/on_boarding/onboard02.jfif"),
        // title: "",
        description: "Discover a vast library of audiobooks from all genres.\n"
            "With Audirab, you can listen to your favorite stories anytime, anywhere.\n"
            "With Audirab, you have the power to transform mundane moments into extraordinary adventures.",
      ),
      OnboardingItem(
        onBoarding: const AssetImage("assets/images/on_boarding/onboard03.jfif"),
        // title: "",
        description: "Ready to Begin Your Audio Adventure?\n"
            "Start your audio journey with Audirab now!\n"
            "Receive recommendations based on your preferences, and never miss out on the latest releases. Join our community of audiobook enthusiasts and start your journey with Audirab today. Your next great listen is just a tap away!",
      ),
    ];

    // PageController to track the current page index
    final PageController pageController = PageController();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFD7CACA),
              Color(0xFF050000),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                itemCount: contents.length,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (_, i) {
                  return Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        if (currentIndex <= 1) // Show skip button only for the first two pages
                          Align(
                            alignment: Alignment.topRight,
                            child: TextButton(
                              onPressed: () {
                                // Handle skip button tap
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: -10, vertical: -2), // Adjust the horizontal and vertical padding to control the button size
                                backgroundColor: Colors.white10, // Slightly transparent background for the skip button
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              child: const Text(
                                'Skip',
                                style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),

                        Expanded(
                          child: Center(
                            child: Image(
                              image: contents[i].onBoarding,
                              height: 180,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        /*Text(
                          contents[i].title,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Text color for titles
                          ),
                        ),*/
                        const SizedBox(height: 20),
                        Text(
                          contents[i].description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white, // Text color for descriptions
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (i == currentIndex && contents[i].additionalImage != null) // Show additional image only for the current page
                          Image(
                            image: contents[i].additionalImage!,
                            height: 100,
                          ),
                      ],
                    ),
                  );
                },
                controller: pageController,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                contents.length,
                    (index) => buildDot(index),
              ),
            ),
            Container(
              height: 60,
              margin: const EdgeInsets.all(40),
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  if (currentIndex < contents.length - 1) {
                    // Go to the next page
                    pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.ease);
                  } else {
                    // Navigate to HomePage
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                ),
                child: Text(
                  currentIndex == contents.length - 1 ? "Finish" : "Next",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildDot(int index) {
    return Container(
      height: 10,
      width: 10,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: index == currentIndex ?
        Color(0xFFE3D512) :
        Colors.white, // Active dot color
      ),
    );
  }
}

class OnboardingItem {
  final ImageProvider onBoarding;
  // final String title;
  final String description;
  final ImageProvider? additionalImage;

  OnboardingItem({
    required this.onBoarding,
    // required this.title,
    required this.description,
    this.additionalImage,
  });
}