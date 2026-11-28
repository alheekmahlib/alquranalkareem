import 'package:flutter/scheduler.dart';

import '../../presentation/controllers/general/app_section.dart';

/// يشغّل [start] بعد الإطار التالي إن كانت شاشة [section] هي الجارية حينها.
///
/// حراسة البدء التلقائي لجولات الأقسام. تُقارن الشاشة الجارية لا تفضيل
/// «شاشة البداية»: الأقسام تُفتح من الرئيسية بمساراتها، فمقارنة تفضيل
/// البداية كانت تمنع الجولة التلقائية لكل قسم ليس هو شاشة البداية، وتُبقي
/// الكنترولر من تشغيل الجولة فوق شاشة أخرى بعد مغادرة سريعة.
void startTourWhenSectionShows(AppSection section, void Function() start) {
  // ردّ ما بعد الإطار لا يُجدول إطاراً بمفرده، فلو كانت الواجهة ساكنة لم
  // يُنفَّذ؛ تأكيد تحديث بصري يضمن الإطارَ التالي.
  SchedulerBinding.instance.ensureVisualUpdate();
  SchedulerBinding.instance.addPostFrameCallback((_) {
    if (section.isShowing) start();
  });
}
