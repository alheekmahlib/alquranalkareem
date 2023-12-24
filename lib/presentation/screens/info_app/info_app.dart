import 'package:alquranalkareem/core/services/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../../core/widgets/widgets.dart';

class InfoApp extends StatelessWidget {
  const InfoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      right: false,
      left: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Padding(
          padding: orientation(
              context,
              const EdgeInsets.only(top: 80.0, bottom: 16.0),
              const EdgeInsets.only(top: 20.0, bottom: 16.0)),
          child: Align(
            alignment: Alignment.topCenter,
            child: Stack(
              children: [
                customClose2(context),
                const Divider(
                  height: 58,
                  thickness: 2,
                  endIndent: 16,
                  indent: 16,
                ),
                Padding(
                  padding: orientation(
                      context,
                      const EdgeInsets.only(top: 30, right: 16, left: 16),
                      const EdgeInsets.only(top: 30, right: 64, left: 64)),
                  child: ListView(
                    children: [
                      Center(
                        child: SizedBox(
                            height: 80,
                            width: MediaQuery.sizeOf(context).width * 3 / 4,
                            child: SvgPicture.asset(
                              'assets/svg/Logo_line2.svg',
                            )),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .surface
                                .withOpacity(.2),
                            border: Border.symmetric(
                                vertical: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    width: 2))),
                        child: Text(
                          AppLocalizations.of(context)!.about_us,
                          style: TextStyle(
                            color: ThemeProvider.themeOf(context).id == 'dark'
                                ? Colors.white
                                : Theme.of(context).primaryColor,
                            fontSize: 18,
                            fontFamily: 'kufi',
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .surface
                                .withOpacity(.2),
                            border: Border.symmetric(
                                vertical: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    width: 2))),
                        child: Text(
                          AppLocalizations.of(context)!.about_app,
                          style: TextStyle(
                            color: ThemeProvider.themeOf(context).id == 'dark'
                                ? Colors.white
                                : Theme.of(context).primaryColor,
                            height: 1.7,
                            fontSize: 15,
                            fontFamily: 'kufi',
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 32.0,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .surface
                                .withOpacity(.2),
                            border: Border.symmetric(
                                vertical: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    width: 2))),
                        child: Text(
                          AppLocalizations.of(context)!.about_app2,
                          style: TextStyle(
                            color: ThemeProvider.themeOf(context).id == 'dark'
                                ? Colors.white
                                : Theme.of(context).primaryColor,
                            fontSize: 18,
                            fontFamily: 'kufi',
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .surface
                                .withOpacity(.2),
                            border: Border.symmetric(
                                vertical: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    width: 2))),
                        child: Text(
                          AppLocalizations.of(context)!.about_app3,
                          style: TextStyle(
                            color: ThemeProvider.themeOf(context).id == 'dark'
                                ? Colors.white
                                : Theme.of(context).primaryColor,
                            height: 1.7,
                            fontSize: 15,
                            fontFamily: 'kufi',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
