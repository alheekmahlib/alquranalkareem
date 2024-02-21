import 'package:alquranalkareem/presentation/screens/quran_page/widgets/search/quran_search.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/constants/svg_picture.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({required this.openContainer});

  final VoidCallback openContainer;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: _InkWellOverlay(
        openContainer: openContainer,
        height: 40,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'search_word'.tr,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontFamily: 'kufi',
                    fontSize: 15),
              ),
              search_icon(height: 20.0)
            ],
          ),
        ),
      ),
    );
  }
}

class _InkWellOverlay extends StatelessWidget {
  const _InkWellOverlay({
    this.openContainer,
    this.height,
    this.child,
  });

  final VoidCallback? openContainer;
  final double? height;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: MediaQuery.sizeOf(context).width * .67,
      child: InkWell(
        onTap: openContainer,
        child: child,
      ),
    );
  }
}

class OpenContainerWrapper extends StatelessWidget {
  const OpenContainerWrapper({
    required this.closedBuilder,
    required this.transitionType,
    this.onClosed,
  });

  final CloseContainerBuilder closedBuilder;
  final ContainerTransitionType transitionType;
  final ClosedCallback<bool?>? onClosed;

  @override
  Widget build(BuildContext context) {
    return OpenContainer<bool>(
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      transitionType: transitionType,
      closedElevation: 5,
      closedColor: Theme.of(context).colorScheme.background,
      openColor: Theme.of(context).colorScheme.background,
      openBuilder: (BuildContext context, VoidCallback _) {
        return QuranSearch();
      },
      onClosed: onClosed,
      tappable: false,
      closedBuilder: closedBuilder,
    );
  }
}
