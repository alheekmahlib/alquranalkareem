import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/widgets/container_with_border.dart';
import '../../controllers/general/general_controller.dart';

class UserOptions extends StatelessWidget {
  const UserOptions({super.key});

  @override
  Widget build(BuildContext context) {
    final generalCtrl = GeneralController.instance;
    return ContainerWithBorder(
      color: Theme.of(context).colorScheme.surface.withOpacity(.15),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            InkWell(
              child: Row(
                children: [
                  Icon(
                    Icons.share_outlined,
                    color: Theme.of(context).hintColor,
                    size: 22,
                  ),
                  Container(
                    width: 2,
                    height: 20,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  Text(
                    'share'.tr,
                    style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontFamily: 'kufi',
                        fontStyle: FontStyle.italic,
                        fontSize: 14),
                  ),
                ],
              ),
              onTap: () async {
                await generalCtrl.share();
              },
            ),
            const Divider(),
            InkWell(
              onTap: generalCtrl.launchEmail,
              child: Row(
                children: [
                  Icon(
                    Icons.email_outlined,
                    color: Theme.of(context).hintColor,
                    size: 22,
                  ),
                  Container(
                    width: 2,
                    height: 20,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  Text(
                    'email'.tr,
                    style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontFamily: 'kufi',
                        fontStyle: FontStyle.italic,
                        fontSize: 14),
                  ),
                ],
              ),
            ),
            const Divider(),
            // InkWell(
            //   onTap: launchFacebookUrl,
            //   child: Row(
            //     children: [
            //       Icon(
            //         Icons.facebook_rounded,
            //         color: Theme.of(context).primaryColorLight,
            //         size: 22,
            //       ),
            //       Container(
            //         width: 2,
            //         height: 20,
            //         margin: const EdgeInsets.symmetric(horizontal: 8),
            //         color: Theme.of(context).colorScheme.surface,
            //       ),
            //       Text(
            //         'facebook'.tr,
            //         style: TextStyle(
            //             color: Theme.of(context).primaryColorLight,
            //             fontFamily: 'kufi',
            //             fontStyle: FontStyle.italic,
            //             fontSize: 14),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
