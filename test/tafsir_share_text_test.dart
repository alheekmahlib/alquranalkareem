import 'package:flutter_test/flutter_test.dart';
import 'package:quran_library/quran_library.dart';

import 'package:alquranalkareem/core/utils/constants/api_constants.dart';
import 'package:alquranalkareem/presentation/screens/quran_page/quran.dart';

void main() {
  group('buildTafsirShareText', () {
    final ayah = AyahModel(
      ayahUQNumber: 7,
      ayahNumber: 7,
      text: '',
      ayaTextEmlaey: 'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ',
      juz: 1,
      page: 1,
      surahNumber: 1,
    );

    test('صيغة النص الكامل: الآية والسورة واسم التفسير والنص والرابط', () {
      final text = buildTafsirShareText(
        ayah: ayah,
        surahName: 'الفاتحة',
        tafsirName: 'التفسير الميسر',
        tafsirBody: 'هداية من أنعم الله عليهم.',
      );

      expect(text, contains('﴿صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ﴾'));
      expect(text, contains('[الفاتحة-7]'));
      expect(text, contains('التفسير الميسر'));
      expect(text, contains('هداية من أنعم الله عليهم.'));
      expect(text, contains('${ApiConstants.quranShareUrl}1&ayah=7'));
    });

    test('تفسير متعدد الأسطر يبقى كما هو داخل النص', () {
      final text = buildTafsirShareText(
        ayah: ayah,
        surahName: 'الفاتحة',
        tafsirName: 'التفسير الميسر',
        tafsirBody: 'سطر أول\nسطر ثانٍ',
      );

      expect(text, contains('سطر أول\nسطر ثانٍ'));
    });
  });
}
