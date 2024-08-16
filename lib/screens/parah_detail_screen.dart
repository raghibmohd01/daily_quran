import 'package:daily_quran/models/ayah_detail_model.dart';
import 'package:daily_quran/models/parah_detail_model.dart';
import 'package:daily_quran/network/quran_repository.dart';
import 'package:daily_quran/resources/strings.dart';
import 'package:daily_quran/resources/styles.dart';
import 'package:daily_quran/widgets/bottom_action_fab_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:just_audio/just_audio.dart';
import '../constants/common_constants.dart';

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
  int? activeAyahIndex;

  late ScrollController _scrollController;
  late bool _isFabVisible;

  @override
  void initState() {
    super.initState();
    currentJuzNumber = widget.juzNumber;
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
        .fetchJuzDetail(currentJuzNumber)
        .then((ParahDetailModel value) {
      if (mounted) {
        setState(() {
          parahDetailModel = value;
          fetchingData = false;
        });
      }
    });
  }

  Future<void> _incrementCounter() async {
    currentJuzNumber++;
    if (currentJuzNumber > lastJuzNumber) {
      currentJuzNumber = 1;
    }
    await fetchFromRepo();
  }

  Future<void> _decrementCounter() async {
    currentJuzNumber--;
    if (currentJuzNumber == 0) {
      currentJuzNumber = lastJuzNumber;
    }
    await fetchFromRepo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !_isFabVisible
          ? null:

      AppBar(

        backgroundColor: Styles.appBarColor,
        title: parahDetailModel == null
            ? Container()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppStrings.juz),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                          '${parahDetailModel?.number ?? currentJuzNumber} / $lastJuzNumber'),
                    ],
                  ),
                ],
              ),
      ),
      floatingActionButton: parahDetailModel == null
          ? Container() : BottomActionFabWidget(
        incrementCallback: _incrementCounter,
        decrementCallback: _decrementCounter,
        isVisible: _isFabVisible,
      ),


      body: Column(
        //direction: Axis.vertical,

        children: [
          parahDetailModel == null || fetchingData
              ? const LinearProgressIndicator()
              : Container(),
          if (parahDetailModel != null)
            Expanded(
              child: ListView.builder(
                  controller: _scrollController,
                  itemCount: parahDetailModel?.ayahs.length,
                  itemBuilder: (BuildContext context, int index) {
                    AyahDetail? ayah = parahDetailModel?.ayahs[index];
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
                  List<AyahDetail> updatedList = parahDetailModel?.ayahs ?? [];
                  AyahDetail updatedAyah =
                      ayahDetailModel.copyWith(playerState: playerState);
                  updatedList[index] = updatedAyah;

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      parahDetailModel =
                          parahDetailModel?.copyWith(ayahs: updatedList);
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

            List<AyahDetail> updatedList = parahDetailModel?.ayahs ?? [];
            AyahDetail updatedAyah =
                ayahDetailModel.copyWith(playerState: playerState);
            updatedList[index] = updatedAyah;

            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                parahDetailModel =
                    parahDetailModel?.copyWith(ayahs: updatedList);
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
