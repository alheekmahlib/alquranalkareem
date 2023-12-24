import 'package:alquranalkareem/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../../../core/services/l10n/app_localizations.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/lottie.dart';
import '../../../controllers/aya_controller.dart';
import '../../../controllers/quranText_controller.dart';
import '../../../controllers/surahTextController.dart';
import '../../quran_page/data/model/aya.dart';
import '../screens/text_page_view.dart';

class QuranTextSearch extends StatelessWidget {
  QuranTextSearch({super.key});
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        topBar(context),
        Container(
          height: 60,
          padding:
              const EdgeInsets.only(top: 8, right: 30, left: 30, bottom: 8),
          child: TextField(
            textAlign: TextAlign.start,
            controller: _controller,
            autofocus: true,
            cursorHeight: 18,
            cursorWidth: 3,
            cursorColor: Theme.of(context).dividerColor,
            textInputAction: TextInputAction.search,
            onSubmitted: (value) {
              sl<AyaController>().search(value);
            },
            onChanged: (value) {
              sl<AyaController>().search(value);
            },
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            style: TextStyle(
                color: Theme.of(context).colorScheme.surface,
                fontFamily: 'kufi',
                fontSize: 15),
            decoration: InputDecoration(
              icon: IconButton(
                onPressed: () => _controller.clear(),
                icon: Icon(
                  Icons.clear,
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.surface),
              ),
              hintText: AppLocalizations.of(context)!.search_word,
              label: Text(
                AppLocalizations.of(context)!.search_word,
                style: TextStyle(color: Theme.of(context).colorScheme.surface),
              ),
              hintStyle: TextStyle(
                  // height: 1.5,
                  color: Theme.of(context).primaryColorLight.withOpacity(0.5),
                  fontFamily: 'kufi',
                  fontWeight: FontWeight.normal,
                  decorationColor: Theme.of(context).primaryColor,
                  fontSize: 14),
              contentPadding: const EdgeInsets.only(right: 16, left: 16),
            ),
          ),
        ),
        Expanded(
          child: Obx(
            () {
              if (sl<AyaController>().isLoading.value) {
                return search(200.0, 200.0);
              } else if (sl<AyaController>().ayahList.isNotEmpty) {
                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                      child: ListView.builder(
                          itemCount: sl<AyaController>().ayahList.length,
                          itemBuilder: (_, index) {
                            final List<Aya> ayahList =
                                sl<AyaController>().ayahList;
                            final aya = ayahList[index];
                            return Column(
                              children: <Widget>[
                                Container(
                                  color: (index % 2 == 0
                                      ? Theme.of(context)
                                          .colorScheme
                                          .surface
                                          .withOpacity(.05)
                                      : Theme.of(context)
                                          .colorScheme
                                          .surface
                                          .withOpacity(.1)),
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context)
                                          .push(animatRoute(TextPageView(
                                        surah: sl<SurahTextController>()
                                            .surahs[aya.surahNum - 1],
                                        nomPageF: sl<SurahTextController>()
                                            .surahs[aya.surahNum - 1]
                                            .ayahs!
                                            .first
                                            .page!,
                                        nomPageL: sl<SurahTextController>()
                                            .surahs[aya.surahNum - 1]
                                            .ayahs!
                                            .last
                                            .page!,
                                        pageNum:
                                            sl<QuranTextController>().value == 1
                                                ? (sl<SurahTextController>()
                                                        .surahs[
                                                            aya.surahNum - 1]
                                                        .ayahs![aya.ayaNum - 1]
                                                        .numberInSurah! -
                                                    2)
                                                : sl<SurahTextController>()
                                                    .surahs[aya.surahNum - 1]
                                                    .ayahs![aya.ayaNum - 1]
                                                    .pageInSurah!,
                                      )));
                                    },
                                    title: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        aya.text,
                                        style: TextStyle(
                                          fontFamily: "uthmanic2",
                                          fontWeight: FontWeight.normal,
                                          fontSize: 22,
                                          color: ThemeProvider.themeOf(context)
                                                      .id ==
                                                  'dark'
                                              ? Theme.of(context).canvasColor
                                              : Theme.of(context)
                                                  .primaryColorDark,
                                        ),
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                                    subtitle: Container(
                                      height: 20,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(4))),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(4),
                                                    bottomRight:
                                                        Radius.circular(4),
                                                  )),
                                              child: Text(
                                                aya.sorahName,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color:
                                                        ThemeProvider.themeOf(
                                                                        context)
                                                                    .id ==
                                                                'dark'
                                                            ? Theme.of(context)
                                                                .canvasColor
                                                            : Theme.of(context)
                                                                .colorScheme
                                                                .background,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                                color: Theme.of(context)
                                                    .primaryColorLight,
                                                child: Text(
                                                  " ${AppLocalizations.of(context)!.part}: ${aya.partNum}",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: ThemeProvider
                                                                      .themeOf(
                                                                          context)
                                                                  .id ==
                                                              'dark'
                                                          ? Theme.of(context)
                                                              .canvasColor
                                                          : Theme.of(context)
                                                              .colorScheme
                                                              .background,
                                                      fontSize: 12),
                                                )),
                                          ),
                                          Expanded(
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(4),
                                                      bottomLeft:
                                                          Radius.circular(4),
                                                    )),
                                                child: Text(
                                                  " ${AppLocalizations.of(context)!.page}: ${aya.pageNum}",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: ThemeProvider
                                                                      .themeOf(
                                                                          context)
                                                                  .id ==
                                                              'dark'
                                                          ? Theme.of(context)
                                                              .canvasColor
                                                          : Theme.of(context)
                                                              .colorScheme
                                                              .background,
                                                      fontSize: 12),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const Divider()
                              ],
                            );
                          })),
                );
              } else if (sl<AyaController>().errorMessage.value.isNotEmpty) {
                return notFound();
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}

Widget ayaNum(context, Color color, String num) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5),
    child: Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
            height: 35,
            width: 35,
            child: SvgPicture.asset('assets/svg/ayah_no.svg')),
        Text(
          num,
          style:
              TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    ),
  );
}
