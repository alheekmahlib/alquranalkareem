import 'package:alquranalkareem/core/utils/constants/extensions/alignment_rotated_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '/core/utils/constants/extensions/svg_extensions.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/svg_constants.dart';
import '../../../controllers/general/general_controller.dart';
import '../../adhkar/controller/adhkar_controller.dart';
import '../controller/waqf_controller.dart';

class WaqfListBuild extends StatelessWidget {
  WaqfListBuild({super.key});

  final generalCtrl = GeneralController.instance;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.sizeOf(context).height,
        child: GetX<WaqfController>(
          builder: (waqfCtrl) => ScrollablePositionedList.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            addAutomaticKeepAlives: true,
            itemScrollController: generalCtrl.state.waqfScrollController,
            itemCount: waqfCtrl.waqfList.length,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              final waqf = waqfCtrl.waqfList[index];
              return Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    width: MediaQuery.sizeOf(context).width,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Align(
                                alignment: Alignment.topCenter,
                                child: customSvgWithColor(
                                  waqf.image,
                                  height: 70,
                                  width: 70,
                                )),
                          ),
                          Center(
                            child: customSvgWithColor(
                              SvgPath.svgSplashIcon,
                              height: 60,
                            ),
                          ),
                          Obx(() {
                            return RichText(
                              text: TextSpan(
                                children: sl<AzkarController>().buildTextSpans(
                                    waqf.translations.values.first),
                                style: TextStyle(
                                  fontSize: sl<GeneralController>()
                                      .state
                                      .fontSizeArabic
                                      .value,
                                  fontFamily: 'naskh',
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                ),
                              ),
                              textDirection: alignmentLayout(
                                  TextDirection.rtl, TextDirection.ltr),
                              textAlign: TextAlign.justify,
                            );
                          }),
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: customSvgWithColor(
                                SvgPath.svgSpaceLine,
                                height: 30,
                                width:
                                    MediaQuery.of(context).size.width / 1 / 4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ));
  }

  // Obx(() {
  //     // Display Waqf data dynamically.
  //     // عرض بيانات الوقف بشكل ديناميكي.
  //     return SizedBox(
  //       height: MediaQuery.sizeOf(context).height,
  //       child: ListView.builder(
  //         itemCount: waqfCtrl.waqfList.length,
  //         itemBuilder: (context, index) {
  //           final waqf = waqfCtrl.waqfList[index];
  //           return Stack(
  //             children: [
  //               Container(
  //                 margin:
  //                     const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  //                 width: MediaQuery.sizeOf(context).width,
  //                 decoration: BoxDecoration(
  //                     color: Theme.of(context).colorScheme.primaryContainer,
  //                     borderRadius: const BorderRadius.all(Radius.circular(8)),
  //                     border: Border.all(
  //                         color: Theme.of(context).colorScheme.primary,
  //                         width: 1)),
  //                 child: Padding(
  //                   padding: const EdgeInsets.symmetric(horizontal: 32),
  //                   child: Column(
  //                     children: [
  //                       Padding(
  //                         padding: const EdgeInsets.only(top: 16.0),
  //                         child: Align(
  //                             alignment: Alignment.topCenter,
  //                             child: SvgPicture.asset(
  //                               waqf.image,
  //                               height: 70,
  //                               width: 70,
  //                               colorFilter: ColorFilter.mode(
  //                                   Theme.of(context).colorScheme.primary,
  //                                   BlendMode.srcIn),
  //                             )),
  //                       ),
  //                       Center(
  //                         child: Text(
  //                           waqf.translations.values.first,
  //                           style: TextStyle(
  //                             fontSize: 16,
  //                             fontFamily: 'naskh',
  //                             color:
  //                                 Theme.of(context).colorScheme.inversePrimary,
  //                           ),
  //                           textAlign: TextAlign.justify,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           );
  //         },
  //       ),
  //     );
  //   });
}
