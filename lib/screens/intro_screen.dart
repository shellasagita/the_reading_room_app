import 'package:flutter/material.dart';
import 'package:the_reading_room_app/constant/app_color.dart';
import 'package:the_reading_room_app/constant/app_image.dart';
import 'package:the_reading_room_app/constant/app_style.dart';
import 'package:the_reading_room_app/routes/app_routes.dart';
import 'package:the_reading_room_app/screens/login_screen.dart';

class IntroScreenGetStarted extends StatefulWidget {
  const IntroScreenGetStarted({super.key});

  @override
  State<IntroScreenGetStarted> createState() => _IntroScreenGetStartedState();
}

class _IntroScreenGetStartedState extends State<IntroScreenGetStarted> {
  Container buildBackground() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImage.backGround),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget buildLayer() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            // Image.asset(AppImage.logoSplash, height: 120),
            SizedBox(height: 20),
            Text(
              'The Reading Room',
              style: AppStyle.fontMoreSugarRegular(fontSize: 32),
            ),
            SizedBox(height: 80),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.login,
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 4,
                ),
                child: Text(
                  'Get Started',
                  style: AppStyle.fontMoreSugarRegular(
                    fontSize: 24,
                    color: AppColor.sageGreen,
                  ),
                  selectionColor: AppColor.cream,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Stack(children: [buildBackground(), buildLayer()]));
  }
}
