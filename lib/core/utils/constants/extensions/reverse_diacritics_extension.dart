extension ReverseDiacriticsExtension on String {
  List<String> reverseDiacritics(String input) {
    final reverseDiacriticsMap = {
      'ا': [
        'أ',
        'إ',
        'آ',
        'إٔ',
        'إٕ',
        'إٓ',
        'أَ',
        'إَ',
        'آَ',
        'إُ',
        'إٌ',
        'إً'
      ],
      'ه': ['ة'],
      'و': ['ؤ', 'وء'],
    };

    List<String> variations = [''];
    for (int i = 0; i < input.length; i++) {
      String char = input[i];
      List<String>? replacements = reverseDiacriticsMap[char];
      if (replacements != null) {
        List<String> newVariations = [];
        for (String variation in variations) {
          for (String replacement in replacements) {
            newVariations.add(variation + replacement);
          }
          newVariations.add(variation + char); // add the original character
        }
        variations = newVariations;
      } else {
        for (int j = 0; j < variations.length; j++) {
          variations[j] = variations[j] + char;
        }
      }
    }
    return variations;
  }
}
