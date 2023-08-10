import 'package:alquranalkareem/cubit/cubit.dart';
import 'package:alquranalkareem/quran_page/cubit/audio/cubit.dart';
import 'package:alquranalkareem/shared/controller/general_controller.dart';
import 'package:alquranalkareem/shared/widgets/svg_picture.dart';
import 'package:alquranalkareem/shared/widgets/widgets.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../cubit/states.dart';
import '../../l10n/app_localizations.dart';
import '../../notes/cubit/note_cubit.dart';
import '../controller/ayat_controller.dart';
import '../share/ayah_to_images.dart';
import 'ayah_list.dart';

double? isSelected;
int? ayahSelected, ayahNumber, surahNumber;
String? surahName;

class ShowTafseer extends StatefulWidget {
  const ShowTafseer({Key? key}) : super(key: key);

  @override
  State<ShowTafseer> createState() => _ShowTafseerState();
}

class _ShowTafseerState extends State<ShowTafseer> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<_ShowTafseerState> _selectableTextKey =
      GlobalKey<_ShowTafseerState>();
  ArabicNumbers arabicNumber = ArabicNumbers();
  late final AyatController ayatController = Get.put(AyatController());
  late final GeneralController generalController = Get.put(GeneralController());
  int pageNum = 0;
  int radioValue = 0;
  double lower = 18;
  double upper = 40;
  double selectedValue = 18.0;
  double? sliderValue;

  // final NoteController _noteController = Get.put(NoteController());

  @override
  void initState() {
    sliderValue = 0;
    AudioCubit.get(context).loadQuranReader();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    QuranCubit cubit = QuranCubit.get(context);
    NotesCubit notesCubit = NotesCubit.get(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        color: Theme.of(context).colorScheme.background,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            icon: Icon(Icons.book,
                                size: 24,
                                color: Theme.of(context).colorScheme.surface),
                            onPressed: () => tafseerDropDown(context),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          flex: 1,
                          child: fontSizeDropDown(context),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(flex: 7, child: AyahList2()),
              ],
            ),
            const Divider(
              height: 0,
              thickness: 3,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () async {
                      if (ayahNumber == null) {
                        customErrorSnackBar(
                            context, AppLocalizations.of(context)!.choiceAyah);
                      } else {
                        await Clipboard.setData(ClipboardData(
                                text:
                                    '﴿${cubit.translateAyah}﴾\n\n${cubit.translate}'))
                            .then((value) => customSnackBar(context,
                                AppLocalizations.of(context)!.copyTafseer));
                      }
                    },
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            ),
                            border: Border.all(
                                width: 2,
                                color: Theme.of(context).dividerColor)),
                        child: Icon(
                          Icons.copy_outlined,
                          size: 18,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  GestureDetector(
                    onTap: () {
                      generalController.shareTafseerValue = 1;
                      if (ayahNumber == null) {
                        customErrorSnackBar(
                            context, AppLocalizations.of(context)!.choiceAyah);
                      } else if (ayatController.radioValue == 3) {
                        showVerseOptionsBottomSheet(
                            context,
                            0,
                            surahNumber!,
                            cubit.translateAyah,
                            cubit.translate ?? '',
                            surahName!);
                      } else {
                        showVerseOptionsBottomSheet(context, 0, surahNumber!,
                            cubit.translateAyah, '', surahName!);
                      }
                    },
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            ),
                            border: Border.all(
                                width: 2,
                                color: Theme.of(context).dividerColor)),
                        child: Icon(
                          Icons.share_outlined,
                          size: 18,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            Flexible(
              flex: 4,
              child: Container(
                height: MediaQuery.of(context).size.height / 1 / 2 * 1.3,
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).colorScheme.background,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height,
                    ),
                    child: Scrollbar(
                      controller: _scrollController,
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: BlocBuilder<QuranCubit, QuranState>(
                          builder: (context, state) {
                            if (state is TextUpdated) {
                              allText = '﴿${state.translateAyah}﴾\n\n' +
                                  state.translate;
                              allTitle = '﴿${state.translateAyah}﴾';
                              cubit.translateAyah = state.translateAyah;
                              cubit.translate = state.translate;
                              return Obx(
                                () => SelectableText.rich(
                                  key: _selectableTextKey,
                                  TextSpan(
                                    children: <InlineSpan>[
                                      TextSpan(
                                        text: '﴿${state.translateAyah}﴾\n\n',
                                        style: TextStyle(
                                            color:
                                                ThemeProvider.themeOf(context)
                                                            .id ==
                                                        'dark'
                                                    ? Colors.white
                                                    : Colors.black,
                                            fontWeight: FontWeight.w100,
                                            height: 1.5,
                                            fontFamily: 'uthmanic2',
                                            fontSize: generalController
                                                .fontSizeArabic.value),
                                      ),
                                      WidgetSpan(
                                        child: Center(
                                          child: spaceLine(
                                              25,
                                              MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1 /
                                                  2),
                                        ),
                                      ),
                                      TextSpan(
                                        text: state.translate,
                                        style: TextStyle(
                                            color:
                                                ThemeProvider.themeOf(context)
                                                            .id ==
                                                        'dark'
                                                    ? Colors.white
                                                    : Colors.black,
                                            height: 1.5,
                                            fontSize: generalController
                                                .fontSizeArabic.value),
                                      ),
                                      WidgetSpan(
                                        child: Center(
                                          child: spaceLine(
                                              25,
                                              MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1 /
                                                  2),
                                        ),
                                      ),
                                    ],
                                  ),
                                  showCursor: true,
                                  cursorWidth: 3,
                                  cursorColor: Theme.of(context).dividerColor,
                                  cursorRadius: const Radius.circular(5),
                                  scrollPhysics: const ClampingScrollPhysics(),
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.justify,
                                  contextMenuBuilder:
                                      buildMyContextMenu(notesCubit),
                                  onSelectionChanged: handleSelectionChanged,
                                ),
                              );
                            } else {
                              return const SizedBox
                                  .shrink(); // Or some other fallback widget
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Divider(
              height: 0,
            )
          ],
        ),
      ),
    );
  }

  tafseerDropDown(BuildContext context) {
    QuranCubit cubit = QuranCubit.get(context);
    List<String> tafName = <String>[
      '${AppLocalizations.of(context)!.tafIbnkatheerN}',
      '${AppLocalizations.of(context)!.tafBaghawyN}',
      '${AppLocalizations.of(context)!.tafQurtubiN}',
      '${AppLocalizations.of(context)!.tafSaadiN}',
      '${AppLocalizations.of(context)!.tafTabariN}',
    ];
    List<String> tafD = <String>[
      '${AppLocalizations.of(context)!.tafIbnkatheerD}',
      '${AppLocalizations.of(context)!.tafBaghawyD}',
      '${AppLocalizations.of(context)!.tafQurtubiD}',
      '${AppLocalizations.of(context)!.tafSaadiD}',
      '${AppLocalizations.of(context)!.tafTabariD}',
    ];
    dropDownModalBottomSheet(
      context,
      MediaQuery.of(context).size.height / 1 / 2,
      MediaQuery.of(context).size.width,
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  height: 30,
                  width: 30,
                  margin: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      border: Border.all(
                          width: 2, color: Theme.of(context).dividerColor)),
                  child: Icon(
                    Icons.close_outlined,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: SvgPicture.asset(
                    'assets/svg/tafseer.svg',
                    height: 50,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 90.0),
              child: ListView.builder(
                itemCount: tafName.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Container(
                        child: ListTile(
                          title: Text(
                            tafName[index],
                            style: TextStyle(
                                color: ayatController.radioValue == index
                                    ? Theme.of(context).primaryColorLight
                                    : const Color(0xffcdba72),
                                fontSize: 14,
                                fontFamily: 'kufi'),
                          ),
                          subtitle: Text(
                            tafD[index],
                            style: TextStyle(
                                color: ayatController.radioValue == index
                                    ? Theme.of(context).primaryColorLight
                                    : const Color(0xffcdba72),
                                fontSize: 12,
                                fontFamily: 'kufi'),
                          ),
                          trailing: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(2.0)),
                              border: Border.all(
                                  color: ayatController.radioValue == index
                                      ? Theme.of(context).primaryColorLight
                                      : const Color(0xffcdba72),
                                  width: 2),
                              color: const Color(0xff39412a),
                            ),
                            child: ayatController.radioValue == index
                                ? const Icon(Icons.done,
                                    size: 14, color: Color(0xfffcbb76))
                                : null,
                          ),
                          onTap: () {
                            cubit.getNewTranslationAndNotify(
                                context, surahNumber!, ayahNumber!);
                            ayatController.handleRadioValueChanged(index);
                            ayatController.saveTafseer(index);
                            Navigator.pop(context);
                          },
                          leading: Container(
                              height: 85.0,
                              width: 41.0,
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4.0)),
                                  border: Border.all(
                                      color: Theme.of(context).dividerColor,
                                      width: 2)),
                              child: SvgPicture.asset(
                                'assets/svg/tafseer_book.svg',
                                colorFilter: ayatController.radioValue == index
                                    ? null
                                    : ColorFilter.mode(
                                        Theme.of(context)
                                            .canvasColor
                                            .withOpacity(.4),
                                        BlendMode.lighten),
                              )),
                        ),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8.0)),
                            border: Border.all(
                                color: Theme.of(context).dividerColor,
                                width: 1)),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 4.0),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String allText = '';
String allTitle = '';
String? selectedTextED;

void handleSelectionChanged(
    TextSelection selection, SelectionChangedCause? cause) {
  if (cause == SelectionChangedCause.longPress) {
    final characters = allText.characters;
    final start = characters.take(selection.start).length;
    final end = characters.take(selection.end).length;
    final selectedText = allText.substring(start - 1, end - 1);

    // setState(() {
    selectedTextED = selectedText;
    // });
    print(selectedText);
  }
}
