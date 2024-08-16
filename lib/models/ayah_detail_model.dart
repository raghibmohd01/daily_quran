import 'dart:convert';

import 'package:daily_quran/models/edition_model.dart';
import 'package:daily_quran/models/surah_model.dart';



// Nested model class for the `data` field
class AyahDetail {
  final int number;
  final String text;
  final EditionModel? edition;
  final Surah? surah;
  final int numberInSurah;
  final int juz;
  final int manzil;
  final int page;
  final int ruku;
  final int hizbQuarter;
  final bool sajda;
  final String? audio;
  final List<String>? audioSecondary;
  final bool? isPlaying;

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
    this.audio, // New nullable field
    this.audioSecondary,
    this.isPlaying,// New nullable field
  });

  // Create an AyahDetail instance from JSON
  factory AyahDetail.fromJson(Map<String, dynamic> json) {
    return AyahDetail(
      number: json['number'],
      text: json['text'],
      edition: json['edition'] == null ?  null: EditionModel.fromJson(json['edition']),
      surah: json['edition'] == null ?  null: Surah.fromJson(json['surah']),
      numberInSurah: json['numberInSurah'],
      juz: json['juz'],
      manzil: json['manzil'],
      page: json['page'],
      ruku: json['ruku'],
      hizbQuarter: json['hizbQuarter'],
      sajda: json['sajda'],
      audio: json['audio'],
      audioSecondary: json['audioSecondary'] != null
          ? List<String>.from(json['audioSecondary'])
          : null,
      isPlaying: false,
    );
  }

  // Convert an AyahDetail instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'text': text,
      'edition': edition?.toJson(),
      'surah': surah?.toJson(),
      'numberInSurah': numberInSurah,
      'juz': juz,
      'manzil': manzil,
      'page': page,
      'ruku': ruku,
      'hizbQuarter': hizbQuarter,
      'sajda': sajda,
      'audio': audio,
      'audioSecondary': audioSecondary,
      'isPlaying':isPlaying,
    };
  }



  // CopyWith method
  AyahDetail copyWith({
    int? number,
    String? text,
    EditionModel? edition,
    Surah? surah,
    int? numberInSurah,
    int? juz,
    int? manzil,
    int? page,
    int? ruku,
    int? hizbQuarter,
    bool? sajda,
    String? audio,
    List<String>? audioSecondary,
    bool? isPlaying,
  }) {
    return AyahDetail(
      number: number ?? this.number,
      text: text ?? this.text,
      edition: edition ?? this.edition,
      surah: surah ?? this.surah,
      numberInSurah: numberInSurah ?? this.numberInSurah,
      juz: juz ?? this.juz,
      manzil: manzil ?? this.manzil,
      page: page ?? this.page,
      ruku: ruku ?? this.ruku,
      hizbQuarter: hizbQuarter ?? this.hizbQuarter,
      sajda: sajda ?? this.sajda,
      audio: audio ?? this.audio,
      audioSecondary: audioSecondary ?? this.audioSecondary,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
