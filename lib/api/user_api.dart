import 'package:http/http.dart' as http;
import 'package:the_reading_room_app/endpoint.dart';
import 'package:the_reading_room_app/helper/preference.dart';
import 'package:the_reading_room_app/model/login_error_response.dart';
import 'package:the_reading_room_app/model/login_response.dart';
import 'package:the_reading_room_app/model/register_error_response';
import 'package:the_reading_room_app/model/register_response.dart';

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

  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(Endpoint.login),
      headers: {"Accept": "application/json"},
      body: {"email": email, "password": password},
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      //ok success login
      print(loginResponseFromJson(response.body).toJson());
      return loginResponseFromJson(response.body).toJson();
    } else {
      return loginErrorResponseFromJson(response.body).toJson();
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
}
