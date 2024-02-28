import 'package:flutter/material.dart';

import '../../../core/utils/constants/extensions/extensions.dart';
import '../../../core/utils/constants/svg_picture.dart';
import '/presentation/screens/splashScreen/widgets/logo_and_title.dart';
import 'widgets/alheekmah_and_loading.dart';

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
                const Align(
                  alignment: Alignment.center,
                  child: LogoAndTitle(),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 64.0),
                    child: splash_icon_half_s(
                      height: MediaQuery.sizeOf(context).width * .5,
                    ),
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
