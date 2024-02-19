import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:info_popup/info_popup.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/lottie.dart';
import '../../../controllers/ourApps_controller.dart';
import '../data/models/ourApp_model.dart';
import '/core/utils/constants/extensions.dart';

class OurAppsBuild extends StatelessWidget {
  const OurAppsBuild({super.key});

  @override
  Widget build(BuildContext context) {
    final ourApps = sl<OurAppsController>();
    return FutureBuilder<List<OurAppInfo>>(
      future: ourApps.fetchApps(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<OurAppInfo>? apps = snapshot.data;
          return SizedBox(
            height: 240,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ListView.separated(
                shrinkWrap: false,
                padding: EdgeInsets.zero,
                itemCount: apps!.length,
                separatorBuilder: (context, i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: context.hDivider(width: 10.0),
                ),
                itemBuilder: (context, index) {
                  // if (index >= 2) {
                  //   index++;
                  // }
                  return InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8))),
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SvgPicture.network(
                            apps[index].appLogo,
                            height: 45,
                            width: 45,
                          ),
                          context.vDivider(height: 40.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  apps[index].appTitle,
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 13,
                                      fontFamily: 'kufi',
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 8.0.h,
                                ),
                                Text(
                                  apps[index].body,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surface
                                          .withOpacity(.7),
                                      fontSize: 11,
                                      fontFamily: 'kufi',
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          InfoPopupWidget(
                            contentTitle: apps[index].aboutApp3.tr,
                            arrowTheme: InfoPopupArrowTheme(
                              color: Theme.of(context).colorScheme.surface,
                              arrowDirection: ArrowDirection.down,
                            ),
                            contentTheme: InfoPopupContentTheme(
                              infoContainerBackgroundColor:
                                  Theme.of(context).colorScheme.background,
                              infoTextStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.surface,
                                  fontSize: 12,
                                  fontFamily: 'kufi'),
                              contentPadding: const EdgeInsets.all(16.0),
                              contentBorderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                              infoTextAlign: TextAlign.justify,
                            ),
                            dismissTriggerBehavior:
                                PopupDismissTriggerBehavior.onTapArea,
                            areaBackgroundColor: Colors.transparent,
                            indicatorOffset: Offset.zero,
                            contentOffset: Offset.zero,
                            child: Icon(
                              Icons.info_outline_rounded,
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      ourApps.launchURL(context, index, apps[index]);
                    },
                  );
                },
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return loading(width: 200.0, height: 200.0);
      },
    );
  }
}
