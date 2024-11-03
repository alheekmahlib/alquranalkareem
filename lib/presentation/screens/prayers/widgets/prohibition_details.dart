part of '../prayers.dart';

class ProhibitionWidget extends StatelessWidget {
  const ProhibitionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<AdhanController>(
      builder: (adhanCtrl) => adhanCtrl.prohibitionTimesBool.value
          ? GestureDetector(
              onTap: () => Get.bottomSheet(
                  prohibitionDetails(
                    context,
                    adhanCtrl.state.prohibitionTimesIndex.value,
                  ),
                  isScrollControlled: true),
              child: Container(
                height: 40,
                width: Get.width * .7,
                padding:
                    const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
                margin: const EdgeInsets.symmetric(horizontal: 6.0),
                decoration: BoxDecoration(
                  color: const Color(0xfff16938).withOpacity(.2),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(4),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    RoundedProgressBar(
                      height: 34,
                      style: RoundedProgressBarStyle(
                        borderWidth: 0,
                        widthShadow: 5,
                        backgroundProgress:
                            const Color(0xfff16938).withOpacity(.5),
                        colorProgress: const Color(0xfff16938),
                        colorProgressDark:
                            const Color(0xfff16938).withOpacity(.5),
                        colorBorder: Colors.transparent,
                        colorBackgroundIcon: Colors.transparent,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      percent: adhanCtrl.getTimeLeftPercentage.value,
                    ),
                    Text(
                      'prohibitionTimes'.tr,
                      style: TextStyle(
                        fontFamily: 'kufi',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).canvasColor,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget prohibitionDetails(BuildContext context, int index) {
    return Container(
      height: Get.height * .55,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          )),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: context.customClose(height: 40),
              ),
              context.vDivider(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'prohibitionTimes'.tr,
                  style: TextStyle(
                    fontFamily: 'kufi',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).canvasColor,
                  ),
                ),
              ),
            ],
          ),
          Flexible(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 16.0),
                  child: Text(
                    '${prohibitionTimesList[index]['title']}'.tr,
                    style: TextStyle(
                      fontFamily: 'kufi',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).canvasColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 16.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          'fromSunnah:'.tr,
                          style: TextStyle(
                            fontFamily: 'kufi',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).canvasColor,
                          ),
                        ),
                      ),
                      const Gap(8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        decoration: BoxDecoration(
                            color:
                                Theme.of(context).canvasColor.withOpacity(.2),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            )),
                        child: Text(
                          prohibitionTimesList[index]['hadith'],
                          style: TextStyle(
                            fontFamily: 'naskh',
                            fontSize: 20,
                            // fontWeight: FontWeight.bold,
                            color: Theme.of(context).canvasColor,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      const Gap(8),
                      context.hDivider(
                          width: Get.width * .5,
                          height: 1,
                          color: context.theme.canvasColor),
                      Text(
                        prohibitionTimesList[index]['source'],
                        style: TextStyle(
                          fontFamily: 'naskh',
                          fontSize: 14,
                          color: Theme.of(context).canvasColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Gap(16),
        ],
      ),
    );
  }
}
