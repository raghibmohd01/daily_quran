

import 'package:shared_preferences/shared_preferences.dart';

import '../constants/common_constants.dart';

class PrefUtil
{
  static late  SharedPreferences instance;



  Future<void> init() async
  {
    instance = await SharedPreferences.getInstance();
  }

  Future<void> updateIdentifier(String? identifier ) async
  {
    if(identifier == null || identifier.isEmpty)
      {
        return;
      }

    await instance.setString(identifierKey, identifier);
  }

  String getIdentifier()
  {
    return  instance.getString(identifierKey) ?? 'en.asad';
  }

}