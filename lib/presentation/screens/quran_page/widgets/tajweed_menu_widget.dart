part of '../quran.dart';

class TajweedMenuWidget extends StatelessWidget {
  TajweedMenuWidget({super.key});

  final quranCtrl = QuranController.instance;

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return (orientation == Orientation.landscape) &&
            !(Responsive.isMobile(context) ||
                Responsive.isMobileLarge(context) ||
                Responsive.isTablet(context) ||
                Responsive.isDesktop(context))
        ? const SizedBox.shrink()
        : FloatingMenuExpendable(
            controller: quranCtrl.state.floatingController,
            panelWidth: 460,
            panelHeight: 460,
            handleWidth: 80,
            handleHeight: 60,
            expandPanelFromHandle: true,
            initialPosition: const Offset(12, 130),
            openMode: FloatingMenuExpendableOpenMode.vertical,
            style: FloatingMenuExpendableStyle(
              // Background barrier
              showBarrierWhenOpen: true,
              barrierDismissible: true,
              barrierColor: context.theme.colorScheme.primaryContainer
                  .withValues(alpha: 0.3),
              barrierBlurSigmaX: 10,
              barrierBlurSigmaY: 10,
              panelDecoration: BoxDecoration(
                color: context.theme.primaryColorLight,
                borderRadius: BorderRadius.circular(8),
              ),
              panelBorderRadius: BorderRadius.circular(8),
            ),
            handleChild: customSvg(
              SvgPath.svgAlwaqfMushafOrthographic,
              height: 40,
            ),
            panelChild: AlwaqfScreen(),
          );
  }
}
