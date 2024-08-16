import 'dart:convert';

import 'package:daily_quran/constants/common_constants.dart';
import 'package:daily_quran/models/edition_model.dart';
import 'package:daily_quran/models/parah_detail_model.dart';
import 'package:daily_quran/models/surah_detail_model.dart';
import 'package:daily_quran/utils/pref_util.dart';
import 'package:http/http.dart' as http;

import '../models/ayah_detail_model.dart';



class QuranRepository {
  final http.Client client = http.Client();

  QuranRepository();

  Future<dynamic> fetchDataFromApi(Uri uri) async {
    try {
       print('uri: $uri');
      var response = await client.get(uri);
      if (response.statusCode == 200) {
        var responseMap = jsonDecode(response.body) as Map<String, dynamic>;
        print(responseMap['data']);
        return responseMap['data'];

      } else {
        return 'Failed to load data';
      }
    } finally {
      client.close();
    }
  }



  Future<SurahDetailModel> fetchSurahDetail(int surahNumber,{String? identifier}) async {
    try {

      if(identifier == null || identifier.isEmpty)
        {
          identifier = PrefUtil().getIdentifier();
        }

      var uri = Uri.parse('$baseUrl/surah/$surahNumber/$identifier');
      var response = await fetchDataFromApi(uri);

      // print('response: $response');
      return SurahDetailModel.fromJson(response);
    } finally {
      client.close();
    }
  }

  Future<AyahDetail> fetchAyahDetail(int ayahNumber,{String? identifier}) async {
    try {

      if(identifier == null || identifier.isEmpty)
      {
        identifier = PrefUtil().getIdentifier();
      }

      var uri = Uri.parse('$baseUrl/ayah/$ayahNumber/$identifier');
      var response = await fetchDataFromApi(uri);
      return AyahDetail.fromJson(response);
    } finally {
      client.close();
    }
  }
  
  Future<ParahDetailModel> fetchJuzDetail(int juzNumber,{String? identifier}) async {
    try {
      if(identifier == null || identifier.isEmpty)
      {
        identifier = PrefUtil().getIdentifier();
      }

      var uri = Uri.parse('$baseUrl/juz/$juzNumber/$identifier');
      var response = await fetchDataFromApi(uri);
      return ParahDetailModel.fromJson(response);
    } finally {
      client.close();
    }
  }
  
  
  Future<List<EditionModel>> fetchEditions() async
  {
    List<EditionModel> allEditions = [];
    

      
      var uri = Uri.parse('$baseUrl/edition');
      var response = await fetchDataFromApi(uri);

      //print('resp ${response}');

      for(dynamic item in response as List<dynamic>)
        {
         // print('item $item');
          EditionModel model =  EditionModel.fromJson(item);
          allEditions.add(model);
        }


      //print('all Edition $allEditions');
      return allEditions;
  }
}


