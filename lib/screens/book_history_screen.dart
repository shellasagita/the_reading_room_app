import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:the_reading_room_app/api/user_api.dart';
import 'package:the_reading_room_app/constant/app_color.dart';
import 'package:the_reading_room_app/constant/app_style.dart';
import 'package:the_reading_room_app/helper/preference.dart';
import 'package:the_reading_room_app/model/list_book.dart';

class BookHistoryScreen extends StatefulWidget {
  const BookHistoryScreen({super.key});
  static const String id = "book_history_screen";

  @override
  State<BookHistoryScreen> createState() => _BookHistoryScreenState();
}

class _BookHistoryScreenState extends State<BookHistoryScreen> {
  bool isLoading = true;
  List<dynamic> histories = [];
  List<dynamic> filteredHistories = [];
  Map<int, Book> bookMap = {};

  String selectedStatus = "All";
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    try {
      final token = await PreferenceHandler.getToken();

      final historyResponse = await http.get(
        Uri.parse("https://appperpus.mobileprojp.com/api/history"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      final bookList = await BookService().getBooks();
      bookMap = {
        for (var book in bookList)
          if (book.id != null) book.id!: book,
      };

      if (historyResponse.statusCode == 200) {
        final result = json.decode(historyResponse.body);
        histories = result['data'] ?? [];
        _applyFilters();
      } else {
        throw Exception("Failed to load history");
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _applyFilters() {
    setState(() {
      filteredHistories =
          histories.where((item) {
            final returnDate = item['return_date'];
            final statusMatches =
                selectedStatus == "All" ||
                (selectedStatus == "Returned" && returnDate != null) ||
                (selectedStatus == "Still Borrowed" && returnDate == null);

            final borrowDateStr = item['borrow_date'];
            final dateMatches =
                selectedDate == null ||
                (borrowDateStr != null &&
                    DateFormat(
                          'yyyy-MM-dd',
                        ).format(DateTime.parse(borrowDateStr)) ==
                        DateFormat('yyyy-MM-dd').format(selectedDate!));

            return statusMatches && dateMatches;
          }).toList();
    });
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _applyFilters();
      });
    }
  }

  void _clearDate() {
    setState(() {
      selectedDate = null;
      _applyFilters();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.cream,
      appBar: AppBar(
        backgroundColor: AppColor.softBlueGray,
        title: Text(
          "Borrow History",
          style: AppStyle.fontMoreSugarExtra(fontSize: 22, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: _pickDate,
            tooltip: "Filter by Date",
          ),
          if (selectedDate != null)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clearDate,
              tooltip: "Clear Date Filter",
            ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: DropdownButtonFormField<String>(
                      value: selectedStatus,
                      items: [
                        DropdownMenuItem(
                          value: "All",
                          child: Text(
                            "All",
                            style: AppStyle.fontMoreSugarRegular(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: "Returned",
                          child: Text(
                            "Returned",
                            style: AppStyle.fontMoreSugarRegular(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: "Still Borrowed",
                          child: Text(
                            "Still Borrowed",
                            style: AppStyle.fontMoreSugarRegular(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedStatus = value;
                            _applyFilters();
                          });
                        }
                      },
                      decoration: InputDecoration(
                        labelText: "Filter by Status",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child:
                        filteredHistories.isEmpty
                            ? const Center(
                              child: Text("No history matches filter."),
                            )
                            : ListView.separated(
                              padding: const EdgeInsets.all(16),
                              separatorBuilder:
                                  (_, __) => const SizedBox(height: 12),
                              itemCount: filteredHistories.length,
                              itemBuilder: (context, index) {
                                final item = filteredHistories[index];
                                final bookId = int.tryParse(
                                  item['book_id'].toString(),
                                );
                                final book =
                                    bookId != null ? bookMap[bookId] : null;

                                final borrowDate = item['borrow_date'] ?? '-';
                                final returnDate = item['return_date'];
                                final status =
                                    returnDate != null
                                        ? "Returned"
                                        : "Still Borrowed";

                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Title: ${book?.title ?? 'Unknown'}",
                                        style: AppStyle.fontMoreSugarExtra(
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        "Author: ${book?.author ?? 'Unknown'}",
                                        style: AppStyle.fontMoreSugarRegular(
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        "Borrow Date: $borrowDate",
                                        style: AppStyle.fontMoreSugarRegular(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        "Return Date: ${returnDate ?? '-'}",
                                        style: AppStyle.fontMoreSugarRegular(
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Status: $status",
                                        style: AppStyle.fontMoreSugarRegular(
                                          fontSize: 14,
                                          color:
                                              status == "Returned"
                                                  ? Colors.green
                                                  : Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                  ),
                ],
              ),
    );
  }
}
