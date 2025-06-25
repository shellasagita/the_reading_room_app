// To parse this JSON data, do
//
//     final listBooksHistory = listBooksHistoryFromJson(jsonString);

import 'dart:convert';

ListBooksHistory listBooksHistoryFromJson(String str) =>
    ListBooksHistory.fromJson(json.decode(str));

String listBooksHistoryToJson(ListBooksHistory data) =>
    json.encode(data.toJson());

class ListBooksHistory {
  String? message;
  List<dynamic>? data;

  ListBooksHistory({this.message, this.data});

  factory ListBooksHistory.fromJson(Map<String, dynamic> json) =>
      ListBooksHistory(
        message: json["message"],
        data:
            json["data"] == null
                ? []
                : List<dynamic>.from(json["data"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
  };
}
