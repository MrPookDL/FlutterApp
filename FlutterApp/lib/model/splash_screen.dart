import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:projet_final/model/widget_tree.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff1f005c),
              Color(0xff5b0060),
              Color.fromARGB(255, 222, 196, 214),
            ],
          ),
        ),
        child: AnimatedSplashScreen(
          splash: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.safety_check,
                size: 80,
                color: Colors.white,
              ),
              SizedBox(height: 20),
              Text(
                'ClassHub',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                  fontSize: 32,
                ),
              ),
            ],
          ),
          splashIconSize: double.infinity,
          duration: 2000,
          splashTransition: SplashTransition.scaleTransition,
          nextScreen: const WidgetTree(),
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}
