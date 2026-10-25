import 'dart:io';

import 'package:alquranalkareem/core/utils/constants/shared_preferences_constants.dart';
import 'package:alquranalkareem/presentation/screens/quran_page/widgets/search/controller/quran_search_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

/// سجل آخر عمليات البحث (issue #70): الإدخال الفارغ أو المكوّن من مسافات
/// يجب ألا يُدرَج في السجل ولا يُحفَظ، بينما الاستعلام الصحيح يُدرَج ويُحفَظ.
class _FakePathProvider extends PathProviderPlatform {
  _FakePathProvider(this.path);

  final String path;

  @override
  Future<String?> getApplicationDocumentsPath() async => path;
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final dir = await Directory.systemTemp.createTemp('quran_search_test');
    PathProviderPlatform.instance = _FakePathProvider(dir.path);
    await GetStorage.init();
  });

  setUp(() async {
    await GetStorage().remove(SEARCH_HISTORY);
  });

  test('addSearchItem ignores empty and whitespace-only queries', () {
    final ctrl = QuranSearchController();

    ctrl.addSearchItem('');
    ctrl.addSearchItem('   ');

    expect(ctrl.state.searchHistory, isEmpty);
    expect(GetStorage().read(SEARCH_HISTORY), isNull);
  });

  test('addSearchItem stores a valid query and persists it', () {
    final ctrl = QuranSearchController();

    ctrl.addSearchItem('الفاتحة');

    expect(ctrl.state.searchHistory, hasLength(1));
    expect(ctrl.state.searchHistory.first.query, 'الفاتحة');
    expect(GetStorage().read(SEARCH_HISTORY), hasLength(1));
  });
}
