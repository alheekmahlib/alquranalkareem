import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '/core/utils/constants/lottie_constants.dart';
import '../../../../../core/utils/constants/extensions/extensions.dart';
import '../../../../../core/utils/constants/lottie.dart';
import '../../controller/ourApps_controller.dart';
import '../../data/models/ourApp_model.dart';

class OurAppsBuild extends StatelessWidget {
  OurAppsBuild({super.key});

  final ourApps = OurAppsController.instance;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<OurAppInfo>>(
      future: ourApps.fetchApps(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<OurAppInfo>? apps = snapshot.data;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ListView.separated(
              primary: false,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: apps!.length,
              separatorBuilder: (context, i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: context.hDivider(width: 10.0),
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: SvgPicture.network(
                            apps[index].appLogo,
                            height: 45,
                            width: 45,
                            colorFilter: index == 4
                                ? ColorFilter.mode(
                                    context.theme.colorScheme.onSurface,
                                    BlendMode.modulate,
                                  )
                                : null,
                          ),
                        ),
                        context.vDivider(height: 40.0),
                        Expanded(
                          flex: 7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                apps[index].appTitle,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 13,
                                  fontFamily: 'kufi',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8.0.h),
                              Text(
                                apps[index].body,
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.surface.withValues(alpha: .7),
                                  fontSize: 11,
                                  fontFamily: 'kufi',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
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
          );
        } else if (snapshot.hasError) {
          return customLottie(
            LottieConstants.assetsLottieNoInternet,
            width: 150.0,
            height: 150.0,
          );
        }
        return customLottie(
          LottieConstants.assetsLottieSplashLoading,
          width: 200.0,
          height: 200.0,
        );
      },
    );
  }
}
