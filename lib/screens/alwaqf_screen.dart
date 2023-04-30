import 'package:alquranalkareem/cubit/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:group_button/group_button.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:theme_provider/theme_provider.dart';
import '../shared/widgets/widgets.dart';



class AlwaqfScreen extends StatefulWidget {
  AlwaqfScreen({Key? key}) : super(key: key);

  @override
  State<AlwaqfScreen> createState() => _AlwaqfScreenState();
}

class _AlwaqfScreenState extends State<AlwaqfScreen> {
  final ScrollController controller = ScrollController();
  ItemScrollController _scrollController = ItemScrollController();

  late GroupButtonController _checkboxesController;

  late GroupButtonController _radioController;

  @override
  void initState() {
    _checkboxesController = GroupButtonController(
      selectedIndexes: [2],
      disabledIndexes: [4],
      onDisablePressed: (index) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${waqfMarks[index]} is disabled')),
      ),
    );
    super.initState();
  }

  List<String> waqfMarks = <String>[
    'assets/svg/alwaqf/01.svg',
    'assets/svg/alwaqf/02.svg',
    'assets/svg/alwaqf/03.svg',
    'assets/svg/alwaqf/04.svg',
    'assets/svg/alwaqf/05.svg',
  ];

  List<String> waqfExplain = <String>[
    'عَلَامَة الوَقْفِ اللَّازم نَحوُ : {إِنَّمَا يَسْتَجِيبُ الَّذِينَ يَسْمَعُونَ ۘ وَالْمَوْتَىٰ يَبْعَثُهُمُ اللَّهُ}.',
    'عَلَامَة الوَقْفِ الجَائِزِ مَعَ كَوْنِ الوَقْفِ أَوْلَى نَحِوُ : {قُل رَّبِّي أَعْلَمُ بِعِدَّتِهِم مَّا يَعْلَمُهُمْ إِلَّا قَلِيلٌ ۗ فَلَا تُمَارِ فِيهِمْ}.',
    'عَلَامَة الوَقْفِ الجَائِزِ جَوَازًا مُسْتَوِيَ الطَّرَفَيْن نَحوُ : {نَّحْنُ نَقُصُّ عَلَيْكَ نَبَأَهُم بِالْحَقِّ ۚ إِنَّهُمْ فِتْيَةٌ آمَنُوا بِرَبِّهِمْ}.',
    'عَلَامَة الوَقْفِ الجَائِزِ مَعَ كَوْنِ الوَصْل أَوْلَى نَحِوُ : {وَإِن يَمْسَسْكَ اللَّهُ بِضُرٍّ فَلَا كَاشِفَ لَهُ إِلَّا هُوَ ۖ وَإِن يَمْسَسْكَ بِخَيْرٍ فَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ}.',
    'عَلَامَةُ تَعَانُق الوَقْفِ بِحَيْثُ إِِذَا وَقِفَ عَلى أَحَدِ المَوْضِعَيْن لَا يَصِحُّ الوَقفُ عَلى الآخَرِ نَحِوُ : {ذَٰلِكَ الْكِتَابُ لَا رَيْبَ ۛ فِيهِ ۛ هُدًى لِّلْمُتَّقِينَ}.',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      right: false,
      left: false,
      child: Scaffold(
          body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          color: Theme.of(context).backgroundColor,
          child: Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 1 / 15),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                color: Theme.of(context).backgroundColor,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  topLeft: Radius.circular(8),
                                ),
                                border: Border.all(
                                    width: 2,
                                    color: Theme.of(context).dividerColor)),
                            child: Icon(
                              Icons.close_outlined,
                              color: Theme.of(context).bottomAppBarColor,
                            ),
                          ),
                        ),
                      ),
                      const Divider(
                        height: 0,
                        thickness: 2,
                        endIndent: 16,
                        indent: 16,
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: orientation(context,
                        EdgeInsets.only(top: 32.0),
                        EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 1 / 13)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: orientation(context, 1, 2),
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
                                          ? Theme.of(context).bottomAppBarColor
                                          : Theme.of(context)
                                              .bottomAppBarColor
                                              .withOpacity(.6),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: SvgPicture.asset(
                                      '${waqfMarks[index]}',
                                      height: 40,
                                      width: 40,
                                      colorFilter: isSelected
                                          ? ColorFilter.mode(Color(0xfffcbb76), BlendMode.srcIn)
                                          : ColorFilter.mode(Color(0xff39412a), BlendMode.srcIn),
                                    ),
                                  );
                                },
                                buttons: waqfMarks,
                                options: GroupButtonOptions(
                                  selectedShadow: const [],
                                  selectedColor:
                                      Theme.of(context).bottomAppBarColor,
                                  unselectedShadow: const [],
                                  unselectedColor: Theme.of(context)
                                      .bottomAppBarColor
                                      .withOpacity(.5),
                                  unselectedTextStyle: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'kufi',
                                    color: ThemeProvider.themeOf(context).id ==
                                            'dark'
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                  spacing: 10,
                                  runSpacing: 10,
                                  groupingType: GroupingType.wrap,
                                  direction: Axis.horizontal,
                                  buttonHeight: 35,
                                  buttonWidth: 60,
                                  mainGroupAlignment: MainGroupAlignment.start,
                                  crossGroupAlignment:
                                      CrossGroupAlignment.start,
                                  groupRunAlignment: GroupRunAlignment.start,
                                  textAlign: TextAlign.center,
                                  textPadding: EdgeInsets.zero,
                                  alignment: Alignment.center,
                                  elevation: 0,
                                ),
                                onSelected: (isSelected, index, bool) =>
                                    _scrollController.scrollTo(
                                        index: index,
                                        duration:
                                            const Duration(milliseconds: 400)),
                                isRadio: true,
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 0,
                          thickness: 2,
                          endIndent: 16,
                          indent: 16,
                        ),
                        Expanded(
                          flex: 7,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height,
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
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          color:
                                              Theme.of(context).backgroundColor,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(8)),
                                          border: Border.all(
                                              color: Theme.of(context)
                                                  .bottomAppBarColor,
                                              width: 1)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 32),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 16.0),
                                              child: Align(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  child: SvgPicture.asset(
                                                    '${waqfMarks[index]}',
                                                    height: 70,
                                                    width: 70,
<<<<<<< Updated upstream
                                                    color: Theme.of(context)
                                                        .bottomAppBarColor,
=======
                                                    colorFilter: ColorFilter.mode(Theme.of(context)
                                                        .colorScheme.surface, BlendMode.srcIn),
>>>>>>> Stashed changes
                                                  )),
                                            ),
                                            Center(
                                              child: SizedBox(
                                                  height: 50,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      1 /
                                                      2,
                                                  child: SvgPicture.asset(
                                                    'assets/svg/Logo_line2.svg',
                                                  )),
                                            ),
                                            SelectableText(
                                              waqfExplain[index],
                                              showCursor: true,
                                              cursorWidth: 3,
                                              cursorColor: Theme.of(context)
                                                  .dividerColor,
                                              cursorRadius:
                                                  const Radius.circular(5),
                                              scrollPhysics:
                                                  const ClampingScrollPhysics(),
                                              textDirection: TextDirection.rtl,
                                              textAlign: TextAlign.justify,
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontFamily: 'naskh',
                                                color: ThemeProvider.themeOf(
                                                                context)
                                                            .id ==
                                                        'dark'
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                            Center(
                                              child: SizedBox(
                                                  height: 50,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      1 /
                                                      2,
                                                  child: SvgPicture.asset(
                                                    'assets/svg/space_line.svg',
                                                  )),
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
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
