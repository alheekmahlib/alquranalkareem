import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '/presentation/screens/home/home_screen.dart';
import '../../../core/services/services_locator.dart';
import '../../screens/adhkar/screens/adhkar_view.dart';
import '../../screens/books/screens/books_screen.dart';
import '../../screens/quran_page/controllers/ayat_controller.dart';
import '../../screens/quran_page/screens/quran_home.dart';
import '../../screens/surah_audio/audio_surah.dart';
import 'general_state.dart';

class GeneralController extends GetxController {
  static GeneralController get instance => Get.isRegistered<GeneralController>()
      ? Get.find<GeneralController>()
      : Get.put<GeneralController>(GeneralController());

  GeneralState state = GeneralState();

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  /// -------- [Methods] ----------

  /// Greeting
  updateGreeting() {
    final now = DateTime.now();
    final isMorning = now.hour < 12;
    state.greeting.value =
        isMorning ? 'صبحكم الله بالخير' : 'مساكم الله بالخير';
  }

  scrollToAyah(int ayahNumber) {
    if (state.ayahListController.hasClients) {
      double position = (ayahNumber - 1) * state.ayahItemWidth;
      state.ayahListController.jumpTo(position);
    } else {
      print("Controller not attached to any scroll views.");
    }
  }

  ayahPosition() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToAyah(sl<AyatController>().isSelected.value.toInt());
    });
  }

  Widget screenSelect() {
    switch (state.screenSelectedValue.value) {
      case 0:
        return const HomeScreen();
      case 1:
        return QuranHome();
      case 3:
        return const AdhkarView();
      case 4:
        return const AudioScreen();
      case 5:
        return BooksScreen();
      default:
        return const HomeScreen();
    }
  }

  Future<void> launchEmail() async {
    const String subject = "تطبيق القرآن الكريم - مكتبة الحكمة";
    const String stringText =
        "يرجى كتابة أي ملاحظة أو إستفسار\n| جزاكم الله خيرًا |";
    String uri =
        'mailto:haozo89@gmail.com?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(stringText)}';
    if (await canLaunchUrl(Uri.parse(uri))) {
      await launchUrl(Uri.parse(uri));
    } else {
      print("No email client found");
    }
  }

  Future<void> launchFacebookUrl() async {
    String uri = 'https://www.facebook.com/alheekmahlib';
    if (await canLaunchUrl(Uri.parse(uri))) {
      await launchUrl(Uri.parse(uri));
    } else {
      print("No url client found");
    }
  }

  Future<void> share() async {
    final box = Get.context!.findRenderObject() as RenderBox?;
    final ByteData bytes =
        await rootBundle.load('assets/images/quran_banner.png');
    final Uint8List list = bytes.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/quran_banner.png').create();
    file.writeAsBytesSync(list);
    await Share.shareXFiles(
      [XFile((file.path))],
      text:
          'تطبيق "القرآن الكريم - مكتبة الحكمة" التطبيق الأمثل لقراءة القرآن.\n\nللتحميل:\nalheekmahlib.com/#/download/app/0',
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }
}
