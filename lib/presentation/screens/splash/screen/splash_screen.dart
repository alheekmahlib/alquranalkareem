import 'package:alquranalkareem/core/utils/constants/extensions/svg_extensions.dart';
import 'package:alquranalkareem/core/utils/constants/svg_constants.dart';
import 'package:alquranalkareem/presentation/screens/splash/screen/widgets/alheekmah_and_loading.dart';
import 'package:alquranalkareem/presentation/screens/splash/screen/widgets/logo_and_title.dart';
import 'package:flutter/material.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/extensions/extensions.dart';
import '../controller/controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: context.customOrientation(
            Stack(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 48.0),
                    child: Opacity(
                      opacity: .4,
                      child: customSvg(
                        SvgPath.svgSplashIconHalfS,
                        height: MediaQuery.sizeOf(context).width * .4,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                      padding: const EdgeInsets.only(top: 56.0),
                      child:
                          sl<SplashScreenController>().ramadhanOrEidGreeting()),
                ),
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: AlheekmahAndLoading(),
                ),
                const Align(
                  alignment: Alignment.center,
                  child: LogoAndTitle(),
                ),
              ],
            ),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: LogoAndTitle(),
                      ),
                      Expanded(
                        flex: 4,
                        child: AlheekmahAndLoading(),
                      )
                    ],
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: sl<SplashScreenController>().ramadhanOrEidGreeting(),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: customSvg(
                      SvgPath.svgSplashIconHalfS,
                      height: MediaQuery.sizeOf(context).width * .25,
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
