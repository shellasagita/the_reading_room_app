import 'package:flutter/material.dart';
import 'package:the_reading_room_app/api/user_api.dart';
import 'package:the_reading_room_app/constant/app_color.dart';
import 'package:the_reading_room_app/constant/app_style.dart';
import 'package:the_reading_room_app/model/list_book.dart';
import 'package:the_reading_room_app/routes/app_routes.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});
  static const String id = AppRoutes.bookList;

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  late Future<List<Book>> _bookFuture;

  @override
  void initState() {
    super.initState();
    _bookFuture = BookService().getBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.cream,
      appBar: AppBar(
        title: Text('Book List', // Daftar Buku
            style: AppStyle.fontMoreSugarExtra(fontSize: 22, color: Colors.white)),
        backgroundColor: AppColor.softBlueGray,
      ),
      body: FutureBuilder<List<Book>>(
        future: _bookFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error loading books'), // Gagal memuat buku
            );
          }
          final books = snapshot.data ?? [];

          if (books.isEmpty) {
            return Center(
              child: Text("No books available."), // Tidak ada buku
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                color: AppColor.lightGreenish,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: Text(
                    book.title ?? '-',
                    style: AppStyle.fontMoreSugarExtra(fontSize: 18),
                  ),
                  subtitle: Text(
                    'Author: ${book.author ?? "-"}\nStock: ${book.stock ?? "0"}',
                    style: AppStyle.fontMoreSugarRegular(fontSize: 14),
                  ),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Go to detail or borrow
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
