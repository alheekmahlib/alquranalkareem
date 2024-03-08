import 'package:flutter/material.dart';

import '../screens/azkar_fav.dart';
import 'azkar_list.dart';

class TabBarViewWidget extends StatelessWidget {
  const TabBarViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Flexible(
      child: TabBarView(
        children: <Widget>[
          AzkarList(),
          AzkarFav(),
        ],
      ),
    );
  }
}
