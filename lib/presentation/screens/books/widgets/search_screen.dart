import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/extensions.dart';
import '/presentation/screens/quran_page/widgets/search/search_extensions/highlight_extension.dart';
import '../../../../core/utils/constants/lottie.dart';
import '../../../../core/utils/constants/lottie_constants.dart';
import '../../../controllers/books_controller.dart';
import '../../quran_page/widgets/search/search_bar_widget.dart';

class SearchScreen extends StatelessWidget {
  final void Function(String)? onSubmitted;
  final bool? isInBook;
  SearchScreen({super.key, this.onSubmitted, this.isInBook});

  final booksCtrl = BooksController.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * .9,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(8),
            topLeft: Radius.circular(8),
          )),
      child: Column(
        children: [
          const Gap(16),
          context.customClose(),
          const Gap(8),
          Text(
            'search'.tr.replaceAll('بحث', 'البحث'),
            style: TextStyle(
              fontFamily: "kufi",
              fontSize: 22,
              color: Theme.of(context).canvasColor,
            ),
          ),
          const Gap(8),
          TextFieldBarWidget(
            controller: booksCtrl.searchController,
            hintText: 'searchInBooks'.tr,
            horizontalPadding: 32.0,
            onPressed: () {
              booksCtrl.searchController.clear();
              booksCtrl.searchResults.clear();
            },
            onChanged: null,
            onSubmitted: (value) {
              if (onSubmitted != null) {
                onSubmitted!(value);
              }
            },
          ),
          Expanded(
            child: Container(
              width: Get.width,
              margin:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: Obx(() {
                if (booksCtrl.isLoading.value) {
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                }

                if (booksCtrl.searchResults.isNotEmpty) {
                  return ListView.builder(
                    itemCount: booksCtrl.searchResults.length,
                    itemBuilder: (context, index) {
                      final result = booksCtrl.searchResults[index];
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              Get.back();
                              isInBook!
                                  ? booksCtrl.moveToPage(
                                      result.title, result.bookNumber)
                                  : await booksCtrl.moveToBookPage(
                                      result.title, result.bookNumber);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(.1),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 16.0),
                                    child: Text.rich(
                                      TextSpan(
                                        children: result.content
                                            .removeDiacritics(result.content)
                                            .highlightLine(booksCtrl
                                                .searchController.text),
                                        style: TextStyle(
                                          fontFamily: "naskh",
                                          fontWeight: FontWeight.normal,
                                          fontSize: 22,
                                          color: Theme.of(context).hintColor,
                                        ),
                                      ),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0, vertical: 2.0),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            borderRadius:
                                                const BorderRadiusDirectional
                                                    .only(
                                              topStart: Radius.circular(8),
                                              bottomStart: Radius.circular(8),
                                            ),
                                          ),
                                          child: Text(
                                            result.bookTitle,
                                            style: TextStyle(
                                              fontFamily: "kufi",
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14,
                                              color:
                                                  Theme.of(context).canvasColor,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      context.vDivider(height: 20),
                                      Expanded(
                                        flex: 4,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0, vertical: 2.0),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            borderRadius:
                                                const BorderRadiusDirectional
                                                    .only(
                                              topEnd: Radius.circular(8),
                                              bottomEnd: Radius.circular(8),
                                            ),
                                          ),
                                          child: Text(
                                            result.title,
                                            style: TextStyle(
                                              fontFamily: "kufi",
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14,
                                              color:
                                                  Theme.of(context).canvasColor,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          context.hDivider(width: Get.width)
                        ],
                      );
                    },
                  );
                } else {
                  return Center(
                    child: customLottie(LottieConstants.assetsLottieNotFound,
                        height: 200.0, width: 200.0),
                  );
                }
              }),
            ),
          ),
        ],
      ),
    );
  }
}