import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/extensions.dart';
import '/presentation/screens/quran_page/widgets/khatmah/screen/khatmahs_screen.dart';
import 'bookmarks_list.dart';

class KhatmahBookmarksScreen extends StatelessWidget {
  const KhatmahBookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * .93,
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8.0),
            topRight: Radius.circular(8.0),
          )),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  context.customWhiteClose(),
                  const Gap(8),
                  context.vDivider(height: 20),
                  const Gap(8),
                  Flexible(
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.all(4.0),
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor.withOpacity(.1),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      child: TabBar(
                        unselectedLabelColor: Colors.grey,
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.surface,
                          fontFamily: 'kufi',
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                        unselectedLabelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.surface,
                          fontFamily: 'kufi',
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                        indicator: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            color:
                                Theme.of(context).colorScheme.primaryContainer),
                        tabs: [
                          Tab(
                            text: 'bookmarks'.tr,
                          ),
                          Tab(
                            text: 'khatmah'.tr,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(32),
              Flexible(
                child: Column(
                  children: [
                    Expanded(
                      child: TabBarView(
                        children: <Widget>[
                          BookmarksList(),
                          KhatmasScreen(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
