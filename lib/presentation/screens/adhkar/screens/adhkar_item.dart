import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/tour/app_tour.dart';
import '../../../../core/tour/azkar_tour_script.dart';
import '../../../../core/tour/tour_replay_button.dart';
import '../../../../core/utils/constants/extensions/extensions.dart';
import '../../../../core/widgets/app_bar_widget.dart';
import '../../../../database/bookmark_db/bookmark_database.dart';
import '../controller/adhkar_controller.dart';
import '../widgets/options_row.dart';
import '../widgets/text_widget.dart';

class AdhkarItem extends StatelessWidget {
  const AdhkarItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final azkarCtrl = AzkarController.instance;
    // مزامنة البيانات وجدولة التمرير إلى الذكر المستهدف (لوجيك في الكنترولر).
    // آمن في كل بناء: getAdhkar متطابقة، وscrollToTargetZekr يصفّر الهدف بعد التمرير.
    azkarCtrl.onAdhkarItemReady();
    // جولة شاشة القسم تبدأ أول مرة فقط، بعد إطار البناء الأول حتى تُبنى
    // أهدافها، والعلم داخل AppTour يمنع تكرارها مهما أُعيد البناء. وتلي في
    // الترتيب تمريرَ الذكر المستهدف فيُنجز قبله.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppTour.instance.startAzkarItemTourOnce();
    });

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, _) {
        AppTour.instance.closeTourIfRunning();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        appBar: AppBarWidget(
          isTitled: true,
          title: azkarCtrl.state.filteredDhekrList.first.category,
          isFontSize: true,
          // هدف جولة شاشة القسم: زر تغيير حجم الخط.
          fontSizeButtonKey: AzkarTourKeys.fontSize,
          searchButton: const SizedBox.shrink(),
          isNotifi: true,
          isBooks: false,
        ),
        body: SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: context.customOrientation(
                const EdgeInsets.all(0),
                const EdgeInsets.symmetric(horizontal: 64.0),
              ),
              child: Stack(
                children: [
                  // SingleChildScrollView + Column (غير كسول) لضمان بناء كل العناصر
                  // وتوفّر GlobalKey لكل عنصر، مما يجعل Scrollable.ensureVisible يعمل دائماً.
                  SingleChildScrollView(
                    controller: azkarCtrl.state.itemScrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final (i, zekr)
                            in azkarCtrl.state.filteredDhekrList.indexed)
                          _ZekrEntry(zekr: zekr, tourTarget: i == 0),
                      ],
                    ),
                  ),
                  TourReplayButton(
                    onPressed: () => AppTour.instance.replayAzkarItemTour(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// عنصر ذكر واحد مع مفتاح عام (للتمرير إليه) وتمييز بصري مؤقت عند الطلب.
/// [tourTarget] على أول عنصر فقط: أهداف جولة شاشة القسم (شريط الخيارات
/// ونص الذكر) على أول عنصر ظاهر أعلى القائمة، ومفتاح كل العناصر يجعل
/// الإضاءة تقع على آخر عنصر بُني في مدى الذاكرة.
class _ZekrEntry extends StatelessWidget {
  final AdhkarData zekr;
  final bool tourTarget;
  const _ZekrEntry({required this.zekr, required this.tourTarget});

  @override
  Widget build(BuildContext context) {
    final azkarCtrl = AzkarController.instance;
    final key = azkarCtrl.state.itemKeys.putIfAbsent(
      zekr.id,
      () => GlobalKey(),
    );
    return Obx(() {
      final isHighlighted = azkarCtrl.state.highlightedZekrId.value == zekr.id;
      return KeyedSubtree(
        key: key,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
          margin: isHighlighted
              ? const EdgeInsetsDirectional.fromSTEB(4, 32, 4, 0)
              : const EdgeInsetsDirectional.fromSTEB(8, 32, 8, 0),
          decoration: isHighlighted
              ? BoxDecoration(
                  color: Theme.of(
                    context,
                  ).primaryColorLight.withValues(alpha: .1),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).primaryColorLight.withValues(alpha: .4),
                    width: 1.5,
                  ),
                )
              : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OptionsRow(
                // هدف جولة شاشة القسم: شريط خيارات أول ذكر.
                key: tourTarget ? AzkarTourKeys.optionsRow : null,
                zekr: zekr,
                azkarFav: false,
              ),
              TextWidget(
                // هدف جولة شاشة القسم: نص أول ذكر ومرجعه.
                key: tourTarget ? AzkarTourKeys.zekrText : null,
                zekr: zekr,
              ),
            ],
          ),
        ),
      );
    });
  }
}
