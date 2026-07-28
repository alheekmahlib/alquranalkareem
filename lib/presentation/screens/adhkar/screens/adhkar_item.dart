import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBarWidget(
        isTitled: true,
        title: azkarCtrl.state.filteredDhekrList.first.category,
        isFontSize: true,
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
            // SingleChildScrollView + Column (غير كسول) لضمان بناء كل العناصر
            // وتوفّر GlobalKey لكل عنصر، مما يجعل Scrollable.ensureVisible يعمل دائماً.
            child: SingleChildScrollView(
              controller: azkarCtrl.state.itemScrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final zekr in azkarCtrl.state.filteredDhekrList)
                    _ZekrEntry(zekr: zekr),
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
class _ZekrEntry extends StatelessWidget {
  final AdhkarData zekr;
  const _ZekrEntry({required this.zekr});

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
              OptionsRow(zekr: zekr, azkarFav: false),
              TextWidget(zekr: zekr),
            ],
          ),
        ),
      );
    });
  }
}
