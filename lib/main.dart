import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:planner_app/firebase_options.dart';
import 'package:planner_app/pages/login.dart';
import 'package:planner_app/pages/home.dart';

Future<void> main() async {
 WidgetsFlutterBinding.ensureInitialized();
//    const FirebaseOptions firebaseOptions = FirebaseOptions(
//     apiKey: 'AIzaSyCm9mlOdUNogO2yxzC2h3MTDIQ23sqlbng',
//     appId: '1:397613401767:web:6b500e3f2ef58ac9d7fd82',
//     messagingSenderId: '397613401767',
//     projectId: 'flutter-midterm-practice',
//     authDomain: 'flutter-midterm-practice.firebaseapp.com',
//     storageBucket: 'flutter-midterm-practice.appspot.com',
//     measurementId: 'G-3R7P44Y7FP',
//  );
//  await Firebase.initializeApp(options: firebaseOptions);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, 
  );
 runApp(const MyApp());
}
class MyApp extends StatelessWidget {
 const MyApp({super.key});
 // This widget is the root of your application.
 @override
 Widget build(BuildContext context) {
   return MaterialApp(
     title: 'Planner App',
     theme:ThemeData.dark(),
     home: const HomePage(),
     debugShowCheckedModeBanner: false,
   );
 }
}
