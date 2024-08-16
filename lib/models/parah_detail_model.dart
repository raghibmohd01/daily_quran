import 'dart:convert';

import 'package:daily_quran/models/ayah_detail_model.dart';
import 'package:daily_quran/models/edition_model.dart';
import 'package:daily_quran/models/surah_model.dart';

import 'ayah_model.dart';

// Main model class
class ParahDetailModel {
  final int number;
  final List<AyahDetail> ayahs;
  final Map<String, Surah> surahs;
  final EditionModel edition;

  ParahDetailModel({
    required this.number,
    required this.ayahs,
    required this.surahs,
    required this.edition,
  });

  factory ParahDetailModel.fromJson(Map<String, dynamic> json) {
    return ParahDetailModel(
      number: json['number'],
      ayahs: (json['ayahs'] as List).map((e) => AyahDetail.fromJson(e)).toList(),
      surahs: (json['surahs'] as Map<String, dynamic>).map(
            (k, e) => MapEntry(k, Surah.fromJson(e)),
      ),
      edition: EditionModel.fromJson(json['edition']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'ayahs': ayahs.map((e) => e.toJson()).toList(),
      'surahs': surahs.map((k, e) => MapEntry(k, e.toJson())),
      'edition': edition.toJson(),
    };
  }

  ParahDetailModel copyWith({
    int? number,
    List<AyahDetail>? ayahs,
    Map<String, Surah>? surahs,
    EditionModel? edition,
  }) {
    return ParahDetailModel(
      number: number ?? this.number,
      ayahs: ayahs ?? this.ayahs,
      surahs: surahs ?? this.surahs,
      edition: edition ?? this.edition,
    );
  }
}




