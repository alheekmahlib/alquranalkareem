class JarhSaying {
  final String scholar;
  final List<String> sayings;

  JarhSaying({required this.scholar, required this.sayings});

  factory JarhSaying.fromJson(Map<String, dynamic> json) {
    return JarhSaying(
      scholar: json['scholar'] as String? ?? '',
      sayings: (json['sayings'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }
}

class NarratorInfo {
  final int id;
  final String name;
  final String url;
  final String? kunyah;
  final String? nasab;
  final String? residence;
  final String? relations;
  final String? deathDate;
  final String? deathPlace;
  final String? birthDate;
  final String? travelPlaces;
  final String? tabaqah;
  final String? rankIbnHajar;
  final String? rankAlDhahabi;
  final String? jarhRaw;
  final List<JarhSaying> jarh;

  NarratorInfo({
    required this.id,
    required this.name,
    required this.url,
    this.kunyah,
    this.nasab,
    this.residence,
    this.relations,
    this.deathDate,
    this.deathPlace,
    this.birthDate,
    this.travelPlaces,
    this.tabaqah,
    this.rankIbnHajar,
    this.rankAlDhahabi,
    this.jarhRaw,
    this.jarh = const [],
  });

  factory NarratorInfo.fromJson(Map<String, dynamic> json) {
    return NarratorInfo(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      url: json['url'] as String? ?? '',
      kunyah: json['kunyah'] as String?,
      nasab: json['nasab'] as String?,
      residence: json['residence'] as String?,
      relations: json['relations'] as String?,
      deathDate: json['deathDate'] as String?,
      deathPlace: json['deathPlace'] as String?,
      birthDate: json['birthDate'] as String?,
      travelPlaces: json['travelPlaces'] as String?,
      tabaqah: json['tabaqah'] as String?,
      rankIbnHajar: json['rankIbnHajar'] as String?,
      rankAlDhahabi: json['rankAlDhahabi'] as String?,
      jarhRaw: json['jarhRaw'] as String?,
      jarh: (json['jarh'] as List<dynamic>?)
              ?.map((e) => JarhSaying.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// Search-friendly name without parentheses content
  String get searchName {
    final parenIdx = name.indexOf('(');
    if (parenIdx > 0) return name.substring(0, parenIdx).trim();
    return name.trim();
  }

  /// Short display title (name without long parenthetical details)
  String get title => searchName;
}
