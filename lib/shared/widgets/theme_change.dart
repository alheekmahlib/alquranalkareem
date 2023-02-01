import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';
import '../../l10n/app_localizations.dart';

class ThemeChange extends StatefulWidget {
  const ThemeChange({Key? key}) : super(key: key);

  @override
  State<ThemeChange> createState() => _ThemeChangeState();
}

class _ThemeChangeState extends State<ThemeChange> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          child: SizedBox(
            height: 30,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(2.0)),
                    border:
                        Border.all(color: const Color(0xff91a57d), width: 2),
                    color: const Color(0xff39412a),
                  ),
                  child: ThemeProvider.themeOf(context).id == 'green'
                      ? const Icon(Icons.done,
                          size: 14, color: Color(0xffF27127))
                      : null,
                ),
                const SizedBox(
                  width: 16.0,
                ),
                Text(
                  AppLocalizations.of(context)!.green,
                  style: TextStyle(
                    color: ThemeProvider.themeOf(context).id == 'green'
                        ? const Color(0xffF27127)
                        : const Color(0xffcdba72),
                    fontSize: 14,
                    fontFamily: 'kufi',
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            ThemeProvider.controllerOf(context).setTheme('green');
          },
        ),
        InkWell(
          child: SizedBox(
            height: 30,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(2.0)),
                    border:
                        Border.all(color: const Color(0xffbc6c25), width: 2),
                    color: const Color(0xff814714),
                  ),
                  child: ThemeProvider.themeOf(context).id == 'blue'
                      ? const Icon(Icons.done,
                          size: 14, color: Color(0xffF27127))
                      : null,
                ),
                const SizedBox(
                  width: 16.0,
                ),
                Text(
                  AppLocalizations.of(context)!.brown,
                  style: TextStyle(
                    color: ThemeProvider.themeOf(context).id == 'blue'
                        ? const Color(0xffF27127)
                        : const Color(0xffcdba72),
                    fontSize: 14,
                    fontFamily: 'kufi',
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            ThemeProvider.controllerOf(context).setTheme('blue');
          },
        ),
        InkWell(
          child: SizedBox(
            height: 30,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(2.0)),
                    border:
                        Border.all(color: const Color(0xff4d4d4d), width: 2),
                    color: const Color(0xff2d2d2d),
                  ),
                  child: ThemeProvider.themeOf(context).id == 'dark'
                      ? const Icon(Icons.done,
                          size: 14, color: Color(0xffF27127))
                      : null,
                ),
                const SizedBox(
                  width: 16.0,
                ),
                Text(
                  AppLocalizations.of(context)!.dark,
                  style: TextStyle(
                    color: ThemeProvider.themeOf(context).id == 'dark'
                        ? const Color(0xffF27127)
                        : const Color(0xffcdba72),
                    fontSize: 14,
                    fontFamily: 'kufi',
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            ThemeProvider.controllerOf(context).setTheme('dark');
          },
        ),
      ],
    );
  }
}

class MThemeChange extends StatefulWidget {
  const MThemeChange({Key? key}) : super(key: key);

  @override
  State<MThemeChange> createState() => _MThemeChangeState();
}

class _MThemeChangeState extends State<MThemeChange> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: 50,
      child: Column(
        children: [
          GestureDetector(
            child: CircleAvatar(
              backgroundColor: const Color(0xff91a57d),
              radius: 20,
              child: CircleAvatar(
                backgroundColor: const Color(0xff39412a),
                radius: 15,
                child: Icon(Icons.done,
                    size: 14,
                    color: ThemeProvider.themeOf(context).id == 'green'
                        ? const Color(0xffF27127)
                        : Colors.transparent),
              ),
            ),
            onTap: () => ThemeProvider.controllerOf(context).setTheme('green'),
          ),
          Container(
            height: 4,
          ),
          GestureDetector(
            child: CircleAvatar(
              backgroundColor: const Color(0xffbc6c25),
              radius: 20,
              child: CircleAvatar(
                backgroundColor: const Color(0xff814714),
                radius: 15,
                child: Icon(Icons.done,
                    size: 14,
                    color: ThemeProvider.themeOf(context).id == 'blue'
                        ? const Color(0xffF27127)
                        : Colors.transparent),
              ),
            ),
            onTap: () => ThemeProvider.controllerOf(context).setTheme('blue'),
          ),
          Container(
            height: 4,
          ),
          GestureDetector(
            child: CircleAvatar(
              backgroundColor: const Color(0xff4d4d4d),
              radius: 20,
              child: CircleAvatar(
                backgroundColor: const Color(0xff2d2d2d),
                radius: 15,
                child: Icon(Icons.done,
                    size: 14,
                    color: ThemeProvider.themeOf(context).id == 'dark'
                        ? const Color(0xffF27127)
                        : Colors.transparent),
              ),
            ),
            onTap: () => ThemeProvider.controllerOf(context).setTheme('dark'),
          ),
        ],
      ),
    );
  }
}
