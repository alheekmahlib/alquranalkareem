import 'package:alquranalkareem/core/utils/helpers/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/tab_bar_widget.dart';
import '../widgets/tab_bar_view_widget.dart';

class AdhkarView extends StatelessWidget {
  const AdhkarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: DefaultTabController(
            length: 2,
            child: Stack(
              children: [
                const TabBarViewWidget(),
                TopBarWidget(
                  isHomeChild: true,
                  isQuranSetting: false,
                  isNotification: false,
                  centerChild: Container(
                    height: 45,
                    padding: const EdgeInsets.all(4.0),
                    margin: const EdgeInsets.only(top: 4.0),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surface.withValues(alpha: .2),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Container(
                      height: 45,
                      width: Get.width * .69,
                      child: TabBar(
                        unselectedLabelColor: context.theme.colorScheme.primary,
                        labelStyle: AppTextStyles.titleSmall(
                          color: context.theme.canvasColor,
                        ),
                        dividerColor: Colors.transparent,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                          color: Theme.of(context).primaryColorLight,
                        ),
                        tabs: [
                          Semantics(
                            button: true,
                            enabled: true,
                            excludeSemantics: true,
                            label: 'azkar'.tr,
                            child: Tab(text: 'azkar'.tr),
                          ),
                          Semantics(
                            button: true,
                            enabled: true,
                            excludeSemantics: true,
                            label: 'azkarfav'.tr,
                            child: Tab(text: 'azkarfav'.tr),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
