import 'package:alquranalkareem/shared/widgets/show_tafseer.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../cubit/ayat/ayat_cubit.dart';
import '../../cubit/cubit.dart';
import '../../quran_page/cubit/audio/cubit.dart';
import '../../quran_page/data/model/ayat.dart';
import 'lottie.dart';

class AyahList extends StatefulWidget {
  final int? pageNum;
  const AyahList({Key? key, required this.pageNum}) : super(key: key);

  @override
  State<AyahList> createState() => _AyahListState();
}

class _AyahListState extends State<AyahList> {
  double? isSelected;
  ArabicNumbers arabicNumber = ArabicNumbers();

  @override
  void initState() {
    QuranCubit cubit = QuranCubit.get(context);
    final ayatCubit = context.read<AyatCubit>();
    ayatCubit.fetchAyat(widget.pageNum!);
    cubit.loadTafseer();
    cubit.audioChoise = 1;
    super.initState();
  }

  bool isFetched = false;
  var fetched;

  Future<List<Ayat>> pageTranslate() async {
    QuranCubit cubit = QuranCubit.get(context);
    if (cubit
            .handleRadioValueChanged(context, cubit.radioValue)
            .getPageTranslate(widget.pageNum!) ==
        null) {
      return cubit
          .handleRadioValueChanged(context, cubit.radioValue)
          .getPageTranslate(widget.pageNum!);
    } else {
      return cubit
          .handleRadioValueChanged(context, cubit.radioValue)
          .getPageTranslate(widget.pageNum!);
    }
  }

  @override
  Widget build(BuildContext context) {
    QuranCubit cubit = QuranCubit.get(context);
    AudioCubit audioCubit = AudioCubit.get(context);
    final ayatCubit = context.watch<AyatCubit>();
    final ayat = ayatCubit.state;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          height: 40,
          decoration: BoxDecoration(
              color: Theme.of(context).dividerColor.withOpacity(.2),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8),
                topLeft: Radius.circular(8),
              ),
              border: Border.all(
                  color: ThemeProvider.themeOf(context).id == 'blue'
                      ? Theme.of(context).dividerColor.withOpacity(.6)
                      : const Color(0xffcdba72),
                  width: 2)),
          child: Center(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              scrollDirection: Axis.horizontal,
              itemCount: ayat?.length ?? 0,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, position) {
                Ayat? aya = ayat![position];
                return Opacity(
                  opacity: isSelected == position ? 1.0 : .5,
                  child: InkWell(
                    onTap: () {
                      cubit.translateAyah = "${aya.ayatext ?? ''}";
                      cubit.translate = "${aya.translate ?? ''}";
                      audioCubit.ayahNum = '${aya.ayaNum ?? 0}';
                      audioCubit.sorahName = '${aya.suraNum ?? 0}';
                      audioCubit.ayahNumber = ayat.last.ayaNum;
                      print(audioCubit.ayahNum);
                      setState(() {
                        isSelected = position.toDouble();
                      });
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Center(
                          child: SvgPicture.asset(
                            'assets/svg/ayah_no.svg',
                            width: 30,
                            height: 30,
                          ),
                        ),
                        Center(
                          child: Text(
                            "${arabicNumber.convert(aya.ayaNum)}",
                            // "1",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontFamily: 'kufi',
                                fontWeight: FontWeight.w700,
                                fontSize: 9),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class AyahList2 extends StatefulWidget {
  const AyahList2({Key? key}) : super(key: key);

  @override
  State<AyahList2> createState() => _AyahList2State();
}

class _AyahList2State extends State<AyahList2> {
  ArabicNumbers arabicNumber = ArabicNumbers();
  @override
  Widget build(BuildContext context) {
    QuranCubit cubit = QuranCubit.get(context);
    final QuranCubit quranCubit = context.read<QuranCubit>();
// Fetch the Ayat instances when needed
    quranCubit.getTranslatedPage(cubit.cuMPage ?? 1, context);
    return FutureBuilder<List<Ayat>>(
        future: cubit
            .handleRadioValueChanged(context, cubit.radioValue)
            .getPageTranslate(cubit.cuMPage),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<Ayat>? ayat = snapshot.data;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                      color: Theme.of(context).dividerColor.withOpacity(.2),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(8),
                        topLeft: Radius.circular(8),
                      ),
                      border: Border.all(
                          color: Theme.of(context).dividerColor, width: 2)),
                  child: Center(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      scrollDirection: Axis.horizontal,
                      itemCount: ayat!.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, index) {
                        Ayat aya = ayat[index];
                        return Opacity(
                          opacity: isSelected == index ? 1.0 : .5,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                // context.read<QuranCubit>().updateText("${aya.ayatext}", "${aya.translate}");
                                // context.read<QuranCubit>().getNewTranslationAndNotify(context, aya.suraNum!, aya.ayaNum!);
                                // print("${aya.ayatext} ${aya.translate}");
                                cubit.getNewTranslationAndNotify(
                                    context, aya.suraNum!, aya.ayaNum!);
                                // cubit.translateAyah = "${aya.ayatext}";
                                // cubit.translate = "${aya.translate}";
                                print("suraNum ${aya.ayaNum}");
                                isSelected = index.toDouble();
                                ayahSelected = index;
                                ayahNumber = aya.ayaNum;
                                surahNumber = aya.suraNum;
                                surahName = aya.sura_name_ar;
                              });
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Center(
                                  child: SvgPicture.asset(
                                    'assets/svg/ayah_no.svg',
                                    width: 35,
                                    height: 35,
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    "${arabicNumber.convert(aya.ayaNum)}",
                                    // "1",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontFamily: 'kufi',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 11),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(child: search(100.0, 40.0));
          }
        });
  }
}
