import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/constants/svg_picture.dart';
import '/core/utils/constants/extensions.dart';
import '/presentation/screens/splashScreen/widgets/logo_and_title.dart';
import 'widgets/alheekmah_and_loading.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.colorScheme.primary,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: context.customOrientation(
            Stack(
              children: [
                const Align(
                  alignment: Alignment.center,
                  child: LogoAndTitle(),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: quran_ic_s(
                    width: 600.0,
                    height: 300.0,
                  ),
                ),
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: AlheekmahAndLoading(),
                )
              ],
            ),
            Center(
              child: Stack(
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
                    alignment: Alignment.topLeft,
                    child: quran_ic_s(
                      width: 600.0,
                      height: 300.0,
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
