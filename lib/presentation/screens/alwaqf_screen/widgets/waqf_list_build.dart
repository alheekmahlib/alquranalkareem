import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '/core/utils/constants/extensions/svg_extensions.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/lists.dart';
import '../../../../core/utils/constants/svg_constants.dart';
import '../../../controllers/general/general_controller.dart';
import '../../adhkar/controller/adhkar_controller.dart';

class WaqfListBuild extends StatelessWidget {
  WaqfListBuild({super.key});

  final generalCtrl = GeneralController.instance;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height,
      child: ScrollablePositionedList.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        addAutomaticKeepAlives: true,
        itemScrollController: generalCtrl.state.waqfScrollController,
        itemCount: waqfMarks.length,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
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
                            child: SvgPicture.asset(
                              waqfMarks[index],
                              height: 70,
                              width: 70,
                              colorFilter: ColorFilter.mode(
                                  Theme.of(context).colorScheme.primary,
                                  BlendMode.srcIn),
                            )),
                      ),
                      Center(
                        child: customSvg(
                          SvgPath.svgSplashIcon,
                          height: 60,
                        ),
                      ),
                      Obx(() {
                        return RichText(
                          text: TextSpan(
                            children: sl<AzkarController>()
                                .buildTextSpans(waqfExplain[index]),
                            style: TextStyle(
                              fontSize: sl<GeneralController>()
                                  .state
                                  .fontSizeArabic
                                  .value,
                              fontFamily: 'naskh',
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                            ),
                          ),
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.justify,
                        );
                      }),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: customSvg(
                            SvgPath.svgSpaceLine,
                            height: 30,
                            width: MediaQuery.of(context).size.width / 1 / 4,
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
    );
  }
}
