part of '../../quran.dart';

class NavBarWidget extends StatelessWidget {
  NavBarWidget({super.key});
  final generalCtrl = GeneralController.instance;
  final quranCtrl = QuranController.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPillButton(
                  context,
                  () {
                    if (GlobalKeyManager().drawerKey.currentState != null) {
                      GlobalKeyManager().drawerKey.currentState!.toggle();
                    }
                  },
                  customSvgWithColor(
                    SvgPath.svgListIcon,
                    height: 22.0,
                    width: 22.0,
                    color: Get.theme.colorScheme.secondary,
                  ),
                ),
                _buildPillButton(
                  context,
                  () {
                    customBottomSheet(const KhatmahBookmarksScreen());
                    generalCtrl.state.showSelectScreenPage.value = false;
                  },
                  customSvgWithColor(
                    SvgPath.svgBookmarkList,
                    height: 22.0,
                    width: 22.0,
                    color: Get.theme.colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPillButton(
    BuildContext context,
    VoidCallback? onTap,
    Widget child,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.2),
          borderRadius: const BorderRadius.all(Radius.circular(14)),
        ),
        child: child,
      ),
    );
  }
}
