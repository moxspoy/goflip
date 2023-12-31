import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStorage {
  Future<String?> getString(String key);

  Future<bool> setString(String key, String value);

  Future<bool?> getBoolean(String key);

  Future<bool> setBoolean(String key, bool value);

  Future<int?> getInt(String key);

  Future<bool> setInt(String key, int value);
}

class SharedPrefs implements LocalStorage {
  @override
  Future<String?> getString(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  @override
  Future<bool> setString(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(key, value);
  }

  @override
  Future<bool?> getBoolean(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  @override
  Future<bool> setBoolean(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(key, value);
  }

  @override
  Future<int?> getInt(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  @override
  Future<bool> setInt(String key, int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setInt(key, value);
  }
}
