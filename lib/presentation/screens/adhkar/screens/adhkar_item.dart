import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/utils/constants/extensions/extensions.dart';
import '../../../../core/widgets/app_bar_widget.dart';
import '../controller/adhkar_controller.dart';
import '../widgets/options_row.dart';
import '../widgets/text_widget.dart';

class AdhkarItem extends StatelessWidget {
  const AdhkarItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final azkarCtrl = AzkarController.instance;
    azkarCtrl.getAdhkar();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
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
          child: Padding(
            padding: context.customOrientation(const EdgeInsets.all(0),
                const EdgeInsets.symmetric(horizontal: 64.0)),
            child: ListView.builder(
                itemCount: azkarCtrl.state.filteredDhekrList.length,
                itemBuilder: (context, index) {
                  var zekr = azkarCtrl.state.filteredDhekrList[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Gap(32),
                        OptionsRow(
                          zekr: zekr,
                          azkarFav: false,
                        ),
                        TextWidget(
                          zekr: zekr,
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
