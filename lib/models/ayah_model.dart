// import 'dart:convert';
//
// // Model class for the ayah
// class Ayah {
//   final int number;
//   final String text;
//   final int numberInSurah;
//   final int juz;
//   final int manzil;
//   final int page;
//   final int ruku;
//   final int hizbQuarter;
//   final dynamic sajda;   // bool or map
//   final String? audio;
//   final List<String>? audioSecondary;
//
//   Ayah({
//     required this.number,
//     required this.text,
//     required this.numberInSurah,
//     required this.juz,
//     required this.manzil,
//     required this.page,
//     required this.ruku,
//     required this.hizbQuarter,
//     required this.sajda,
//     this.audio, // New nullable field
//     this.audioSecondary, // New nullable field
//   });
//
//   // Create an Ayah instance from JSON
//   factory Ayah.fromJson(Map<String, dynamic> json) {
//     return Ayah(
//       number: json['number'],
//       text: json['text'],
//       numberInSurah: json['numberInSurah'],
//       juz: json['juz'],
//       manzil: json['manzil'],
//       page: json['page'],
//       ruku: json['ruku'],
//       hizbQuarter: json['hizbQuarter'],
//       sajda: json['sajda'],
//       audio: json['audio'],
//       audioSecondary: json['audioSecondary'] != null
//           ? List<String>.from(json['audioSecondary'])
//           : null,
//     );
//   }
//
//   // Convert an Ayah instance to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'number': number,
//       'text': text,
//       'numberInSurah': numberInSurah,
//       'juz': juz,
//       'manzil': manzil,
//       'page': page,
//       'ruku': ruku,
//       'hizbQuarter': hizbQuarter,
//       'sajda': sajda,
//       'audio': audio,
//       'audioSecondary': audioSecondary,
//     };
//   }
//
//   @override
//   String toString() {
//     return jsonEncode(this.toJson());
//   }
// }