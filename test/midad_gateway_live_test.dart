import 'package:alquranalkareem/presentation/screens/ai_search/ai_search.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const enabled = bool.fromEnvironment('MIDAD_LIVE_TEST');
  test(
    'live gateway returns a completion through the Flutter client',
    () async {
      final result = await LlmService().chatCompletion(
        messages: [
          {'role': 'user', 'content': 'Reply YES'},
        ],
        provider: LlmService.providers.first,
      );
      expect(result.content.trim(), isNotEmpty);
    },
    skip: !enabled,
    timeout: const Timeout(Duration(minutes: 3)),
  );

  test(
    'live gateway supports tool calls through the Flutter client',
    () async {
      final provider = LlmService.providers.firstWhere(
        (p) => p.id == 'zai-glm-4-5-flash',
      );
      final result = await LlmService().chatCompletion(
        messages: [
          {'role': 'user', 'content': 'Call lookup with query equal to الصبر.'},
        ],
        tools: [
          {
            'type': 'function',
            'function': {
              'name': 'lookup',
              'description': 'Look up a query',
              'parameters': {
                'type': 'object',
                'properties': {
                  'query': {'type': 'string'},
                },
                'required': ['query'],
              },
            },
          },
        ],
        provider: provider,
        forceToolUse: true,
      );
      expect(result.hasToolCalls, isTrue);
      expect(result.toolCalls.first.name, 'lookup');
    },
    skip: !enabled,
    timeout: const Timeout(Duration(minutes: 3)),
  );
  test(
    'live assistant retrieves a sourced Quran quotation',
    () async {
      final state = AiSearchState();
      state.selectedProvider.value = LlmService.providers.firstWhere(
        (p) => p.id == 'zai-glm-4-5-flash',
      );
      const query = 'اعرض نص الآية الأولى من سورة الفاتحة';
      state.addAssistantUserMessage(query);
      try {
        await UnifiedOrchestrator().handleUserMessage(
          userText: query,
          state: state,
        );
        expect(state.assistantError.value, isEmpty);
        final replies = state.assistantMessages
            .where((m) => m.isAssistant)
            .toList();
        expect(replies, isNotEmpty);
        expect(replies.last.quotations, isNotEmpty);
      } finally {
        state.searchTextEditing.dispose();
      }
    },
    skip: !enabled,
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
