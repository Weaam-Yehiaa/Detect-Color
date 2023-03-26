import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

import 'my_home_page.dart';

class MySplashScreen extends StatelessWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      backgroundColor: Colors.lightBlue,
      loadingText: const Text(
        'Loading...',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
      title: const Text(
        'Color Detection',
        style: TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
      seconds: 4,
        navigateAfterSeconds: const MyHomePage(),
    );
  }
}
