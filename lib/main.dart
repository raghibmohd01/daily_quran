import 'dart:io';

import 'package:daily_quran/screens/ayah_detail_screen.dart';
import 'package:daily_quran/screens/home_screen.dart';
import 'package:daily_quran/screens/parah_detail_screen.dart';
import 'package:daily_quran/screens/select_edition_page.dart';
import 'package:daily_quran/screens/surah_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        hintColor: Colors.blueAccent,
        // Customize other properties
      ),
      home: const SelectEditionPage(),
    );
  }
}
