import 'package:flutter/material.dart';
import 'package:mini_project/Pages/Sign_Log/LogIn_Page.dart';
import 'package:mini_project/Pages/Sign_Log/SignUp_Page.dart';

import '../CommonParts/AppBar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Audio Book App',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Wellcome To AudiRAB'), // Hide the back button
      body: SingleChildScrollView(
        child: Column(
          children: [
            CurvedBackground(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 20,),
                        const SectionHeading(title: 'popular categories', showActionButton: false),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 80,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: 8,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (_,index) {
                              return const VerticalImageText();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Your additional text goes here'
                  'asugfdgfhwdfjk\n hfjwej ewgih jhwde cnwej'
                  'jdbfhkd shchw dsd hbixhk anxhbsx k \n gcz sbyshjb hcs',
              style: TextStyle(fontSize: 16, color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15,),
            const Center(
              child: Image(
                height: 170,
                width: 200,
                image: AssetImage("assets/images/on_boarding/onboard01.png"),
              ),
            ),
            // Add SignUp and LogIn buttons
            Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const SignUp_Page()),
                      );// Handle SignUp button tap
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green, // Change font color
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Change button padding
                      textStyle: const TextStyle(fontSize: 20), // Change font size
                    ),
                    child: const Text('Sign Up'),
                  ),
                  const SizedBox(width: 10, height: 100,),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const LogIn_Page()),
                      );// Handle LogIn button tap
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue, // Change font color
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Change button padding
                      textStyle: const TextStyle(fontSize: 20), // Change font size
                    ),
                    child: const Text('Log In'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        width: 250,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.grey),
            const SizedBox(width: 20),
            Text(
              'search in store',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ),
    );
  }
}


class CurvedBackground extends StatelessWidget {
  final Widget child;

  const CurvedBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280, // Adjust the height as needed
      decoration: const BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -150,
            right: -250,
            child: CircularContainer(
              backgroundColor: Colors.white70.withOpacity(0.1),
            ),
          ),
          Positioned(
            top: 100,
            right: -300,
            child: CircularContainer(
              backgroundColor: Colors.white70.withOpacity(0.1),
            ),
          ),
          const Positioned(
            top: 200,
            left: 0,
            right: 0,
            bottom: 0,
            child: Center(
              child: Text(
                'Your additional text goes here',
                style: TextStyle(fontSize: 16, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: child,
          ),
        ],
      ),
    );
  }
}

class CircularContainer extends StatelessWidget {
  const CircularContainer({
    Key? key,
    this.child,
    this.width = 400,
    this.height = 400,
    this.radius = 400,
    this.padding = 0,
    this.backgroundColor = Colors.blueAccent,
  }) : super(key: key);

  final double? width;
  final double? height;
  final double radius;
  final double padding;
  final Widget? child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: backgroundColor,
      ),
      child: child,
    );
  }
}

class SectionHeading extends StatelessWidget {
  final String title;
  final bool showActionButton;

  const SectionHeading({
    required this.title,
    this.showActionButton = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white), // Adjusted text color
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (showActionButton)
          TextButton(
            onPressed: () {},
            child: const Text('button title'),
          )
      ],
    );
  }
}

class VerticalImageText extends StatelessWidget {
  const VerticalImageText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: Image.asset(
                  'assets/icons/Home_popular/icon.jfif',
                  fit: BoxFit.cover,
                  color: Colors.black12,
                ),
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: 55,
              child: Text(
                'store uvjdcv bb',
                style: Theme.of(context).textTheme.labelMedium!.apply(color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }
}
