import 'package:flutter/material.dart';
import 'package:the_reading_room_app/api/user_api.dart';
import 'package:the_reading_room_app/constant/app_color.dart';
import 'package:the_reading_room_app/constant/app_image.dart';
import 'package:the_reading_room_app/constant/app_style.dart';
import 'package:intl/intl.dart';
import 'package:the_reading_room_app/model/list_book.dart';
import 'package:the_reading_room_app/model/borrow_book.dart';

class BorrowBookScreen extends StatefulWidget {
  const BorrowBookScreen({super.key});
  static const String id = "/borrow_book";

  @override
  State<BorrowBookScreen> createState() => _BorrowBookScreenState();
}

class _BorrowBookScreenState extends State<BorrowBookScreen> {
  final BookService _bookService = BookService();
  List<Data> _borrowedBooks = [];
  Map<int, Book> _bookMap = {}; // Map untuk bookId ke detail buku
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    try {
      final books = await _bookService.getBooks();
      final bookMap = {for (var book in books) if (book.id != null) book.id!: book};

      final borrowData = await _bookService.fetchBookHistory();
      setState(() {
        _bookMap = bookMap;
        _borrowedBooks = borrowData.cast<Data>();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error: $e");
      setState(() => _isLoading = false);
    }
  }

  int _daysLeft(DateTime borrowDate) {
    final dueDate = borrowDate.add(const Duration(days: 7));
    return dueDate.difference(DateTime.now()).inDays;
  }

  void _showBookDialog(Data data) {
    final book = _bookMap[data.bookId];
    final daysLeft = _daysLeft(data.borrowDate!);
    final borrowDateStr = DateFormat('dd MMM yyyy').format(data.borrowDate!);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          book != null ? book.title ?? "Untitled" : 'Book ID: ${data.bookId}',
          style: AppStyle.fontMoreSugarExtra(fontSize: 20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Author: ${book?.author ?? 'Unknown'}"),
            Text("Borrowed on: $borrowDateStr"),
            Text("Days left: $daysLeft days"),
            const SizedBox(height: 16),
            Row(
              children: const [
                Icon(Icons.menu_book, color: AppColor.softBlueGray),
                SizedBox(width: 8),
                Text("Read Book", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () async {
                Navigator.of(context).pop();
                await _returnBook(data.bookId!);
              },
              child: Row(
                children: const [
                  Icon(Icons.assignment_return, color: AppColor.mossGreen),
                  SizedBox(width: 8),
                  Text("Return Book", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _returnBook(int bookId) async {
    try {
      await _bookService.returnBookAction(bookId: bookId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Book returned"), backgroundColor: Colors.green),
      );
      _loadAllData();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to return"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.cream,
      appBar: AppBar(
        title: Text("Borrowed Books", style: AppStyle.fontMoreSugarExtra(fontSize: 22, color: Colors.white)),
        backgroundColor: AppColor.softBlueGray,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(AppImage.bookShelf, fit: BoxFit.cover),
          ),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _borrowedBooks.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (context, index) {
                    final bookData = _borrowedBooks[index];
                    final book = _bookMap[bookData.bookId];
                    return GestureDetector(
                      onTap: () => _showBookDialog(bookData),
                      child: Column(
                        children: [
                          Expanded(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(AppImage.coverBook, fit: BoxFit.contain),
                                Positioned(
                                  bottom: 10,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                    child: Text(
                                      book?.title ?? 'Book ID: ${bookData.bookId}',
                                      style: AppStyle.fontMoreSugarRegular(fontSize: 12, color: Colors.black87),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
