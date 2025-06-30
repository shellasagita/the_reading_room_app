import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:the_reading_room_app/endpoint.dart';
import 'package:the_reading_room_app/helper/preference.dart';
import 'package:the_reading_room_app/model/add_book.dart';
import 'package:the_reading_room_app/model/borrow_book.dart';
import 'package:the_reading_room_app/model/list_book.dart';
import 'package:the_reading_room_app/model/list_books_history.dart';
import 'package:the_reading_room_app/model/login_response.dart';
import 'package:the_reading_room_app/model/register_error_response';
import 'package:the_reading_room_app/model/register_response.dart';
import 'package:the_reading_room_app/model/delete_book.dart';

class UserService {
  Future<Map<String, dynamic>> registerUser({
    required String email,
    required String name,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(Endpoint.register),
      headers: {"Accept": "application/json"},
      body: {"name": name, "email": email, "password": password},
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(registerResponseFromJson(response.body).toJson());
      return registerResponseFromJson(response.body).toJson();
    } else if (response.statusCode == 422) {
      return registerErrorResponseFromJson(response.body).toJson();
    } else {
      print("Failed to register user: ${response.statusCode}");
      throw Exception("Failed to register user: ${response.statusCode}");
    }
  }

  Future<LoginResponse> loginUser({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(Endpoint.login),
      headers: {"Accept": "application/json"},
      body: {"email": email, "password": password},
    );

    print("Raw response body: ${response.body}");
    print("Status code: ${response.statusCode}");

    if (response.statusCode == 200) {
      return loginResponseFromJson(response.body);
    } else {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Login failed');
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    final token = await PreferenceHandler.getToken();

    final response = await http.get(
      Uri.parse("${Endpoint.baseUrlApi}/profile"),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    print("PROFILE RESPONSE: ${response.body}");

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return result; // Harus mengandung 'message' dan 'data' (user info)
    } else {
      throw Exception("Failed to load profile");
    }
  }
}

// Future<Map<String, dynamic>> getProfile() async {
//   String? token = await PreferenceHandler.getToken();
//   final response = await http.get(
//     Uri.parse(Endpoint.profile),
//     headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
//   );
//   print(response.body);
//   print(response.body);
//   if (response.statusCode == 200) {
//     print(profileResponseFromJson(response.body).toJson());
//     return profileResponseFromJson(response.body).toJson();
//   } else if (response.statusCode == 422) {
//     return registerErrorResponseFromJson(response.body).toJson();
//   } else {
//     print("Failed to register user: ${response.statusCode}");
//     throw Exception("Failed to register user: ${response.statusCode}");
//   }
// }

// Future<bool> updateProfile(String name) async {
//   String? token = await PreferenceHandler.getToken();

//   final response = await http.put(
//     Uri.parse(Endpoint.updateProfile), // Tambahkan endpoint baru ini
//     headers: {
//       "Accept": "application/json",
//       "Authorization": "Bearer $token",
//       "Content-Type": "application/json",
//     },
//     body: jsonEncode({"name": name}),
//   );

//   print("Update response: ${response.body}");

//   if (response.statusCode == 200) {
//     return true; // sukses update
//   } else {
//     print("Update failed: ${response.statusCode}");
//     return false; // gagal update
//   }
// }

class BookService {
  Future<List<Book>> getBooks() async {
    final token = await PreferenceHandler.getToken();

    print(" Requesting book list");
    print("GET BOOKS: ${Endpoint.bookList}");
    print("TOKEN: $token");

    final response = await http.get(
      Uri.parse(Endpoint.bookList),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    print("Book response: ${response.body}");

    if (response.statusCode == 200) {
      final books = listBookFromJson(response.body);
      return books.data ?? [];
    } else {
      throw Exception('Failed to fetch books');
    }
  }

  Future<BorrowBook> borrowBook(int bookId) async {
    final token = await PreferenceHandler.getToken();

    final response = await http.post(
      Uri.parse("${Endpoint.baseUrlApi}/borrow"),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      body: {"book_id": bookId.toString()},
    );

    print("Borrow response: ${response.body}");

    if (response.statusCode == 200) {
      return borrowBookFromJson(response.body);
    } else {
      throw Exception("Failed to borrow book: ${response.body}");
    }
  }

  Future<Map<String, dynamic>> returnBookAction({required int bookId}) async {
    final token = await PreferenceHandler.getToken();

    final response = await http.post(
      Uri.parse("${Endpoint.returnBook}/$bookId"), // tambahkan /$bookId
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    print("Return Response: ${response.body}");

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to return book: ${response.statusCode}");
    }
  }

  Future<List<dynamic>> fetchBookHistory() async {
    final token = await PreferenceHandler.getToken();

    final response = await http.get(
      Uri.parse(
        "${Endpoint.baseUrlApi}/borrow-history",
      ), // pastikan endpoint ini benar
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    print("Book history response: ${response.body}");

    if (response.statusCode == 200) {
      final data = listBooksHistoryFromJson(response.body);
      return data.data ?? [];
    } else {
      throw Exception('Failed to fetch book history');
    }
  }

  // Fungsi untuk menambahkan buku
  Future<AddBook> addBook({
    required String title,
    required String author,
    required int stock,
  }) async {
    final token = await PreferenceHandler.getToken();

    final response = await http.post(
      Uri.parse("${Endpoint.bookList}"), // /api/books
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      body: {"title": title, "author": author, "stock": stock.toString()},
    );

    print("Add Book response: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return addBookFromJson(response.body);
    } else {
      throw Exception("Failed to add book: ${response.statusCode}");
    }
  }

  Future<AddBook> editBook({
    required int bookId,
    required String title,
    required String author,
    required int stock,
  }) async {
    final token = await PreferenceHandler.getToken();

    final response = await http.put(
      Uri.parse("${Endpoint.bookList}/$bookId"), // /api/books/{id}
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      body: {"title": title, "author": author, "stock": stock.toString()},
    );

    print("Edit Book response: ${response.body}");

    if (response.statusCode == 200) {
      return addBookFromJson(response.body); // Responnya sama dengan AddBook
    } else {
      throw Exception("Failed to edit book: ${response.statusCode}");
    }
  }

  Future<DeleteBook> deleteBook(int bookId) async {
    final token = await PreferenceHandler.getToken();

    final response = await http.delete(
      Uri.parse("${Endpoint.deleteBook}/$bookId"), // contoh: /api/books/5
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return deleteBookFromJson(response.body);
    } else {
      throw Exception("Failed to delete book: ${response.statusCode}");
    }
  }

  returnBook(int bookId) {}
}
