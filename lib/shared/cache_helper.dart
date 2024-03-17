import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static Future<void> saveUserToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userToken', token);
  }

  static Future<String?> getUserToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs
        .getString('userToken'); // Returns null if 'userToken' does not exist.
  }

  static Future<void> removeUserToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userToken');
  }
}
