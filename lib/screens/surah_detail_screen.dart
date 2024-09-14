import 'package:daily_quran/models/ayah_detail_model.dart';
import 'package:daily_quran/models/ayah_model.dart';
import 'package:daily_quran/network/quran_repository.dart';
import 'package:daily_quran/resources/styles.dart';
import 'package:daily_quran/screens/select_edition_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:just_audio/just_audio.dart';
import '../constants/common_constants.dart';
import '../models/surah_detail_model.dart';
import '../models/surah_model.dart';
import '../widgets/bottom_action_fab_widget.dart';

class SurahDetailScreen extends StatefulWidget {
  const SurahDetailScreen({super.key, this.surahNumber = 1});

  final int surahNumber;

  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  SurahDetailModel? surahDetailModel;
  late int currentSurahNumber;
  late ScrollController _scrollController;
  late bool _isFabVisible;
  bool fetchingData = true;
  int? activeAyahIndex;
  final _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    currentSurahNumber = widget.surahNumber;
    fetchFromRepo();
    _init();
    _isFabVisible = true;
    _scrollController = ScrollController();
    listenScrolling();
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



  Future<void> _init() async {
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
          print('A stream error occurred: $e');
        });
    // Try to load audio from a source and catch any errors.
    try {
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
        .fetchSurahDetail(currentSurahNumber)
        .then((SurahDetailModel value) {
      setState(() {
        surahDetailModel = value;
        fetchingData = false;
      });
    });
  }

  void _incrementCounter() {
    currentSurahNumber++;
    if (currentSurahNumber > lastSurahNumber) {
      currentSurahNumber = 1;
    }
    fetchFromRepo();
  }

  void _decrementCounter() {
    currentSurahNumber--;
    if (currentSurahNumber == 0) {
      currentSurahNumber = lastSurahNumber;
    }
    fetchFromRepo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !_isFabVisible
          ? null
          : AppBar(
              backgroundColor: Styles.appBarColor,
              title: surahDetailModel == null
                  ? Container()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(surahDetailModel?.englishName ?? ''),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                                '${surahDetailModel?.number ?? 1} / $lastSurahNumber' ??
                                    'SurahNumber'),
                            Spacer(),

                            IconButton(onPressed: (){

                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SelectEditionPage()));

                            },icon: const Icon(Icons.settings),),
                              ],
                        ),
                      ],
                    ),
            ),
      floatingActionButton: surahDetailModel == null
          ? Container()
          : BottomActionFabWidget(
              incrementCallback: _incrementCounter,
              decrementCallback: _decrementCounter,
              isVisible: _isFabVisible,
            ),
      body: Column(
        children: [
          surahDetailModel == null || fetchingData
              ? const LinearProgressIndicator()
              : Container(),

          if(surahDetailModel!=null)
          Expanded(
            child: ListView.builder(
                    controller: _scrollController,
                    itemCount: surahDetailModel?.ayahs.length,
                    itemBuilder: (BuildContext context, int index) {
                      AyahDetail? ayah = surahDetailModel?.ayahs[index];
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
                                      horizontal: 30, vertical: 15),
                                  child: Text(ayah?.text ?? 'Loading..',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(height: 2)))),
                          getPlayerWidget(ayah, index),
                        ],
                      );
                    }),
          ),
        ],
      ),
    );
  }

  Widget getPlayerWidget(AyahDetail? ayahDetailModel, int index) {
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

          if (ayahDetailModel.playerState != playerState &&
              ayahDetailModel.playerState != null &&
              activeAyahIndex == index) {
            List<AyahDetail> updatedList = surahDetailModel?.ayahs ?? [];
            AyahDetail updatedAyah =
            ayahDetailModel.copyWith(playerState: playerState);
            updatedList[index] = updatedAyah;

            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                surahDetailModel =
                    surahDetailModel?.copyWith(ayahs: updatedList);
              });
            });
          }

          if (ayahDetailModel.playerState?.processingState ==
              ProcessingState.loading ||
              ayahDetailModel.playerState?.processingState ==
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
          ayahDetailModel.playerState?.playing != true) {
            return getPlayButtonWidget(
                index, ayahDetailModel, playerState);
          } else if (ayahDetailModel.playerState?.processingState !=
              ProcessingState.completed) {
            return getPauseButton(index);
          } else if (ayahDetailModel.playerState?.processingState ==
              ProcessingState.completed) {
            return getReplayButton(index);
          }
          return Container();
        },
      ),
    );
  }



  Widget getPlayButtonWidget(
      int index, AyahDetail ayahDetailModel, PlayerState? playerState) {
    return SizedBox(
      width: playIconContainerSize,
      height: playIconContainerSize,
      child: Center(
        child: IconButton(
          icon: const Icon(Icons.play_arrow),
          iconSize: playIconSize,
          onPressed: () async {
            activeAyahIndex = index;

            await _player.setAudioSource(
                AudioSource.uri(Uri.parse(ayahDetailModel.audio ?? '')));

            _player.play();

            List<AyahDetail> updatedList = surahDetailModel?.ayahs ?? [];
            AyahDetail updatedAyah =
            ayahDetailModel.copyWith(playerState: playerState);
            updatedList[index] = updatedAyah;

            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                surahDetailModel =
                    surahDetailModel?.copyWith(ayahs: updatedList);
              });
            });
          },
        ),
      ),
    );
  }

  Widget getPauseButton(int index) {
    return SizedBox(
      width: playIconContainerSize,
      height: playIconContainerSize,
      child: IconButton(
        icon: const Icon(Icons.pause),
        iconSize: playIconSize,
        onPressed: () {
          activeAyahIndex = index;
          _player.pause();
        },
      ),
    );
  }

  Widget getReplayButton(int index) {
    return SizedBox(
      width: playIconContainerSize,
      height: playIconContainerSize,
      child: IconButton(
        icon: const Icon(Icons.replay),
        iconSize: playIconSize,
        onPressed: () {
          activeAyahIndex = index;
          _player.seek(Duration.zero);
        },
      ),
    );
  }
}
