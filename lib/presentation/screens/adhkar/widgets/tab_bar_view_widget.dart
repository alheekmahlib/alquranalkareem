import 'package:flutter/material.dart';

import '../screens/adhkar_fav.dart';
import 'adhkar_list.dart';

class TabBarViewWidget extends StatelessWidget {
  const TabBarViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Flexible(
      child: TabBarView(
        children: <Widget>[
          AdhkarList(),
          AdhkarFav(),
        ],
      ),
    );
  }
}
