import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/tab_bar_widget.dart';
import '../widgets/tab_bar_view_widget.dart';

class AzkarView extends StatelessWidget {
  const AzkarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.colorScheme.background,
      body: SafeArea(
        child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    const TabBarWidget(
                      isChild: true,
                      isIndicator: false,
                    ),
                    Container(
                      height: 40,
                      width: MediaQuery.sizeOf(context).width * .69,
                      margin: const EdgeInsets.only(top: 30),
                      child: TabBar(
                        unselectedLabelColor: Get.theme.colorScheme.primary,
                        labelStyle: TextStyle(
                          color: Get.theme.colorScheme.secondary,
                          fontFamily: 'kufi',
                          fontSize: 11.sp,
                        ),
                        indicator: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            color: Get.theme.colorScheme.primary),
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
                  ],
                ),
                const TabBarViewWidget(),
              ],
            )),
      ),
    );
  }
}
