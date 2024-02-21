import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:group_button/group_button.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../core/services/services_locator.dart';
import '../../../core/utils/constants/extensions/extensions.dart';
import '../../../core/utils/constants/lists.dart';
import '../../../core/utils/constants/svg_picture.dart';
import '../../../core/widgets/app_bar_widget.dart';
import '../../controllers/general_controller.dart';
import '/presentation/controllers/azkar_controller.dart';

class AlwaqfScreen extends StatelessWidget {
  AlwaqfScreen({Key? key}) : super(key: key);

  final ScrollController controller = ScrollController();
  final ItemScrollController _scrollController = ItemScrollController();
  late final GroupButtonController checkboxesController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: const AppBarWidget(isTitled: false),
        body: SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: context.customOrientation(1, 2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GroupButton(
                        buttonIndexedBuilder:
                            (isSelected, index, BuildContext) {
                          return Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(.6),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: SvgPicture.asset(
                              waqfMarks[index],
                              height: 40,
                              width: 40,
                              colorFilter: isSelected
                                  ? ColorFilter.mode(
                                      Theme.of(context).colorScheme.surface,
                                      BlendMode.srcIn)
                                  : ColorFilter.mode(
                                      Theme.of(context).colorScheme.secondary,
                                      BlendMode.srcIn),
                            ),
                          );
                        },
                        buttons: waqfMarks,
                        options: GroupButtonOptions(
                          selectedShadow: const [],
                          selectedColor: Theme.of(context).colorScheme.primary,
                          unselectedShadow: const [],
                          unselectedColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(.5),
                          unselectedTextStyle: TextStyle(
                            fontSize: 18,
                            fontFamily: 'kufi',
                            color: Get.isDarkMode ? Colors.white : Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(4),
                          spacing: 10,
                          runSpacing: 10,
                          groupingType: GroupingType.wrap,
                          direction: Axis.horizontal,
                          buttonHeight: 35,
                          buttonWidth: 60,
                          mainGroupAlignment: MainGroupAlignment.start,
                          crossGroupAlignment: CrossGroupAlignment.start,
                          groupRunAlignment: GroupRunAlignment.start,
                          textAlign: TextAlign.center,
                          textPadding: EdgeInsets.zero,
                          alignment: Alignment.center,
                          elevation: 0,
                        ),
                        onSelected: (isSelected, index, bool) =>
                            _scrollController.scrollTo(
                                index: index,
                                duration: const Duration(milliseconds: 400)),
                        isRadio: true,
                      ),
                    ],
                  ),
                ),
                context.hDivider(color: Theme.of(context).colorScheme.primary),
                Expanded(
                  flex: 9,
                  child: SizedBox(
                    height: MediaQuery.sizeOf(context).height,
                    child: ScrollablePositionedList.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      addAutomaticKeepAlives: true,
                      itemScrollController: _scrollController,
                      itemCount: waqfMarks.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              width: MediaQuery.sizeOf(context).width,
                              decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                  border: Border.all(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 1)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 32),
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
                                                Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                BlendMode.srcIn),
                                          )),
                                    ),
                                    Center(
                                      child: splash_icon(),
                                    ),
                                    Obx(() {
                                      return SelectableText.rich(
                                        TextSpan(
                                          children: sl<AzkarController>()
                                              .buildTextSpans(
                                                  waqfExplain[index]),
                                          style: TextStyle(
                                            fontSize: sl<GeneralController>()
                                                .fontSizeArabic
                                                .value,
                                            fontFamily: 'naskh',
                                            color: Theme.of(context)
                                                .colorScheme
                                                .inversePrimary,
                                          ),
                                        ),
                                        showCursor: true,
                                        cursorWidth: 3,
                                        cursorColor:
                                            Theme.of(context).dividerColor,
                                        cursorRadius: const Radius.circular(5),
                                        scrollPhysics:
                                            const ClampingScrollPhysics(),
                                        textDirection: TextDirection.rtl,
                                        textAlign: TextAlign.justify,
                                      );
                                    }),
                                    Center(
                                      child: spaceLine(
                                        30,
                                        MediaQuery.of(context).size.width /
                                            1 /
                                            4,
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
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
