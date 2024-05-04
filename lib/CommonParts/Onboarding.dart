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
        title: "Welcome",
        description: "sdflkndljbdfbxm,cn,bd  bkjd zncbaskcb"
            "sbsmcnb,bc bk nsckhn nnc kn ndsc kn c",
      ),
      OnboardingItem(
        onBoarding: const AssetImage("assets/images/on_boarding/onboard02.jfif"),
        title: "Second Page",
        description: "Description of second page",
      ),
      OnboardingItem(
        onBoarding: const AssetImage("assets/images/on_boarding/onboard03.jfif"),
        title: "Final Page",
        description: "Description of final page",
      ),
    ];

    // PageController to track the current page index
    final PageController pageController = PageController();

    return Scaffold(
      body: Column(
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
                          child: GestureDetector(
                            onTap: () {
                              // Handle skip button tap
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white38,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white70, width: 0),
                              ),
                              child: const Text(
                                'Skip',
                                style: TextStyle(color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      Image(
                        image: contents[i].onBoarding,
                        height: 180,
                      ),
                      Text(
                        contents[i].title,
                        style: const TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        contents[i].description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
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
                backgroundColor: MaterialStateProperty.all(Colors.purpleAccent),
              ),
              child: Text(
                currentIndex == contents.length - 1 ? "Finish" : "Next",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          )
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
        color: index == currentIndex ? Colors.purpleAccent : Colors.grey, // Active dot color
      ),
    );
  }
}

class OnboardingItem {
  final ImageProvider onBoarding;
  final String title;
  final String description;
  final ImageProvider? additionalImage;

  OnboardingItem({
    required this.onBoarding,
    required this.title,
    required this.description,
    this.additionalImage,
  });
}
