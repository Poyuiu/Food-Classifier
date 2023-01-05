import 'package:flutter/material.dart';
import 'package:food_classifier/my_splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Team18 Final',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MySplashScreen(),
    );
  }
}
