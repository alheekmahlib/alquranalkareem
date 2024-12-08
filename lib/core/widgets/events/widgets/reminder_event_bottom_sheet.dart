part of '../events.dart';

class ReminderEventBottomSheet extends StatelessWidget {
  final String lottieFile;
  final String title;
  final String hadith;
  final String bookInfo;
  final String titleString;
  final String svgPath;
  final int? day;
  final int? month;
  ReminderEventBottomSheet({
    super.key,
    required this.lottieFile,
    required this.title,
    required this.hadith,
    required this.bookInfo,
    required this.titleString,
    required this.svgPath,
    this.day,
    this.month,
  });

  final generalCtrl = GeneralController.instance;
  final eventCtrl = EventController.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * .85,
      width: Get.width,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          )),
      child: Stack(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: context.customOrientation(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    closeWidget(context),
                    const Gap(8),
                    Flexible(
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Column(
                          children: [
                            headerWidget(context),
                            bodyWidget(context),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          closeWidget(context),
                          const Gap(8),
                          headerWidget(context),
                        ],
                      ),
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Column(
                          children: [
                            bodyWidget(context),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Widget closeWidget(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      context.customWhiteClose(),
      const Gap(8),
      context.vDivider(height: 20),
      const Gap(8),
      Text(
        'events'.tr,
        style: TextStyle(
          color: Theme.of(context).canvasColor,
          fontFamily: 'kufi',
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    ]);
  }

  Widget headerWidget(BuildContext context) {
    return Container(
        width: Get.width,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(
              color: Theme.of(context).canvasColor,
              width: 2,
            )),
        child: eventCtrl.getArtWidget(
          ramadanOrEid(lottieFile, width: 200),
          customSvgWithColor(svgPath,
              color: Theme.of(context).canvasColor, width: 200, height: 200),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              titleString,
              style: TextStyle(
                color: Theme.of(context).canvasColor,
                fontFamily: 'kufi',
                fontWeight: FontWeight.bold,
                fontSize: 60,
                height: 3,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          day!,
          month!,
        ));
  }

  Widget bodyWidget(BuildContext context) {
    return Column(
      children: [
        Container(
          width: Get.width,
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              )),
          child: Text(
            title.tr,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontFamily: 'kufi',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              height: 1.7,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              )),
          child: ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: [
              const Gap(8),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      children: hadith.buildTextSpans(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onInverseSurface,
                        fontFamily: 'naskh',
                        fontSize: generalCtrl.state.fontSizeArabic.value,
                        height: 1.7,
                      ),
                    ),
                    WidgetSpan(child: context.hDivider(width: Get.width)),
                    TextSpan(
                      text: bookInfo,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onInverseSurface,
                        fontFamily: 'naskh',
                        fontSize: generalCtrl.state.fontSizeArabic.value - 5,
                        height: 1.7,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        )
      ],
    );
  }
}
