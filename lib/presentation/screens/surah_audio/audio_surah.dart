part of 'surah_audio.dart';

class AudioScreen extends StatelessWidget {
  const AudioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final surahCtrl = AudioCtrl.instance;
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
        backgroundColor: context.theme.colorScheme.primaryContainer,
        body: SafeArea(
          child: Container(
            color: context.theme.colorScheme.primaryContainer,
            child: Stack(
              children: [
                const BackDropWidget(),
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
                        child: Container(
                          width: context.customOrientation(
                            Get.width,
                            Get.width * .5,
                          ),
                          margin: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16,
                          ),
                          decoration: BoxDecoration(
                            color: context.theme.colorScheme.primary,
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
                                firstChild: const SizedBox(
                                  height: 100,
                                  child: CollapsedPlayWidget(),
                                ),
                                secondChild: PlayWidget(),
                                crossFadeState:
                                    surahCtrl.surahState.isPlayExpanded.value
                                    ? CrossFadeState.showSecond
                                    : CrossFadeState.showFirst,
                              ),
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
        ),
      ),
    );
  }

  // @override
  bool get wantKeepAlive => true;
}
