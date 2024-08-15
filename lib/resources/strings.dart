

import 'english_strings.dart';



class StringKey {
  static const String dailyQuran = 'dailyQuran';
  static const String juz = 'dailyQuran';

}


class AppStrings {

  static const language = 'english';


  static String juz = _languageStrings[language][StringKey.juz];
  static String dailyQuran = _languageStrings[language][StringKey.dailyQuran];

}

Map<String,dynamic> _languageStrings = {
  'english': englishStrings,
};






