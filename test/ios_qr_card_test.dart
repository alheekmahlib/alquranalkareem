import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import 'package:alquranalkareem/presentation/screens/sync/sync.dart';

/// بطاقة QR بأسلوب iOS — يجب أن تُبنى وتعرض PrettyQrView مع بيانات الغرفة.
void main() {
  testWidgets('IosQrCard تعرض رمز QR ناعمًا مع البيانات', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: IosQrCard(data: 'test-room-data')),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(PrettyQrView), findsOneWidget);
    expect(find.byType(IosQrCard), findsOneWidget);
  });

  testWidgets('مع تقليل الحركة: تبقى البطاقة بلا جسيمات ولا تتعطل', (
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

    expect(find.byType(PrettyQrView), findsOneWidget);
  });
}
