// To parse this JSON data, do
//
//     final listBook = listBookFromJson(jsonString);

import 'dart:convert';

ListBook listBookFromJson(String str) => ListBook.fromJson(json.decode(str));

String listBookToJson(ListBook data) => json.encode(data.toJson());

class ListBook {
  String? message;
  List<Book>? data;

  ListBook({this.message, this.data});

  factory ListBook.fromJson(Map<String, dynamic> json) => ListBook(
    message: json["message"],
    data:
        json["data"] == null
            ? []
            : List<Book>.from(json["data"]!.map((x) => Book.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data":
        data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Book {
  int? id;
  String? title;
  String? author;
  String? stock;
  DateTime? createdAt;
  DateTime? updatedAt;

  Book({
    this.id,
    this.title,
    this.author,
    this.stock,
    this.createdAt,
    this.updatedAt,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
    id: json["id"],
    title: json["title"],
    author: json["author"],
    stock: json["stock"],
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt:
        json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "author": author,
    "stock": stock,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
