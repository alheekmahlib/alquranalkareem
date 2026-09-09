import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:quran_library/quran_library.dart';

import '/core/utils/constants/extensions/svg_extensions.dart';
import '/core/utils/constants/svg_constants.dart';
import '/core/utils/helpers/app_text_styles.dart';
import '/presentation/screens/ai_search/ai_search.dart';
import '../../quran_page/quran.dart';

class MidadWidget extends StatelessWidget {
  MidadWidget({super.key});

  final quranCtrl = QuranController.instance;
  final tasmee = TasmeeCtrl.instance;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buttonBuild(
          context,
          isRTL: true,
          title: 'midadWelcome',
          svgPath: SvgPath.svgHomeMidadIcon,
          onTap: () =>
              Get.to(() => AiSearchResults(), transition: Transition.fadeIn),
        ),
        _buttonBuild(
          context,
          isRTL: false,
          title: 'tasmeeModeTeacher',
          titleLogo: 'tasmeeModeTeacher',
          svgPath: null,
          onTap: () async {
            final lastReadPage = quranCtrl.state.box.read('last_page') ?? 1;
            tasmee.state.showAllWords.value = false;
            await tasmee.enterTasmeeMode();
            Get.to(
              () => QuranHome(isTasmeeMode: true),
              transition: Transition.downToUp,
            );
            Future.delayed(const Duration(milliseconds: 300), () {
              quranCtrl.changeSurahListOnTap(lastReadPage);
            });
          },
        ),
      ],
    );
  }

  Widget _buttonBuild(
    BuildContext context, {
    required String title,
    String? titleLogo,
    String? svgPath,
    required Function()? onTap,
    required bool isRTL,
  }) {
    return Expanded(
      child: IntrinsicHeight(
        child: GestureDetector(
          onTap: () => onTap?.call(),
          child: Row(
            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
            children: [
              const Gap(16),
              Container(
                width: 8,
                decoration: BoxDecoration(
                  color: context.theme.primaryColorLight,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              Expanded(
                child: Container(
                  height: 100,
                  width: Get.width,
                  alignment: .center,
                  margin: const EdgeInsets.symmetric(horizontal: 6.0),
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    color: context.theme.primaryColorLight.withValues(
                      alpha: .1,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    crossAxisAlignment: .center,
                    mainAxisAlignment: .center,
                    children: [
                      const Gap(6),
                      if (svgPath != null)
                        customSvgWithCustomColor(
                          svgPath,
                          height: 32,
                          width: 22,
                          color: context.theme.primaryColorLight,
                        ),
                      if (titleLogo != null)
                        Text(
                          titleLogo.tr.replaceAll(' ', '\n'),
                          style: AppTextStyles.titleSmall(
                            height: 1.0,
                            fontSize: 22,
                            color: context.theme.colorScheme.inversePrimary,
                          ),
                          textAlign: .center,
                          maxLines: 2,
                          // overflow: TextOverflow.ellipsis,
                        ),
                      const Gap(6),
                      Text(
                        title.tr,
                        style: AppTextStyles.titleSmall(
                          color: context.theme.colorScheme.inversePrimary,
                        ),
                        textAlign: .center,
                        maxLines: 2,
                        // overflow: TextOverflow.ellipsis,
                      ),
                      const Gap(6),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
