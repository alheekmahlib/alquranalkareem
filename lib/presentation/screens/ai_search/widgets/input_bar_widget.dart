part of '../ai_search.dart';

class InputBarWidget extends StatelessWidget {
  InputBarWidget({super.key});
  final ctrl = AiSearchController.instance;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        decoration: BoxDecoration(
          color: context.theme.colorScheme.surface.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: context.theme.colorScheme.surface.withValues(alpha: 0.15),
          ),
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              Row(
                children: [
                  // Text field
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        minLines: 1,
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        controller: ctrl.state.searchTextEditing,
                        cursorColor: context.theme.colorScheme.surface,
                        style: TextStyle(
                          color: context.theme.colorScheme.surface,
                          fontSize: 15,
                        ),
                        decoration: InputDecoration(
                          hintText: 'askMidad'.tr,
                          hintStyle: TextStyle(
                            color: context.theme.colorScheme.surface,
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                        textInputAction: TextInputAction.send,
                        onSubmitted: (query) {
                          if (query.trim().isNotEmpty) {
                            ctrl.search(query);
                            FocusManager.instance.primaryFocus?.unfocus();
                          }
                        },
                      ),
                    ),
                  ),
                  // Clear button
                  if (ctrl.state.searchTextEditing.text.isNotEmpty)
                    IconButton(
                      onPressed: () => ctrl.clearSearch(),
                      icon: Icon(
                        Icons.close,
                        size: 18,
                        color: context.theme.colorScheme.surface.withValues(
                          alpha: 0.4,
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 12),
                ],
              ),
              Row(
                children: [
                  // Send button
                  IconButton(
                    onPressed: ctrl.state.searchTextEditing.text.isNotEmpty
                        ? () {
                            final query = ctrl.state.searchTextEditing.text
                                .trim();
                            if (query.isNotEmpty) {
                              ctrl.search(query);
                              FocusManager.instance.primaryFocus?.unfocus();
                            }
                          }
                        : null,
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: context.theme.colorScheme.surface.withValues(
                          alpha: ctrl.state.searchTextEditing.text.isNotEmpty
                              ? 0.25
                              : .1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.arrow_upward,
                        size: 18,
                        color: context.theme.colorScheme.surface,
                      ),
                    ),
                  ),
                  // Section filter dropdown
                  SectionFilterWidget(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
