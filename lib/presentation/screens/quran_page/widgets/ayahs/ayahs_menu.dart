import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/convert_number_extension.dart';
import '/core/utils/constants/extensions/extensions.dart';
import '/core/widgets/share/share_ayah_options.dart';
import '/presentation/screens/quran_page/controller/extensions/quran_ui.dart';
import '../../../../controllers/general_controller.dart';
import '../../controller/quran_controller.dart';
import '../buttons/add_bookmark_button.dart';
import '../buttons/copy_button.dart';
import '../buttons/play_button.dart';
import '../buttons/tafsir_button.dart';

class AyahsMenu extends StatelessWidget {
  final int surahNum;
  final int ayahNum;
  final String ayahText;
  final int pageIndex;
  final String ayahTextNormal;
  final int ayahUQNum;
  final String surahName;
  final bool isSelected;
  final int index;

  AyahsMenu({
    super.key,
    required this.surahNum,
    required this.ayahNum,
    required this.ayahText,
    required this.pageIndex,
    required this.ayahTextNormal,
    required this.ayahUQNum,
    required this.surahName,
    required this.isSelected,
    required this.index,
  });

  final generalCtrl = GeneralController.instance;
  final quranCtrl = QuranController.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
      decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.surface.withOpacity(.4)
              : Theme.of(context).colorScheme.surface.withOpacity(.15),
          borderRadius: const BorderRadius.all(Radius.circular(4))),
      width: double.infinity,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 35,
            width: 35,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  'assets/svg/sora_num.svg',
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.primary, BlendMode.srcIn),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      '${ayahNum.toString().convertNumbers()}',
                      style: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontFamily: "kufi",
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          height: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Obx(() => AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                firstChild: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TafsirButton(
                      surahNum: surahNum,
                      ayahNum: ayahNum,
                      ayahText: ayahText,
                      pageIndex: pageIndex,
                      ayahTextNormal: ayahTextNormal,
                      ayahUQNum: ayahUQNum,
                      index: index,
                    ),
                    const Gap(6),
                    context.vDivider(height: 18.0),
                    PlayButton(
                      surahNum: surahNum,
                      ayahNum: ayahNum,
                      ayahUQNum: ayahUQNum,
                    ),
                    const Gap(6),
                    context.vDivider(height: 18.0),
                    GestureDetector(
                      onTap: () => quranCtrl.toggleMenu("$surahNum-$ayahNum"),
                      child: Icon(
                        Icons.more_vert_outlined,
                        size: 24,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                secondChild: Container(
                  width: MediaQuery.sizeOf(context).width * .6,
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TafsirButton(
                          surahNum: surahNum,
                          ayahNum: ayahNum,
                          ayahText: ayahText,
                          pageIndex: pageIndex,
                          ayahTextNormal: ayahTextNormal,
                          ayahUQNum: ayahUQNum,
                          index: index,
                        ),
                        const Gap(6),
                        context.vDivider(height: 18.0),
                        PlayButton(
                          surahNum: surahNum,
                          ayahNum: ayahNum,
                          ayahUQNum: ayahUQNum,
                        ),
                        const Gap(4),
                        context.vDivider(height: 18.0),
                        const Gap(6),
                        AddBookmarkButton(
                          surahNum: surahNum,
                          ayahNum: ayahNum,
                          ayahUQNum: ayahUQNum,
                          pageIndex: pageIndex,
                          surahName: surahName,
                        ),
                        const Gap(6),
                        context.vDivider(height: 18.0),
                        const Gap(6),
                        CopyButton(
                          ayahNum: ayahNum,
                          surahName: surahName,
                          ayahTextNormal: ayahTextNormal,
                        ),
                        const Gap(6),
                        context.vDivider(height: 18.0),
                        const Gap(6),
                        ShareAyahOptions(
                          ayahNumber: ayahNum,
                          ayahUQNumber: ayahUQNum,
                          surahNumber: surahNum,
                          ayahTextNormal: ayahTextNormal,
                          ayahText: ayahTextNormal,
                          surahName: 'surahName',
                        ),
                        const Gap(6),
                        context.vDivider(height: 18.0),
                        context.customClose(
                          height: 16.0,
                          close: () =>
                              quranCtrl.toggleMenu("$surahNum-$ayahNum"),
                        ),
                      ],
                    ),
                  ),
                ),
                crossFadeState:
                    quranCtrl.state.moreOptionsMap["$surahNum-$ayahNum"] == true
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
              )),
        ],
      ),
    );
  }
}
