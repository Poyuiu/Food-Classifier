import 'package:flutter/material.dart';
import 'package:food_classifier/my_home_page.dart';
import 'package:splashscreen/splashscreen.dart';

class MySplashScreen extends StatelessWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      backgroundColor: Colors.lightBlue,
      loadingText: const Text(
        'Hungry...',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      title: const Text(
        'Food Classifier',
        style: TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
      seconds: 2,
      navigateAfterSeconds: const MyHomePage(),
    );
  }
}
