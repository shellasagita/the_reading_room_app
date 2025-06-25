import 'package:flutter/material.dart';
import 'package:the_reading_room_app/helper/preference.dart';
import 'package:the_reading_room_app/routes/app_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  void changePage() {
    Future.delayed(Duration(seconds: 3), () async {
      bool isLogin = await PreferenceHandler.getLogin();
      print("isLogin: $isLogin");
      // if (isLogin) {
      //   return Navigator.pushNamedAndRemoveUntil(
      //     context,
      //     MeetDuaBelasB.id,
      //     (route) => false,
      //   );
      // } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.intro,
        (route) => false,
      );
      // }
    });
  }

  @override
  void initState() {
    changePage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Image.asset('name'),
            SizedBox(height: 20),
            Text("The Reading Room", style: TextStyle(fontSize: 18)),
            Spacer(),
            SafeArea(child: Text("v 1.0.0", style: TextStyle(fontSize: 18))),
          ],
        ),
      ),
    );
  }
}
