import 'package:alquranalkareem/shared/controller/general_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../l10n/app_localizations.dart';
import '../../shared/widgets/lottie.dart';
import '../../shared/widgets/widgets.dart';
import '../azkar_controller.dart';

class AzkarFav extends StatefulWidget {
  const AzkarFav({Key? key}) : super(key: key);

  static double fontSizeAzkar = 20;

  @override
  State<AzkarFav> createState() => _AzkarFavState();
}

class _AzkarFavState extends State<AzkarFav> {
  late final AzkarController azkarController = Get.put(AzkarController());
  late final GeneralController generalController = Get.put(GeneralController());
  var controller = ScrollController();
  double lowerValue = 18;
  double upperValue = 40;
  String? selectedValue;

  @override
  void initState() {
    azkarController.getAzkar();
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
              if (azkarController.azkarList.isEmpty) {
                return bookmarks(150.0, 150.0);
              } else {
                return AnimationLimiter(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ListView.builder(
                        shrinkWrap: true,
                        controller: controller,
                        padding: EdgeInsets.zero,
                        itemCount: azkarController.azkarList.length,
                        itemBuilder: (BuildContext context, int index) {
                          var azkar = azkarController.azkarList[index];
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
                                  child: Dismissible(
                                    background: Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8))),
                                      child: delete(context),
                                    ),
                                    key: ValueKey<int>(azkar.id!),
                                    onDismissed: (DismissDirection direction) {
                                      azkarController.deleteAzkar(
                                          azkar, context);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface
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
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .surface,
                                                    width: 2,
                                                  ),
                                                ),
                                              ),
                                              width: double.infinity,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: Obx(() {
                                                  final controller = Get.find<
                                                      GeneralController>();
                                                  return SelectableText(
                                                    azkar.zekr!,
                                                    style: TextStyle(
                                                        color: ThemeProvider.themeOf(
                                                                        context)
                                                                    .id ==
                                                                'dark'
                                                            ? Colors.white
                                                            : Colors.black,
                                                        height: 1.4,
                                                        fontFamily: 'naskh',
                                                        fontSize: controller
                                                            .fontSizeArabic
                                                            .value),
                                                    showCursor: true,
                                                    cursorWidth: 3,
                                                    cursorColor:
                                                        Theme.of(context)
                                                            .dividerColor,
                                                    cursorRadius:
                                                        const Radius.circular(
                                                            5),
                                                    scrollPhysics:
                                                        const ClampingScrollPhysics(),
                                                    // toolbarOptions: const ToolbarOptions(
                                                    //     copy: true, selectAll: true),
                                                    textDirection:
                                                        TextDirection.rtl,
                                                    textAlign:
                                                        TextAlign.justify,
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
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8),
                                                    margin:
                                                        const EdgeInsets
                                                                .symmetric(
                                                            horizontal: 8),
                                                    decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .colorScheme
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
                                                      azkar.reference!,
                                                      style: TextStyle(
                                                          color: ThemeProvider.themeOf(
                                                                          context)
                                                                      .id ==
                                                                  'dark'
                                                              ? Colors.white
                                                              : Theme.of(
                                                                      context)
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
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 8),
                                                  margin:
                                                      const EdgeInsets.symmetric(
                                                          horizontal: 8),
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .colorScheme
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
                                                        color: ThemeProvider.themeOf(
                                                                        context)
                                                                    .id ==
                                                                'dark'
                                                            ? Colors.white
                                                            : Theme.of(context)
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
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surface
                                                      .withOpacity(.2),
                                                  border: Border.symmetric(
                                                      vertical: BorderSide(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .surface,
                                                          width: 2))),
                                              // width: double.infinity,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      IconButton(
                                                        onPressed: () {
                                                          Share.share(
                                                              '${azkar.category}\n\n'
                                                              '${azkar.zekr}\n\n'
                                                              '| ${azkar.description}. | (التكرار: ${azkar.count})');
                                                        },
                                                        icon: Icon(
                                                          Icons.share,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .surface,
                                                          size: 20,
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
                                                                      AppLocalizations.of(
                                                                              context)!
                                                                          .copyAzkarText));
                                                        },
                                                        icon: Icon(
                                                          Icons.copy,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .surface,
                                                          size: 20,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  fontSizeDropDown(context),
                                                  Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        topRight:
                                                            Radius.circular(8),
                                                        bottomRight:
                                                            Radius.circular(8),
                                                      ),
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .surface,
                                                    ),
                                                    child: Row(
                                                      // mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          azkar.count!,
                                                          style: TextStyle(
                                                              color: ThemeProvider.themeOf(
                                                                              context)
                                                                          .id ==
                                                                      'dark'
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  'kufi',
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic),
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Icon(
                                                          Icons.repeat,
                                                          color: ThemeProvider.themeOf(
                                                                          context)
                                                                      .id ==
                                                                  'dark'
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
