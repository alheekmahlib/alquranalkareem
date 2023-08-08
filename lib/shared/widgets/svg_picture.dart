import 'package:alquranalkareem/cubit/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../quran_page/data/repository/bookmarks_controller.dart';

besmAllah(BuildContext context) {
  return SvgPicture.asset(
    'assets/svg/besmAllah.svg',
    width: 200,
    colorFilter: ColorFilter.mode(
        Theme.of(context).cardColor.withOpacity(.8), BlendMode.srcIn),
  );
}

spaceLine(double height, width) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: SvgPicture.asset(
      'assets/svg/space_line.svg',
      height: height,
      width: width,
    ),
  );
}

quranIcon(BuildContext context, double height, width) {
  return SvgPicture.asset(
    'assets/svg/quran_au_ic.svg',
    colorFilter: ColorFilter.mode(
        Theme.of(context).colorScheme.surface, BlendMode.srcIn),
    width: width,
    height: height,
  );
}

bookmarkIcon(BuildContext context, double height, width) {
  QuranCubit cubit = QuranCubit.get(context);
  return GetBuilder<BookmarksController>(builder: (bookmarksController) {
    return SvgPicture.asset(
      'assets/svg/bookmark_ic.svg',
      width: width,
      height: height,
      colorFilter: bookmarksController.isPageBookmarked(cubit.cuMPage)
          ? null
          : ColorFilter.mode(
              Theme.of(context).primaryColorDark, BlendMode.srcIn),
    );
  });
}
