import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '/core/utils/constants/extensions.dart';
import '/core/widgets/widgets.dart';

class TopBarWidget extends StatelessWidget {
  const TopBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:
          context.customOrientation(130.0, context.definePlatform(40.0, 130.0)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: .1,
            child: SvgPicture.asset('assets/svg/splash_icon.svg'),
          ),
          SvgPicture.asset(
            'assets/svg/Logo_line2.svg',
            height: 80,
            width: MediaQuery.sizeOf(context).width / 1 / 2,
          ),
          Align(
            alignment: Alignment.topRight,
            child: customClose(context),
          ),
        ],
      ),
    );
  }
}
