import 'package:alquranalkareem/cubit/cubit.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:theme_provider/theme_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../quran_page/data/model/sorah.dart';
import '../../quran_page/data/repository/sorah_repository.dart';

class SorahList extends StatefulWidget {
  const SorahList({super.key});

  @override
  _SorahListState createState() => _SorahListState();
}

class _SorahListState extends State<SorahList>
    with AutomaticKeepAliveClientMixin<SorahList> {
  SorahRepository sorahRepository = SorahRepository();
  List<Sorah>? sorahList;
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    getList();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  getList() async {
    sorahRepository.all().then((values) {
      setState(() {
        sorahList = values;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ArabicNumbers arabicNumber = ArabicNumbers();
    super.build(context);
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: sorahList != null
                  ? AnimationLimiter(
                      child: Scrollbar(
                        thumbVisibility: true,
                        // interactive: true,
                        controller: controller,
                        child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: sorahList!.length,
                            controller: controller,
                            itemBuilder: (_, index) {
                              Sorah sorah = sorahList![index];
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 450),
                                child: SlideAnimation(
                                  verticalOffset: 50.0,
                                  child: FadeInAnimation(
                                    child: GestureDetector(
                                      onTap: () {
                                        QuranCubit.get(context)
                                            .dPageController
                                            ?.animateToPage(
                                              sorah.pageNum - 1,
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              curve: Curves.easeIn,
                                            );
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                          height: 65,
                                          color: (index % 2 == 0
                                              ? Theme.of(context)
                                                  .colorScheme.background
                                              : Theme.of(context)
                                                  .dividerColor
                                                  .withOpacity(.3)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                      "${arabicNumber.convert(sorah.id)}",
                                                      style: TextStyle(
                                                          color: ThemeProvider.themeOf(
                                                                          context)
                                                                      .id ==
                                                                  'dark'
                                                              ? Theme.of(
                                                                      context)
                                                                  .canvasColor
                                                              : Theme.of(
                                                                      context)
                                                                  .primaryColorLight,
                                                          fontFamily: "kufi",
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        height: 2
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SvgPicture.asset(
                                                      'assets/svg/surah_name/00${index + 1}.svg',
                                                      colorFilter: ThemeProvider
                                                                      .themeOf(
                                                                          context)
                                                                  .id ==
                                                              'dark'
                                                          ? ColorFilter.mode(Theme.of(context)
                                                              .canvasColor, BlendMode.srcIn)
                                                          : ColorFilter.mode(Theme.of(context)
                                                              .primaryColorDark, BlendMode.srcIn),
                                                      width: 100,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 8.0),
                                                      child: Text(
                                                        sorah.nameEn,
                                                        style: TextStyle(
                                                          fontFamily: "naskh",
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 10,
                                                          color: ThemeProvider.themeOf(
                                                                          context)
                                                                      .id ==
                                                                  'dark'
                                                              ? Theme.of(
                                                                      context)
                                                                  .canvasColor
                                                              : Theme.of(
                                                                      context)
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
                                                      "| ${arabicNumber.convert(sorah.ayaCount)} |",
                                                      style: TextStyle(
                                                        fontFamily: "kufi",
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                  : Center(
                      child: Lottie.asset('assets/lottie/loading.json',
                          width: 150, height: 150),
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
