part of '../../quran.dart';

class LeftPage extends StatelessWidget {
  final Widget child;

  LeftPage({super.key, required this.child});

  final quranCtrl = QuranController.instance;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: 'Quran Page',
      child: Container(
        height: MediaQuery.sizeOf(context).height,
        margin: const EdgeInsets.only(left: 4.0),
        decoration: BoxDecoration(
            color: Get.isDarkMode
                ? Theme.of(context).primaryColorDark.withValues(alpha: .5)
                : Theme.of(context).dividerColor.withValues(alpha: .5),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12), bottomLeft: Radius.circular(12))),
        child: Container(
          margin: const EdgeInsets.only(left: 4.0),
          decoration: BoxDecoration(
              color: Get.isDarkMode
                  ? Theme.of(context).primaryColorDark.withValues(alpha: .7)
                  : Theme.of(context).dividerColor.withValues(alpha: .7),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12))),
          child: GetX<QuranController>(
            builder: (quranCtrl) => Container(
              margin: const EdgeInsets.only(left: 4.0),
              decoration: BoxDecoration(
                  color: quranCtrl.backgroundColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12))),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
