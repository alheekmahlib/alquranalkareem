class Azkar {
  int? id;
  String? category;
  String? count;
  String? description;
  String? reference;
  String? zekr;

  Azkar(
      this.id,
      this.category,
      this.count,
      this.description,
      this.reference,
      this.zekr);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'count': count,
      'description': description,
      'reference': reference,
      'zekr': zekr,
    };
  }

  Azkar.fromJson(Map<String, dynamic> map) {
      id = map['id'];
      category = map['category'];
      count = map['count'];
      description = map['description'];
      reference = map['reference'];
      zekr = map['zekr'];
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'category': category,
      'count': count,
      'description': description,
      'reference': reference,
      'zekr': zekr,
    };
  }

  @override
  String toString() {
    return 'Azkar(id: $id, category: $category, count: $count, description: $description, reference: $reference, zekr: $zekr)';
  }
}
