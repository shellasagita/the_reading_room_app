import 'package:flutter/material.dart';
import 'package:the_reading_room_app/api/user_api.dart';
import 'package:the_reading_room_app/constant/app_color.dart';
import 'package:the_reading_room_app/constant/app_style.dart';
import 'package:the_reading_room_app/model/list_book.dart';

class BorrowBookScreen extends StatefulWidget {
  const BorrowBookScreen({super.key});
  static const String id = "/borrow_book";

  @override
  State<BorrowBookScreen> createState() => _BorrowBookScreenState();
}

class _BorrowBookScreenState extends State<BorrowBookScreen> {
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

  Future<void> _borrowBook(int bookId) async {
    try {
      final response = await _bookService.borrowBook(bookId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message ?? 'Book borrowed!'), backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to borrow book'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.cream,
      appBar: AppBar(
        title: const Text("Borrow Book"),
        backgroundColor: AppColor.softBlueGray,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _books.length,
              itemBuilder: (context, index) {
                final book = _books[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(book.title ?? "Untitled", style: AppStyle.fontMoreSugarRegular(fontSize: 16)),
                    subtitle: Text(book.author ?? "Unknown author"),
                    trailing: IconButton(
                      icon: const Icon(Icons.book_online),
                      onPressed: () => _borrowBook(book.id!),
                      color: AppColor.mossGreen,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
