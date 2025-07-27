// Model to represent Waqf data from JSON file.
// موديل لتمثيل بيانات الوقف من ملف JSON.

class WaqfModel {
  final String image;
  final Map<String, String> translations;

  WaqfModel({required this.image, required this.translations});

  // Factory method to create an instance from JSON.
  // دالة لإنشاء كائن من JSON.
  factory WaqfModel.fromJson(Map<String, dynamic> json) {
    return WaqfModel(
      image: json['image'],
      translations: Map<String, String>.from(json['translations']),
    );
  }
}
