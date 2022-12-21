
class Notes {
  int? id;
  String? title;
  String? description;

  Notes(this.id, this.title, this.description);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
    };
  }

  Notes.fromJson(Map<String, dynamic> json) {
      id = json['id'];
      title = json['title'];
      description = json['description'];
  }


}
