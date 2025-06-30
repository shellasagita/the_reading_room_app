// import 'package:flutter/material.dart';
// import 'package:the_reading_room_app/api/user_api.dart';
// import 'package:the_reading_room_app/constant/app_color.dart';
// import 'package:the_reading_room_app/constant/app_style.dart';
// import 'package:the_reading_room_app/model/list_book.dart';

// class ReturnBookScreen extends StatefulWidget {
//   final int bookId;
//   const ReturnBookScreen({super.key, required this.bookId});

//   static const String id = '/return_book_screen';

//   @override
//   State<ReturnBookScreen> createState() => _ReturnBookScreenState();
// }

// class _ReturnBookScreenState extends State<ReturnBookScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _bookIdController = TextEditingController();
//   bool _isLoading = false;

//   @override
//   void dispose() {
//     _bookIdController.dispose();
//     super.dispose();
//   }

//   Future<void> _handleReturnBook() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _isLoading = true);

//     try {
//       final response = await BookService().returnBookAction(
//         bookId: int.parse(_bookIdController.text.trim()),
//       );

//       final message = response['message'] ?? 'Book returned successfully!';

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(message), backgroundColor: Colors.green),
//       );

//       _bookIdController.clear();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to return book: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.cream,
//       appBar: AppBar(
//         title: Text(
//           "Return Book",
//           style: AppStyle.fontMoreSugarExtra(fontSize: 22),
//         ),
//         backgroundColor: AppColor.softBlueGray,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               Text(
//                 'Return a Book',
//                 style: AppStyle.fontMoreSugarExtra(fontSize: 28),
//               ),
//               const SizedBox(height: 32),
//               TextFormField(
//                 controller: _bookIdController,
//                 keyboardType: TextInputType.number,
//                 decoration: InputDecoration(
//                   labelText: 'Book ID',
//                   hintText: 'Enter the ID of the book to return',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   filled: true,
//                   fillColor: AppColor.creamyBeige,
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Book ID is required';
//                   }
//                   if (int.tryParse(value) == null) {
//                     return 'Book ID must be a number';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 32),
//               ElevatedButton(
//                 onPressed: _isLoading ? null : _handleReturnBook,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColor.mossGreen,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 32,
//                     vertical: 16,
//                   ),
//                 ),
//                 child:
//                     _isLoading
//                         ? const CircularProgressIndicator(color: Colors.white)
//                         : Text(
//                           'Return Book',
//                           style: AppStyle.fontMoreSugarRegular(fontSize: 16),
//                         ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
