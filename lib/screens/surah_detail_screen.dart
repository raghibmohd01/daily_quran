import 'package:daily_quran/models/ayah_model.dart';
import 'package:daily_quran/network/quran_repository.dart';
import 'package:daily_quran/resources/styles.dart';
import 'package:flutter/material.dart';
import '../constants/common_constants.dart';
import '../models/surah_detail_model.dart';
import '../models/surah_model.dart';

class SurahDetailScreen extends StatefulWidget {
  const SurahDetailScreen({super.key, this.surahNumber = 1});

  final int surahNumber;

  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  SurahDetailModel? surahDetailModel;
  late int currentSurahNumber;

  @override
  void initState() {
    super.initState();
    currentSurahNumber = widget.surahNumber;
    fetchFromRepo();
  }

  Future<void> fetchFromRepo() async {
    QuranRepository()
        .fetchSurahDetail(currentSurahNumber)
        .then((SurahDetailModel value) {
      setState(() {
        surahDetailModel = value;
      });
    });
  }

  void _incrementCounter()
  {
    currentSurahNumber++;
    if(currentSurahNumber > lastSurahNumber)
    {
      currentSurahNumber = 1;
    }
    fetchFromRepo();
  }

  void _decrementCounter()
  {


    currentSurahNumber--;
    if(currentSurahNumber == 0)
      {
        currentSurahNumber = lastSurahNumber;
      }
    fetchFromRepo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Styles.appBarColor,
        title: surahDetailModel == null ? Container():Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(surahDetailModel?.englishName ?? ''),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('${surahDetailModel?.number ?? 1} / $lastSurahNumber' ??
                    'SurahNumber'),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [


          FloatingActionButton(
            onPressed: _incrementCounter,
            heroTag: null,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 10,),
          FloatingActionButton(
            onPressed: _decrementCounter,
            tooltip: 'Decrement',
            heroTag: null,
            child: const Icon(Icons.remove),
          ),
          const SizedBox(height: 20,width:50),
        ],
      ),

      body: Center(
        child: surahDetailModel == null
            ? const CircularProgressIndicator()
            : ListView.builder(
                itemCount: surahDetailModel?.ayahs.length,
                itemBuilder: (BuildContext context, int n) {
                  Ayah? ayah = surahDetailModel?.ayahs[n];
                  return Card(
                      margin: const EdgeInsets.all(8),
                      color: Colors.black,
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50)),
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          child: Text(ayah?.text ?? 'Loading..',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(height: 2))));
                }),
      ),
    );
  }
}
