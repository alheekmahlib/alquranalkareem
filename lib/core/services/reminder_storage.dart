import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/reminder_model.dart';

List<GlobalKey> textFieldKeys = [];

class ReminderStorage {
  static const String _storageKey = 'reminders';

  static Future<void> saveReminders(List<Reminder> reminders) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> remindersJson =
        reminders.map((r) => jsonEncode(r.toJson())).toList();
    await prefs.setStringList(_storageKey, remindersJson);
  }

  static Future<List<Reminder>> loadReminders() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> remindersJson =
        prefs.getStringList(_storageKey)?.cast<String>() ?? [];
    List<Reminder> reminders =
        remindersJson.map((r) => Reminder.fromJson(jsonDecode(r))).toList();
    return reminders;
  }

  static Future<void> deleteReminder(int id) async {
    List<Reminder> reminders = await loadReminders();
    reminders.removeWhere((r) => r.id == id);
    await saveReminders(reminders);
  }
}
