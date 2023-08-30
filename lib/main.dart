import 'package:alquranalkareem/quran_page/data/data_client.dart';
import 'package:alquranalkareem/quran_page/data/tafseer_data_client.dart';
import 'package:alquranalkareem/shared/local_notifications.dart';
import 'package:flutter/material.dart';

import 'database/databaseHelper.dart';
import 'database/notificationDatabase.dart';
import 'myApp.dart';
import 'services_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ServicesLocator.init();
  await sl.allReady();
  init();
  runApp(MyApp(theme: ThemeData.light()));
}

init() async {
  DatabaseHelper databaseHelper = DatabaseHelper.instance;
  databaseHelper.database;
  NotificationDatabaseHelper notificationdatabaseHelper =
      NotificationDatabaseHelper.instance;
  notificationdatabaseHelper.database;
  DataBaseClient dataBaseClient = DataBaseClient.instance;
  dataBaseClient.initDatabase();
  TafseerDataBaseClient tafseerDataBaseClient = TafseerDataBaseClient.instance;
  tafseerDataBaseClient.initDatabase();
  NotifyHelper().initializeNotification();
}
