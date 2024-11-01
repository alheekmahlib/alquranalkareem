part of '../../prayers.dart';

class DetectLocation extends StatelessWidget {
  DetectLocation({super.key});

  final generalCtrl = GeneralController.instance;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          height: 60,
          width: Get.width,
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor.withOpacity(.1),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'تحديد الموقع',
                style: TextStyle(
                  fontFamily: 'kufi',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).canvasColor,
                ),
              ),
              Switch(
                value: generalCtrl.state.activeLocation.value,
                activeColor: Colors.red,
                inactiveTrackColor:
                    Theme.of(context).colorScheme.surface.withOpacity(.5),
                onChanged: (bool value) => generalCtrl.toggleLocationService(),
              ),
            ],
          ),
        ));
  }
}
