import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:the_reading_room_app/constant/app_color.dart';
import 'package:the_reading_room_app/constant/app_style.dart';
import 'package:the_reading_room_app/endpoint.dart';
import 'package:the_reading_room_app/helper/preference.dart';

class AddBookScreen extends StatefulWidget {
  static const String id = "/add_book";
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _submitBook() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final token = await PreferenceHandler.getToken();

    final response = await http.post(
      Uri.parse("${Endpoint.baseUrlApi}/books"),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      body: {
        "title": _titleController.text,
        "author": _authorController.text,
        "stock": _stockController.text,
      },
    );

    setState(() => _isLoading = false);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Book added successfully",
            style: AppStyle.fontMoreSugarRegular(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.green,
        ),
      );
      _titleController.clear();
      _authorController.clear();
      _stockController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Failed to add book",
            style: AppStyle.fontMoreSugarRegular(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppStyle.fontMoreSugarRegular(
            fontSize: 16,
            color: Colors.grey[800],
          ),
          filled: true,
          fillColor: AppColor.cream,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        style: AppStyle.fontMoreSugarRegular(
          fontSize: 16,
          color: AppColor.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.cream,
      appBar: AppBar(
        title: Text(
          "Add New Book",
          style: AppStyle.fontMoreSugarExtra(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: AppColor.softBlueGray,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                controller: _titleController,
                label: "Title",
                validator:
                    (value) => value!.isEmpty ? "Please enter title" : null,
              ),
              _buildTextField(
                controller: _authorController,
                label: "Author",
                validator:
                    (value) => value!.isEmpty ? "Please enter author" : null,
              ),
              _buildTextField(
                controller: _stockController,
                label: "Stock",
                keyboardType: TextInputType.number,
                validator:
                    (value) => value!.isEmpty ? "Please enter stock" : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child:
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.mossGreen,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _submitBook,
                          child: Text(
                            "Add Book",
                            style: AppStyle.fontMoreSugarExtra(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
