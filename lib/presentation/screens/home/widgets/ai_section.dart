import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:quran_library/quran_library.dart';

import '/core/utils/constants/extensions/svg_extensions.dart';
import '/core/utils/constants/svg_constants.dart';
import '/core/utils/helpers/app_text_styles.dart';
import '/presentation/screens/ai_search/ai_search.dart';
import '../../../../core/utils/constants/extensions/alignment_rotated_extension.dart';
import '../../quran_page/quran.dart';

class AiSection extends StatelessWidget {
  AiSection({super.key});

  final quranCtrl = QuranController.instance;
  final tasmee = TasmeeCtrl.instance;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _AiCard(
          isRTL: true,
          title: 'midad'.tr,
          description: 'midadDescription'.tr,
          svgPath: SvgPath.svgHomeMidadIcon,
          iconSize: 26,
          onTap: () =>
              Get.to(() => AiSearchResults(), transition: Transition.fadeIn),
        ),
        _AiCard(
          isRTL: false,
          title: 'tasmeeModeTeacher'.tr,
          description: 'tasmeeDescription'.tr,
          svgPath: SvgPath.svgQuranMicrophone,
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
}

class _AiCard extends StatelessWidget {
  const _AiCard({
    required this.title,
    required this.description,
    required this.svgPath,
    required this.onTap,
    required this.isRTL,
    this.iconSize = 20,
  });

  final String title;
  final String description;
  final String svgPath;
  final VoidCallback? onTap;
  final bool isRTL;

  /// مقاس صندوق الأيقونة داخل الشارة؛ النسبة الحقيقية يحافظ عليها الـ SVG
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: IntrinsicHeight(
        child: _PressableCard(
          onTap: onTap,
          child: Row(
            textDirection: isRTL
                ? alignmentLayout(TextDirection.rtl, TextDirection.ltr)
                : alignmentLayout(TextDirection.ltr, TextDirection.rtl),
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
                  // height: 105,
                  width: Get.width,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 6.0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4.0,
                    vertical: 6.0,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        context.theme.primaryColorLight.withValues(alpha: .01),
                        context.theme.primaryColorLight.withValues(alpha: .05),
                        context.theme.primaryColorLight.withValues(alpha: .1),
                        context.theme.primaryColorLight.withValues(alpha: .15),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.0, 0.4, 0.8, 1.0],
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      customSvgWithColor(
                        svgPath,
                        height: iconSize,
                        width: iconSize,
                        color: context.theme.primaryColorLight,
                      ),
                      const Gap(4),
                      Text(
                        title,
                        style: AppTextStyles.titleSmall(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: context.theme.colorScheme.inversePrimary,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Gap(2),
                      Text(
                        description,
                        style: AppTextStyles.titleSmall(
                          fontSize: 11,
                          height: 1.2,
                          color: context.theme.colorScheme.inversePrimary
                              .withValues(alpha: .6),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
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

/// تغليف البطاقة بتغذية راجعة خفيفة عند اللمس (انكماش 2% لمدة 100ms)
class _PressableCard extends StatefulWidget {
  const _PressableCard({required this.onTap, required this.child});

  final VoidCallback? onTap;
  final Widget child;

  @override
  State<_PressableCard> createState() => _PressableCardState();
}

class _PressableCardState extends State<_PressableCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: widget.child,
      ),
    );
  }
}
