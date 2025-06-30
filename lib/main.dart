import 'package:flutter/material.dart';
import 'package:the_reading_room_app/routes/app_routes.dart';
import 'package:the_reading_room_app/screens/add_book_screen.dart';
import 'package:the_reading_room_app/screens/book_history_screen.dart';
import 'package:the_reading_room_app/screens/book_list_screen.dart';
import 'package:the_reading_room_app/screens/borrow_book_screen.dart';
import 'package:the_reading_room_app/screens/delete_book_screen.dart';
import 'package:the_reading_room_app/screens/home_screen.dart';
import 'package:the_reading_room_app/screens/intro_screen.dart';
import 'package:the_reading_room_app/screens/login_screen.dart';
import 'package:the_reading_room_app/screens/profile_screen.dart';
import 'package:the_reading_room_app/screens/register_screen.dart';
import 'package:the_reading_room_app/screens/return_book_screen.dart';
import 'package:the_reading_room_app/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Reading Room',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: SplashScreen(),
      // // initialRoute: AppRoutes.splash,
      routes: {
        // AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.intro: (context) => const IntroScreenGetStarted(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.register: (context) => const RegisterScreen(),
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.profile: (context) => const ProfileScreen(),
        AppRoutes.bookList: (context) => const BookListScreen(),
        AppRoutes.borrowBook: (context) => const BorrowBookScreen(),
        // AppRoutes.returnBook: (context) => const ReturnBookScreen(bookId: book.id!),
        AppRoutes.bookHistory: (context) => const BookHistoryScreen(),
        AppRoutes.addBook: (context) => const AddBookScreen(),
        AppRoutes.deleteBook: (context) => const DeleteBookScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
