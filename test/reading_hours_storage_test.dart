import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

/// يثبّت عقد تخزين مدرج ساعات القراءة (sn_reading_hours):
/// json.encode يشترط مفاتيح نصية، لذا يجب أن يُخزَّن المدرج بـ String keys.
/// القارئ readReadingHistogram يحوّلها عبر int.tryParse('$key').
void main() {
  test('Map بمفاتيح int يفشل ترميزه — توثيق السبب الجذري للانهيار', () {
    final histogram = <int, int>{12: 1}; // أول إدخال في المدرج
    expect(() => jsonEncode(histogram), throwsA(isA<JsonUnsupportedObjectError>()));
  });

  test('الشكل المخزن بعد الإصلاح (مفاتيح String) يرمّز بنجاح', () {
    final histogram = <int, int>{12: 3, 21: 7};
    final stored = <String, int>{};
    histogram.forEach((hour, count) => stored['$hour'] = count);
    final encoded = jsonEncode({'sn_reading_hours': stored});
    expect(encoded, contains('"12":3'));
    expect(encoded, contains('"21":7'));

    // إعادة القراءة بنمط readReadingHistogram
    final decoded = jsonDecode(encoded) as Map<String, dynamic>;
    final raw = decoded['sn_reading_hours'] as Map;
    final back = <int, int>{};
    raw.forEach((key, value) {
      final hour = int.tryParse('$key');
      if (hour != null) back[hour] = value as int;
    });
    expect(back, {12: 3, 21: 7});
  });
}
