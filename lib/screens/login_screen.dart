import 'package:flutter/material.dart';
import 'package:the_reading_room_app/api/user_api.dart';
import 'package:the_reading_room_app/constant/app_color.dart';
import 'package:the_reading_room_app/constant/app_image.dart';
import 'package:the_reading_room_app/constant/app_style.dart';
import 'package:the_reading_room_app/helper/preference.dart';
import 'package:the_reading_room_app/model/login_response.dart';
import 'package:the_reading_room_app/screens/home_screen.dart';
import 'package:the_reading_room_app/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String id = "login_screen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final loginResponse = await UserService().loginUser(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        await PreferenceHandler.saveToken(loginResponse.data.token);
        await PreferenceHandler.saveLogin(true);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login successful!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.cream,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AppImage.backGroundWithFlower,
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 80),
                    Text(
                      "Let's, Begin!",
                      textAlign: TextAlign.center,
                      style: AppStyle.fontMoreSugarExtra(
                        fontSize: 32,
                      ).copyWith(color: AppColor.black),
                    ),
                    const SizedBox(height: 60),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Enter your email',
                        hintStyle: AppStyle.fontMoreSugarRegular(fontSize: 16)
                            .copyWith(color: Colors.grey[600]),
                        prefixIcon: Icon(Icons.email, color: AppColor.softBlueGray),
                        filled: true,
                        fillColor: AppColor.cream,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                      ),
                      style: AppStyle.fontMoreSugarRegular(fontSize: 16)
                          .copyWith(color: AppColor.black),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Password
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        hintStyle: AppStyle.fontMoreSugarRegular(fontSize: 16)
                            .copyWith(color: Colors.grey[600]),
                        prefixIcon: Icon(Icons.lock, color: AppColor.softBlueGray),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: AppColor.softBlueGray,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: AppColor.cream,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                      ),
                      style: AppStyle.fontMoreSugarRegular(fontSize: 16)
                          .copyWith(color: AppColor.black),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),

                    Center(
                      child: SizedBox(
                        width: 80,
                        height: 80,
                        child: FloatingActionButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          backgroundColor: AppColor.mossGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          elevation: 5,
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Icon(Icons.arrow_forward_ios, color: AppColor.cream, size: 30),
                        ),
                      ),
                    ),

                    const SizedBox(height: 80),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: AppStyle.fontMoreSugarRegular(fontSize: 16)
                              .copyWith(color: AppColor.black),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => const RegisterScreen()),
                            );
                          },
                          child: Text(
                            'Sign up',
                            style: AppStyle.fontMoreSugarExtra(fontSize: 14)
                                .copyWith(color: AppColor.softBlueGray),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
