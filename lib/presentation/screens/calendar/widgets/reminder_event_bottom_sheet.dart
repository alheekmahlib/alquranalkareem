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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TitleWidget(title: 'events'),
          const Gap(8),
          SizedBox(
            height: Get.height * .6,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  headerWidget(context),
                  const Gap(15),
                  bodyWidget(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget headerWidget(BuildContext context) {
    return eventCtrl.getArtWidget(
      ramadanOrEid(lottieFile, width: 200),
      customSvgWithColor(
        svgPath,
        color: Theme.of(context).primaryColorLight,
        width: 300,
        // height: 200,
      ),
      FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          titleString,
          style: AppTextStyles.titleLarge().copyWith(
            color: Theme.of(context).primaryColorLight,
            fontSize: 60,
            height: 3,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      day!,
      month!,
    );
  }

  Widget bodyWidget(BuildContext context) {
    return Column(
      children: [
        Container(
          width: Get.width,
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8),
          ),
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
                      style: AppTextStyles.bodyLarge(),
                    ),
                    WidgetSpan(child: context.hDivider(width: Get.width)),
                    TextSpan(text: bookInfo, style: AppTextStyles.titleSmall()),
                  ],
                ),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
