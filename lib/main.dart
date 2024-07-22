import 'package:flutter/material.dart';
import 'package:mini_project/Pages/Home/New_Story.dart';
import 'CommonParts/Onboarding.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: 'AIzaSyC_qwLZRELDGbTHv4apWfqEFgB42vzVTp8',
        appId: '1:337764060105:android:e32d952555ff9bff583618',
        messagingSenderId: '337764060105',
        projectId: 'audirab-44b07'
    ),
  );
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Onboarding(),
    );
  }
}
