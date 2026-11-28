import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/presentation/screens/adhkar/screens/adhkar_view.dart';
import '/presentation/screens/ai_search/ai_search.dart';
import '/presentation/screens/books/books.dart';
import '/presentation/screens/home/home_screen.dart';
import '/presentation/screens/quran_page/quran.dart';
import '/presentation/screens/surah_audio/surah_audio.dart';

/// أقسام التطبيق التي تُفتح من الصفحة الرئيسية.
///
/// لكل قسم اسم مسار ثابت ([route]) يُمرَّر صريحًا كلما فُتح القسم، فيُعرف
/// القسم الجاري بمقارنة `Get.currentRoute` به ([isShowing]) دون الاعتماد
/// على طريقة GetX في اشتقاق الأسماء من نوع الـ closure.
enum AppSection {
  home(0, '/HomeScreen', _buildHome),
  mushaf(1, '/QuranHome', _buildMushaf),
  azkar(3, '/AdhkarView', _buildAzkar),
  audio(4, '/AudioScreen', _buildAudio),
  books(5, '/BooksScreen', _buildBooks),
  midad(6, '/AiSearchResults', _buildMidad),
  tasmee(7, '/QuranHome', _buildTasmee);

  const AppSection(this.startIndex, this.route, this.builder);

  /// ترتيب القسم في منتقي «شاشة البداية». الفهرس 2 للأوقاف وليس قسمًا هنا
  /// فيعود إلى الرئيسية كما كان يفعل screenSelect سابقًا.
  final int startIndex;

  /// اسم مسار القسم، واحد لكل شاشة: التسميع والمصحف يشتركان في QuranHome.
  final String route;

  /// باني شاشة القسم؛ يُستعمل للجذر (شاشة البداية) وللفتح من الرئيسية.
  final Widget Function() builder;

  /// هل يظهر القسم الآن؟
  bool get isShowing => Get.currentRoute == route;

  /// القسم المطابق لترتيب شاشة البداية [index]، والرئيسية لكل ما عداه.
  static AppSection forStartIndex(int index) => values.firstWhere(
    (section) => section.startIndex == index,
    orElse: () => home,
  );
}

/// تتزايد مع كل حدث تنقل (فتح أو رجوع أو إزالة أو استبدال)؛ تُحدَّث من
/// `routingCallback` في GetMaterialApp. من ينتظر ظهور شاشة قسم يستيقظ بها
/// فيقيّم شرطه، فلا يفوّته أن إشارة الجاهزية تحققت قبل فتح الشاشة: كنترولر
/// المكتبة والأذكار يُنشآن في الرئيسية فتجهز بياناتهما قبل فتحهما.
final routeChanges = 0.obs;

/// يفتح القسم فوق الشاشة الحالية باسم مساره الثابت. منع GetX للتكرار
/// يعتمد على الاسم، فلا يُفتح القسم فوق نفسه.
extension AppSectionNavigation on AppSection {
  void push({Transition transition = Transition.downToUp}) =>
      Get.to(builder, routeName: route, transition: transition);
}

/// سقف احتياطي لانتظار خروج شاشة أُخرجت (لو لم يكتمل وعدها لأي سبب).
const _disposeTimeout = Duration(seconds: 2);

/// ينتظر خروج [routes] من الشجرة، أي انتهاء حركة خروجها فعلاً لا بمهلة
/// تقديرية. لازم قبل فتح شاشة فوق نسخة مُخرجة منها: نسختان من شاشة واحدة
/// في الشجرة في الوقت نفسه يكرران مفاتيحها العامة فيتكرر المفتاح (شاشة
/// التسميع فوق شاشة المصحف مثلاً، وهما QuranHome).
Future<void> whenRoutesDisposed(Iterable<Route<dynamic>> routes) =>
    Future.wait([
      for (final route in routes)
        if (route is TransitionRoute<dynamic>)
          route.completed.timeout(_disposeTimeout, onTimeout: () {}),
    ]);

/// يطفو بالشاشات حتى الصفحة الرئيسية محافظًا على حالتها. يكتمل الوعد بعد
/// خروج الشاشات المُطردة من الشجعة (انظر [whenRoutesDisposed]) وقيمته true
/// إن صارت الرئيسية هي الشاشة الجارية، وfalse إن كان جذر المكدس شاشة بدء
/// أخرى فالرئيسية ليست فوقه (يفتحها المستدعي عندها بـ Get.offAll).
Future<bool> popToHomeIfStacked() async {
  if (AppSection.home.isShowing) return true;
  final leaving = <Route<dynamic>>[];
  Get.until((route) {
    if (route.settings.name == AppSection.home.route || route.isFirst) {
      return true;
    }
    leaving.add(route);
    return false;
  });
  await whenRoutesDisposed(leaving);
  return AppSection.home.isShowing;
}

Widget _buildHome() => HomeScreen();

Widget _buildMushaf() => QuranHome();

Widget _buildAzkar() => const AdhkarView();

Widget _buildAudio() => AudioScreen();

Widget _buildBooks() => BooksScreen();

Widget _buildMidad() => AiSearchResults();

Widget _buildTasmee() => QuranHome(isTasmeeMode: true);
