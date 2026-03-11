part of '../surah_audio.dart';

class AudioScreen extends StatelessWidget {
  AudioScreen({super.key});
  final quranCtrl = QuranController.instance;
  final surahCtrl = AudioCtrl.instance;

  @override
  Widget build(BuildContext context) {
    // surahCtrl.loadSurahReader();
    // surahCtrl.loadLastSurahListen;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, _) {
        if (didPop) {
          return;
        }
        surahCtrl.state.audioPlayer.stop();
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: context.theme.colorScheme.primary,
        body: SafeArea(
          child: Container(
            color: context.theme.colorScheme.primaryContainer,
            child: Stack(
              children: [
                BackDropWidget(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        // عند السحب للأعلى يفتح السلايدر، وعند السحب للأسفل يغلق
                        // On vertical drag: up opens, down closes
                        onVerticalDragUpdate: (details) {
                          if (details.primaryDelta != null) {
                            if (details.primaryDelta! < -8) {
                              // سحب للأعلى: فتح السلايدر
                              // Drag up: open
                              Future.delayed(
                                const Duration(milliseconds: 10),
                                () =>
                                    surahCtrl.surahState.isPlayExpanded.value =
                                        true,
                              );
                            } else if (details.primaryDelta! > 8) {
                              // سحب للأسفل: إغلاق السلايدر
                              // Drag down: close

                              surahCtrl.surahState.isPlayExpanded.value = false;
                            }
                          }
                        },
                        child: Column(
                          children: [
                            Container(
                              height: 8,
                              width: Get.width,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 62.0,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Theme.of(context).colorScheme.primary,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: .2),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(
                                      0,
                                      -5,
                                    ), // changes position of shadow
                                  ),
                                ],
                              ),
                            ),
                            const Gap(8.0),
                            Container(
                              width: context.customOrientation(
                                Get.width,
                                Get.width * .5,
                              ),
                              margin: const EdgeInsets.only(
                                left: 16,
                                right: 16,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    context.theme.colorScheme.primaryContainer,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: .2),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(
                                      0,
                                      -5,
                                    ), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Obx(
                                () => AnimatedSize(
                                  duration: const Duration(milliseconds: 300),
                                  alignment: AlignmentGeometry.bottomCenter,
                                  child: AnimatedCrossFade(
                                    // مطابقة مدة الأنيميشن مع السلايدر لتجنب overflow
                                    // Match animation duration with slider to avoid overflow
                                    duration: const Duration(milliseconds: 200),
                                    reverseDuration: const Duration(
                                      milliseconds: 200,
                                    ),
                                    secondCurve: Curves.linear,
                                    firstChild: SizedBox(
                                      height: 73,
                                      child: CollapsedPlayWidget(),
                                    ),
                                    secondChild: PlayWidget(),
                                    crossFadeState:
                                        surahCtrl
                                            .surahState
                                            .isPlayExpanded
                                            .value
                                        ? CrossFadeState.showSecond
                                        : CrossFadeState.showFirst,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                TopBarWidget(
                  isHomeChild: true,
                  isQuranSetting: false,
                  isNotification: false,
                  isDraggable: false,
                  centerChild: TextFieldBarWidget(
                    hintText: 'searchToSurah'.tr,
                    controller: surahCtrl.surahState.textController,
                    horizontalPadding: 0.0,
                    onPressed: () {},
                    onButtonPressed: () {
                      surahCtrl.surahState.textController.clear();
                    },
                    onChanged: (query) => AudioCtrl.instance.searchSurah(query),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // @override
  bool get wantKeepAlive => true;
}
