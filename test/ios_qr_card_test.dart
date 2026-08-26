import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:alquranalkareem/presentation/screens/sync/sync.dart';

/// بطاقة QR بأسلوب iOS — الرمز مرسوم بالكامل كجسيمات عبر CustomPaint.
void main() {
  testWidgets('IosQrCard تعرض الرمز كجسيمات عبر CustomPaint', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: IosQrCard(data: 'test-room-data')),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(IosQrCard), findsOneWidget);
    expect(find.byType(CustomPaint), findsWidgets);
  });

  testWidgets('مع تقليل الحركة: تُرسم الجسيمات ساكنة ولا تتعطل', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(disableAnimations: true),
          child: Scaffold(
            body: Center(child: IosQrCard(data: 'test-room-data')),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(IosQrCard), findsOneWidget);
    expect(find.byType(CustomPaint), findsWidgets);
  });

  testWidgets('تغيير البيانات يعيد توليد الجسيمات دون أخطاء', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: IosQrCard(data: 'room-1')),
        ),
      ),
    );
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: IosQrCard(data: 'room-2-with-a-much-longer-payload'),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(IosQrCard), findsOneWidget);
    expect(find.byType(CustomPaint), findsWidgets);
  });
}
