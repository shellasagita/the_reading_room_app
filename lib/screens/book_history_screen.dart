import 'package:flutter/material.dart';
import 'package:the_reading_room_app/constant/app_color.dart';
import 'package:the_reading_room_app/constant/app_style.dart';
import 'package:the_reading_room_app/helper/preference.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookHistoryScreen extends StatefulWidget {
  const BookHistoryScreen({super.key});
  static const String id = "book_history_screen";

  @override
  State<BookHistoryScreen> createState() => _BookHistoryScreenState();
}

class _BookHistoryScreenState extends State<BookHistoryScreen> {
  bool isLoading = true;
  List<dynamic> histories = [];

  Future<void> fetchBookHistories() async {
    final token = await PreferenceHandler.getToken();

    final response = await http.get(
      Uri.parse("https://appperpus.mobileprojp.com/api/borrow-history"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      setState(() {
        histories = result['data'] ?? [];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception("Failed to load borrow history");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBookHistories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.cream,
      appBar: AppBar(
        backgroundColor: AppColor.softBlueGray,
        title: Text("Borrow History", style: AppStyle.fontMoreSugarExtra(fontSize: 22, color: Colors.white)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : histories.isEmpty
              ? Center(
                  child: Text(
                    "No borrow history found.",
                    style: AppStyle.fontMoreSugarRegular(fontSize: 16),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemCount: histories.length,
                  itemBuilder: (context, index) {
                    final item = histories[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 4, offset: const Offset(0, 2)),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Book ID: ${item['book_id'] ?? '-'}",
                              style: AppStyle.fontMoreSugarRegular(fontSize: 16)),
                          const SizedBox(height: 4),
                          Text("User ID: ${item['user_id'] ?? '-'}",
                              style: AppStyle.fontMoreSugarRegular(fontSize: 16)),
                          const SizedBox(height: 4),
                          Text("Borrow Date: ${item['borrow_date'] ?? '-'}",
                              style: AppStyle.fontMoreSugarRegular(fontSize: 14)),
                          const SizedBox(height: 4),
                          Text("Return Date: ${item['return_date'] ?? '-'}",
                              style: AppStyle.fontMoreSugarRegular(fontSize: 14)),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
