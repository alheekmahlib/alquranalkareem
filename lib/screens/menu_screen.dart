import 'dart:convert';

import 'package:alquranalkareem/l10n/app_localizations.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_provider/theme_provider.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../shared/local_notifications.dart';
import '../shared/reminder_model.dart';
import 'about_app.dart';
import '../shared/widgets/widgets.dart';
import 'info_app.dart';
import 'alwaqf_screen.dart';


List<GlobalKey> textFieldKeys = [];

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {


  @override
  void initState() {
    QuranCubit.get(context).updateGreeting();
    QuranCubit.get(context).loadReminders();
    super.initState();
  }

  @override
  void dispose() {
    QuranCubit.get(context).time;
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    QuranCubit cubit = QuranCubit.get(context);
    return BlocConsumer<QuranCubit, QuranState>(
  listener: (context, state) {
    LoadRemindersState();
    ShowTimePickerState();
    AddReminderState();
    DeleteReminderState();
    OnTimeChangedState();
  },
  builder: (context, state) {
    return SafeArea(
      top: false,
      bottom: false,
      right: false,
      left: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Padding(
          padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 40.0),
          child: ListView(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  '| ${cubit.greeting} |',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'kufi',
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Divider(
                thickness: 1,
              ),
              Container(
                height: orientation(context, 220.0, 350.0),
                // width: 70,
                decoration: BoxDecoration(
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
              ),
              const Divider(
                thickness: 1,
                height: 30,
              ),
<<<<<<< Updated upstream
              Wrap(
                children: [
                  orientation == Orientation.portrait
                      ? Container(
                          height: 100,
                          width: 170,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Stack(
                            children: [
                              SvgPicture.asset(
                                'assets/svg/last_read.svg',
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of(context)!.lastRead,
                                    style: TextStyle(
                                      fontFamily: 'kufi',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          Theme.of(context).bottomAppBarColor,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Divider(
                                    height: 1,
                                    endIndent: 20,
                                    indent: 20,
                                  ),
                                  SvgPicture.asset(
                                    'assets/svg/surah_name/00${cubit.soMName}.svg',
                                    height: 36,
                                    color: Theme.of(context).bottomAppBarColor,
                                  ),
                                  Divider(
                                    height: 1,
                                    endIndent: 20,
                                    indent: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '|${AppLocalizations.of(context)!.pageNo} ${cubit.cuMPage}|',
                                        style: TextStyle(
                                          fontFamily: 'kufi',
                                          fontSize: 12,
                                          color: Theme.of(context)
                                              .bottomAppBarColor,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        Icons.menu_book,
                                        color:
                                            Theme.of(context).bottomAppBarColor,
                                        size: 14,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      : Container(
                          height: 300,
                          width: 370,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Stack(
                            children: [
                              SvgPicture.asset(
                                'assets/svg/last_read.svg',
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of(context)!.lastRead,
                                    style: TextStyle(
                                      fontFamily: 'kufi',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          Theme.of(context).bottomAppBarColor,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 70,
                                  ),
                                  Divider(
                                    height: 1,
                                    endIndent: 120,
                                    indent: 120,
                                  ),
                                  SvgPicture.asset(
                                    'assets/svg/surah_name/00${cubit.soMName}.svg',
                                    height: 52,
                                    color: Theme.of(context).bottomAppBarColor,
                                  ),
                                  Divider(
                                    height: 1,
                                    endIndent: 120,
                                    indent: 120,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '|${AppLocalizations.of(context)!.pageNo} ${cubit.cuMPage}|',
                                        style: TextStyle(
                                          fontFamily: 'kufi',
                                          fontSize: 14,
                                          color: Theme.of(context)
                                              .bottomAppBarColor,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        Icons.menu_book,
                                        color:
                                            Theme.of(context).bottomAppBarColor,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                  SizedBox(
                    width: 8,
                  ),
                  Column(
                    children: [
                      GestureDetector(
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .bottomAppBarColor
                                          .withOpacity(.4),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8))),
                                ),
                                Opacity(
                                  opacity: .1,
                                  child: SvgPicture.asset(
                                    'assets/svg/alwaqf.svg',
                                    width: 90,
                                  ),
                                ),
                                SvgPicture.asset(
                                  'assets/svg/alwaqf.svg',
                                  width: 70,
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context)
                                .push(animatRoute(AlwaqfScreen()));
                          }),
                      SizedBox(
                        height: 8,
                      ),
                      GestureDetector(
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .bottomAppBarColor
                                          .withOpacity(.4),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8))),
                                ),
                                Opacity(
                                    opacity: .1,
                                    child: SvgPicture.asset(
                                      'assets/svg/menu_ic.svg',
                                      width: 110,
                                    )),
                                SvgPicture.asset(
                                  'assets/svg/menu_ic.svg',
                                  width: 80,
                                ),
                              ],
=======
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme.surface
                      .withOpacity(.2),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                // padding: EdgeInsets.all(16.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 1/4,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.lastRead,
                            style: TextStyle(
                              fontFamily: 'kufi',
                              fontSize: 14,
                              color: Theme.of(context).canvasColor,
>>>>>>> Stashed changes
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Divider(
                            endIndent: 8,
                            indent: 8,
                            height: 8,
                          ),
                          Icon(
                            Icons.menu_book,
                            color: Theme.of(context).canvasColor,
                            size: 22,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 2,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.all(Radius.circular(8))
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    SvgPicture.asset(
                      'assets/svg/surah_name/00${cubit.soMName}.svg',
                      height: 40,
                      colorFilter: ColorFilter.mode(
                          ThemeProvider.themeOf(context).id == 'dark'
                          ? Theme.of(context).canvasColor
                          : Theme.of(context).primaryColorLight,
                          BlendMode.srcIn
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Text(
                      '|${AppLocalizations.of(context)!.pageNo} ${cubit.cuMPage}|',
                      style: TextStyle(
                        fontFamily: 'kufi',
                        fontSize: 12,
                        color: ThemeProvider.themeOf(context).id == 'dark'
                            ? Theme.of(context).canvasColor
                            : Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                thickness: 1,
                height: 30,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme.surface
                      .withOpacity(.2),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    InkWell(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
<<<<<<< Updated upstream
                                  color: Theme.of(context)
                                      .bottomAppBarColor
                                      .withOpacity(.4),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8))),
                            ),
                            Opacity(
                              opacity: .1,
=======
                                color: Theme.of(context)
                                    .colorScheme.surface,
                                borderRadius: BorderRadius.all(Radius.circular(2)),
                              ),
>>>>>>> Stashed changes
                              child: SvgPicture.asset(
                                'assets/svg/alwaqf.svg',
                                width: 22,
                              ),
                            ),
                            Container(
                              width: 2,
                              height: 20,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 8),
                              color: ThemeProvider.themeOf(context)
                                  .id ==
                                  'dark'
                                  ? Colors.white
                                  : Theme.of(context).primaryColor,
                            ),
                            Text(
                              AppLocalizations.of(context)!.stopSigns,
                              style: TextStyle(
                                  color:
                                  ThemeProvider.themeOf(context)
                                      .id ==
                                      'dark'
                                      ? Colors.white
                                      : Theme.of(context)
                                      .primaryColor,
                                  fontFamily: 'kufi',
                                  fontStyle: FontStyle.italic,
                                  fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      onTap: () async {
                        Navigator.of(context)
                            .push(animatRoute(AlwaqfScreen()));
                      },
                    ),
                    const Divider(),
                    InkWell(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme.surface,
                                borderRadius: BorderRadius.all(Radius.circular(2)),
                              ),
                              child: SvgPicture.asset(
                                'assets/svg/menu_ic.svg',
                                width: 22,
                              ),
                            ),
                            Container(
                              width: 2,
                              height: 20,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 8),
                              color: ThemeProvider.themeOf(context)
                                  .id ==
                                  'dark'
                                  ? Colors.white
                                  : Theme.of(context).primaryColor,
                            ),
                            Text(
                              AppLocalizations.of(context)!.setting,
                              style: TextStyle(
                                  color:
                                  ThemeProvider.themeOf(context)
                                      .id ==
                                      'dark'
                                      ? Colors.white
                                      : Theme.of(context)
                                      .primaryColor,
                                  fontFamily: 'kufi',
                                  fontStyle: FontStyle.italic,
                                  fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      onTap: () async {
                        Navigator.of(context)
                            .push(animatRoute(const AboutApp()));
                      },
                    ),
                    const Divider(),
                    InkWell(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme.surface,
                                borderRadius: BorderRadius.all(Radius.circular(2)),
                              ),
                              child: SvgPicture.asset(
                                'assets/svg/info_ic.svg',
                                width: 22,
                              ),
                            ),
                            Container(
                              width: 2,
                              height: 20,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 8),
                              color: ThemeProvider.themeOf(context)
                                  .id ==
                                  'dark'
                                  ? Colors.white
                                  : Theme.of(context).primaryColor,
                            ),
                            Text(
                              AppLocalizations.of(context)!.aboutApp,
                              style: TextStyle(
                                  color:
                                  ThemeProvider.themeOf(context)
                                      .id ==
                                      'dark'
                                      ? Colors.white
                                      : Theme.of(context)
                                      .primaryColor,
                                  fontFamily: 'kufi',
                                  fontStyle: FontStyle.italic,
                                  fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      onTap: () async {
                        Navigator.of(context)
                            .push(animatRoute(const InfoApp()));
                      },
                    ),
                  ],
                ),
              ),
              const Divider(
                thickness: 1,
                height: 30,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme.surface
                      .withOpacity(.2),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: List<Widget>.generate(
                    cubit.reminders.length,
                        (int index) {
                      final reminder = cubit.reminders[index];
                      TextEditingController controller = TextEditingController(text: reminder.name);
                      // Create a new GlobalKey for the TextField and add it to the list
                      GlobalKey textFieldKey = GlobalKey();
                      textFieldKeys.add(textFieldKey);
                      return Dismissible(
                        background: Container(
                          decoration: const BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(8))),
                          child: delete(context),
                        ),
                        key: UniqueKey(),
                        onDismissed: (DismissDirection direction) async {
                          await cubit.deleteReminder(context, index);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
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
                                        cursorColor: Theme.of(context).dividerColor,
                                        textDirection: TextDirection.rtl,
                                        style: TextStyle(
                                            color: ThemeProvider.themeOf(context).id ==
                                                'dark'
                                                ? Colors.white
                                                : Theme.of(context).primaryColor,
                                            fontFamily: 'kufi',
                                            fontSize: 14),
                                        decoration: InputDecoration(

                                            hintText: 'اكتب اسم التذكير',
                                          hintStyle: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'kufi',
                                            color: ThemeProvider.themeOf(context).id ==
                                                'dark'
                                                ? Colors.white.withOpacity(.5)
                                                : Theme.of(context).primaryColor.withOpacity(.5),
                                          ),
                                          icon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                reminder.name = controller.text;
                                              });
                                              ReminderStorage.saveReminders(cubit.reminders);
                                            },
                                            icon: Icon(
                                              Icons.done,
                                              size: 14,
                                              color: Theme.of(context).colorScheme.surface,
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
                                  color: ThemeProvider.themeOf(context).id ==
                                      'dark'
                                      ? Colors.white
                                      : Theme.of(context).primaryColor,
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
                                    ReminderStorage.saveReminders(cubit.reminders);
                                    if (reminder.isEnabled) {
                                      // Show the TimePicker to set the reminder time
                                      bool isConfirmed = await cubit.showTimePicker(context, reminder);
                                      if (!isConfirmed) {
                                        setState(() {
                                          reminder.isEnabled = false;
                                        });
                                      }
                                    } else {
                                      // Cancel the scheduled notification
                                      NotifyHelper().cancelScheduledNotification(reminder.id);
                                    }
                                  },
                                  iconBuilder: rollingIconBuilder,
                                  borderWidth: 1,
                                  indicatorColor: Theme.of(context).colorScheme.surface,
                                  innerColor: Theme.of(context).canvasColor,
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                  height: 25,
                                  dif: 2.0,
                                  borderColor: Theme.of(context).colorScheme.surface,
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
                child: GestureDetector(
                  onTap: cubit.addReminder,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(8)),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.surface,
                        width: 1
                      )
                    ),
                      child: Text(AppLocalizations.of(context)!.addReminder,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.surface,
                        fontSize: 14,
                        fontFamily: 'kufi'
                      ),)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  },
);
  }
}

class ReminderStorage {
  static final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  static const String _storageKey = 'reminders';

  static Future<void> saveReminders(List<Reminder> reminders) async {
    SharedPreferences prefs = await _prefs;
    List<String> remindersJson = reminders.map((r) => jsonEncode(r.toJson())).toList();
    await prefs.setStringList(_storageKey, remindersJson);
  }

  static Future<List<Reminder>> loadReminders() async {
    SharedPreferences prefs = await _prefs;
    List<String> remindersJson = prefs.getStringList(_storageKey)?.cast<String>() ?? [];
    List<Reminder> reminders = remindersJson.map((r) => Reminder.fromJson(jsonDecode(r)) as Reminder).toList();
    return reminders;
  }

  static Future<void> deleteReminder(int id) async {
    List<Reminder> reminders = await loadReminders();
    reminders.removeWhere((r) => r.id == id);
    await saveReminders(reminders);
  }

}
Widget rollingIconBuilder(int value, Size iconSize, bool foreground) {
  IconData data = Icons.done;
  if (value.isEven) data = Icons.close;
  return Icon(
    data,
    size: 18,
  );
}
