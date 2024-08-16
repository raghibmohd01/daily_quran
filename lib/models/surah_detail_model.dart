import 'dart:convert';

import 'package:daily_quran/models/edition_model.dart';


import 'ayah_detail_model.dart';
import 'ayah_model.dart';

// Main model class for the surah
class SurahDetailModel {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final String revelationType;
  final int numberOfAyahs;
  final List<AyahDetail> ayahs;
  final EditionModel edition;

  SurahDetailModel({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.revelationType,
    required this.numberOfAyahs,
    required this.ayahs,
    required this.edition,
  });

  // Create a SurahDetail instance from JSON
  factory SurahDetailModel.fromJson(Map<String, dynamic> json) {
    return SurahDetailModel(
      number: json['number'],
      name: json['name'],
      englishName: json['englishName'],
      englishNameTranslation: json['englishNameTranslation'],
      revelationType: json['revelationType'],
      numberOfAyahs: json['numberOfAyahs'],
      ayahs: (json['ayahs'] as List<dynamic>)
          .map((ayahJson) => AyahDetail.fromJson(ayahJson as Map<String, dynamic>))
          .toList(),
      edition: EditionModel.fromJson(json['edition']),
    );
  }

  // Convert a SurahDetail instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'name': name,
      'englishName': englishName,
      'englishNameTranslation': englishNameTranslation,
      'revelationType': revelationType,
      'numberOfAyahs': numberOfAyahs,
      'ayahs': ayahs.map((ayah) => ayah.toJson()).toList(),
      'edition': edition.toJson(),
    };
  }


  // Implement the copyWith method
  SurahDetailModel copyWith({
    int? number,
    String? name,
    String? englishName,
    String? englishNameTranslation,
    String? revelationType,
    int? numberOfAyahs,
    List<AyahDetail>? ayahs,
    EditionModel? edition,
  }) {
    return SurahDetailModel(
      number: number ?? this.number,
      name: name ?? this.name,
      englishName: englishName ?? this.englishName,
      englishNameTranslation: englishNameTranslation ?? this.englishNameTranslation,
      revelationType: revelationType ?? this.revelationType,
      numberOfAyahs: numberOfAyahs ?? this.numberOfAyahs,
      ayahs: ayahs ?? this.ayahs,
      edition: edition ?? this.edition,
    );
  }


  @override
  String toString() {
    return jsonEncode(this.toJson());
  }
}



