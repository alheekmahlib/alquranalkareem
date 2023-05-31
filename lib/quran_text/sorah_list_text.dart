import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:theme_provider/theme_provider.dart';
import '../l10n/app_localizations.dart';
import '../shared/widgets/lottie.dart';
import '../shared/widgets/widgets.dart';
import 'cubit/quran_text_cubit.dart';
import 'cubit/surah_text_cubit.dart';
import 'text_page_view.dart';
import 'model/QuranModel.dart';


class SorahListText extends StatefulWidget {
  const SorahListText({super.key});

  @override
  _SorahListTextState createState() => _SorahListTextState();
}

class _SorahListTextState extends State<SorahListText>
    with SingleTickerProviderStateMixin {
  final ScrollController controller = ScrollController();
  Widget? textPage;

  @override
  void initState() {
    super.initState();
    QuranTextCubit.get(context).loadTranslateValue();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ArabicNumbers arabicNumber = ArabicNumbers();
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.all(
          Radius.circular(8)
        )
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: BlocBuilder<SurahTextCubit, List<SurahText>?>(
                builder: (context, state) {
                  if (state == null) {
                    return Center(
                      child: loadingLottie(200.0, 200.0),
                    );
                  }
                  return AnimationLimiter(
                    child: Scrollbar(
                      controller: controller,
                      thumbVisibility: true,
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics:
                          const AlwaysScrollableScrollPhysics(),
                          itemCount: state.length,
                          controller: controller,
                          padding: EdgeInsets.zero,
                          itemBuilder: (_, index) {
                            return AnimationConfiguration
                                .staggeredList(
                              position: index,
                              duration:
                              const Duration(milliseconds: 450),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          animatRoute(TextPageView(
                                            surah: state[index],
                                            nomPageF: state[index]
                                                .ayahs!
                                                .first
                                                .page!,
                                            nomPageL: state[index]
                                                .ayahs!
                                                .last
                                                .page!,
                                          )));
                                      print("surah: ${state[index]}");
                                      print("nomPageF: ${state[index].ayahs!.first.page!}");
                                      print("nomPageL: ${state[index].ayahs!.last.page!}");
                                    },
                                    child: Container(
                                        height: 60,
                                        color: (index % 2 == 0
                                            ? Theme.of(context)
                                            .colorScheme.background
                                            : Theme.of(context)
                                            .dividerColor
                                            .withOpacity(.3)),
                                        child: Padding(
                                          padding: const EdgeInsets
                                              .symmetric(
                                              horizontal: 8),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              Stack(
                                                alignment:
                                                Alignment.center,
                                                children: [
                                                  SizedBox(
                                                      height: 40,
                                                      width: 40,
                                                      child:
                                                      SvgPicture
                                                          .asset(
                                                        'assets/svg/sora_num.svg',
                                                      )),
                                                  Text(
                                                    arabicNumber.convert(state[index]
                                                        .number
                                                        .toString()),
                                                    style: TextStyle(
                                                        color: ThemeProvider.themeOf(context)
                                                            .id ==
                                                            'dark'
                                                            ? Theme.of(
                                                            context)
                                                            .canvasColor
                                                            : Theme.of(
                                                            context)
                                                            .primaryColorLight,
                                                        fontFamily:
                                                        "kufi",
                                                        fontSize: 14,
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        height: 2),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/svg/surah_name/00${index + 1}.svg',
                                                    colorFilter: ThemeProvider.themeOf(
                                                        context)
                                                        .id ==
                                                        'dark'
                                                        ? ColorFilter.mode(Theme.of(
                                                        context)
                                                        .canvasColor, BlendMode.srcIn)
                                                        : ColorFilter.mode(Theme.of(
                                                        context)
                                                        .primaryColorDark, BlendMode.srcIn),
                                                    width: 100,
                                                  ),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .only(
                                                        right:
                                                        8.0),
                                                    child: Text(
                                                      state[index].englishName!,
                                                      style:
                                                      TextStyle(
                                                        fontFamily:
                                                        "kufi",
                                                        fontWeight:
                                                        FontWeight
                                                            .w600,
                                                        fontSize: 10,
                                                        color: ThemeProvider.themeOf(context)
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
                                                MainAxisAlignment
                                                    .center,
                                                children: [
                                                  Text(
                                                    "| ${AppLocalizations.of(context)?.aya_count} |",
                                                    style: TextStyle(
                                                      fontFamily:
                                                      "uthman",
                                                      fontSize: 12,
                                                      color: ThemeProvider.themeOf(context)
                                                          .id ==
                                                          'dark'
                                                          ? Theme.of(
                                                          context)
                                                          .canvasColor
                                                          : Theme.of(
                                                          context)
                                                          .primaryColorDark,
                                                    ),
                                                  ),
                                                  Text(
                                                    "| ${arabicNumber.convert(state[index].ayahs!.last.numberInSurah)} |",
                                                    style: TextStyle(
                                                      fontFamily:
                                                      "kufi",
                                                      fontSize: 14,
                                                      fontWeight:
                                                      FontWeight
                                                          .bold,
                                                      color: ThemeProvider.themeOf(context)
                                                          .id ==
                                                          'dark'
                                                          ? Theme.of(
                                                          context)
                                                          .canvasColor
                                                          : Theme.of(
                                                          context)
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
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
