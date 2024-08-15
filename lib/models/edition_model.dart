import 'dart:convert';

class EditionModel {
  final String? identifier;
  final String? language;
  final String? name;
  final String? englishName;
  final String? format;
  final String? type;
  final String? direction;

  EditionModel({
    required this.identifier,
    required this.language,
    required this.name,
    required this.englishName,
    required this.format,
    required this.type,
    required this.direction,
  });

  // Create a QuranResource instance from JSON
  factory EditionModel.fromJson(Map<String, dynamic> json) {
    return EditionModel(
      identifier: json['identifier'],
      language: json['language'],
      name: json['name'],
      englishName: json['englishName'],
      format: json['format'],
      type: json['type'],
      direction: json['direction'],
    );
  }

  // Convert a QuranResource instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'identifier': identifier,
      'language': language,
      'name': name,
      'englishName': englishName,
      'format': format,
      'type': type,
      'direction': direction,
    };
  }

  @override
  String toString() {
    return jsonEncode(this.toJson());
  }
}
