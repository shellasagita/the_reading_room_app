import 'package:flutter/material.dart';
import 'package:the_reading_room_app/api/user_api.dart';
import 'package:the_reading_room_app/constant/app_color.dart';
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
  String? _errorMessage; // General error message
  String? _emailApiError; // Specific error from API for email

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Function to handle user registration
  Future<void> _registerUser() async {
    // Clear previous errors
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

        // Check the response structure to determine success or error
        if (response.containsKey('message') &&
            response['message'] == 'User registered successfully!') {
          // Assuming 'User registered successfully!' is the success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration successful! Please login.'),
              backgroundColor: Colors.green,
            ),
          );
          // Navigate to LoginScreen on successful registration
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        } else if (response.containsKey('message') &&
            response.containsKey('errors')) {
          // Handle validation errors from the API (status code 422 usually)
          final errorResponse = RegisterErrorResponse.fromJson(response);
          if (errorResponse.errors?.email != null &&
              errorResponse.errors!.email!.isNotEmpty) {
            setState(() {
              _emailApiError =
                  errorResponse
                      .errors!
                      .email!
                      .first; // Display the first email error
            });
          }
          setState(() {
            _errorMessage =
                errorResponse.message ??
                'Registration failed due to validation issues.';
          });
        } else {
          // Handle other potential error structures or unknown errors
          setState(() {
            _errorMessage =
                response['message'] ??
                'An unknown error occurred during registration.';
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Failed to connect to the server: $e';
          print('Registration error: $e'); // Print detailed error to console
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $_errorMessage'),
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColor.black),
          onPressed: () {
            Navigator.of(
              context,
            ).pop(); // Go back to the previous screen (LoginScreen)
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
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

                // Name Text Field
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter your name',
                    hintStyle: AppStyle.fontMoreSugarRegular(
                      fontSize: 16,
                    ).copyWith(color: Colors.grey[600]),
                    prefixIcon: Icon(
                      Icons.person,
                      color: AppColor.softBlueGray,
                    ),
                    filled: true,
                    fillColor: AppColor.cream,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 20.0,
                    ),
                  ),
                  style: AppStyle.fontMoreSugarRegular(
                    fontSize: 16,
                  ).copyWith(color: AppColor.black),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Email Text Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    hintStyle: AppStyle.fontMoreSugarRegular(
                      fontSize: 16,
                    ).copyWith(color: Colors.grey[600]),
                    prefixIcon: Icon(Icons.email, color: AppColor.softBlueGray),
                    filled: true,
                    fillColor: AppColor.cream,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 20.0,
                    ),
                    // Display API email error if present
                    errorText: _emailApiError,
                  ),
                  style: AppStyle.fontMoreSugarRegular(
                    fontSize: 16,
                  ).copyWith(color: AppColor.black),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Password Text Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    hintStyle: AppStyle.fontMoreSugarRegular(
                      fontSize: 16,
                    ).copyWith(color: Colors.grey[600]),
                    prefixIcon: Icon(Icons.lock, color: AppColor.softBlueGray),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
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
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 20.0,
                    ),
                  ),
                  style: AppStyle.fontMoreSugarRegular(
                    fontSize: 16,
                  ).copyWith(color: AppColor.black),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Confirm Password Text Field
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  decoration: InputDecoration(
                    hintText: 'Confirm your password',
                    hintStyle: AppStyle.fontMoreSugarRegular(
                      fontSize: 16,
                    ).copyWith(color: Colors.grey[600]),
                    prefixIcon: Icon(Icons.lock, color: AppColor.softBlueGray),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColor.softBlueGray,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: AppColor.cream,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 20.0,
                    ),
                  ),
                  style: AppStyle.fontMoreSugarRegular(
                    fontSize: 16,
                  ).copyWith(color: AppColor.black),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),

                // Display general error message if present
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

                // Register Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed:
                        _isLoading
                            ? null
                            : _registerUser, // Disable button while loading
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.mossGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 4,
                    ),
                    child:
                        _isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : Text(
                              'Register',
                              style: AppStyle.fontMoreSugarExtra(
                                fontSize: 18,
                              ).copyWith(color: Colors.white),
                            ),
                  ),
                ),
                const SizedBox(height: 30),

                // "Already have an account? Sign in" text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: AppStyle.fontMoreSugarRegular(
                        fontSize: 16,
                      ).copyWith(color: AppColor.black),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Pop to go back to LoginScreen
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Sign in',
                        style: AppStyle.fontMoreSugarExtra(
                          fontSize: 14,
                        ).copyWith(color: AppColor.softBlueGray),
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
    );
  }
}
