import 'package:flutter/material.dart';

import '../../../core/utils/constants/extensions/extensions.dart';
import '../../../core/widgets/app_bar_widget.dart';
import 'widgets/group_buttons_widget.dart';
import 'widgets/waqf_list_build.dart';

class AlwaqfScreen extends StatelessWidget {
  AlwaqfScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        appBar: const AppBarWidget(isTitled: false),
        body: SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: context.customOrientation(1, 2),
                  child: GroupButtonsWidget(),
                ),
                context.hDivider(color: Theme.of(context).colorScheme.primary),
                Expanded(
                  flex: 9,
                  child: WaqfListBuild(),
                ),
              ],
            ),
          ),
        ));
  }
}
