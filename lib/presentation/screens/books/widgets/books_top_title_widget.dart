part of '../books.dart';

class BooksTopTitleWidget extends StatelessWidget {
  final int bookNumber;
  final int index;
  final booksCtrl = BooksController.instance;

  BooksTopTitleWidget({
    super.key,
    required this.bookNumber,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _isTashkilBuild(context),
          const Gap(8),
          fontSizeSliderWidget(context),
          const Gap(8),
          _changeBackgroundColor(context),
        ],
      ),
    );
  }

  Widget fontSizeSliderWidget(BuildContext context) {
    return SizedBox(
      height: 35,
      width: Get.width * .5,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Container(
              height: 35,
              // width: Get.width * .4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: context.theme.primaryColorLight.withValues(alpha: .2),
                  width: 1,
                ),
              ),
              child: Obx(
                () => FlutterSlider(
                  values: [
                    GeneralController.instance.state.fontSizeArabic.value,
                  ],
                  max: 50,
                  min: 20,
                  rtl: true,
                  trackBar: FlutterSliderTrackBar(
                    inactiveTrackBarHeight: 5,
                    activeTrackBarHeight: 5,
                    inactiveTrackBar: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: context.theme.colorScheme.surface,
                    ),
                    activeTrackBar: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: context.theme.colorScheme.primary,
                    ),
                  ),
                  handlerAnimation: const FlutterSliderHandlerAnimation(
                    curve: Curves.elasticOut,
                    reverseCurve: null,
                    duration: Duration(milliseconds: 700),
                    scale: 1.4,
                  ),
                  onDragging: (handlerIndex, lowerValue, upperValue) async {
                    lowerValue = lowerValue;
                    upperValue = upperValue;
                    GeneralController.instance.state.fontSizeArabic.value =
                        lowerValue;

                    GeneralController.instance.state.box.write(
                      FONT_SIZE,
                      lowerValue,
                    );
                  },
                  handler: FlutterSliderHandler(
                    decoration: const BoxDecoration(),
                    child: Material(
                      type: MaterialType.circle,
                      color: Colors.transparent,
                      elevation: 3,
                      child: customSvg('assets/svg/slider_ic.svg'),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Gap(8),
          Semantics(
            button: true,
            enabled: true,
            label: 'Change Font Size',
            child: customSvgWithColor(
              SvgPath.svgFontSize,
              height: 25.0,
              width: 25.0,
              color: context.theme.primaryColorLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _isTashkilBuild(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GetX<BooksController>(
        builder: (booksCtrl) => CustomButton(
          height: 50,
          width: 45,
          isCustomSvgColor: true,
          svgPath: SvgPath.svgTashkil,
          svgColor: booksCtrl.state.isTashkil.value
              ? context.theme.canvasColor
              : context.theme.canvasColor.withValues(alpha: .5),
          backgroundColor: context.theme.colorScheme.primary,
          borderColor: context.theme.primaryColorLight.withValues(alpha: .2),
          onPressed: () => booksCtrl.isTashkilOnTap(),
        ),
      ),
    );
  }

  Widget _changeBackgroundColor(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Obx(
        () => CustomButton(
          onPressed: () {
            Get.dialog(
              Dialog(
                alignment: Alignment.center,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                surfaceTintColor: Theme.of(context).colorScheme.primary,
                child: SizedBox(
                  height: 240,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    child: Column(
                      children: [
                        ColorPicker(
                          hasBorder: true,
                          wheelHasBorder: true,
                          wheelDiameter: 300,
                          color: Color(
                            booksCtrl.state.backgroundPickerColor.value,
                          ),
                          borderColor: context.theme.colorScheme.primary,
                          onColorChanged: (Color color) =>
                              booksCtrl.state.temporaryBackgroundColor.value =
                                  color.toARGB32(),
                          pickersEnabled: {
                            ColorPickerType.wheel: false,
                            ColorPickerType.both: false,
                            ColorPickerType.primary: false,
                            ColorPickerType.accent: false,
                            ColorPickerType.custom: true,
                          },
                          customColorSwatchesAndNames: {
                            const MaterialColor(0xffFFFBF8, <int, Color>{
                              50: Color(0xffffffff),
                              100: Color(0xfffffbfb),
                              200: Color(0xffFFFBF8),
                              300: Color(0xfffff9f5),
                              400: Color(0xfffff7f1),
                              500: Color(0xfffff6e2),
                              600: Color(0xffefe3d1),
                              700: Color(0xffdacdba),
                              800: Color(0xffc8bba6),
                              900: Color(0xffe3d0ac),
                            }): 'Brown',
                          },
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: ContainerButton(
                                onPressed: () {
                                  booksCtrl.state.backgroundPickerColor.value =
                                      0xfffaf7f3;
                                  booksCtrl.state.box.remove(
                                    BACKGROUND_PICKER_COLOR_FOR_BOOK,
                                  );
                                  booksCtrl.update();
                                  Get.back();
                                },
                                height: 35,
                                title: 'reset',
                                horizontalPadding: 16.0,
                                mainAxisAlignment: MainAxisAlignment.center,
                              ),
                            ),
                            const Spacer(),
                            Expanded(
                              flex: 3,
                              child: ContainerButton(
                                onPressed: () => Get.back(),
                                height: 35,
                                title: 'cancel',
                                horizontalPadding: 16.0,
                                mainAxisAlignment: MainAxisAlignment.center,
                              ),
                            ),
                            const Gap(8),
                            Expanded(
                              flex: 3,
                              child: ContainerButton(
                                onPressed: () {
                                  booksCtrl.state.backgroundPickerColor.value =
                                      booksCtrl
                                          .state
                                          .temporaryBackgroundColor
                                          .value;
                                  booksCtrl.state.box.write(
                                    BACKGROUND_PICKER_COLOR_FOR_BOOK,
                                    booksCtrl.state.backgroundPickerColor.value,
                                  );
                                  booksCtrl.update();
                                  Get.back();
                                },
                                height: 35,
                                title: 'ok',
                                horizontalPadding: 16.0,
                                mainAxisAlignment: MainAxisAlignment.center,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          height: 50,
          width: 45,
          isCustomSvgColor: true,
          svgPath: SvgPath.svgBooksBackgroundIcon,
          svgColor: Color(booksCtrl.state.backgroundPickerColor.value),
          backgroundColor: context.theme.colorScheme.primary,
        ),
      ),
    );
  }
}
