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
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
      child: Opacity(
        opacity: daysRemaining == 0 ? .5 : 1,
        child: Container(
          height: 50,
          width: 380,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            border: Border.all(
              width: 1,
              color: Theme.of(context).canvasColor.withValues(alpha: .5),
            ),
          ),
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              LinearProgressIndicator(
                minHeight: 50,
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                value: (1.0 - (daysRemaining / 355)).clamp(
                  0.0,
                  1.0,
                ), //(daysRemaining / 1000).toDouble(),
                backgroundColor: Theme.of(context).canvasColor,
                color: daysRemaining == 0
                    ? Theme.of(context).colorScheme.surface
                    : Theme.of(
                        context,
                      ).colorScheme.surface.withValues(alpha: .7),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          daysRemaining == 0
                              ? '$name: ${'hasPassed'.tr}'
                              : name,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: 'kufi',
                            color: Theme.of(
                              context,
                            ).colorScheme.onInverseSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    daysRemaining == 0
                        ? const SizedBox.shrink()
                        : Expanded(
                            flex: 3,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '${countdownCtrl.daysArabicConvert(daysRemaining, daysRemaining.toString().convertNumbersToCurrentLang())}',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'kufi',
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onInverseSurface,
                                ),
                                textAlign: TextAlign.center,
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
