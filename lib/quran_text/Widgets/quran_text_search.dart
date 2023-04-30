import 'package:alquranalkareem/quran_text/cubit/quran_text_cubit.dart';
import 'package:alquranalkareem/shared/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:theme_provider/theme_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../quran_page/data/model/aya.dart';
import '../../quran_page/data/repository/aya_repository.dart';
import '../model/QuranModel.dart';
import '../repository/quranApi.dart';
import '../text_page_view.dart';

class QuranTextSearch extends StatefulWidget {
  late Function onSubmitted;

  QuranTextSearch({super.key});

  @override
  _QuranTextSearchState createState() => _QuranTextSearchState();
}

class _QuranTextSearchState extends State<QuranTextSearch> {
  AyaRepository ayaRepository = AyaRepository();
  List<Aya>? ayahList;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  search(String text) async {
    ayaRepository.search(text).then((values) {
      setState(() {
        ayahList = values;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    QuranServer quranServer = QuranServer();
    QuranTextCubit TextCubit = QuranTextCubit.get(context);
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
              if (value != null) {
                search(value);
              }
            },
            onChanged: (value) {
              if (value != null) {
                search(value);
              }
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
          child: Container(
              child: ayahList != null
                  ? FutureBuilder(
                      future: quranServer.QuranData(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<SurahText> surah = snapshot.data!;
                          return ListView.builder(
                              itemCount: ayahList!.length,
                              itemBuilder: (_, index) {
                                Aya aya = ayahList![index];
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
                                            // surah: surah[bookmark.sorahNum!],
                                            surah: surah[aya.sorahId - 1],
                                            nomPageF: surah[aya.sorahId - 1]
                                                .ayahs!
                                                .first
                                                .page!,
                                            nomPageL: surah[aya.sorahId - 1].ayahs!.last.page!,
                                            pageNum: TextCubit.value == 1 ? (surah[aya.sorahId - 1].ayahs![aya.ayaNum - 1].numberInSurah! - 1) : surah[aya.sorahId - 1].ayahs![aya.ayaNum - 1].pageInSurah,
                                          )));
                                          print('${surah[aya.sorahId]}');
                                          print(
                                              '${surah[aya.sorahId].ayahs!.first.page!}');
                                          print(
                                              '${surah[aya.sorahId].ayahs!.last.page!}');
                                          print('pageNum: ${aya.pageNum}');
                                        },
                                        title: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            aya.text,
                                            style: TextStyle(
                                              fontFamily: "uthmanic2",
                                              fontWeight: FontWeight.normal,
                                              fontSize: 22,
                                              color:
                                                  ThemeProvider.themeOf(context)
                                                              .id ==
                                                          'dark'
                                                      ? Theme.of(context)
                                                          .canvasColor
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
                                              borderRadius:
                                                  const BorderRadius.all(
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
                                                          const BorderRadius
                                                              .only(
                                                        topRight:
                                                            Radius.circular(4),
                                                        bottomRight:
                                                            Radius.circular(4),
                                                      )),
                                                  child: Text(
                                                    aya.sorahName,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: ThemeProvider.themeOf(
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
                                                      textAlign:
                                                          TextAlign.center,
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
                                                            const BorderRadius
                                                                .only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  4),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  4),
                                                        )),
                                                    child: Text(
                                                      " ${AppLocalizations.of(context)!.page}: ${aya.pageNum}",
                                                      textAlign:
                                                          TextAlign.center,
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
                              });
                        } else {
                          return Center(
                            child: Lottie.asset('assets/lottie/bookmarks.json',
                                width: 200, height: 200),
                          );
                        }
                      })
                  : Lottie.asset('assets/lottie/search.json',
                      width: 200, height: 200)),
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
