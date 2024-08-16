import 'package:daily_quran/resources/strings.dart';
import 'package:daily_quran/screens/ayah_detail_screen.dart';
import 'package:daily_quran/screens/parah_detail_screen.dart';
import 'package:daily_quran/screens/surah_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../resources/styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Styles.appBarColor,
          title:  Text(AppStrings.dailyQuran),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Read by: '),
              SizedBox(height: 10,),
              Container(
                width: 200,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ParahDetailScreen()),
                    );
                    
                  },
                  child:  Text(AppStrings.juz),
                ),
              ),
              Container(
                width: 200,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                  onPressed: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SurahDetailScreen()),
                    );
                  },
                  child: const Text('Surah'),
                ),
              ),
              Container(
                width: 200,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                  onPressed: () {
                    
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AyahDetailScreen()));
                    
                  },
                  child: const Text('Ayah'),
                ),
              ),
            ],
          ),
        ));
  }
}
