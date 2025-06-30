// To parse this JSON data, do
//
//     final addBook = addBookFromJson(jsonString);

import 'dart:convert';

AddBook addBookFromJson(String str) => AddBook.fromJson(json.decode(str));

String addBookToJson(AddBook data) => json.encode(data.toJson());

class AddBook {
    String message;
    Data data;

    AddBook({
        required this.message,
        required this.data,
    });

    factory AddBook.fromJson(Map<String, dynamic> json) => AddBook(
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
    };
}

class Data {
    String title;
    String author;
    int stock;
    DateTime updatedAt;
    DateTime createdAt;
    int id;

    Data({
        required this.title,
        required this.author,
        required this.stock,
        required this.updatedAt,
        required this.createdAt,
        required this.id,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        title: json["title"],
        author: json["author"],
        stock: json["stock"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "author": author,
        "stock": stock,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
    };
}
