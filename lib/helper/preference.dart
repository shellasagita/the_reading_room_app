import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHandler {
  static const String _loginKey = "login";
  static const String _tokenKey = "token";

  static  Future<void> saveLogin(bool login) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_loginKey, login);
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_tokenKey, token);
  }

  static Future<bool> getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    bool? login = prefs.getBool(_loginKey) ?? false;
    return login;
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(_tokenKey);
    return token;
  }

  static Future<String?> putProfile() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(_tokenKey);
    return token;
  }

  // static void deleteLogin() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.remove(_loginKey);
  // }

  static Future<void> deleteLogin() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(_loginKey); // optional pakai await
  }
}

// // Tambahkan ke PreferenceHandler
// class PreferenceHandler {
//   static const String _loginKey = "login";
//   static const String _tokenKey = "token";
//   static const String _roleKey = "role";
//   static const String _userEmailKey = "user_email";
//   static const String _userIdKey = "user_id";

//   static Future<void> saveLogin(bool login) async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setBool(_loginKey, login);
//   }

//   static Future<void> saveToken(String token) async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setString(_tokenKey, token);
//   }

//   static Future<void> saveUserEmail(String email) async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setString(_userEmailKey, email);
//   }

//   static Future<void> saveUserId(int id) async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setInt(_userIdKey, id);
//   }

//   static Future<void> saveRoleFromEmail(String email) async {
//     final prefs = await SharedPreferences.getInstance();
//     final role = (email == "admin@mail.com") ? "admin" : "user";
//     prefs.setString(_roleKey, role);
//   }

//   static Future<String?> getRole() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(_roleKey);
//   }

//   static Future<String?> getEmail() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(_userEmailKey);
//   }

//   static Future<int?> getUserId() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getInt(_userIdKey);
//   }

//   static Future<void> deleteLogin() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_loginKey);
//     await prefs.remove(_tokenKey);
//     await prefs.remove(_roleKey);
//     await prefs.remove(_userEmailKey);
//     await prefs.remove(_userIdKey);
//   }

//   // Tambahkan fungsi untuk validasi hak tambah buku
//   static Future<bool> canAddBook() async {
//     final role = await getRole();
//     return role == "admin" || role == "user"; // Keduanya boleh tambah
//   }

//   // Tambahkan fungsi untuk validasi hak hapus buku
//   static Future<bool> canDeleteBook(int bookCreatorId) async {
//     final role = await getRole();
//     final userId = await getUserId();

//     if (role == "admin") return true;
//     return userId == bookCreatorId;
//   }
// }

// // Di login screen setelah login berhasil
// final loginResponse = LoginResponse.fromJson(response);
// await PreferenceHandler.saveToken(loginResponse.data.token);
// await PreferenceHandler.saveUserEmail(loginResponse.data.user.email);
// await PreferenceHandler.saveUserId(loginResponse.data.user.id);
// await PreferenceHandler.saveRoleFromEmail(loginResponse.data.user.email);
// await PreferenceHandler.saveLogin(true);

// // Contoh penggunaan untuk pengecekan tambah buku
// if (await PreferenceHandler.canAddBook()) {
//   // tampilkan tombol tambah buku
// }

// // Contoh penggunaan untuk pengecekan hapus buku
// if (await PreferenceHandler.canDeleteBook(book.userId)) {
//   // tampilkan tombol hapus
// } else {
//   // sembunyikan tombol
// }
