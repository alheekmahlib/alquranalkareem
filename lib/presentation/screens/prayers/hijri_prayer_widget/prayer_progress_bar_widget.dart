part of '../prayers.dart';

class PrayerProgressBar extends StatelessWidget {
  PrayerProgressBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: GestureDetector(
        onTap: () => Get.to(OccasionsWidget(), transition: Transition.downToUp),
        child: SizedBox(
          height: 275,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 275,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: HijriWidget(),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: PrayerProgressWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
