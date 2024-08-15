import 'package:daily_quran/models/ayah_model.dart';
import 'package:daily_quran/models/parah_detail_model.dart';
import 'package:daily_quran/network/quran_repository.dart';
import 'package:daily_quran/resources/styles.dart';
import 'package:flutter/material.dart';
import '../constants/common_constants.dart';
import '../models/surah_detail_model.dart';
import '../models/surah_model.dart';

class ParahDetailScreen extends StatefulWidget {
  const ParahDetailScreen({super.key, this.juzNumber = 1});

  final int juzNumber;

  @override
  State<ParahDetailScreen> createState() => ParahDetailScreenState();
}

class ParahDetailScreenState extends State<ParahDetailScreen> {
  ParahDetailModel? parahDetailModel;
  late int currentJuzNumber;

  @override
  void initState() {
    super.initState();
    currentJuzNumber = widget.juzNumber;
    fetchFromRepo();
  }

  Future<void> fetchFromRepo() async {
    QuranRepository()
        .fetchJuzDetail(currentJuzNumber)
        .then((ParahDetailModel value) {
          if(mounted) {
            setState(() {
        parahDetailModel = value;
      });
          }
    });
  }

  Future<void> _incrementCounter()
  async {
    currentJuzNumber++;
    if(currentJuzNumber > lastJuzNumber)
    {
      currentJuzNumber = 1;
    }
   await fetchFromRepo();
  }

  Future<void> _decrementCounter()
  async {
    currentJuzNumber--;
    if(currentJuzNumber == 0)
    {
      currentJuzNumber = lastJuzNumber;
    }
    await fetchFromRepo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Styles.appBarColor,
        title: parahDetailModel == null ? Container():Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Juz'),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('${parahDetailModel?.number ?? currentJuzNumber} / $lastJuzNumber' ??
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
          const SizedBox(height: 10),

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
        child: parahDetailModel == null
            ? const CircularProgressIndicator()
            : ListView.builder(
            itemCount: parahDetailModel?.ayahs.length,
            itemBuilder: (BuildContext context, int n) {
              Ayah? ayah = parahDetailModel?.ayahs[n];
              return Card(
                 margin: const EdgeInsets.all(8),
                  color: Colors.black,
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50)),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 12),
                      child: Text(ayah?.text ?? 'Loading..',
                          style: Styles.getJuzStyle(context))));
            }),
      ),
    );
  }
}
