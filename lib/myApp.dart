import 'package:alquranalkareem/notes/cubit/note_cubit.dart';
import 'package:alquranalkareem/quran_page/cubit/audio/cubit.dart';
import 'package:alquranalkareem/quran_page/cubit/bookmarks/bookmarks_cubit.dart';
<<<<<<< HEAD
import 'package:alquranalkareem/quran_text/cubit/quran_text_cubit.dart';
=======
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
import 'package:alquranalkareem/screens/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/cubit.dart';

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
    required this.theme,
  }) : super(key: key);
  final ThemeData theme;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //     statusBarColor: Theme.of(context).primaryColorDark
    // ));
    // page.QuranCubit cubit = page.QuranCubit.get(context);

    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return ThemeProvider(
      defaultThemeId: 'green',
      saveThemesOnChange: true,
      loadThemeOnInit: false,
      onInitCallback: (controller, previouslySavedThemeFuture) async {
        String? savedTheme = await previouslySavedThemeFuture;
        if (savedTheme != null) {
          controller.setTheme(savedTheme);
        } else {
          Brightness platformBrightness =
              SchedulerBinding.instance.window.platformBrightness ??
                  Brightness.light;
          if (platformBrightness == Brightness.dark) {
            controller.setTheme('dark');
          } else {
            controller.setTheme('green');
          }
          controller.forgetSavedTheme();
        }
      },
      themes: <AppTheme>[
        AppTheme(
          id: 'green',
          description: "My Custom Theme",
          data: ThemeData(
<<<<<<< HEAD
            colorScheme: ColorScheme(
                brightness: Brightness.light,
                primary: const Color(0xff232c13),
                onPrimary: const Color(0xff161f07),
                secondary: const Color(0xff39412a),
                onSecondary: const Color(0xff39412a),
                error: const Color(0xff91a57d),
                onError: const Color(0xff91a57d),
                background: const Color(0xfff3efdf),
                onBackground: const Color(0xfff3efdf),
                surface: const Color(0xff91a57d),
                onSurface: const Color(0xff91a57d),),
            primaryColor: const Color(0xff232c13),
            primaryColorLight: const Color(0xff39412a),
            primaryColorDark: const Color(0xff161f07),
=======
            primaryColor: const Color(0xff232c13),
            primaryColorLight: const Color(0xff39412a),
            primaryColorDark: const Color(0xff161f07),
            bottomAppBarColor: const Color(0xff91a57d),
            backgroundColor: const Color(0xfff3efdf),
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
            dialogBackgroundColor: const Color(0xfff2f1da),
            dividerColor: const Color(0xffcdba72),
            highlightColor: const Color(0xff91a57d).withOpacity(0.3),
            indicatorColor: const Color(0xffcdba72),
<<<<<<< HEAD
=======
            toggleableActiveColor: const Color(0xffcdba72),
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
            scaffoldBackgroundColor: const Color(0xff232c13),
            canvasColor: const Color(0xfff3efdf),
            hoverColor: const Color(0xfff2f1da).withOpacity(0.3),
            disabledColor: const Color(0Xffffffff),
            hintColor: const Color(0xff232c13),
            focusColor: const Color(0xff91a57d),
            secondaryHeaderColor: const Color(0xff39412a),
            cardColor: const Color(0xff232c13),
            textSelectionTheme: TextSelectionThemeData(
                selectionColor: const Color(0xff91a57d).withOpacity(0.3),
                selectionHandleColor: const Color(0xff91a57d)),
            cupertinoOverrideTheme: const CupertinoThemeData(
              primaryColor: Color(0xff606c38),
            ),
          ),
        ),
        AppTheme(
          id: 'blue',
          description: "My Custom Theme",
          data: ThemeData(
<<<<<<< HEAD
            colorScheme: ColorScheme(
              brightness: Brightness.light,
              primary: const Color(0xffbc6c25),
              onPrimary: const Color(0xff814714),
              secondary: const Color(0xfffcbb76),
              onSecondary: const Color(0xfffcbb76),
              error: const Color(0xff606c38),
              onError: const Color(0xff606c38),
              background: const Color(0xfffefae0),
              onBackground: const Color(0xfffefae0),
              surface: const Color(0xff606c38),
              onSurface: const Color(0xff606c38),),
            primaryColor: const Color(0xffbc6c25),
            primaryColorLight: const Color(0xfffcbb76),
            primaryColorDark: const Color(0xff814714),
=======
            primaryColor: const Color(0xffbc6c25),
            primaryColorLight: const Color(0xfffcbb76),
            primaryColorDark: const Color(0xff814714),
            bottomAppBarColor: const Color(0xff606c38),
            backgroundColor: const Color(0xfffefae0),
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
            dialogBackgroundColor: const Color(0xfffefae0),
            dividerColor: const Color(0xfffcbb76),
            highlightColor: const Color(0xfffcbb76).withOpacity(0.3),
            indicatorColor: const Color(0xfffcbb76),
<<<<<<< HEAD
=======
            toggleableActiveColor: const Color(0xff606c38),
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
            scaffoldBackgroundColor: const Color(0xff814714),
            canvasColor: const Color(0xffF2E5D5),
            hoverColor: const Color(0xffF2E5D5).withOpacity(0.3),
            disabledColor: const Color(0Xffffffff),
            hintColor: const Color(0xff814714),
            focusColor: const Color(0xffbc6c25),
            secondaryHeaderColor: const Color(0xffbc6c25),
            cardColor: const Color(0xff814714),
            textSelectionTheme: TextSelectionThemeData(
                selectionColor: const Color(0xff606c38).withOpacity(0.3),
                selectionHandleColor: const Color(0xff606c38)),
            cupertinoOverrideTheme: const CupertinoThemeData(
              primaryColor: Color(0xff606c38),
            ),
          ),
        ),
        AppTheme(
          id: 'dark',
          description: "My Custom Theme",
          data: ThemeData(
<<<<<<< HEAD
            colorScheme: ColorScheme(
              brightness: Brightness.light,
              primary: const Color(0xff3F3F3F),
              onPrimary: const Color(0xff2d2d2d),
              secondary: const Color(0xff4d4d4d),
              onSecondary: const Color(0xff4d4d4d),
              error: const Color(0xff91a57d),
              onError: const Color(0xff91a57d),
              background: const Color(0xff3F3F3F),
              onBackground: const Color(0xff3F3F3F),
              surface: const Color(0xff91a57d),
              onSurface: const Color(0xff91a57d),),
            primaryColor: const Color(0xff3F3F3F),
            primaryColorLight: const Color(0xff4d4d4d),
            primaryColorDark: const Color(0xff2d2d2d),
=======
            primaryColor: const Color(0xff3F3F3F),
            primaryColorLight: const Color(0xff4d4d4d),
            primaryColorDark: const Color(0xff2d2d2d),
            bottomAppBarColor: const Color(0xff91a57d),
            backgroundColor: const Color(0xff3F3F3F),
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
            dialogBackgroundColor: const Color(0xff3F3F3F),
            dividerColor: const Color(0xff91a57d),
            highlightColor: const Color(0xff91a57d).withOpacity(0.3),
            indicatorColor: const Color(0xff91a57d),
<<<<<<< HEAD
=======
            toggleableActiveColor: const Color(0xff91a57d),
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
            scaffoldBackgroundColor: const Color(0xff2d2d2d),
            canvasColor: const Color(0xfff3efdf),
            hoverColor: const Color(0xfff2f1da).withOpacity(0.3),
            disabledColor: const Color(0Xffffffff),
            hintColor: const Color(0xff2d2d2d),
            focusColor: const Color(0xff91a57d),
            secondaryHeaderColor: const Color(0xff91a57d),
            cardColor: const Color(0xfff3efdf),
            textSelectionTheme: TextSelectionThemeData(
                selectionColor: const Color(0xff91a57d).withOpacity(0.3),
                selectionHandleColor: const Color(0xff91a57d)),
            cupertinoOverrideTheme: const CupertinoThemeData(
              primaryColor: Color(0xff606c38),
            ),
          ),
        ),
      ],
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: MultiBlocProvider(
          providers: [
            BlocProvider<QuranCubit>(
              create: (BuildContext context) => QuranCubit(),
            ),
            BlocProvider<AudioCubit>(
              create: (BuildContext context) => AudioCubit(),
            ),
            BlocProvider<NotesCubit>(
              create: (BuildContext context) => NotesCubit(),
            ),
            BlocProvider<BookmarksCubit>(
              create: (BuildContext context) => BookmarksCubit(),
            ),
<<<<<<< HEAD
            BlocProvider<QuranTextCubit>(
              create: (BuildContext context) => QuranTextCubit(),
            ),
=======
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
          ],
          child: SplashScreen(),
          // child: const HomePage(),
        ),
      ),
    );
  }
}
