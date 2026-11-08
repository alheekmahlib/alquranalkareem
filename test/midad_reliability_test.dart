import 'package:alquranalkareem/presentation/screens/ai_search/ai_search.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('passage identity survives conversation persistence', () {
    const quotation = Quotation(
      text: 'نص',
      type: QuotationType.seerah,
      attribution: 'المصدر',
      passageId: 42,
      passageSource: QuotationSource.seerah,
    );
    final restored = Quotation.fromJson(quotation.toJson());
    expect(restored.passageId, 42);
    expect(restored.passageSource, QuotationSource.seerah);
    expect(restored.attribution, 'المصدر');
  });

  test('legacy passages do not guess their originating server', () {
    final old = Quotation.fromJson({'tx': 'نص', 'tp': 'seerah', 'pid': 42});
    expect(old.passageSource, isNull);
  });

  test('same passage number on different servers has separate cached text', () {
    final state = AiSearchState();
    state.fullTextCache[state.passageKey(QuotationSource.heekmah, 42)] = 'فقه';
    state.fullTextCache[state.passageKey(QuotationSource.seerah, 42)] = 'سيرة';
    expect(state.getFullText(QuotationSource.heekmah, 42), 'فقه');
    expect(state.getFullText(QuotationSource.seerah, 42), 'سيرة');
    state.searchTextEditing.dispose();
  });

  test('current user message appears once in request history', () {
    final state = AiSearchState();
    state.addAssistantUserMessage('ما تفسير الفاتحة؟');
    final messages = state.assistantMessagesToOpenAi();
    expect(
      messages.where((m) => m['content'] == 'ما تفسير الفاتحة؟'),
      hasLength(1),
    );
    state.searchTextEditing.dispose();
  });
}
