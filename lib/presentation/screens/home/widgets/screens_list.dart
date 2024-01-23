import 'package:alquranalkareem/core/widgets/container_with_lines.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/utils/constants/lists.dart';

class ScreensList extends StatelessWidget {
  const ScreensList({super.key});

  @override
  Widget build(BuildContext context) {
    return ContainerWithLines(
        linesColor: Get.theme.colorScheme.primary,
        containerColor: Get.theme.colorScheme.primary.withOpacity(.2),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            alignment: WrapAlignment.center,
            children: List.generate(
                screensList.length,
                (index) => GestureDetector(
                      onTap: () => Get.to(screensList[index]['route'],
                          transition: Transition.downToUp),
                      child: Container(
                        height: 65,
                        width: screensList[index]['width'],
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Get.theme.colorScheme.primary,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            boxShadow: [
                              BoxShadow(
                                  color: Get.theme.colorScheme.surface
                                      .withOpacity(.4),
                                  offset: const Offset(6, 6),
                                  spreadRadius: 0,
                                  blurRadius: 0)
                            ]),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              screensList[index]['svgUrl'],
                              height: 65,
                            ),
                            screensList[index]['name'] != ''
                                ? Container(
                                    width: 150,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 8.0),
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(4)),
                                        border: Border.all(
                                            color:
                                                Get.theme.colorScheme.surface,
                                            width: 1)),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        screensList[index]['name'],
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontFamily: 'kufi',
                                            color: Get
                                                .theme.colorScheme.secondary),
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ],
                        ),
                      ),
                    )),
          ),
        ));
  }
}
