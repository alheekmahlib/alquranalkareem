import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

import '/presentation/screens/quran_text/widgets/widgets.dart';
import '../../../presentation/controllers/ayat_controller.dart';
import '../../../presentation/controllers/playList_controller.dart';
import '../../services/services_locator.dart';

class PlayListAyatWidget extends StatelessWidget {
  final bool? startNum;
  final bool? endNum;
  const PlayListAyatWidget(
      {super.key, this.startNum = false, this.endNum = false});

  @override
  Widget build(BuildContext context) {
    final ayatController = sl<AyatController>();
    final playList = sl<PlayListController>();
    playList.ayahPosition(startNum!);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        height: 500,
        width: 190,
        child: ListView.builder(
            controller: playList.scrollController,
            itemCount: ayatController.allAyatList.length,
            itemBuilder: (context, index) {
              final ayah = ayatController.allAyatList[index];
              return InkWell(
                child: SizedBox(
                  height: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'آية | ${arabicNumber.convert(ayah.ayaNum)}',
                        style: TextStyle(
                          color: ThemeProvider.themeOf(context).id == 'dark'
                              ? Colors.white
                              : Theme.of(context).primaryColorLight,
                          fontSize: 18,
                          fontFamily: 'naskh',
                        ),
                      ),
                      Text(
                        ayah.text.toString(),
                        style: TextStyle(
                          color: ThemeProvider.themeOf(context).id == 'dark'
                              ? Colors.white.withOpacity(.6)
                              : Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(.6),
                          fontSize: 18,
                          fontFamily: 'uthmanic2',
                        ),
                        maxLines: 1,
                      ),
                      const Divider(
                        endIndent: 16,
                        indent: 16,
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  if (startNum == true) {
                    playList.startNum.value = ayah.ayaNum;
                  } else {
                    playList.endNum.value = ayah.ayaNum;
                  }

                  Navigator.pop(context);
                  print('playList.startNum.value: ${playList.startNum.value}');
                },
              );
            }),
      ),
    );
  }
}
