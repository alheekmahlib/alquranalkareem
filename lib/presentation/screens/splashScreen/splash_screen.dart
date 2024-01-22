import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/services_locator.dart';
import '../../../core/utils/constants/lottie.dart';
import '../../controllers/audio_controller.dart';
import '../../controllers/ayat_controller.dart';
import '../../controllers/bookmarks_controller.dart';
import '../../controllers/general_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../controllers/translate_controller.dart';
import '../home/home_screen.dart';
import '../onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  bool animate = false;

  @override
  initState() {
    sl<AyatController>().loadTafseer();
    sl<TranslateDataController>().loadTranslateValue();
    sl<SettingsController>().loadLang();
    sl<AudioController>().loadQuranReader();
    sl<BookmarksController>().getBookmarksList();

    sl<GeneralController>().getLastPageAndFontSize();
    sl<GeneralController>().updateGreeting();

    startTime();
    super.initState();
  }

  Future startTime() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      animate = true;
    });
    await Future.delayed(const Duration(seconds: 3));
    // Get.off(() => OnboardingScreen());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigationPage();
    });
  }

  Widget? myWidget;
  void navigationPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('is_first_time ${prefs.getBool("is_first_time")}');
    if (prefs.getBool("is_first_time") == null) {
      Get.off(() => const OnboardingScreen());
      prefs.setBool("is_first_time", false);
    } else {
      Get.off(() => const HomeScreen());
    }
    // Get.off(() => OnboardingScreen());
    // Navigator.of(context).pushReplacementNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3efdf),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/svg/splash_icon.svg',
                    height: 120,
                    width: 120,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ClipPath(
                      clipper: const ShapeBorderClipper(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)))),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                            color: const Color(0xff91a57d).withOpacity(.2),
                            border: const Border.symmetric(
                                vertical: BorderSide(
                                    color: Color(0xff91a57d), width: 2))),
                        child: AnimatedOpacity(
                          duration: const Duration(seconds: 1),
                          opacity: animate ? 1 : 0,
                          child: const Text(
                            'وَرَتِّلِ الْقُرْآنَ تَرْتِيلًا',
                            style: TextStyle(
                                fontFamily: 'kufi',
                                color: Color(0xff39412a),
                                fontSize: 18),
                          ),
                        ),
                      )),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/svg/alheekmah_logo.svg',
                      colorFilter: const ColorFilter.mode(
                          Color(0xff39412a), BlendMode.srcIn),
                      width: 90,
                    ),
                    Transform.translate(
                      offset: const Offset(0, 30),
                      child: RotatedBox(
                        quarterTurns: 2,
                        child: loading(width: 250.0),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
