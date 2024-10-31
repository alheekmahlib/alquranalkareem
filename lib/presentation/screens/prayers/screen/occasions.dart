import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/extensions.dart';
import '/core/utils/constants/extensions/svg_extensions.dart';
import '/core/utils/constants/svg_constants.dart';
import '../../../controllers/general/general_controller.dart';
import '../prayer_settings.dart';
import '../prayer_widget.dart';

class OccasionsWidget extends StatelessWidget {
  OccasionsWidget({super.key});

  final generalCtrl = GeneralController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          GestureDetector(
            onTap: () =>
                Get.bottomSheet(PrayerSettings(), isScrollControlled: true),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: customSvgWithColor(SvgPath.svgOptions,
                  height: 30.0,
                  width: 30.0,
                  color: Get.theme.colorScheme.secondary),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          color: Theme.of(context).colorScheme.primary,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(
                  'assets/svg/hijri/${generalCtrl.state.today.hMonth}.svg',
                  width: Get.width,
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).canvasColor.withOpacity(.05),
                      BlendMode.srcIn)),
              context.customOrientation(
                  ListView(
                      padding: EdgeInsets.zero,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        Obx(
                          () => !generalCtrl.state.activeLocation.value
                              ? Container(
                                  height: 80,
                                  width: Get.width,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 16.0),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 16.0),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .canvasColor
                                        .withOpacity(.1),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 7,
                                        child: Text(
                                          'يرجى تفعيل تحديد الموقع لتفعيل أوقات الصلاة',
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontFamily: 'naskh',
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .canvasColor
                                                .withOpacity(.7),
                                          ),
                                        ),
                                      ),
                                      const Gap(32),
                                      Expanded(
                                        flex: 2,
                                        child: Switch(
                                          value: generalCtrl
                                              .state.activeLocation.value,
                                          activeColor: Colors.red,
                                          inactiveTrackColor: Theme.of(context)
                                              .colorScheme
                                              .surface
                                              .withOpacity(.5),
                                          onChanged: (bool value) => generalCtrl
                                              .toggleLocationService(),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : PrayerWidget(),
                        ),
                      ]),
                  Row(
                    children: [
                      Expanded(
                          flex: 4,
                          child: ListView(
                            children: [
                              const Gap(16.0),
                              Obx(
                                () => !generalCtrl.state.activeLocation.value
                                    ? Container(
                                        height: 80,
                                        width: Get.width,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 16.0),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 16.0),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .canvasColor
                                              .withOpacity(.1),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(8)),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              flex: 7,
                                              child: Text(
                                                'يرجى تفعيل تحديد الموقع لتفعيل أوقات الصلاة',
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontFamily: 'naskh',
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context)
                                                      .canvasColor
                                                      .withOpacity(.7),
                                                ),
                                              ),
                                            ),
                                            const Gap(32),
                                            Expanded(
                                              flex: 2,
                                              child: Switch(
                                                value: generalCtrl
                                                    .state.activeLocation.value,
                                                activeColor: Colors.red,
                                                inactiveTrackColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .surface
                                                        .withOpacity(.5),
                                                onChanged: (bool value) =>
                                                    generalCtrl
                                                        .toggleLocationService(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : PrayerWidget(),
                              ),
                            ],
                          )),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
