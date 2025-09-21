import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:res_q/screens/home_screen.dart';
import 'package:res_q/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ResQ App',
      debugShowCheckedModeBanner: false,
      home: SplashToAuth(),
    );
  }
}

class SplashToAuth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Container(
        width: double.infinity,
        height: double.infinity,
        child: Image.asset(
          'assets/2.jpg',
          fit: BoxFit.cover, // 👈 Makes the splash full screen!
        ),
      ),
      duration: 2500,
      splashIconSize: double.infinity,
      backgroundColor: Colors.white,
      splashTransition: SplashTransition.fadeTransition, // smoother than scaleTransition
      pageTransitionType: PageTransitionType.bottomToTop,
      nextScreen: AuthCheck(),
    );
  }
}

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          return HomeScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}

