import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/tab_bar_widget.dart';
import '../widgets/tab_bar_view_widget.dart';

class AzkarView extends StatelessWidget {
  const AzkarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                TabBarWidget(
                  isFirstChild: true,
                  isCenterChild: true,
                  centerChild: Container(
                    height: 40,
                    width: MediaQuery.sizeOf(context).width * .69,
                    margin: const EdgeInsets.only(top: 7.0),
                    child: TabBar(
                      unselectedLabelColor:
                          Theme.of(context).colorScheme.primary,
                      labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontFamily: 'kufi',
                        fontSize: 11,
                      ),
                      dividerColor: Colors.transparent,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                          color: Theme.of(context).colorScheme.primary),
                      tabs: [
                        Semantics(
                          button: true,
                          enabled: true,
                          excludeSemantics: true,
                          label: 'azkar'.tr,
                          child: Tab(
                            text: 'azkar'.tr,
                          ),
                        ),
                        Semantics(
                          button: true,
                          enabled: true,
                          excludeSemantics: true,
                          label: 'azkarfav'.tr,
                          child: Tab(
                            text: 'azkarfav'.tr,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const TabBarViewWidget(),
              ],
            )),
      ),
    );
  }
}
