import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdhanSounds extends StatelessWidget {
  const AdhanSounds({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.bottomSheet(Container(), isScrollControlled: true),
      child: Container(
        height: 60,
        width: Get.width,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor.withOpacity(.1),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'أصوات الأذان',
              style: TextStyle(
                fontFamily: 'kufi',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).canvasColor,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_outlined,
              size: 24,
              color: Theme.of(context).canvasColor,
            )
          ],
        ),
      ),
    );
  }
}
