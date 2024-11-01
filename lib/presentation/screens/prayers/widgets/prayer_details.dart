part of '../prayers.dart';

class PrayerDetails extends StatelessWidget {
  final int index;
  final String prayerName;
  const PrayerDetails(
      {super.key, required this.index, required this.prayerName});

  @override
  Widget build(BuildContext context) {
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
                  'aboutPrayer'.tr,
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
          Text(
            prayerName.tr,
            style: TextStyle(
              fontFamily: 'kufi',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).canvasColor,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
            child: prayerHadithsList[index]['fromQuran'] != ''
                ? Column(
                    children: [
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          'fromQuran:'.tr,
                          style: TextStyle(
                            fontFamily: 'kufi',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).canvasColor,
                          ),
                        ),
                      ),
                      const Gap(16),
                      Text(
                        prayerHadithsList[index]['fromQuran'],
                        style: TextStyle(
                          fontFamily: 'uthmanic2',
                          fontSize: 22,
                          color: Theme.of(context).canvasColor,
                        ),
                      ),
                      context.hDivider(
                          width: Get.width * .5,
                          height: 1,
                          color: context.theme.canvasColor),
                      Text(
                        prayerHadithsList[index]['ayahNumber'],
                        style: TextStyle(
                          fontFamily: 'naskh',
                          fontSize: 14,
                          color: Theme.of(context).canvasColor,
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
            child: Column(
              children: [
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    'fromSunnah:'.tr,
                    style: TextStyle(
                      fontFamily: 'kufi',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).canvasColor,
                    ),
                  ),
                ),
                const Gap(16),
                Text(
                  prayerHadithsList[index]['fromSunnah'],
                  style: TextStyle(
                    fontFamily: 'naskh',
                    fontSize: 20,
                    // fontWeight: FontWeight.bold,
                    color: Theme.of(context).canvasColor,
                  ),
                  textAlign: TextAlign.justify,
                ),
                const Gap(8),
                context.hDivider(
                    width: Get.width * .5,
                    height: 1,
                    color: context.theme.canvasColor),
                Text(
                  prayerHadithsList[index]['rule'],
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
    );
  }
}
