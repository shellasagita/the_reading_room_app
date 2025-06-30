import 'package:flutter/material.dart';
import 'package:the_reading_room_app/api/user_api.dart';
import 'package:the_reading_room_app/constant/app_color.dart';
import 'package:the_reading_room_app/constant/app_image.dart';
import 'package:the_reading_room_app/constant/app_style.dart';
import 'package:the_reading_room_app/model/register_error_response';
import 'package:the_reading_room_app/screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static const String id = "/register_screen";

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String? _errorMessage;
  String? _emailApiError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    setState(() {
      _errorMessage = null;
      _emailApiError = null;
    });

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await UserService().registerUser(
          email: _emailController.text.trim(),
          name: _nameController.text.trim(),
          password: _passwordController.text,
        );

        if (response.containsKey('message') &&
            response['message'] == 'User registered successfully!') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration successful! Please login.'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        } else if (response.containsKey('message') &&
            response.containsKey('errors')) {
          final errorResponse = RegisterErrorResponse.fromJson(response);
          if (errorResponse.errors?.email != null &&
              errorResponse.errors!.email!.isNotEmpty) {
            setState(() {
              _emailApiError = errorResponse.errors!.email!.first;
            });
          }
          setState(() {
            _errorMessage =
                errorResponse.message ??
                'Registration failed due to validation issues.';
          });
        } else {
          setState(() {
            _errorMessage =
                response['message'] ??
                'An unknown error occurred during registration.';
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Failed to connect to the server: \$e';
          print('Registration error: \$e');
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: \$_errorMessage'),
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
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColor.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset(
              AppImage.backGroundSky,
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      "Let's, Register!",
                      textAlign: TextAlign.center,
                      style: AppStyle.fontMoreSugarExtra(
                        fontSize: 32,
                      ).copyWith(color: AppColor.black),
                    ),
                    const SizedBox(height: 50),
                    _buildTextField(_nameController, 'Enter your name', Icons.person, false),
                    const SizedBox(height: 20),
                    _buildTextField(_emailController, 'Enter your email', Icons.email, false, isEmail: true, errorText: _emailApiError),
                    const SizedBox(height: 20),
                    _buildTextField(_passwordController, 'Enter your password', Icons.lock, !_isPasswordVisible, isPassword: true, toggleVisibility: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    }),
                    const SizedBox(height: 20),
                    _buildTextField(_confirmPasswordController, 'Confirm your password', Icons.lock, !_isConfirmPasswordVisible, isPassword: true, toggleVisibility: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    }, isConfirm: true),
                    const SizedBox(height: 40),
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Text(
                          _errorMessage!,
                          style: AppStyle.fontMoreSugarRegular(
                            fontSize: 14,
                          ).copyWith(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _registerUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.mossGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 4,
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                                'Register',
                                style: AppStyle.fontMoreSugarExtra(
                                  fontSize: 18,
                                ).copyWith(color: Colors.white),
                              ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: AppStyle.fontMoreSugarRegular(fontSize: 16).copyWith(color: AppColor.black),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Text(
                            'Sign in',
                            style: AppStyle.fontMoreSugarExtra(fontSize: 14).copyWith(color: AppColor.softBlueGray),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    IconData icon,
    bool obscure, {
    bool isEmail = false,
    bool isPassword = false,
    bool isConfirm = false,
    String? errorText,
    VoidCallback? toggleVisibility,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      obscureText: isPassword ? obscure : false,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppStyle.fontMoreSugarRegular(fontSize: 16).copyWith(color: Colors.grey[600]),
        prefixIcon: Icon(icon, color: AppColor.softBlueGray),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscure ? Icons.visibility_off : Icons.visibility,
                  color: AppColor.softBlueGray,
                ),
                onPressed: toggleVisibility,
              )
            : null,
        filled: true,
        fillColor: AppColor.cream,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        errorText: errorText,
      ),
      style: AppStyle.fontMoreSugarRegular(fontSize: 16).copyWith(color: AppColor.black),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please fill this field';
        }
        if (isEmail && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Please enter a valid email';
        }
        if (isPassword && value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        if (isConfirm && value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }
}
