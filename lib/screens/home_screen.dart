import 'package:flutter/material.dart';
import 'package:the_reading_room_app/api/user_api.dart';
import 'package:the_reading_room_app/constant/app_color.dart';
import 'package:the_reading_room_app/constant/app_image.dart';
import 'package:the_reading_room_app/constant/app_style.dart';
import 'package:the_reading_room_app/helper/preference.dart';
import 'package:the_reading_room_app/routes/app_routes.dart';

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
                    "Hi, ${userName ?? 'Reader'}!",
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
      // body: Stack(
      //   children: [
      //     Positioned.fill(
      //       child: Image.asset(AppImage.backGroundGradient, fit: BoxFit.cover),
      //     ),
      //     Center(
      //       child: Text(
      //         'Welcome to The Reading Room!',
      //         style: AppStyle.fontMoreSugarRegular(fontSize: 18),
      //       ),
      //     ),
      //   ],
      // ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(AppImage.backGroundGradient, fit: BoxFit.cover),
          ),
          Container(
            color: Colors.white.withOpacity(0.2), // semi-transparent overlay
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: AppColor.blushPink.withOpacity(1.0),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: AppColor.lightGreenish,
                          child: Icon(Icons.person, color: AppColor.black),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome, ${userName ?? 'Reader'}!",
                              style: AppStyle.fontMoreSugarRegular(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Explore your digital library",
                              style: AppStyle.fontMoreSugarRegular(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Features',
                  style: AppStyle.fontMoreSugarRegular(
                    fontSize: 18,
                    color: AppColor.black,
                  ),
                ),
                const SizedBox(height: 12),
                GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.2,
                  children: [
                    _buildFeatureCard(
                      context,
                      Icons.menu_book,
                      'Book List',
                      AppRoutes.bookList,
                    ),
                    _buildFeatureCard(
                      context,
                      Icons.book_outlined,
                      'Borrow Book',
                      AppRoutes.borrowBook,
                    ),
                    _buildFeatureCard(
                      context,
                      Icons.history,
                      'Borrow History',
                      AppRoutes.bookHistory,
                    ),
                    _buildFeatureCard(
                      context,
                      Icons.add_box,
                      'Add Book',
                      AppRoutes.addBook,
                    ),
                    _buildFeatureCard(
                      context,
                      Icons.delete,
                      'Delete Book',
                      AppRoutes.deleteBook,
                    ),
                    _buildFeatureCard(
                      context,
                      Icons.person,
                      'Profile',
                      AppRoutes.profile,
                    ),
                  ],
                ),
              ],
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

  Widget _buildFeatureCard(
    BuildContext context,
    IconData icon,
    String label,
    String route,
  ) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.lightGreenish.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColor.mossGreen, width: 1),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: AppColor.mossGreen),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppStyle.fontMoreSugarRegular(
                fontSize: 14,
                color: AppColor.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
