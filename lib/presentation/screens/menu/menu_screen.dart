import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/local_notifications.dart';
import '../../../core/services/services_locator.dart';
import '../../../core/widgets/delete_widget.dart';
import '../../../core/widgets/widgets.dart';
import '../../controllers/general_controller.dart';
import '../../controllers/reminder_controller.dart';
import '../about_app/about_app.dart';
import '../alwaqf_screen/alwaqf_screen.dart';
import '../info_app/info_app.dart';
import '/core/utils/constants/extensions.dart';
import 'data/models/reminder_model.dart';

List<GlobalKey> textFieldKeys = [];

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    sl<ReminderController>().loadReminders();
    return SafeArea(
      top: false,
      bottom: false,
      right: false,
      left: false,
      child: Scaffold(
        backgroundColor: Get.theme.colorScheme.background,
        appBar: AppBar(
          backgroundColor: Get.theme.colorScheme.background,
        ),
        body: context.customOrientation(
            Padding(
              padding: const EdgeInsets.only(right: 16.0, left: 16.0),
              child: ListView(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: greeting(),
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                  hijiriWidget(),
                  const Divider(
                    thickness: 1,
                    height: 30,
                  ),
                  lastReadWidget(),
                  const Divider(
                    thickness: 1,
                    height: 30,
                  ),
                  listWidget(),
                  const Divider(
                    thickness: 1,
                    height: 30,
                  ),
                  reminderWidget()
                ],
              ),
            ),
            ListView(
              children: [
                Padding(
                  padding: context.customOrientation(
                      const EdgeInsets.only(right: 16.0, left: 16.0, top: 40.0),
                      const EdgeInsets.only(
                          right: 16.0, left: 16.0, top: 16.0)),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        greeting(),
                        const Divider(
                          thickness: 1,
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: SizedBox(
                          width: MediaQuery.sizeOf(context).width * .4,
                          child: Column(
                            children: [
                              listWidget(),
                              const Divider(
                                thickness: 1,
                                height: 30,
                              ),
                              reminderWidget()
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: SizedBox(
                          width: MediaQuery.sizeOf(context).width * .4,
                          child: Column(
                            children: [
                              hijiriWidget(),
                              const Divider(
                                thickness: 1,
                              ),
                              lastReadWidget(),
                              const Divider(
                                thickness: 1,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }

  Widget greeting() {
    return Text(
      '| ${sl<GeneralController>().greeting.value} |',
      style: TextStyle(
        fontSize: 16.0,
        fontFamily: 'kufi',
        color: Get.theme.colorScheme.surface,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget hijiriWidget() {
    return Container(
      height: context.customOrientation(220.0, 220.0),
      // width: 70,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            'assets/svg/hijiri_widget.svg',
          ),
          hijriDate(context),
        ],
      ),
    );
  }

  Widget lastReadWidget() {
    return Semantics(
      button: true,
      enabled: true,
      label: 'lastRead'.tr,
      child: Container(
        width: context.customOrientation(MediaQuery.sizeOf(context).width,
            MediaQuery.sizeOf(context).width * .4),
        decoration: BoxDecoration(
          color: Get.theme.colorScheme.surface.withOpacity(.2),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        // padding: EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            Container(
              width: context.customOrientation(
                  MediaQuery.sizeOf(context).width / 1 / 4,
                  MediaQuery.sizeOf(context).width * .12),
              height: 70,
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'lastRead'.tr,
                    style: TextStyle(
                      fontFamily: 'kufi',
                      fontSize: 14,
                      color: Get.theme.canvasColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Divider(
                    endIndent: 8,
                    indent: 8,
                    height: 8,
                  ),
                  Icon(
                    Icons.menu_book,
                    color: Get.theme.canvasColor,
                    size: 22,
                  ),
                ],
              ),
            ),
            Container(
              height: 50,
              width: 2,
              decoration: BoxDecoration(
                  color: Get.theme.colorScheme.surface,
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
            ),
            const SizedBox(
              width: 16,
            ),
            SvgPicture.asset(
              'assets/svg/surah_name/00${sl<GeneralController>().soMName.value}.svg',
              height: 40,
              colorFilter: ColorFilter.mode(
                  Get.isDarkMode
                      ? Get.theme.canvasColor
                      : Get.theme.primaryColorLight,
                  BlendMode.srcIn),
            ),
            const SizedBox(
              width: 16,
            ),
            Text(
              '|${'pageNo'.tr} ${sl<GeneralController>().currentPage.value}|',
              style: TextStyle(
                fontFamily: 'kufi',
                fontSize: 12,
                color: Get.isDarkMode
                    ? Get.theme.canvasColor
                    : Get.theme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget listWidget() {
    return Container(
      // width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.surface.withOpacity(.2),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Semantics(
            button: true,
            enabled: true,
            label: 'waqfName'.tr,
            child: InkWell(
              child: SizedBox(
                // width: MediaQuery.sizeOf(context).width,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Get.theme.colorScheme.surface,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(2)),
                      ),
                      child: SvgPicture.asset(
                        'assets/svg/alwaqf.svg',
                        width: 22,
                      ),
                    ),
                    Container(
                      width: 2,
                      height: 20,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      color: Get.isDarkMode
                          ? Colors.white
                          : Get.theme.primaryColor,
                    ),
                    Text(
                      'stopSigns'.tr,
                      style: TextStyle(
                          color: Get.isDarkMode
                              ? Colors.white
                              : Get.theme.primaryColor,
                          fontFamily: 'kufi',
                          fontStyle: FontStyle.italic,
                          fontSize: 14),
                    ),
                  ],
                ),
              ),
              onTap: () async {
                Navigator.of(context).push(animatRoute(AlwaqfScreen()));
              },
            ),
          ),
          const Divider(),
          Semantics(
            button: true,
            enabled: true,
            label: 'setting'.tr,
            child: InkWell(
              child: SizedBox(
                // width: MediaQuery.sizeOf(context).width,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Get.theme.colorScheme.surface,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(2)),
                      ),
                      child: SvgPicture.asset(
                        'assets/svg/menu_ic.svg',
                        width: 22,
                      ),
                    ),
                    Container(
                      width: 2,
                      height: 20,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      color: Get.isDarkMode
                          ? Colors.white
                          : Get.theme.primaryColor,
                    ),
                    Text(
                      'setting'.tr,
                      style: TextStyle(
                          color: Get.isDarkMode
                              ? Colors.white
                              : Get.theme.primaryColor,
                          fontFamily: 'kufi',
                          fontStyle: FontStyle.italic,
                          fontSize: 14),
                    ),
                  ],
                ),
              ),
              onTap: () async {
                Navigator.of(context).push(animatRoute(const AboutApp()));
              },
            ),
          ),
          const Divider(),
          Semantics(
            button: true,
            enabled: true,
            label: 'aboutApp'.tr,
            child: InkWell(
              child: SizedBox(
                // width: MediaQuery.sizeOf(context).width,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Get.theme.colorScheme.surface,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(2)),
                      ),
                      child: SvgPicture.asset(
                        'assets/svg/info_ic.svg',
                        width: 22,
                      ),
                    ),
                    Container(
                      width: 2,
                      height: 20,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      color: Get.isDarkMode
                          ? Colors.white
                          : Get.theme.primaryColor,
                    ),
                    Text(
                      'aboutApp'.tr,
                      style: TextStyle(
                          color: Get.isDarkMode
                              ? Colors.white
                              : Get.theme.primaryColor,
                          fontFamily: 'kufi',
                          fontStyle: FontStyle.italic,
                          fontSize: 14),
                    ),
                  ],
                ),
              ),
              onTap: () async {
                Navigator.of(context).push(animatRoute(const InfoApp()));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget reminderWidget() {
    return Obx(() => Column(
          children: [
            Container(
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.surface.withOpacity(.2),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: List<Widget>.generate(
                  sl<ReminderController>().reminders.length,
                  (int index) {
                    final reminder = sl<ReminderController>().reminders[index];
                    TextEditingController controller =
                        TextEditingController(text: reminder.name);
                    // Create a new GlobalKey for the TextField and add it to the list
                    GlobalKey textFieldKey = GlobalKey();
                    textFieldKeys.add(textFieldKey);
                    return Dismissible(
                      background: DeleteWidget(),
                      key: UniqueKey(),
                      onDismissed: (DismissDirection direction) async {
                        await sl<ReminderController>()
                            .deleteReminder(context, index);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 200,
                              child: Directionality(
                                textDirection: TextDirection.ltr,
                                child: TextField(
                                  key: textFieldKeys[index],
                                  controller: controller,
                                  // focusNode: _textFocusNode,
                                  autofocus: false,
                                  cursorHeight: 18,
                                  cursorWidth: 3,
                                  cursorColor: Get.theme.dividerColor,
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                      color: Get.isDarkMode
                                          ? Colors.white
                                          : Get.theme.primaryColor,
                                      fontFamily: 'kufi',
                                      fontSize: 14),
                                  decoration: InputDecoration(
                                    hintText: 'اكتب اسم التذكير',
                                    hintStyle: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'kufi',
                                      color: Get.isDarkMode
                                          ? Colors.white.withOpacity(.5)
                                          : Get.theme.primaryColor
                                              .withOpacity(.5),
                                    ),
                                    icon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          reminder.name = controller.text;
                                        });
                                        ReminderStorage.saveReminders(
                                            sl<ReminderController>().reminders);
                                      },
                                      icon: Icon(
                                        Icons.done,
                                        size: 14,
                                        color: Get.theme.colorScheme.surface,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              '${reminder.time.hour}:${reminder.time.minute}',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'kufi',
                                color: Get.isDarkMode
                                    ? Colors.white
                                    : Get.theme.primaryColor,
                              ),
                            ),
                            SizedBox(
                              width: 70,
                              child: AnimatedToggleSwitch<int>.rolling(
                                current: reminder.isEnabled ? 1 : 0,
                                values: const [0, 1],
                                onChanged: (i) async {
                                  bool value = i == 1;
                                  setState(() {
                                    reminder.isEnabled = value;
                                  });
                                  ReminderStorage.saveReminders(
                                      sl<ReminderController>().reminders);
                                  if (reminder.isEnabled) {
                                    // Show the TimePicker to set the reminder time
                                    bool isConfirmed =
                                        await sl<ReminderController>()
                                            .showTimePicker(context, reminder);
                                    if (!isConfirmed) {
                                      setState(() {
                                        reminder.isEnabled = false;
                                      });
                                    }
                                  } else {
                                    // Cancel the scheduled notification
                                    NotifyHelper().cancelScheduledNotification(
                                        reminder.id);
                                  }
                                },
                                iconBuilder: rollingIconBuilder,
                                borderWidth: 1,
                                style: ToggleStyle(
                                  indicatorColor: Get.theme.colorScheme.surface,
                                  backgroundColor: Get.theme.canvasColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                  // dif: 2.0,
                                  borderColor: Get.theme.colorScheme.surface,
                                ),
                                height: 25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Semantics(
                button: true,
                enabled: true,
                label: 'addReminder'.tr,
                child: GestureDetector(
                  onTap: sl<ReminderController>().addReminder,
                  child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 4),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          border: Border.all(
                              color: Get.theme.colorScheme.surface, width: 1)),
                      child: Text(
                        'addReminder'.tr,
                        style: TextStyle(
                            color: Get.theme.colorScheme.surface,
                            fontSize: 14,
                            fontFamily: 'kufi'),
                      )),
                ),
              ),
            ),
          ],
        ));
  }
}

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

Widget rollingIconBuilder(int value, bool foreground) {
  IconData data = Icons.done;
  if (value.isEven) data = Icons.close;
  return Icon(
    data,
    size: 18,
  );
}
