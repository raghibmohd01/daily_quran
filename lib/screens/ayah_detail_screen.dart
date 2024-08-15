import 'package:daily_quran/resources/styles.dart';
import 'package:flutter/material.dart';

import '../constants/common_constants.dart';
import '../models/ayah_detail_model.dart';
import '../network/quran_repository.dart';

class AyahDetailScreen extends StatefulWidget {
  const AyahDetailScreen({super.key, this.ayahNumber = 1});

  final int ayahNumber;

  @override
  State<AyahDetailScreen> createState() => _AyahDetailScreenState();
}

class _AyahDetailScreenState extends State<AyahDetailScreen> {
  late int _ayahNumber;

  String text = '';
  AyahDetail? ayahDetailModel;

  void _incrementCounter() {
    setState(() {
      _ayahNumber++;
      if (_ayahNumber > lastAyahNumber) {
        _ayahNumber = 1;
      }

      fetchData();
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_ayahNumber == 1) return;
      _ayahNumber--;
      fetchData();
    });
  }

  @override
  void initState() {
    super.initState();
    _ayahNumber = widget.ayahNumber;
    fetchData();
  }

  Future<void> fetchData() async {
    QuranRepository().fetchAyahDetail(_ayahNumber).then((AyahDetail value) {
      setState(() {
        ayahDetailModel = value;
        text = value.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Styles.appBarColor,
        title: ayahDetailModel == null ? Container(): Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ayahDetailModel?.surah.englishName ?? ''),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('${ayahDetailModel?.surah.number ?? ''} / '),
                Text('${ayahDetailModel?.numberInSurah ?? ''}'),
                const Spacer(),
                Text(
                  'Ayah: $_ayahNumber',
                  // style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 100,
              ),
              ayahDetailModel == null
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Card(
                        margin: EdgeInsets.all(8),
                        color: Colors.black,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50)),
                          width: double.infinity,
                          padding: const EdgeInsets.all(30),
                          child: Text(text,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(height: 2)),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            heroTag: null,
            child: const Icon(Icons.add),
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            onPressed: _decrementCounter,
            tooltip: 'Decrement',
            heroTag: null,
            child: const Icon(Icons.remove),
          ),
          const SizedBox(height: 20, width: 50),
        ],
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
