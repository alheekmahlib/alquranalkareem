import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hijri/hijri_calendar.dart';

import '../../../../core/widgets/widgets.dart';
import '../widgets/widgets.dart';
import '/core/utils/constants/extensions.dart';
import '/presentation/screens/quran_text/screens/surah_list_text.dart';

class SurahTextScreen extends StatelessWidget {
  const SurahTextScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Get.theme.colorScheme.background,
        appBar: AppBar(
          backgroundColor: Get.theme.colorScheme.background,
        ),
        body: Container(
          decoration: BoxDecoration(
              color: Get.theme.colorScheme.background,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              border:
                  Border.all(width: 2, color: Get.theme.colorScheme.surface)),
          child: context.definePlatform(
            context.customOrientation(
              Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: topBar(context),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Divider(
                    height: 1,
                    thickness: 2,
                    endIndent: 16,
                    indent: 16,
                  ),
                  Expanded(
                    flex: 7,
                    child: SizedBox(
                        // height: MediaQuery.sizeOf(context).height * 3 / 4,
                        width: MediaQuery.sizeOf(context).width,
                        child: SorahListText()),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: SizedBox(
                        // height: MediaQuery.sizeOf(context).height * 3 / 4,
                        width: MediaQuery.sizeOf(context).width,
                        child: SorahListText()),
                  ),
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: context.customOrientation(
                          const EdgeInsets.only(
                              right: 16.0, left: 16.0, top: 40.0),
                          const EdgeInsets.only(right: 16.0, left: 16.0)),
                      child: topBar(context),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  flex: 5,
                  child: SorahListText(),
                ),
                Expanded(
                  flex: 5,
                  child: SizedBox(child: topBar(context)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget topBar(BuildContext context) {
    var _today = HijriCalendar.now();
    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: .1,
          child: SvgPicture.asset(
            'assets/svg/hijri/${_today.hMonth}.svg',
            width: MediaQuery.sizeOf(context).width,
            colorFilter: ColorFilter.mode(
                Get.theme.colorScheme.surface, BlendMode.srcIn),
          ),
        ),
        Align(
          alignment:
              context.customOrientation(Alignment.topCenter, Alignment.center),
          child: Container(
            // height: context.definePlatform(100.0, 150.0),
            width: context.definePlatform(110.0, 160.0),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                border:
                    Border.all(color: Get.theme.colorScheme.surface, width: 1)),
            padding: const EdgeInsets.only(top: 4),
            margin: const EdgeInsets.only(top: 16.0),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: context.definePlatform(50.0, 75.0),
                  width: context.definePlatform(105.0, 155.0),
                  decoration: BoxDecoration(
                      color: Get.theme.colorScheme.surface,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(8),
                        topLeft: Radius.circular(8),
                      )),
                ),
                hijriDate2(context),
              ],
            ),
          ),
        ),
        context.customOrientation(
          Align(
            alignment: Alignment.bottomLeft,
            child: greeting(context),
          ),
          Align(
            alignment: Alignment.topRight,
            child: greeting(context),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Row(
            children: [
              bookmarksTextList(
                  context,
                  context.customOrientation(
                      MediaQuery.sizeOf(context).width * .9,
                      context.definePlatform(
                          MediaQuery.sizeOf(context).width * .5,
                          MediaQuery.sizeOf(context).width * .5))),
              quranTextSearch(
                  context,
                  context.customOrientation(
                      MediaQuery.sizeOf(context).width * .9,
                      context.definePlatform(
                          MediaQuery.sizeOf(context).width * .5,
                          MediaQuery.sizeOf(context).width * .5))),
              notesListText(
                  context,
                  context.customOrientation(
                      MediaQuery.sizeOf(context).width * .9,
                      context.definePlatform(
                          MediaQuery.sizeOf(context).width * .5,
                          MediaQuery.sizeOf(context).width * .5))),
            ],
          ),
        ),
      ],
    );
  }
}
