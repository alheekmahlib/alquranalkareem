import 'dart:async' show unawaited;

import 'package:multi_store_review/multi_store_review.dart';

class UiHelper {
  static final MultiStoreReview _review = MultiStoreReview.instance;

  /// معرّفا التطبيق في متاجر آبل: iOS وmacOS لهما سجلان منفصلان، لذا
  /// يُمرَّر معرّف لكل منهما. متجر Google يُستنتج تلقائيًا من اسم الحزمة.
  static const StoreListing _listing = StoreListing(
    appStoreId: '1500153222',
    macAppStoreId: '1660688066',
  );

  /// يُنادى مرة عند إقلاع التطبيق: يعدّ الإطلاق ويسلّح بوابة التقييم.
  ///
  /// الأرقام منسوخة من إعداد rate_my_app السابق:
  /// 7 تشغيلات قبل أول طلب، و15 يومًا بين المحاولات.
  /// الحالة تُخزَّن داخل المنصة نفسها (SharedPreferences/UserDefaults) —
  /// لا تحتاج get_storage ولا أي إعداد إضافي.
  static void initReviewGate() {
    unawaited(
      _review.configure(
        policy: const ReviewPolicy(minLaunches: 7, minDaysBetweenPrompts: 15),
      ),
    );
  }

  /// اسأل بوابة التقييم في اللحظات الإيجابية (إتمام ختمة/جزء، حفظ مرجعية...).
  ///
  /// تعيد true إذا جرت محاولة عرض حوار التقييم (أو فتح صفحة المتجر كحل
  /// بديل)، وfalse إن قررت البوابة الانتظار. لا ترمي استثناءً أبدًا،
  /// وحوار التقييم أصلي ومترجم وفق لغة جهاز المستخدم.
  static Future<bool> maybeRequestReview() =>
      _review.maybeRequestReview(listing: _listing);
}
