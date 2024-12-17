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
        onBoarding:
            const AssetImage("assets/images/on_boarding/onboard01.webp"),
        title: "We are Your Best Digital Solution",
        description:
            "Step into a world where stories come to life, where every page is an adventure, and every word is a journey!",
      ),
      OnboardingItem(
        onBoarding:
            const AssetImage("assets/images/on_boarding/onboard02.webp"),
        title: "We are Here to Achieve Your Goals",
        description:
            "Discover a vast library of audiobooks from all genres. With AudiRAB, you can listen to your favorite stories anytime, anywhere.",
      ),
      OnboardingItem(
        onBoarding:
            const AssetImage("assets/images/on_boarding/onboard03.webp"),
        title: "Ready to Begin Your Audio Adventure",
        description:
            "Join our community of audiobook enthusiasts and start your journey with AudiRAB today. Your next great listen is just a tap away!",
      ),
    ];

    // PageController to track the current page index
    final PageController pageController = PageController();

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "assets/images/on_boarding/OnBoardingBackground.jpg"), // Background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Foreground content
          Container(
            color: Colors.black
                .withOpacity(0.7), // Overlay to darken the background image
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
                          crossAxisAlignment: CrossAxisAlignment
                              .center, // Align content to the center
                          children: [
                            if (currentIndex <=
                                1) // Show skip button only for the first two pages
                              Align(
                                alignment: Alignment.topRight,
                                child: TextButton(
                                  onPressed: () {
                                    // Handle skip button tap
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (_) => const HomePage()));
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                  ),
                                  child: const Text(
                                    'Skip',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            Expanded(
                              child: Center(
                                child: ClipOval(
                                  child: Image(
                                    image: contents[i].onBoarding,
                                    height: 250,
                                    width: 250,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              contents[i].title,
                              style: const TextStyle(
                                fontSize: 24, // Increased font size
                                fontWeight: FontWeight.bold,
                                color: Colors.white, // Text color for titles
                              ),
                              textAlign:
                                  TextAlign.center, // Align text to the center
                            ),
                            const SizedBox(height: 20),
                            Text(
                              contents[i].description,
                              textAlign:
                                  TextAlign.center, // Align text to the center
                              style: const TextStyle(
                                fontSize: 16,
                                color:
                                    Colors.white, // Text color for descriptions
                              ),
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
                  width: double.infinity,
                  margin: const EdgeInsets.all(40),
                  child: TextButton(
                    onPressed: () {
                      if (currentIndex < contents.length - 1) {
                        // Go to the next page
                        pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease);
                      } else {
                        // Navigate to HomePage
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (_) => const HomePage()));
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Colors.white), // White background
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
        ],
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
        color: index == currentIndex
            ? Colors.white
            : Colors.grey, // Active dot color
      ),
    );
  }
}

class OnboardingItem {
  final ImageProvider onBoarding;
  final String title;
  final String description;

  OnboardingItem({
    required this.onBoarding,
    required this.title,
    required this.description,
  });
}
