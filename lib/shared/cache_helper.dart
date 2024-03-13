import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? sharedPreferences;

  static Future<String> getSavedString(
      String value, String defaultValue) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? savedValue = _prefs.getString(value) ?? defaultValue;

    return savedValue;
  }

  static Future<bool> removeString(String key) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    bool savedValue = await _prefs.remove(key);
    return savedValue;
  }

  static Future<bool> setSavedString(
      String key,
      String value,
      ) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    bool savedValue = await _prefs.setString(key, value);

    return savedValue;
  }

  static Future<bool> containsString(
      String key,
      ) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    bool savedValue = await _prefs.containsKey(key);

    return savedValue;
  }

  static logout(context) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.clear();
  }
}