import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefServices {
  final SharedPreferences _prefs;

  SharedPrefServices(this._prefs);

  // Future init() async {
  //   _prefs = await SharedPreferences.getInstance();
  //   return _prefs;
  // }

  saveString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  Future<String> getString(String? key, {String? defaultValue = ""}) async {
    String data = await Future.value(_prefs.getString(key!) ?? defaultValue);
    return data;
  }

  saveBoolean(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  saveInLocalStorageAsInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  Future<bool> getBoolean(String? key) async {
    bool data = await Future.value(_prefs.getBool(key!) ?? false);
    return data;
  }

  Future<bool> isContain(String? key) async {
    bool data = await Future.value(_prefs.containsKey(key!));
    return data;
  }

  Future<int> getInteger(String? key, {int? defaultValue = 1}) async {
    int data = await Future.value(_prefs.getInt(key ?? '') ?? defaultValue);
    return data;
  }

  saveInteger(String? key, int value) async {
    await _prefs.setInt(key!, value);
  }

  saveDouble(String? key, double value) async {
    await _prefs.setDouble(key!, value);
  }

  Future<double> getDouble(String? key) async {
    double data = await Future.value(_prefs.getDouble(key!) ?? 0.0);
    return data;
  }

  removeFromLocalStorage({@required String? key}) async {
    var data = _prefs.remove(key!);
    return data;
  }

  void clearPrefs() {
    _prefs.clear();
  }
}
