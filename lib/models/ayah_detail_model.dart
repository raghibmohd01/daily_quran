import 'dart:convert';

import 'package:daily_quran/models/edition_model.dart';
import 'package:daily_quran/models/surah_model.dart';



// Nested model class for the `data` field
class AyahDetail {
  final int number;
  final String text;
  final EditionModel edition;
  final Surah surah;
  final int numberInSurah;
  final int juz;
  final int manzil;
  final int page;
  final int ruku;
  final int hizbQuarter;
  final bool sajda;

  AyahDetail({
    required this.number,
    required this.text,
    required this.edition,
    required this.surah,
    required this.numberInSurah,
    required this.juz,
    required this.manzil,
    required this.page,
    required this.ruku,
    required this.hizbQuarter,
    required this.sajda,
  });

  // Create a VerseData instance from JSON
  factory AyahDetail.fromJson(Map<String, dynamic> json) {
    return AyahDetail(
      number: json['number'],
      text: json['text'],
      edition: EditionModel.fromJson(json['edition']),
      surah: Surah.fromJson(json['surah']),
      numberInSurah: json['numberInSurah'],
      juz: json['juz'],
      manzil: json['manzil'],
      page: json['page'],
      ruku: json['ruku'],
      hizbQuarter: json['hizbQuarter'],
      sajda: json['sajda'],
    );
  }

  // Convert a VerseData instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'text': text,
      'edition': edition.toJson(),
      'surah': surah.toJson(),
      'numberInSurah': numberInSurah,
      'juz': juz,
      'manzil': manzil,
      'page': page,
      'ruku': ruku,
      'hizbQuarter': hizbQuarter,
      'sajda': sajda,
    };
  }


  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

// Nested model class for the `edition` field


// Nested model class for the `surah` field
