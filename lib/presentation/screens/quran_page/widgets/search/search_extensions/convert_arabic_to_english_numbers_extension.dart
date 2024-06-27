extension ConvertArabicToEnglishNumbersExtension on String {
  String convertArabicToEnglishNumbers(String input) {
    const arabicNumbers = '٠١٢٣٤٥٦٧٨٩';
    const englishNumbers = '0123456789';

    return input.split('').map((char) {
      int index = arabicNumbers.indexOf(char);
      if (index != -1) {
        return englishNumbers[index];
      }
      return char;
    }).join('');
  }
}
