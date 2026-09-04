import 'package:alquranalkareem/core/services/expansion_tile_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// التوسيع البرمجي عبر ExpansionTileManager بديل آمن لـ GlobalKey،
/// لأن family_bottom_sheet يركّب محتوى الورقة مرتين فلا يصح GlobalKey داخله.
void main() {
  testWidgets('expand(name) يوسّع ExpansionTile ويحدّث الحالة', (tester) async {
    final manager = ExpansionTileManager();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ExpansionTile(
            controller: manager.getController('playList_tile'),
            title: const Text('title'),
            children: const [Text('tile-child')],
          ),
        ),
      ),
    );

    expect(manager.isExpanded('playList_tile'), isFalse);
    // أبناء ExpansionTile لا تُبنى قبل التوسيع
    expect(find.text('tile-child'), findsNothing);

    manager.expand('playList_tile');
    await tester.pumpAndSettle();

    expect(manager.isExpanded('playList_tile'), isTrue);
    expect(find.text('tile-child'), findsOneWidget);
  });
}
