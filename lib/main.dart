import 'package:flutter/material.dart';
import 'package:the_reading_room_app/routes/app_routes.dart';
import 'package:the_reading_room_app/screens/intro_screen.dart';
import 'package:the_reading_room_app/screens/login_screen.dart';
import 'package:the_reading_room_app/screens/register_screen.dart';
import 'package:the_reading_room_app/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Reading Room',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: SplashScreen(),
      // initialRoute: AppRoutes.splash,
      routes: {
        // AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.intro: (context) => const IntroScreenGetStarted(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.register: (context) => const RegisterScreen(),
        //   //  AppRoutes.homepage: (context) => const HomeScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
