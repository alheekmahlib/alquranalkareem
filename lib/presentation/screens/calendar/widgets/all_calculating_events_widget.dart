part of '../events.dart';

class AllCalculatingEventsWidget extends StatelessWidget {
  final eventsCtrl = EventController.instance;

  AllCalculatingEventsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset('assets/svg/hijri/${eventsCtrl.hijriNow.hMonth}.svg',
              width: Get.width,
              colorFilter: ColorFilter.mode(
                  Theme.of(context).canvasColor.withValues(alpha: .05),
                  BlendMode.srcIn)),
          Column(mainAxisSize: MainAxisSize.max, children: [
            const Gap(16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                children: [
                  GestureDetector(
                    onVerticalDragUpdate: (details) {
                      if (details.primaryDelta! < 0 &&
                          !eventsCtrl.boxController.isBoxOpen) {
                        eventsCtrl.boxController.openBox();
                      } else if (details.primaryDelta! > 0 &&
                          eventsCtrl.boxController.isBoxOpen) {
                        eventsCtrl.boxController.closeBox();
                      }
                    },
                    onTap: () => eventsCtrl.boxController.isBoxOpen
                        ? eventsCtrl.boxController.closeBox()
                        : eventsCtrl.boxController.openBox(),
                    child: Container(
                      width: Get.width,
                      color: Colors.transparent,
                      child: Icon(
                        Icons.drag_handle_outlined,
                        size: 40,
                        color: Get.theme.canvasColor,
                      ),
                    ),
                  ),
                  Text.rich(
                    TextSpan(children: [
                      TextSpan(
                        text: eventsCtrl.isNewHadith
                            ? monthHadithsList[eventsCtrl.hijriNow.hMonth - 1]
                                ['hadithPart1']
                            : monthHadithsList[1]['hadithPart1'],
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'naskh',
                          height: 1.9,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context)
                              .canvasColor
                              .withValues(alpha: .7),
                        ),
                      ),
                      TextSpan(
                        text: eventsCtrl.isNewHadith
                            ? monthHadithsList[eventsCtrl.hijriNow.hMonth - 1]
                                ['hadithPart2']
                            : monthHadithsList[1]['hadithPart2'],
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'naskh',
                          height: 1.9,
                          fontWeight: FontWeight.bold,
                          color: Color(0xffffffff),
                        ),
                      ),
                      TextSpan(
                        text: eventsCtrl.isNewHadith
                            ? monthHadithsList[1]['bookName']
                            : monthHadithsList[eventsCtrl.hijriNow.hMonth - 1]
                                ['bookName'],
                        style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'naskh',
                          height: 1.7,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context)
                              .canvasColor
                              .withValues(alpha: .7),
                        ),
                      ),
                    ]),
                    textAlign: TextAlign.justify,
                  ),
                  const Gap(16.0),
                  context.hDivider(width: Get.width),
                ],
              ),
            ),
            const Gap(16.0),
            Obx(() {
              if (eventsCtrl.events.isEmpty) {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: eventsCtrl.events.length,
                  itemBuilder: (context, i) => !eventsCtrl.notReminderIndex
                          .contains(eventsCtrl.events[i].id)
                      ? const SizedBox.shrink()
                      : CalculatingDateEventsWidget(
                          name: eventsCtrl.events[i].title.tr,
                          year: eventsCtrl.hijriNow.hYear,
                          month: eventsCtrl.events[i].month,
                          day: eventsCtrl.events[i].day.first,
                        ),
                );
              }
            }),
            context.hDivider(width: Get.width),
            const Gap(16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                'hijriNote'.tr,
                style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'kufi',
                  height: 1.7,
                  color: Theme.of(context).canvasColor.withValues(alpha: .7),
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
