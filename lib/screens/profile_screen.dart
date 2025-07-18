import 'package:flutter/material.dart';
import 'package:the_reading_room_app/constant/app_color.dart';
import 'package:the_reading_room_app/constant/app_style.dart';
import 'package:the_reading_room_app/helper/preference.dart';
import 'package:the_reading_room_app/routes/app_routes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  static const String id = AppRoutes.profile;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? userName;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final name = await PreferenceHandler.getName();
    final email = await PreferenceHandler.getEmail();
    setState(() {
      userName = name ?? "Unknown User";
      userEmail = email ?? "unknown@example.com";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.cream,
      appBar: AppBar(
        backgroundColor: AppColor.softBlueGray,
        title: Text(
          'Profile',
          style: AppStyle.fontMoreSugarExtra(fontSize: 22, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: AppColor.lightGreenish,
                child: Icon(Icons.person, size: 50, color: AppColor.black),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                userName ?? "",
                style: AppStyle.fontMoreSugarExtra(fontSize: 24),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                userEmail ?? "",
                style: AppStyle.fontMoreSugarRegular(fontSize: 16, color: Colors.grey[700]),
              ),
            ),
            const SizedBox(height: 40),
            Divider(color: AppColor.sageGreenAlt),
            const SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text(
                'Logout',
                style: AppStyle.fontMoreSugarRegular(fontSize: 16),
              ),
              onTap: () async {
                await PreferenceHandler.deleteAll();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
