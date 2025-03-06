import 'package:get/get.dart';

class ElevatedButtonController extends GetxController {
  static ElevatedButtonController get instance =>
      Get.isRegistered<ElevatedButtonController>()
          ? Get.find<ElevatedButtonController>()
          : Get.put<ElevatedButtonController>(ElevatedButtonController());

  RxBool buttonPressed = false.obs;
  RxBool animationCompleted = true.obs;
  // RxBool isClicked = false.obs;

  void initElevatedButton(int index, {int? delayed}) {
    Future.delayed(Duration(milliseconds: delayed ?? 600)).then(
        (_) => Future.delayed(Duration(milliseconds: index * 600)).then((_) {
              buttonPressed.value = true;
              animationCompleted.value = false;
              update(['buttonIndex_${index}']);
              Future.delayed(const Duration(milliseconds: 1000)).then((_) {
                buttonPressed.value = false;
                animationCompleted.value = true;
                update(['buttonIndex_${index}']);
              });
            }));
  }

  @override
  void onClose() {
    buttonPressed.close();
    animationCompleted.close();
    // isClicked.close();
    super.onClose();
  }
}
