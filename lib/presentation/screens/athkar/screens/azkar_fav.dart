import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/lottie.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../controllers/azkar_controller.dart';
import '../../../controllers/general_controller.dart';

class AzkarFav extends StatefulWidget {
  const AzkarFav({Key? key}) : super(key: key);

  static double fontSizeAzkar = 20;

  @override
  State<AzkarFav> createState() => _AzkarFavState();
}

class _AzkarFavState extends State<AzkarFav> {
  var controller = ScrollController();
  double lowerValue = 18;
  double upperValue = 40;
  String? selectedValue;

  @override
  void initState() {
    sl<AzkarController>().getAzkar();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (sl<AzkarController>().azkarList.isEmpty) {
                return bookmarks(150.0, 150.0);
              } else {
                return AnimationLimiter(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ListView.builder(
                        shrinkWrap: true,
                        controller: controller,
                        padding: EdgeInsets.zero,
                        itemCount: sl<AzkarController>().azkarList.length,
                        itemBuilder: (BuildContext context, int index) {
                          var azkar = sl<AzkarController>().azkarList[index];
                          print(azkar.zekr);
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 450),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Get.theme.colorScheme.surface
                                            .withOpacity(.2),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(8),
                                        )),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.symmetric(
                                                vertical: BorderSide(
                                                  color: Get.theme.colorScheme
                                                      .surface,
                                                  width: 2,
                                                ),
                                              ),
                                            ),
                                            width: double.infinity,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Obx(() {
                                                final controller = Get.find<
                                                    GeneralController>();
                                                return Text(
                                                  azkar.zekr!,
                                                  style: TextStyle(
                                                      color: Get.isDarkMode
                                                          ? Colors.white
                                                          : Colors.black,
                                                      height: 1.4,
                                                      fontFamily: 'naskh',
                                                      fontSize: controller
                                                          .fontSizeArabic
                                                          .value),
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  textAlign: TextAlign.justify,
                                                );
                                              }),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                          horizontal: 8),
                                                  margin:
                                                      const EdgeInsets.symmetric(
                                                          horizontal: 8),
                                                  decoration: BoxDecoration(
                                                      color: Get.theme
                                                          .colorScheme.surface
                                                          .withOpacity(.2),
                                                      border: Border.symmetric(
                                                          vertical: BorderSide(
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .surface,
                                                              width: 2))),
                                                  child: Text(
                                                    azkar.reference!,
                                                    style: TextStyle(
                                                        color: Get.isDarkMode
                                                            ? Colors.white
                                                            : Get.theme
                                                                .primaryColorDark,
                                                        fontSize: 12,
                                                        fontFamily: 'kufi',
                                                        fontStyle:
                                                            FontStyle.italic),
                                                  ))),
                                        ),
                                        Align(
                                            alignment: Alignment.center,
                                            child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8),
                                                decoration: BoxDecoration(
                                                    color: Get.theme.colorScheme
                                                        .surface
                                                        .withOpacity(.2),
                                                    border: Border.symmetric(
                                                        vertical: BorderSide(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .surface,
                                                            width: 2))),
                                                child: Text(
                                                  azkar.description!,
                                                  style: TextStyle(
                                                      color: Get.isDarkMode
                                                          ? Colors.white
                                                          : Get.theme
                                                              .primaryColorDark,
                                                      fontSize: 16,
                                                      fontFamily: 'kufi',
                                                      fontStyle:
                                                          FontStyle.italic),
                                                ))),
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Get
                                                    .theme.colorScheme.surface
                                                    .withOpacity(.2),
                                                border: Border.symmetric(
                                                    vertical: BorderSide(
                                                        color: Get
                                                            .theme
                                                            .colorScheme
                                                            .surface,
                                                        width: 2))),
                                            // width: double.infinity,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    Share.share(
                                                        '${azkar.category}\n\n'
                                                        '${azkar.zekr}\n\n'
                                                        '| ${azkar.description}. | (التكرار: ${azkar.count})');
                                                  },
                                                  icon: Semantics(
                                                    button: true,
                                                    enabled: true,
                                                    label: 'Share thikr',
                                                    child: Icon(
                                                      Icons.share,
                                                      color: Get.theme
                                                          .colorScheme.surface,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () async {
                                                    await Clipboard.setData(
                                                            ClipboardData(
                                                                text:
                                                                    '${azkar.category}\n\n${azkar.zekr}\n\n| ${azkar.description}. | (التكرار: ${azkar.count})'))
                                                        .then((value) =>
                                                            customSnackBar(
                                                                context,
                                                                'copyAzkarText'
                                                                    .tr));
                                                  },
                                                  icon: Semantics(
                                                    button: true,
                                                    enabled: true,
                                                    label: 'Copy thikr',
                                                    child: Icon(
                                                      Icons.copy,
                                                      color: Get.theme
                                                          .colorScheme.surface,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),
                                                fontSizeDropDown(context),
                                                IconButton(
                                                    onPressed: () =>
                                                        sl<AzkarController>()
                                                            .deleteAzkar(
                                                                azkar, context),
                                                    icon: Semantics(
                                                      button: true,
                                                      enabled: true,
                                                      label: 'Delete thikr',
                                                      child: Icon(
                                                        Icons
                                                            .delete_forever_outlined,
                                                        color: Get
                                                            .theme
                                                            .colorScheme
                                                            .surface,
                                                        size: 24,
                                                      ),
                                                    )),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(8),
                                                      bottomRight:
                                                          Radius.circular(8),
                                                    ),
                                                    color: Get.theme.colorScheme
                                                        .surface,
                                                  ),
                                                  child: Row(
                                                    // mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        azkar.count!,
                                                        style: TextStyle(
                                                            color: Get
                                                                    .isDarkMode
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize: 14,
                                                            fontFamily: 'kufi',
                                                            fontStyle: FontStyle
                                                                .italic),
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Icon(
                                                        Icons.repeat,
                                                        color: Get.isDarkMode
                                                            ? Colors.white
                                                            : Colors.black,
                                                        size: 20,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                );
              }
            }),
          )
        ],
      ),
    );
  }
}
