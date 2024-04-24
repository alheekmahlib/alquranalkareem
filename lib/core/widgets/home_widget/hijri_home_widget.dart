import 'package:flutter/material.dart';

import '../../services/services_locator.dart';
import '/presentation/controllers/general_controller.dart';

class HijriHomeWidget extends StatelessWidget {
  HijriHomeWidget({super.key});

  final generalCtrl = sl<GeneralController>();

  @override
  Widget build(BuildContext context) {
    String hijriDate = "01 Muharram 1444";
    return Container(
      key: generalCtrl.globalKey,
      width: 350,
      height: 300,
      color: Theme.of(context).colorScheme.primary,
      child: Center(
        child: Column(
          children: [
            Container(
              height: 100.0,
              width: 100.0,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/basit.jpg'),
                    fit: BoxFit.fitWidth,
                  ),
                  shape: BoxShape.rectangle,
                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                  border: Border.all(
                      color: Theme.of(context).dividerColor, width: 2)),
            ),
            Text(
              'Today is $hijriDate',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
