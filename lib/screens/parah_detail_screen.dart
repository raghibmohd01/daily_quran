import 'package:daily_quran/models/ayah_detail_model.dart';
import 'package:daily_quran/models/ayah_model.dart';
import 'package:daily_quran/models/parah_detail_model.dart';
import 'package:daily_quran/network/quran_repository.dart';
import 'package:daily_quran/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
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
  bool fetchingData = true;
  final _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    currentJuzNumber = widget.juzNumber;
    fetchFromRepo();
    _init();
  }


  Future<void> _init() async {
    // Inform the operating system of our app's audio attributes etc.
    // We pick a reasonable default for an app that plays speech.
    // final session = await AudioSession.instance;
    // await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
          print('A stream error occurred: $e');
        });
    // Try to load audio from a source and catch any errors.
    try {
      // AAC example: https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.aac
      // await _player.setAudioSource(AudioSource.uri(
      //     Uri.parse(parahDetailModel?.audio ?? defualtAudioUrl)));
      _player.setVolume(40);
    } on PlayerException catch (e) {
      print("Error loading audio source: $e");
    }
  }


  @override
  void dispose() {
    //(WidgetsBinding.instance).removeObserver(observer)
    // Release decoders and buffers back to the operating system making them
    // available for other apps to use.
    _player.dispose();
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      _player.stop();
    }
  }

  Future<void> fetchFromRepo() async {
    setState(() {
      fetchingData = true;
    });

    QuranRepository()
        .fetchJuzDetail(currentJuzNumber)
        .then((ParahDetailModel value) {
          if(mounted) {
            setState(() {
        parahDetailModel = value;
        fetchingData = false;
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

      body:

      Column(
        //direction: Axis.vertical,

        children: [
          parahDetailModel == null || fetchingData
              ? const LinearProgressIndicator(): Container(),
          if(parahDetailModel != null)
          Expanded(
            child: ListView.builder(
                itemCount: parahDetailModel?.ayahs.length,
                itemBuilder: (BuildContext context, int n) {
                  AyahDetail? ayah = parahDetailModel?.ayahs[n];
                  return Stack(
                    children: [
            
                      Card(
                         margin: const EdgeInsets.all(8),
                          color: Colors.black,
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50)),
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 12),
                              child: Text(ayah?.text ?? 'Loading..',
                                  style: Styles.getJuzStyle(context)))),
            
                      getPlayerWidget(ayah),
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }

 Widget getPlayerWidget(AyahDetail? ayahDetailModel) {


    return ayahDetailModel == null || ayahDetailModel?.audio == null || (ayahDetailModel?.audio ?? '').isEmpty
        ? const SizedBox()
        : Container(
      width: playIconContainerSize,
      height: playIconContainerSize,
      padding:
      const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
      child: StreamBuilder<PlayerState>(
        stream: _player.playerStateStream,
        builder: (context, snapshot) {
          final playerState = snapshot.data;
          final processingState =
              playerState?.processingState;
          final playing = playerState?.playing;
          if (processingState == ProcessingState.loading ||
              processingState ==
                  ProcessingState.buffering) {
            return Container(
              margin: const EdgeInsets.all(18.0),
              width: 18,
              height: 18,
              child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 1,
                  )),
            );
          } else if (playing != true) {
            return SizedBox(
              width: playIconContainerSize,
              height: playIconContainerSize,
              child: Center(
                child: IconButton(
                  icon: const Icon(Icons.play_arrow),
                  iconSize: playIconSize,
                  onPressed: () async {


                    await _player.setAudioSource(
                        AudioSource.uri(Uri.parse(
                            ayahDetailModel?.audio ?? '')));

                    _player.play();
                  },
                ),
              ),
            );
          } else if (processingState !=
              ProcessingState.completed) {
            return SizedBox(
              width: playIconContainerSize,
              height: playIconContainerSize,
              child: IconButton(
                icon: const Icon(Icons.pause),
                iconSize: playIconSize,
                onPressed: _player.pause,
              ),
            );
          } else {
            return SizedBox(
              width: playIconContainerSize,
              height: playIconContainerSize,
              child: IconButton(
                icon: const Icon(Icons.replay),
                iconSize: playIconSize,
                onPressed: () =>
                    _player.seek(Duration.zero),
              ),
            );
          }
        },
      ),
    );
  }
}
