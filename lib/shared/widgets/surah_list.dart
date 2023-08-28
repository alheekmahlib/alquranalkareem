import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../l10n/app_localizations.dart';
import 'controllers_put.dart';

class SurahList extends StatelessWidget {
  SurahList({super.key});

  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    ArabicNumbers arabicNumber = ArabicNumbers();
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: AnimationLimiter(
                child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: sorahRepositoryController.sorahs.length,
                    controller: controller,
                    itemBuilder: (_, index) {
                      final surah = sorahRepositoryController.sorahs[index];
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 450),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: GestureDetector(
                              onTap: () {
                                generalController.dPageController
                                    ?.animateToPage(
                                  surah.pageNum - 1,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeIn,
                                );
                                Navigator.pop(context);
                              },
                              child: Container(
                                  height: 65,
                                  color: (index % 2 == 0
                                      ? Theme.of(context).colorScheme.background
                                      : Theme.of(context)
                                          .dividerColor
                                          .withOpacity(.3)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            SizedBox(
                                                height: 40,
                                                width: 40,
                                                child: SvgPicture.asset(
                                                  'assets/svg/sora_num.svg',
                                                )),
                                            Text(
                                              "${arabicNumber.convert(surah.id)}",
                                              style: TextStyle(
                                                  color: ThemeProvider.themeOf(
                                                                  context)
                                                              .id ==
                                                          'dark'
                                                      ? Theme.of(context)
                                                          .canvasColor
                                                      : Theme.of(context)
                                                          .primaryColorLight,
                                                  fontFamily: "kufi",
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  height: 2),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/svg/surah_name/00${index + 1}.svg',
                                              colorFilter:
                                                  ThemeProvider.themeOf(context)
                                                              .id ==
                                                          'dark'
                                                      ? ColorFilter.mode(
                                                          Theme.of(context)
                                                              .canvasColor,
                                                          BlendMode.srcIn)
                                                      : ColorFilter.mode(
                                                          Theme.of(context)
                                                              .primaryColorDark,
                                                          BlendMode.srcIn),
                                              width: 100,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: Text(
                                                surah.nameEn,
                                                style: TextStyle(
                                                  fontFamily: "naskh",
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 10,
                                                  color: ThemeProvider.themeOf(
                                                                  context)
                                                              .id ==
                                                          'dark'
                                                      ? Theme.of(context)
                                                          .canvasColor
                                                      : Theme.of(context)
                                                          .primaryColorLight,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "| ${AppLocalizations.of(context)?.aya_count} |",
                                              style: TextStyle(
                                                fontFamily: "uthman",
                                                fontSize: 12,
                                                color: ThemeProvider.themeOf(
                                                                context)
                                                            .id ==
                                                        'dark'
                                                    ? Theme.of(context)
                                                        .canvasColor
                                                    : Theme.of(context)
                                                        .primaryColorDark,
                                              ),
                                            ),
                                            Text(
                                              "| ${arabicNumber.convert(surah.ayaCount)} |",
                                              style: TextStyle(
                                                fontFamily: "kufi",
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: ThemeProvider.themeOf(
                                                                context)
                                                            .id ==
                                                        'dark'
                                                    ? Theme.of(context)
                                                        .canvasColor
                                                    : Theme.of(context)
                                                        .primaryColorDark,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
