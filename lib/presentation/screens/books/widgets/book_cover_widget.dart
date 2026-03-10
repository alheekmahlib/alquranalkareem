part of '../books.dart';

class BookCoverWidget extends StatelessWidget {
  final Book? book;
  final int? bookNumber;
  final bool isInDetails;
  final bool? isSixthBooks;
  final bool? isNinthBooks;
  const BookCoverWidget({
    super.key,
    this.book,
    this.isInDetails = false,
    this.bookNumber,
    this.isSixthBooks = false,
    this.isNinthBooks = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isInDetails
            ? Container(
                height: context.customOrientation(190.h, 230.h),
                width: context.customOrientation(140.w, 90.w),
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.primary,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: _heroWidget(context),
              )
            : GestureDetector(
                onTap: isInDetails
                    ? null
                    : () {
                        Get.to(
                          () => ChaptersPage(
                            book: book!,
                            isSixthBooks: isSixthBooks!,
                            isNinthBooks: isNinthBooks!,
                          ),
                          transition: Transition.fade,
                        );
                      },
                child: Container(
                  height: context.customOrientation(130.h, 230.h),
                  width: context.customOrientation(95.w, 90.w),
                  decoration: BoxDecoration(
                    color: context.theme.colorScheme.primary,
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  child: _heroWidget(context),
                ),
              ),
      ),
    );
  }

  Widget _heroWidget(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: customSvg(
              SvgPath.svgHomeQuranLogo,
              height: isInDetails ? 25 : context.customOrientation(20.h, 35.h),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
            child: customSvgWithColor(
              SvgPath.svgDecorations,
              height: isInDetails ? 45 : context.customOrientation(25.h, 70.h),
              color: context.theme.canvasColor,
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
            child: RotatedBox(
              quarterTurns: 2,
              child: customSvgWithColor(
                SvgPath.svgDecorations,
                height: isInDetails
                    ? 45
                    : context.customOrientation(25.h, 70.h),
                color: context.theme.canvasColor,
              ),
            ),
          ),
        ),
        // customSvg(SvgPath.svgRightBook),
        Container(
          height: isInDetails
              ? 170
              : context.definePlatform(
                  context.customOrientation(120.h, 150.h),
                  180.h,
                ),
          width: isInDetails ? 110 : context.definePlatform(70.w, 50.0.w),
          alignment: Alignment.center,
          child: Text(
            _getBookNameBeforeSymbol(book!.bookName),
            style: AppTextStyles.titleMedium(
              fontSize: isInDetails
                  ? 22
                  : context.definePlatform(
                      context.customOrientation(16.0.sp, 8.0.sp),
                      22.0,
                    ),
              color: context.theme.canvasColor,
              height: 1.5,
            ),
            maxLines: 3,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  // Helper method to extract book name before '-' or '=' symbols
  // دالة مساعدة لاستخراج اسم الكتاب قبل رمز '-' أو '='
  String _getBookNameBeforeSymbol(String bookName) {
    // Find the position of '-' or '=' symbols
    // البحث عن موضع رمز '-' أو '='
    int dashIndex = bookName.indexOf('-');
    int equalIndex = bookName.indexOf('=');

    // Determine which symbol comes first (or if only one exists)
    // تحديد أي رمز يأتي أولاً (أو إذا كان هناك رمز واحد فقط)
    int splitIndex = -1;

    if (dashIndex != -1 && equalIndex != -1) {
      // Both symbols exist, take the one that comes first
      // الرمزان موجودان، نأخذ الذي يأتي أولاً
      splitIndex = dashIndex < equalIndex ? dashIndex : equalIndex;
    } else if (dashIndex != -1) {
      // Only dash exists
      // رمز الشرطة فقط موجود
      splitIndex = dashIndex;
    } else if (equalIndex != -1) {
      // Only equal sign exists
      // رمز المساواة فقط موجود
      splitIndex = equalIndex;
    }

    // If no symbols found, return the original name (limited to 3 words)
    // إذا لم يتم العثور على رموز، إرجاع الاسم الأصلي (محدود بـ 3 كلمات)
    if (splitIndex == -1) {
      return _limitToThreeWords(bookName.trim());
    }

    // Return the text before the symbol, trimmed of whitespace
    // إرجاع النص الذي يأتي قبل الرمز، مع إزالة المسافات الزائدة
    String textBeforeSymbol = bookName.substring(0, splitIndex).trim();

    // Limit to maximum 3 words
    // تحديد النص بحد أقصى 3 كلمات
    return _limitToThreeWords(textBeforeSymbol);
  }

  // Helper method to limit text to maximum 3 words
  // دالة مساعدة لتحديد النص بحد أقصى 3 كلمات
  String _limitToThreeWords(String text) {
    if (text.isEmpty) return text;

    // Split the text into words
    // تقسيم النص إلى كلمات
    List<String> words = text
        .split(' ')
        .where((word) => word.isNotEmpty)
        .toList();

    // If 3 words or less, return as is
    // إذا كان 3 كلمات أو أقل، إرجاع النص كما هو
    if (words.length <= 3) {
      return words.join(' ');
    }

    // Return only the first 3 words
    // إرجاع أول 3 كلمات فقط
    return words.take(3).join(' ');
  }
}
