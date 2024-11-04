part of '../../quran.dart';

class NavBarWidget extends StatelessWidget {
  NavBarWidget({super.key});
  final generalCtrl = GeneralController.instance;
  final quranCtrl = QuranController.instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.translate(
          offset: const Offset(0, 2),
          child: Row(
            // mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  if (GlobalKeyManager().drawerKey.currentState != null) {
                    GlobalKeyManager().drawerKey.currentState!.toggle();
                  }
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    RotatedBox(
                      quarterTurns: 30,
                      child: customSvgWithColor(SvgPath.svgButtonCurve,
                          height: 45.0,
                          width: 45.0,
                          color: Get.theme.colorScheme.primary),
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      margin: const EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                          border: Border.all(
                              width: 1,
                              color: Theme.of(context).colorScheme.surface)),
                      child: customSvg(
                        SvgPath.svgListIcon,
                        height: 25,
                        width: 25,
                      ),
                    ),
                  ],
                ),
              ),
              // PagesIndicator(),
              GestureDetector(
                onTap: () {
                  Get.bottomSheet(const KhatmahBookmarksScreen(),
                      isScrollControlled: true);
                  generalCtrl.state.showSelectScreenPage.value = false;
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    RotatedBox(
                      quarterTurns: 30,
                      child: customSvgWithColor(SvgPath.svgButtonCurve,
                          height: 45.0,
                          width: 45.0,
                          color: Get.theme.colorScheme.primary),
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      margin: const EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                          border: Border.all(
                              width: 1,
                              color: Theme.of(context).colorScheme.surface)),
                      child: customSvg(
                        SvgPath.svgBookmarkList,
                        height: 25,
                        width: 25,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 15,
          width: MediaQuery.sizeOf(context).width,
          color: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }
}
