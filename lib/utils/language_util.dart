// Define a map to associate language codes with their names

import 'dart:core';

class LanguageUtil {
  static const Map<String, String> languageCodes = {
    'ar': 'Arabic',
    'am': 'Amharic',
    'az': 'Azerbaijani',
    'ber': 'Berber',
    'bn': 'Bengali',
    'cs': 'Czech',
    'de': 'German',
    'dv': 'Dhivehi',
    'en': 'English',
    'es': 'Spanish',
    'fa': 'Persian',
    'fr': 'French',
    'ha': 'Hausa',
    'hi': 'Hindi',
    'id': 'Indonesian',
    'it': 'Italian',
    'ja': 'Japanese',
    'ko': 'Korean',
    'ku': 'Kurdish',
    'ml': 'Malayalam',
    'nl': 'Dutch',
    'no': 'Norwegian',
    'pl': 'Polish',
    'ps': 'Pashto',
    'pt': 'Portuguese',
    'ro': 'Romanian',
    'ru': 'Russian',
    'sd': 'Sindhi',
    'so': 'Somali',
    'sq': 'Albanian',
    'sv': 'Swedish',
    'sw': 'Swahili',
    'ta': 'Tamil',
    'tg': 'Tajik',
    'th': 'Thai',
    'tr': 'Turkish',
    'tt': 'Tatar',
    'ug': 'Uighur',
    'ur': 'Urdu',
    'uz': 'Uzbek',
    // Add more language codes and names as needed
  };

  String getLanguageName(String? code) {
    // Return the language name from the map or a default value if the code is not found
    return languageCodes[code] ?? (code ?? '');
  }
}


extension CapitalizeFirst on String {
  String capitalizeFirstLetter()
  {
    return this[0].toUpperCase() + substring(1);
  }
}