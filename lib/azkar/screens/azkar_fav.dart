import 'package:another_xlider/another_xlider.dart';
import 'package:another_xlider/models/handler.dart';
import 'package:another_xlider/models/handler_animation.dart';
import 'package:another_xlider/models/trackbar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../cubit/cubit.dart';
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
                                                child: SelectableText(
                                                  azkar.zekr!,
                                                  style: TextStyle(
                                                      color:
                                                          ThemeProvider.themeOf(
                                                                          context)
                                                                      .id ==
                                                                  'dark'
                                                              ? Colors.white
                                                              : Colors.black,
                                                      height: 1.4,
                                                      fontFamily: 'naskh',
                                                      fontSize: AzkarFav
                                                          .fontSizeAzkar),
                                                  showCursor: true,
                                                  cursorWidth: 3,
                                                  cursorColor: Theme.of(context)
                                                      .dividerColor,
                                                  cursorRadius:
                                                      const Radius.circular(5),
                                                  scrollPhysics:
                                                      const ClampingScrollPhysics(),
                                                  // toolbarOptions: const ToolbarOptions(
                                                  //     copy: true, selectAll: true),
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  textAlign: TextAlign.justify,
                                                ),
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

  Widget fontSizeDropDown(BuildContext context) {
    QuranCubit cubit = QuranCubit.get(context);
    return DropdownButton2(
      isExpanded: true,
      items: [
        DropdownMenuItem<String>(
          child: FlutterSlider(
            values: [AzkarFav.fontSizeAzkar],
            max: 40,
            min: 18,
            rtl: true,
            trackBar: FlutterSliderTrackBar(
              inactiveTrackBarHeight: 5,
              activeTrackBarHeight: 5,
              inactiveTrackBar: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.surface,
              ),
              activeTrackBar: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Theme.of(context).colorScheme.background),
            ),
            handlerAnimation: const FlutterSliderHandlerAnimation(
                curve: Curves.elasticOut,
                reverseCurve: null,
                duration: Duration(milliseconds: 700),
                scale: 1.4),
            onDragging: (handlerIndex, lowerValue, upperValue) {
              lowerValue = lowerValue;
              upperValue = upperValue;
              AzkarFav.fontSizeAzkar = lowerValue;
              cubit.saveAzkarFontSize(AzkarFav.fontSizeAzkar);
              setState(() {});
            },
            handler: FlutterSliderHandler(
              decoration: const BoxDecoration(),
              child: Material(
                type: MaterialType.circle,
                color: Colors.transparent,
                elevation: 3,
                child: SvgPicture.asset('assets/svg/slider_ic.svg'),
              ),
            ),
          ),
        )
      ],
      value: selectedValue,
      onChanged: (value) {
        setState(() {
          selectedValue = value as String;
        });
      },
      customButton: Icon(
        Icons.format_size,
        color: Theme.of(context).colorScheme.surface,
      ),
      iconStyleData: const IconStyleData(
        iconSize: 24,
      ),
      buttonStyleData: const ButtonStyleData(
        height: 50,
        width: 50,
        elevation: 0,
      ),
      dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(.9),
              borderRadius: const BorderRadius.all(Radius.circular(8))),
          padding: const EdgeInsets.only(left: 1, right: 1),
          maxHeight: 230,
          width: 230,
          elevation: 0,
          offset: const Offset(0, 0),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(8),
            thickness: MaterialStateProperty.all(6),
          )),
      menuItemStyleData: const MenuItemStyleData(
        height: 45,
      ),
    );
  }
}
