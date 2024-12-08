part of '../../whats_new.dart';

class PageViewBuild extends StatelessWidget {
  final PageController controller;
  final List<Map<String, dynamic>> newFeatures;
  PageViewBuild(
      {super.key, required this.controller, required this.newFeatures});

  final whatsNewCtrl = WhatsNewController.instance;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Flexible(
      child: PageView.builder(
          controller: controller,
          itemCount: newFeatures.length,
          onPageChanged: (page) {
            whatsNewCtrl.state.onboardingPageNumber.value = page;
            whatsNewCtrl.state.currentPageIndex.value = page;
          },
          itemBuilder: (context, index) {
            // splashCtrl.onboardingPageNumber.value =
            //     newFeatures[index]['index'] + index;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(16),
                  newFeatures[index]['title'] == ''
                      ? const SizedBox.shrink()
                      : Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surface
                                  .withOpacity(.3),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4))),
                          child: Text(
                            '${newFeatures[index]['title']}'.tr,
                            style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              fontSize: 16.0.sp,
                              fontFamily: 'kufi',
                              height: 2,
                            ),
                          ),
                        ),
                  const Gap(8),
                  newFeatures[index]['imagePath'] == ''
                      ? const SizedBox.shrink()
                      : Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surface
                                    .withOpacity(.3),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(8.0))),
                            child: Image.asset(
                              newFeatures[index]['imagePath'],
                              width: context.customOrientation(
                                  MediaQuery.of(context).size.width * 3 / 4,
                                  MediaQuery.of(context).size.width),
                            ),
                          ),
                        ),
                  const Gap(8),
                  newFeatures[index]['details'] == ''
                      ? const SizedBox.shrink()
                      : Container(
                          width: size.width,
                          padding: const EdgeInsets.all(16.0),
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surface
                                  .withOpacity(.3),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4))),
                          child: Text(
                            '${newFeatures[index]['details']}'.tr,
                            style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              fontSize: 14.0.sp,
                              fontFamily: 'kufi',
                              height: 2,
                            ),
                          ),
                        ),
                ],
              ),
            );
          }),
    );
  }
}
