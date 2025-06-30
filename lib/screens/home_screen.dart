import 'package:flutter/material.dart';
import 'package:the_reading_room_app/constant/app_color.dart';
import 'package:the_reading_room_app/constant/app_image.dart';
import 'package:the_reading_room_app/constant/app_style.dart';
import 'package:the_reading_room_app/helper/preference.dart';
import 'package:the_reading_room_app/routes/app_routes.dart';
import 'package:the_reading_room_app/api/user_api.dart';
import 'package:the_reading_room_app/model/login_response.dart';

class HomeScreen extends StatefulWidget {
  static const String id = AppRoutes.home;

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userName;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final token = await PreferenceHandler.getToken();
      if (token != null) {
        final profile = await UserService().getProfile();
        setState(() {
          userName = profile['data']['name'];
        });
      }
    } catch (e) {
      debugPrint("Failed to load profile: \$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.cream,
      appBar: AppBar(
        backgroundColor: AppColor.softBlueGray,
        centerTitle: true,
        title: Text(
          'The Reading Room',
          style: AppStyle.fontMoreSugarRegular(
            fontSize: 22,
            color: Colors.white,
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: AppColor.creamyBeige,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/backgroundwithoutflower.png',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColor.lightGreenish,
                    child: Icon(Icons.person, color: AppColor.black),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Hi, ${userName ?? 'User'}!",
                    style: AppStyle.fontMoreSugarRegular(
                      fontSize: 18,
                      color: AppColor.black,
                    ),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(
              context,
              Icons.person,
              'Profile',
              AppRoutes.profile,
            ),
            _buildDrawerItem(
              context,
              Icons.menu_book,
              'Book List',
              AppRoutes.bookList,
            ),
            _buildDrawerItem(
              context,
              Icons.book_outlined,
              'Borrow Book',
              AppRoutes.borrowBook,
            ),
            // _buildDrawerItem(
            //   context,
            //   Icons.assignment_return,
            //   'Return Book',
            //   AppRoutes.returnBook,
            // ),
            _buildDrawerItem(
              context,
              Icons.history,
              'Borrow History',
              AppRoutes.bookHistory,
            ),
            _buildDrawerItem(
              context,
              Icons.add_box,
              'Add Book',
              AppRoutes.addBook,
            ),
            _buildDrawerItem(
              context,
              Icons.delete,
              'Delete Book',
              AppRoutes.deleteBook,
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(AppImage.backGroundGradient, fit: BoxFit.cover),
          ),
          Center(
            child: Text(
              'Welcome to The Reading Room!',
              style: AppStyle.fontMoreSugarRegular(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  ListTile _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String label,
    String route,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppColor.mossGreen),
      title: Text(label, style: AppStyle.fontMoreSugarRegular(fontSize: 16)),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, route);
      },
    );
  }
}
