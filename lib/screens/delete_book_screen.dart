import 'package:flutter/material.dart';
import 'package:the_reading_room_app/api/user_api.dart';
import 'package:the_reading_room_app/model/list_book.dart';
import 'package:the_reading_room_app/model/delete_book.dart';
import 'package:the_reading_room_app/constant/app_color.dart';
import 'package:the_reading_room_app/constant/app_style.dart';

class DeleteBookScreen extends StatefulWidget {
  static const String id = "/delete_book_screen";

  const DeleteBookScreen({super.key});

  @override
  State<DeleteBookScreen> createState() => _DeleteBookScreenState();
}

class _DeleteBookScreenState extends State<DeleteBookScreen> {
  List<Book> _books = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  Future<void> _fetchBooks() async {
    try {
      final books = await BookService().getBooks();
      setState(() {
        _books = books;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching books: $e");
    }
  }

  Future<void> _deleteBook(int bookId) async {
    try {
      final response = await BookService().deleteBook(bookId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message ?? "Book deleted")),
      );
      _fetchBooks(); // refresh
    } catch (e) {
      print("Delete error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete book")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.cream,
      appBar: AppBar(
        backgroundColor: AppColor.softBlueGray,
        title: Text(
          "Delete Book",
          style: AppStyle.fontMoreSugarExtra(fontSize: 22, color: Colors.white),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _books.isEmpty
              ? Center(child: Text("No books available"))
              : ListView.builder(
                  itemCount: _books.length,
                  itemBuilder: (context, index) {
                    final book = _books[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      color: Colors.white,
                      child: ListTile(
                        title: Text(book.title ?? "No title"),
                        subtitle: Text("Author: ${book.author ?? "-"}"),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _showConfirmDialog(book),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  void _showConfirmDialog(Book book) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Book"),
        content: Text("Are you sure you want to delete '${book.title}'?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteBook(book.id ?? 0);
            },
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }
}
