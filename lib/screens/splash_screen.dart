import 'package:flutter/material.dart';
import 'package:the_reading_room_app/constant/app_color.dart';
import 'package:the_reading_room_app/constant/app_image.dart';
import 'package:the_reading_room_app/constant/app_style.dart';
import 'package:the_reading_room_app/helper/preference.dart';
import 'package:the_reading_room_app/screens/intro_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void changePage() {
    Future.delayed(Duration(seconds: 5), () async {
      bool isLogin = await PreferenceHandler.getLogin();
      print("isLogin: $isLogin");
      // if (isLogin) {
      //   return Navigator.pushNamedAndRemoveUntil(
      //     context,
      //     MeetDuaBelasB.id,
      //     (route) => false,
      //   );
      // } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => IntroScreenGetStarted()),
      );
      // }
    });
  }

  @override
  void initState() {
    changePage();
    super.initState();
  }

  Container buildBackground() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImage.backGroundSunset),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Stack(children: [buildBackground(), buildLayer()]));
  }

  Widget buildLayer() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          // SizedBox(height: 20),
          Container(
             decoration: BoxDecoration(
              color: AppColor.cream,
              borderRadius: BorderRadius.circular(900.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // Subtle shadow color
                  spreadRadius: 9, // How far the shadow spreads
                  blurRadius: 7, // How blurry the shadow is
                  offset: const Offset(0, 9), // Changes position of shadow
                ),
              ],
            ),
            child: Text(
              "The Reading Room",
              style: AppStyle.fontMoreSugarRegular(
                fontSize: 32,
                color: AppColor.black,
              ),
            ),
          ),
          SizedBox(height: 30),
          Container(
            // color: AppColor.cream,
            decoration: BoxDecoration(
              color: AppColor.cream,
              borderRadius: BorderRadius.circular(400.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.9), // Subtle shadow color
                  spreadRadius: 2, // How far the shadow spreads
                  blurRadius: 7, // How blurry the shadow is
                  offset: const Offset(0, 3), // Changes position of shadow
                ),
              ],
            ),
            child: Image.asset(AppImage.logoFront, height: 200),
          ),

          Spacer(),
          SafeArea(
            child: Container(
              color: AppColor.cream,
              child: Text("v 1.0.0", style: AppStyle.fontMoreSugarThin()),
            ),
          ),
        ],
      ),
    );
  }
}
