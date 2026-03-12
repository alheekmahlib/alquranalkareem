part of '../events.dart';

class CalculatingDateEventsWidget extends StatelessWidget {
  final String name;
  final int year;
  final int month;
  final int day;
  CalculatingDateEventsWidget({
    super.key,
    required this.month,
    required this.day,
    required this.name,
    required this.year,
  });

  final countdownCtrl = EventController.instance;

  @override
  Widget build(BuildContext context) {
    int daysRemaining = countdownCtrl.calculate(year, month, day);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 16.0),
      child: Opacity(
        opacity: daysRemaining == 0 ? .5 : 1,
        child: Container(
          height: 40,
          width: 380,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: context.theme.primaryColorLight.withValues(alpha: .1),
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              RoundedProgressBar(
                height: 30,
                style: RoundedProgressBarStyle(
                  borderWidth: 0,
                  widthShadow: 5,
                  backgroundProgress:
                      context.theme.colorScheme.primaryContainer,
                  colorProgress: context.theme.colorScheme.surface,
                  colorProgressDark: context.theme.colorScheme.surface
                      .withValues(alpha: .5),
                  colorBorder: context.theme.colorScheme.primaryContainer,
                  colorBackgroundIcon: Colors.transparent,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                percent: (1.0 - (daysRemaining / 355)) * 100,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 7,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            daysRemaining == 0
                                ? '$name: ${'hasPassed'.tr}'
                                : name,
                            style: AppTextStyles.titleMedium().copyWith(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    daysRemaining == 0
                        ? const SizedBox.shrink()
                        : Expanded(
                            flex: 3,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Align(
                                alignment: AlignmentDirectional.centerEnd,
                                child: Text(
                                  '${countdownCtrl.daysArabicConvert(daysRemaining, daysRemaining.toString().convertNumbersToCurrentLang())}',
                                  style: AppTextStyles.titleMedium().copyWith(
                                    fontSize: 16.0,
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
    );
  }
}
