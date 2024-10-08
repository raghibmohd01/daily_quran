import 'package:daily_quran/resources/styles.dart';
import 'package:daily_quran/screens/select_edition_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:just_audio/just_audio.dart';

import '../constants/common_constants.dart';
import '../models/ayah_detail_model.dart';
import '../network/quran_repository.dart';
import '../widgets/bottom_action_fab_widget.dart';

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
  final _player = AudioPlayer();

  late ScrollController _scrollController;

  late bool _isFabVisible;
  bool fetchingData = true;
  int? activeAyahIndex;


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
    _init();

    _isFabVisible = true;
    _scrollController = ScrollController();
    listenScrolling();
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
      await _player.setAudioSource(AudioSource.uri(
          Uri.parse(ayahDetailModel?.audio ?? defualtAudioUrl)));
      _player.setVolume(40);
    } on PlayerException catch (e) {
      print("Error loading audio source: $e");
    }
  }


  void listenScrolling() {
    _scrollController.addListener(() {
      if (_scrollController.offset > 50 &&
          _scrollController.position.userScrollDirection ==
              ScrollDirection.reverse) {
        if (_isFabVisible) {
          setState(() {
            _isFabVisible = false;
          });
        }
      } else if (

      // _scrollController.offset <= 50 &&
      _scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_isFabVisible) {
          setState(() {
            _isFabVisible = true;
          });
        }
      }
    });
  }

  Future<void> fetchData() async {

    setState(() {
      fetchingData = true;
    });

    QuranRepository()
        .fetchAyahDetail(_ayahNumber)
        .then((AyahDetail value) async {
      setState(() {
        _player.stop();
        ayahDetailModel = value;
        text = value.text;
        fetchingData = false;
      });
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  !_isFabVisible
          ? null: AppBar(
        backgroundColor: Styles.appBarColor,

        title: ayahDetailModel == null
            ? Container()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(ayahDetailModel?.surah?.englishName ?? ''),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('${ayahDetailModel?.surah?.number ?? ''} / '),
                      Text('${ayahDetailModel?.numberInSurah ?? ''}'),
                      const Spacer(),
                      // Text(
                      //   'Ayah: $_ayahNumber',
                      //   // style: Theme.of(context).textTheme.headlineSmall,
                      // ),

                      IconButton(onPressed: (){

                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SelectEditionPage()));

                      }, icon: const Icon(Icons.settings),)
                    ],
                  ),
                ],
              ),
      ),

      floatingActionButton: ayahDetailModel == null
          ? Container()
          : BottomActionFabWidget(
        incrementCallback: _incrementCounter,
        decrementCallback: _decrementCounter,
        isVisible: _isFabVisible,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if(ayahDetailModel != null || !fetchingData)
            const SizedBox(
              height: 100,
            ),
            Stack(
              children: [
                ayahDetailModel == null || fetchingData
                    ? const LinearProgressIndicator()
                    : Container(),
                if(ayahDetailModel!=null)
                SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Card(
                          margin: const EdgeInsets.all(8),
                          color: Colors.black,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50)),
                            width: double.infinity,
                            margin: const EdgeInsets.all(30),
                            child: Text(
                              text,
                              style: Styles.getAyahTextStyle(context),
                            ),
                          ),
                        ),
                      ),
                ayahDetailModel == null || ayahDetailModel?.audio == null || (ayahDetailModel?.audio ?? '').isEmpty
                    ? const SizedBox()
                    : getPlayerWidget(ayahDetailModel),

                // Container(
                //         width: playIconContainerSize,
                //         height: playIconContainerSize,
                //         padding:
                //             const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                //         child: StreamBuilder<PlayerState>(
                //           stream: _player.playerStateStream,
                //           builder: (context, snapshot) {
                //             final playerState = snapshot.data;
                //             final processingState =
                //                 playerState?.processingState;
                //             final playing = playerState?.playing;
                //             if (processingState == ProcessingState.loading ||
                //                 processingState ==
                //                     ProcessingState.buffering) {
                //               return Container(
                //                 margin: const EdgeInsets.all(18.0),
                //                 width: 18,
                //                 height: 18,
                //                 child: const Center(
                //                     child: CircularProgressIndicator(
                //                   strokeWidth: 1,
                //                 )),
                //               );
                //             } else if (playing != true) {
                //               return SizedBox(
                //                 width: playIconContainerSize,
                //                 height: playIconContainerSize,
                //                 child: Center(
                //                   child: IconButton(
                //                     icon: const Icon(Icons.play_arrow),
                //                     iconSize: playIconSize,
                //                     onPressed: () async {
                //                       await _player.setAudioSource(
                //                           AudioSource.uri(Uri.parse(
                //                               ayahDetailModel?.audio ?? '')));
                //
                //                       _player.play();
                //                     },
                //                   ),
                //                 ),
                //               );
                //             } else if (processingState !=
                //                 ProcessingState.completed) {
                //               return SizedBox(
                //                 width: playIconContainerSize,
                //                 height: playIconContainerSize,
                //                 child: IconButton(
                //                   icon: const Icon(Icons.pause),
                //                   iconSize: playIconSize,
                //                   onPressed: _player.pause,
                //                 ),
                //               );
                //             } else {
                //               return SizedBox(
                //                 width: playIconContainerSize,
                //                 height: playIconContainerSize,
                //                 child: IconButton(
                //                   icon: const Icon(Icons.replay),
                //                   iconSize: playIconSize,
                //                   onPressed: () =>
                //                       _player.seek(Duration.zero),
                //                 ),
                //               );
                //             }
                //           },
                //         ),
                //       ),
              ],
            )
          ],
        ),
      ),


      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


  Widget getPlayerWidget(AyahDetail? ayahDetailModel, ) {
    return ayahDetailModel == null ||
        ayahDetailModel.audio == null ||
        (ayahDetailModel.audio ?? '').isEmpty
        ? const SizedBox()
        : Container(
      width: playIconContainerSize,
      height: playIconContainerSize,
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
      child: StreamBuilder<PlayerState>(
        stream: _player.playerStateStream,
        builder: (context, snapshot) {
          final playerState = snapshot.data;
          // final processingState = playerState?.processingState;
          // final playing = playerState?.playing;

          if (ayahDetailModel?.playerState != playerState) {

            AyahDetail? updatedAyah = ayahDetailModel?.copyWith(playerState: playerState);



            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                ayahDetailModel = updatedAyah;
              });
            });
          }

          if (ayahDetailModel?.playerState?.processingState ==
              ProcessingState.loading ||
              ayahDetailModel?.playerState?.processingState ==
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
          } else if ( //playing != true &&
          ayahDetailModel?.playerState?.playing != true) {
            return getPlayButtonWidget(ayahDetailModel, playerState);
          } else if (ayahDetailModel?.playerState?.processingState !=
              ProcessingState.completed) {
            return getPauseButton();
          } else if (ayahDetailModel?.playerState?.processingState ==
              ProcessingState.completed) {
            return getReplayButton();
          }
          return Container();
        },
      ),
    );
  }



  Widget getPlayButtonWidget(AyahDetail? ayahDetailModel, PlayerState? playerState) {
    return SizedBox(
      width: playIconContainerSize,
      height: playIconContainerSize,
      child: Center(
        child: IconButton(
          icon: const Icon(Icons.play_arrow),
          iconSize: playIconSize,
          onPressed: () async {


            await _player.setAudioSource(
                AudioSource.uri(Uri.parse(ayahDetailModel?.audio ?? '')));

            _player.play();

            AyahDetail? updatedAyahState =
            ayahDetailModel?.copyWith(playerState: playerState);


            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                ayahDetailModel = updatedAyahState;
              });
            });
          },
        ),
      ),
    );
  }

  Widget getPauseButton() {
    return SizedBox(
      width: playIconContainerSize,
      height: playIconContainerSize,
      child: IconButton(
        icon: const Icon(Icons.pause),
        iconSize: playIconSize,
        onPressed: () {
          _player.pause();
        },
      ),
    );
  }

  Widget getReplayButton() {
    return SizedBox(
      width: playIconContainerSize,
      height: playIconContainerSize,
      child: IconButton(
        icon: const Icon(Icons.replay),
        iconSize: playIconSize,
        onPressed: () {
          _player.seek(Duration.zero);
        },
      ),
    );
  }
}
