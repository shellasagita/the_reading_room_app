// To parse this JSON data, do
//
//     final returnBook = returnBookFromJson(jsonString);

import 'dart:convert';

ReturnBook returnBookFromJson(String str) => ReturnBook.fromJson(json.decode(str));

String returnBookToJson(ReturnBook data) => json.encode(data.toJson());

class ReturnBook {
    String message;
    Data data;

    ReturnBook({
        required this.message,
        required this.data,
    });

    factory ReturnBook.fromJson(Map<String, dynamic> json) => ReturnBook(
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
    };
}

class Data {
    int id;
    String userId;
    String bookId;
    DateTime borrowDate;
    DateTime returnDate;
    DateTime createdAt;
    DateTime updatedAt;

    Data({
        required this.id,
        required this.userId,
        required this.bookId,
        required this.borrowDate,
        required this.returnDate,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        userId: json["user_id"],
        bookId: json["book_id"],
        borrowDate: DateTime.parse(json["borrow_date"]),
        returnDate: DateTime.parse(json["return_date"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "book_id": bookId,
        "borrow_date": "${borrowDate.year.toString().padLeft(4, '0')}-${borrowDate.month.toString().padLeft(2, '0')}-${borrowDate.day.toString().padLeft(2, '0')}",
        "return_date": returnDate.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
