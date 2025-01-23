part of '../../whats_new.dart';

class WhatsNewWidget extends StatelessWidget {
  const WhatsNewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
      width: size.width,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: .3),
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      child: Text(
        "What's New".tr,
        style: TextStyle(
          color: Theme.of(context).colorScheme.inversePrimary,
          fontSize: 14.0.sp,
          fontFamily: 'kufi',
        ),
      ),
    );
  }
}
