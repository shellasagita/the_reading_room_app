import 'package:flutter/material.dart';
import 'package:the_reading_room_app/routes/app_routes.dart';

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
      initialRoute: AppRoutes.splash,
      routes: {
        // AppRoutes.splash: (context) => const SplashPage(),
        // //   AppRoutes.login: (context) => const LoginPage(),
        // //   AppRoutes.register: (context) => const RegisterPage(),
        // //   AppRoutes.homepage: (context) => const HomePage(),
        // home: (title: 'Flutter Demo Home Page'),
      },
    );
  }
}
