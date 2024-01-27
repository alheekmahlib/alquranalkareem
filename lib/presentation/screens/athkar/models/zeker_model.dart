class Zekr {
  final int? id;
  final String category;
  final String count;
  final String description;
  final String reference;
  final String zekr;

  Zekr({
    this.id,
    required this.category,
    required this.count,
    required this.description,
    required this.reference,
    required this.zekr,
  });

  factory Zekr.fromJson(Map<String, dynamic> json) {
    return Zekr(
      id: json['id'],
      category: json['category'],
      count: json['count'],
      description: json['description'],
      reference: json['reference'],
      zekr: json['zekr'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'count': count,
      'description': description,
      'reference': reference,
      'zekr': zekr,
    };
  }
}
