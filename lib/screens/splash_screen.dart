import 'dart:async';
import 'package:alquranalkareem/cubit/cubit.dart';
import 'package:alquranalkareem/home_page.dart';
import 'package:alquranalkareem/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../shared/widgets/lottie.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool animate = false;


  @override
  void initState() {
    startTime();
    QuranCubit.get(context).loadLang();
    QuranCubit.get(context).loadMCurrentPage();
    QuranCubit.get(context).loadTafseer();
    QuranCubit.get(context).loadFontSize();
    print('cubit.showTaf ${QuranCubit.get(context).showTaf}');
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
      // Navigator.pushReplacement<void, void>(
      //   context,
      //   MaterialPageRoute<void>(
      //     builder: (BuildContext context) => OnboardingScreen(),
      //   ),
      // );
      Get.off(() => OnboardingScreen());
      prefs.setBool("is_first_time", false);
    } else {
      // Navigator.pushReplacement<void, void>(
      //   context,
      //   MaterialPageRoute<void>(
      //     builder: (BuildContext context) => const HomePage(),
      //   ),
      // );
      Get.off(() => const HomePage());
    }
    // Get.off(() => OnboardingScreen());
    // Navigator.of(context).pushReplacementNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                                      color: Color(0xff91a57d),
                                      width: 2))),
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/svg/alheekmah_logo.svg',
                    colorFilter: const ColorFilter.mode(Color(0xff39412a), BlendMode.srcIn),
                        width: 90,
                      ),
                      RotatedBox(
                        quarterTurns: 2,
                        child: loading(140.0, 30.0),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
