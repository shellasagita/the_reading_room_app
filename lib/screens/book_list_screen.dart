import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_reading_room_app/api/user_api.dart';
import 'package:the_reading_room_app/constant/app_color.dart';
import 'package:the_reading_room_app/constant/app_style.dart';
import 'package:the_reading_room_app/model/list_book.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});
  static const String id = "/book_list";

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  final BookService _bookService = BookService();
  List<Book> _books = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    try {
      final books = await _bookService.getBooks();
      setState(() {
        _books = books;
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading books: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _confirmAndBorrowBook(Book book) async {
    int stock = int.tryParse(book.stock ?? "0") ?? 0;
    if (stock == 0) return;

    final shouldBorrow = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              "Confirm Borrow",
              style: AppStyle.fontMoreSugarRegular(fontSize: 22),
            ),
            content: Text(
              "Do you want to borrow \"${book.title}\"?",
              style: AppStyle.fontMoreSugarThin(fontSize: 14),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  "Cancel",
                  style: AppStyle.fontMoreSugarRegular(fontSize: 14),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  "Yes",
                  style: AppStyle.fontMoreSugarRegular(fontSize: 14),
                ),
              ),
            ],
          ),
    );

    if (shouldBorrow == true) {
      try {
        final response = await _bookService.borrowBook(book.id!);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? "Book borrowed successfully."),
            backgroundColor: Colors.green,
          ),
        );

        setState(() {
          book.stock = (stock - 1).toString();
        });

        await _saveBorrowedBook(book);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to borrow book."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveBorrowedBook(Book book) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'borrowed_books';
    final List<String> borrowedBooksJson = prefs.getStringList(key) ?? [];

    bool alreadyAdded = borrowedBooksJson.any((jsonStr) {
      final map = json.decode(jsonStr);
      return map['id'] == book.id;
    });

    if (!alreadyAdded) {
      borrowedBooksJson.add(json.encode(book.toJson()));
      await prefs.setStringList(key, borrowedBooksJson);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.cream,
      appBar: AppBar(
        title: Text(
          "Book List",
          style: AppStyle.fontMoreSugarExtra(fontSize: 22, color: Colors.white),
        ),
        backgroundColor: AppColor.softBlueGray,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: _books.length,
                itemBuilder: (context, index) {
                  final book = _books[index];
                  int stock = int.tryParse(book.stock ?? "0") ?? 0;

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      title: Text(
                        book.title ?? "Untitled",
                        style: AppStyle.fontMoreSugarExtra(fontSize: 16),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book.author ?? "Unknown",
                            style: AppStyle.fontMoreSugarRegular(fontSize: 14),
                          ),
                          Text(
                            "Stock: $stock",
                            style: AppStyle.fontMoreSugarRegular(
                              fontSize: 14,
                              color: stock == 0 ? Colors.red : Colors.black,
                            ),
                          ),
                        ],
                      ),
                      trailing: ElevatedButton(
                        onPressed:
                            stock == 0
                                ? null
                                : () => _confirmAndBorrowBook(book),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              stock == 0 ? Colors.grey : AppColor.mossGreen,
                        ),
                        child: Text(
                          "Borrow",
                          style: AppStyle.fontMoreSugarRegular(fontSize: 14),
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
