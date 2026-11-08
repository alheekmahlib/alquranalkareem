import 'dart:io';

import 'package:alquranalkareem/presentation/screens/ai_search/ai_search.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

class _FakePathProvider extends PathProviderPlatform {
  _FakePathProvider(this.path);
  final String path;
  @override
  Future<String?> getApplicationDocumentsPath() async => path;
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final dir = await Directory.systemTemp.createTemp('midad_selector_test');
    PathProviderPlatform.instance = _FakePathProvider(dir.path);
    await GetStorage.init();
  });
  testWidgets('model selector builds with or without gateway configuration', (
    tester,
  ) async {
    Get.testMode = true;
    await tester.pumpWidget(
      GetMaterialApp(home: Scaffold(body: ModelSelectorWidget())),
    );
    expect(tester.takeException(), isNull);

    if (LlmService.gatewayUrl.isEmpty) {
      expect(find.byType(DropdownButton2<LlmProvider>), findsNothing);
    } else {
      expect(find.text(LlmService.defaultProvider.displayName), findsOneWidget);
      final next = LlmService.providers.firstWhere(
        (p) => p.id == 'zai-glm-4-5-flash',
      );
      AiSearchController.instance.state.selectedProvider.value = next;
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(find.text(next.displayName), findsOneWidget);
    }
    await tester.pumpWidget(const SizedBox.shrink());
    Get.reset();
    await tester.pump();
  });
}
