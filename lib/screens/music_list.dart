import 'package:active_ecommerce_flutter/audio_provider/view_model_provider.dart';
import 'package:active_ecommerce_flutter/custom/play_animation_button.dart';
import 'package:active_ecommerce_flutter/data_model/mp3_response.dart' as mp3;
import 'package:active_ecommerce_flutter/repositories/audio_repository.dart';
import 'package:active_ecommerce_flutter/screens/audio_player_file/local_db_helper.dart';
import 'package:active_ecommerce_flutter/screens/audio_player_file/loop_controll.dart';
import 'package:active_ecommerce_flutter/screens/audio_player_file/position_seek_widget.dart';
import 'package:active_ecommerce_flutter/ui_sections/custom_text.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'dart:math' show Random, pi;

import 'package:provider/provider.dart';

import '../quran_app/database/dbhelper.dart';

class MusicList extends StatefulWidget {
  var id, checker;
  MusicList({Key key, this.id, this.checker}) : super(key: key);

  @override
  State<MusicList> createState() => _MusicListState();
}

class _MusicListState extends State<MusicList> {
  mp3.Mp3Response mp3response;

  var mp3List = [];
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId("0");
  Audio selectedAudio;
  List<Audio> audioList = [];
  int globalIndex;
  List<String> urlList = [];
  bool isNavShow = false;
  Random rnd = new Random();
  bool isShuffle = false;
  bool isLoop = false;
  LoopMode loopMode;
  ViewModelProvider viewModelProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // viewModelProvider.audioListProvider.clear();
    // setState(() {});
    // viewModelProvider.setAudioProvider(viewModelProvider.audioListProvider);
    print(widget.id);
    if (widget.checker == 1) {
      getArtistMp3();
    } else if (widget.checker == 2) {
      getGenreMp3();
    } else if (widget.checker == 3) {
      getAlbumMp3();
    }
    viewModelProvider = Provider.of<ViewModelProvider>(context, listen: false);
    audioPlayer.playlistAudioFinished.listen(
      (Playing playing) {
        print('playlistAudioFinished : $playing');
        if (viewModelProvider.isLoop == false) {
          if (viewModelProvider.globalIndexProvider ==
              (viewModelProvider.audioListProvider.length - 1)) {
            viewModelProvider.globalIndexProvider = 0;
            viewModelProvider.setIsGlobalIndexProvider(
                viewModelProvider.globalIndexProvider);
            viewModelProvider.selectedAudioProvider = viewModelProvider
                .audioListProvider[viewModelProvider.globalIndexProvider];
            setState(() {});
            // audioPlayer.playlistPlayAtIndex(globalIndex);
            // setState(() {});
          } else if (viewModelProvider.globalIndexProvider <
              viewModelProvider.audioListProvider.length - 1) {
            viewModelProvider.globalIndexProvider++;
            viewModelProvider.setIsGlobalIndexProvider(
                viewModelProvider.globalIndexProvider);
            viewModelProvider.selectedAudioProvider = viewModelProvider
                .audioListProvider[viewModelProvider.globalIndexProvider];
            //audioPlayer.playlistPlayAtIndex(globalIndex);
            setState(() {});
          }
        }

        //skipNext();

        audioPlayer.play();

//         //audioPlayer.next(keepLoopMode: true);
      },
    );
  }

  void setUpPlayer() async {
    await audioPlayer.open(
      Playlist(audios: viewModelProvider.audioListProvider),
      showNotification: true,
      autoStart: false,
      notificationSettings: NotificationSettings(
        customPrevAction: (player) {
          if (viewModelProvider.globalIndexProvider > 0) {
            viewModelProvider.globalIndexProvider--;
            viewModelProvider.setIsGlobalIndexProvider(
                viewModelProvider.globalIndexProvider);
            // setState(() {});
            viewModelProvider.selectedAudioProvider = viewModelProvider
                .audioListProvider[viewModelProvider.globalIndexProvider];
            viewModelProvider.setSelectedAudioProvider(
                viewModelProvider.selectedAudioProvider);
            // setState(() {});
            player.playlistPlayAtIndex(viewModelProvider.globalIndexProvider);
            setState(() {});
          } else if (viewModelProvider.globalIndexProvider == 0) {
            viewModelProvider.globalIndexProvider =
                viewModelProvider.audioListProvider.length - 1;
            viewModelProvider.setIsGlobalIndexProvider(
                viewModelProvider.globalIndexProvider);
            // setState(() {});
            viewModelProvider.selectedAudioProvider = viewModelProvider
                .audioListProvider[viewModelProvider.globalIndexProvider];
            viewModelProvider.setSelectedAudioProvider(
                viewModelProvider.selectedAudioProvider);
            setState(() {});
            // player.previous(keepLoopMode: false);
            player.playlistPlayAtIndex(viewModelProvider.globalIndexProvider);
            setState(() {});
          }
        },
        customNextAction: (player) {
          if (viewModelProvider.globalIndexProvider ==
              (viewModelProvider.audioListProvider.length - 1)) {
            viewModelProvider.globalIndexProvider = 0;

            viewModelProvider.setIsGlobalIndexProvider(
                viewModelProvider.globalIndexProvider);
            // setState(() {});
            viewModelProvider.selectedAudioProvider = viewModelProvider
                .audioListProvider[viewModelProvider.globalIndexProvider];
            viewModelProvider.setSelectedAudioProvider(
                viewModelProvider.selectedAudioProvider);
            setState(() {});
          } else if (viewModelProvider.globalIndexProvider <
              viewModelProvider.audioListProvider.length - 1) {
            viewModelProvider.globalIndexProvider++;
            viewModelProvider.setIsGlobalIndexProvider(
                viewModelProvider.globalIndexProvider);
            // setState(() {});
            viewModelProvider.selectedAudioProvider = viewModelProvider
                .audioListProvider[viewModelProvider.globalIndexProvider];
            viewModelProvider.setSelectedAudioProvider(
                viewModelProvider.selectedAudioProvider);
            setState(() {});
          }
          player.next();
        },
      ),
    );
  }

  playMusic() async {
    // await audioPlayer.play();
    await audioPlayer
        .playlistPlayAtIndex(viewModelProvider.globalIndexProvider);
  }

  pauseMusic() async {
    await audioPlayer.pause();
  }

  skipPrevious() async {
    await audioPlayer.previous();
    // await audioPlayer.prev();
  }

  skipNext() async {
    await audioPlayer.next(keepLoopMode: true);
    // globalIndex++;
    // setState(() {});
  }

  getArtistMp3() async {
    mp3List.clear();
    audioList.clear();

    mp3response = await AudioRepository().getArtistMp3List(widget.id);
    mp3List.addAll(mp3response.data);
    for (int i = 0; i < mp3List.length; i++) {
      //urlList.add("https://ayat-app.com/public/" + mp3List[i].file);
      audioList.add(
        Audio.network(
          "https://ayat-app.com/public/" + mp3List[i].file,
          metas: Metas(
              title: mp3List[i].name,
              id: "https://ayat-app.com/public/" + mp3List[i].coverArt,
              album: mp3List[i].description,
              artist: mp3List[i].listens.toString()),
        ),
      );
    }
    viewModelProvider.audioListProvider.addAll(audioList);
    viewModelProvider.setAudioProvider(viewModelProvider.audioListProvider);
    //setState(() {});
    print('p l: ${viewModelProvider.audioListProvider.length}');
    setUpPlayer();
    setState(() {});
  }

  getGenreMp3() async {
    mp3List.clear();
    audioList.clear();
    // viewModelProvider.audioListProvider.clear();
    // viewModelProvider.setAudioProvider(viewModelProvider.audioListProvider);
    mp3response = await AudioRepository().getGenreMp3List(widget.id);
    mp3List.addAll(mp3response.data);
    for (int i = 0; i < mp3List.length; i++) {
      //urlList.add("https://ayat-app.com/public/" + mp3List[i].file);
      audioList.add(
        Audio.network(
          "https://ayat-app.com/public/" + mp3List[i].file,
          metas: Metas(
              title: mp3List[i].name,
              id: "https://ayat-app.com/public/" + mp3List[i].coverArt,
              album: mp3List[i].description,
              artist: mp3List[i].listens.toString()),
        ),
      );
    }
    viewModelProvider.audioListProvider.addAll(audioList);
    viewModelProvider.setAudioProvider(viewModelProvider.audioListProvider);
    // setState(() {});
    setUpPlayer();
    setState(() {});
  }

  getAlbumMp3() async {
    mp3List.clear();
    audioList.clear();
    // viewModelProvider.audioListProvider.clear();
    // viewModelProvider.setAudioProvider(viewModelProvider.audioListProvider);
    mp3response = await AudioRepository().getAlbumMp3List(widget.id);
    mp3List.addAll(mp3response.data);
    for (int i = 0; i < mp3List.length; i++) {
      //urlList.add("https://ayat-app.com/public/" + mp3List[i].file);
      audioList.add(
        Audio.network(
          "https://ayat-app.com/public/" + mp3List[i].file,
          metas: Metas(
              title: mp3List[i].name,
              id: "https://ayat-app.com/public/" + mp3List[i].coverArt,
              album: mp3List[i].description,
              artist: mp3List[i].listens.toString()),
        ),
      );
    }
    viewModelProvider.audioListProvider.addAll(audioList);
    viewModelProvider.setAudioProvider(viewModelProvider.audioListProvider);
    // setState(() {});
    setUpPlayer();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
            child: ListView.builder(
                itemCount: viewModelProvider.audioListProvider.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      viewModelProvider.globalIndexProvider = index;
                      viewModelProvider.setIsGlobalIndexProvider(
                          viewModelProvider.globalIndexProvider);

                      viewModelProvider.selectedAudioProvider =
                          viewModelProvider.audioListProvider[
                              viewModelProvider.globalIndexProvider];
                      viewModelProvider.setSelectedAudioProvider(
                          viewModelProvider.selectedAudioProvider);
                      viewModelProvider.isNavProvider = true;
                      viewModelProvider
                          .setIsNavProvider(viewModelProvider.isNavProvider);
                      //print(globalIndex);
                      var mp = mp3List[viewModelProvider.globalIndexProvider];
                      setState(() {});
                      mp3.Datum datum = mp3.Datum(
                          id: mp.id,
                          name: mp.name,
                          coverArt: mp.coverArt,
                          file: mp.file,
                          artistId: mp.artistId,
                          genreId: mp.genreId,
                          listens: mp.listens,
                          isFeatured: mp.isFeatured,
                          description: mp.description);

                      print(mp.id);
                      // datum.id = mp.id;
                      // datum.name = mp.name;
                      // datum.coverArt = mp.coverArt;
                      // datum.file = mp.coverArt;

                      // datum.artistId = mp.artistId;
                      // datum.genreId = mp.genreId;
                      // datum.listens = mp.listens;
                      // datum.isFeatured = mp.isFeatured;
                      // datum.description = mp.description;
                      DBHelper().saveToRecentList(datum);
                      setState(() {});
                      // isPlaying ? pauseMusic() :
                      playMusic();
                      print("play");
                    },
                    child: Container(
                      height: 70,
                      width: double.infinity,
                      // color: Colors.greenAccent,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 50,
                                  width: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Image.network(
                                      viewModelProvider
                                          .audioListProvider[index].metas.id,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      viewModelProvider
                                          .audioListProvider[index].metas.title,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black54),
                                    ),
                                    Text(
                                      "Ayat-App",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.remove_red_eye,
                                          color: Colors.amber,
                                          size: 12,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          viewModelProvider
                                              .audioListProvider[index]
                                              .metas
                                              .artist,
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.black54),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                            globalIndex == index
                                ? Image.asset('assets/play.gif',
                                    width: 60.0, height: 60.0)
                                : Text('')
                            // audioPlayer.builderIsPlaying(
                            //     builder: (context, isPlaying) {
                            //   return SizedBox(
                            //     height: 33,
                            //     width: 46,
                            //     child: PlayButton(
                            //       pauseIcon: isPlaying
                            //           ? Icon(Icons.pause,
                            //               color: Colors.black, size: 15)
                            //           : Icon(Icons.play_arrow,
                            //               color: Colors.black, size: 15),
                            //       playIcon: Icon(Icons.play_arrow,
                            //           color: Colors.black, size: 15),
                            //       onPressed: () {
                            //         globalIndex = index;
                            //         setState(() {});
                            //         selectedAudio = audioList[globalIndex];
                            //         isNavShow = true;
                            //         print(globalIndex);
                            //         setState(() {});
                            //         // isPlaying ? pauseMusic() :
                            //         playMusic();
                            //         print("play");
                            //       },
                            //     ),
                            //   );
                            // })
                          ],
                        ),
                      ),
                    ),
                  );
                })),
        bottomNavigationBar: viewModelProvider.isNavProvider == false
            ? Container(
                height: 50,
              )
            : audioPlayer.builderIsPlaying(builder: (context, isPlaying) {
                return GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        useRootNavigator: true,
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return Container(
                            child: buildPlayer(),
                          );
                        });
                  },
                  child: Container(
                    height: 50,
                    color: Colors.redAccent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Image.network(
                                // selectedMuisc!.imageUrl,
                                viewModelProvider
                                    .selectedAudioProvider.metas.id,
                                height: 50,
                                width: 40,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  viewModelProvider
                                      .selectedAudioProvider.metas.title,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                // CustomText(
                                //   // text: selectedMuisc!.title,
                                //   text: selectedAudio.metas.title,
                                //   color: Colors.white,
                                //   fontSize: 12,
                                //   fontWeight: FontWeight.bold,
                                // ),
                                // Text(
                                //   selectedAudio.metas.artist,
                                //   style: TextStyle(
                                //       color: Colors.white,
                                //       fontWeight: FontWeight.bold),
                                // ),
                                // CustomText(
                                //   // text: selectedMuisc!.lebel,
                                //   text: selectedAudio.metas.artist,
                                //   color: Colors.grey,
                                //   fontSize: 12,
                                //   fontWeight: FontWeight.bold,
                                // ),
                              ],
                            )
                          ],
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (viewModelProvider.globalIndexProvider > 0) {
                                  viewModelProvider.globalIndexProvider--;
                                  viewModelProvider.setIsGlobalIndexProvider(
                                      viewModelProvider.globalIndexProvider);
                                  // setState(() {});
                                  viewModelProvider.selectedAudioProvider =
                                      viewModelProvider.audioListProvider[
                                          viewModelProvider
                                              .globalIndexProvider];
                                  viewModelProvider.setSelectedAudioProvider(
                                      viewModelProvider.selectedAudioProvider);
                                  audioPlayer.playlistPlayAtIndex(
                                      viewModelProvider.globalIndexProvider);
                                  setState(() {});
                                } else if (viewModelProvider
                                        .globalIndexProvider ==
                                    0) {
                                  viewModelProvider.globalIndexProvider =
                                      viewModelProvider
                                              .audioListProvider.length -
                                          1;
                                  viewModelProvider.setIsGlobalIndexProvider(
                                      viewModelProvider.globalIndexProvider);
                                  // setState(() {});
                                  viewModelProvider.selectedAudioProvider =
                                      viewModelProvider.audioListProvider[
                                          viewModelProvider
                                              .globalIndexProvider];
                                  viewModelProvider.setSelectedAudioProvider(
                                      viewModelProvider.selectedAudioProvider);
                                  // player.previous(keepLoopMode: false);
                                  audioPlayer.playlistPlayAtIndex(
                                      viewModelProvider.globalIndexProvider);
                                  setState(() {});
                                }
                              },
                              child: Icon(
                                Icons.skip_previous,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            GestureDetector(
                              onTap: () {
                                // audioPlayerState == PlayerState.PLAYING
                                //     ? pauseMusic()
                                //     : playMusic();
                                isPlaying ? pauseMusic() : playMusic();
                              },
                              child: Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            GestureDetector(
                              onTap: () {
                                if (viewModelProvider.globalIndexProvider ==
                                    (viewModelProvider
                                            .audioListProvider.length -
                                        1)) {
                                  viewModelProvider.globalIndexProvider = 0;
                                  viewModelProvider.setIsGlobalIndexProvider(
                                      viewModelProvider.globalIndexProvider);
                                  // setState(() {});
                                  viewModelProvider.selectedAudioProvider =
                                      viewModelProvider.audioListProvider[
                                          viewModelProvider
                                              .globalIndexProvider];
                                  viewModelProvider.setSelectedAudioProvider(
                                      viewModelProvider.selectedAudioProvider);
                                  setState(() {});
                                } else if (viewModelProvider
                                        .globalIndexProvider <
                                    viewModelProvider.audioListProvider.length -
                                        1) {
                                  viewModelProvider.globalIndexProvider++;
                                  viewModelProvider.setIsGlobalIndexProvider(
                                      viewModelProvider.globalIndexProvider);
                                  // setState(() {});
                                  viewModelProvider.selectedAudioProvider =
                                      viewModelProvider.audioListProvider[
                                          viewModelProvider
                                              .globalIndexProvider];
                                  viewModelProvider.setSelectedAudioProvider(
                                      viewModelProvider.selectedAudioProvider);
                                  setState(() {});
                                }
                                skipNext();
                              },
                              child: Icon(
                                Icons.skip_next,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            // GestureDetector(
                            //   onTap: () {
                            //     // audioPlayerState == PlayerState.PLAYING
                            //     //     ? pauseMusic()
                            //     //     : playMusic();
                            //     skipNext();
                            //     selectedAudio;
                            //     setState(() {});
                            //   },
                            //   child: Icon(
                            //     Icons.skip_next_rounded,
                            //     color: Colors.white,
                            //     size: 30,
                            //   ),
                            // ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }));
  }

  Widget buildPlayer() {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return StatefulBuilder(
      builder: ((context, setState) {
        return audioPlayer.builderIsPlaying(builder: (context, isPlaying) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.black,
              elevation: 0.0,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.expand_more,
                    color: Colors.white,
                    size: 26,
                  )),
              title: Column(
                children: [
                  CustomText(
                    text: viewModelProvider.selectedAudioProvider.metas.title,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                  // CustomText(
                  //   text: selectedAudio.metas.artist,
                  //   fontSize: 12,
                  //   fontWeight: FontWeight.w800,
                  //   color: Colors.white,
                  // ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.more_vert,
                    size: 26,
                  ),
                )
              ],
            ),
            body: SafeArea(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Image.network(
                    viewModelProvider.selectedAudioProvider.metas.id,
                    height: height * 0.4,
                    width: double.infinity,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: viewModelProvider
                                .selectedAudioProvider.metas.title,
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          // CustomText(
                          //   text: selectedAudio.metas.artist,
                          //   color: Colors.grey,
                          //   fontSize: 15,
                          //   fontWeight: FontWeight.w600,
                          // ),
                        ],
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.favorite_border_outlined,
                            size: 30,
                            color: Colors.white,
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      audioPlayer.builderRealtimePlayingInfos(
                          builder: ((context, infos) {
                        return Text(
                          infos.currentPosition.inSeconds < 60
                              ? '00:${infos.currentPosition.inSeconds}'
                              : '${(infos.currentPosition.inSeconds / 60).toInt()} : ${(infos.currentPosition.inSeconds % 60).toInt()}',
                          style: TextStyle(color: Colors.white),
                        );
                      })),
                      Container(
                        width: 250,
                        child: audioPlayer.builderRealtimePlayingInfos(
                          builder: (context, infos) {
                            return PositionSeekWidget(
                              currentPosition: infos.currentPosition,
                              duration: infos.duration,
                              seekTo: (to) {
                                audioPlayer.seek(to);
                              },
                            );
                          },
                        ),
                      ),
                      audioPlayer.builderRealtimePlayingInfos(
                          builder: ((context, infos) {
                        int minute = (infos.duration.inSeconds / 60).toInt();
                        int reminder = (infos.duration.inSeconds % 60);
                        return Text(
                          // infos.duration.inMinutes.toString(),
                          '${minute.toString()} : $reminder',
                          style: TextStyle(color: Colors.white),
                        );
                      })),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          onPressed: () {
                            // if (isShuffle == false) {
                            //   isShuffle = true;

                            //   int randomIndex =
                            //       rnd.nextInt((audioList.length - 1) - 0);
                            //   globalIndex = randomIndex;
                            //   setState(() {});
                            //   selectedAudio = audioList[globalIndex];
                            //   playMusic();
                            //   setState(() {});
                            // } else {
                            //   isNavShow = false;
                            //   setState(() {});
                            // }
                          },
                          icon: Icon(Icons.shuffle,
                              size: 28,
                              color: isShuffle == false
                                  ? Colors.white
                                  : Colors.blueGrey)),
                      IconButton(
                          onPressed: () {
                            if (viewModelProvider.globalIndexProvider > 0) {
                              viewModelProvider.globalIndexProvider--;
                              viewModelProvider.setIsGlobalIndexProvider(
                                  viewModelProvider.globalIndexProvider);
                              // setState(() {});
                              viewModelProvider.selectedAudioProvider =
                                  viewModelProvider.audioListProvider[
                                      viewModelProvider.globalIndexProvider];
                              viewModelProvider.setSelectedAudioProvider(
                                  viewModelProvider.selectedAudioProvider);
                              audioPlayer.playlistPlayAtIndex(
                                  viewModelProvider.globalIndexProvider);
                              setState(() {});
                            } else if (viewModelProvider.globalIndexProvider ==
                                0) {
                              viewModelProvider.globalIndexProvider =
                                  viewModelProvider.audioListProvider.length -
                                      1;
                              viewModelProvider.setIsGlobalIndexProvider(
                                  viewModelProvider.globalIndexProvider);
                              // setState(() {});
                              viewModelProvider.selectedAudioProvider =
                                  viewModelProvider.audioListProvider[
                                      viewModelProvider.globalIndexProvider];
                              viewModelProvider.setSelectedAudioProvider(
                                  viewModelProvider.selectedAudioProvider);
                              // player.previous(keepLoopMode: false);
                              audioPlayer.playlistPlayAtIndex(
                                  viewModelProvider.globalIndexProvider);
                              setState(() {});
                            }
                          },
                          icon: Icon(
                            Icons.skip_previous,
                            size: 34,
                            color: Colors.white,
                          )),
                      GestureDetector(
                        onTap: () {
                          // audioPlayerState == PlayerState.PLAYING
                          //     ? pauseMusic()
                          //     : playMusic();
                          // setState(() {});
                          isPlaying ? pauseMusic() : playMusic();
                        },
                        child: Icon(
                          // audioPlayerState == PlayerState.PLAYING
                          isPlaying
                              ? Icons.pause_circle_filled_outlined
                              : Icons.play_circle_fill_outlined,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // audioPlayerState == PlayerState.PLAYING
                          //     ? pauseMusic()
                          //     : playMusic();
                          // setState(() {});
                          audioPlayer.stop();
                        },
                        child: Icon(
                          // audioPlayerState == PlayerState.PLAYING
                          Icons.stop_sharp,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            if (viewModelProvider.globalIndexProvider ==
                                (viewModelProvider.audioListProvider.length -
                                    1)) {
                              viewModelProvider.globalIndexProvider = 0;
                              viewModelProvider.setIsGlobalIndexProvider(
                                  viewModelProvider.globalIndexProvider);
                              // setState(() {});
                              viewModelProvider.selectedAudioProvider =
                                  viewModelProvider.audioListProvider[
                                      viewModelProvider.globalIndexProvider];
                              viewModelProvider.setSelectedAudioProvider(
                                  viewModelProvider.selectedAudioProvider);
                              setState(() {});
                            } else if (viewModelProvider.globalIndexProvider <
                                viewModelProvider.audioListProvider.length -
                                    1) {
                              viewModelProvider.globalIndexProvider++;
                              viewModelProvider.setIsGlobalIndexProvider(
                                  viewModelProvider.globalIndexProvider);
                              // setState(() {});
                              viewModelProvider.selectedAudioProvider =
                                  viewModelProvider.audioListProvider[
                                      viewModelProvider.globalIndexProvider];
                              viewModelProvider.setSelectedAudioProvider(
                                  viewModelProvider.selectedAudioProvider);
                              setState(() {});
                            }
                            skipNext();
                          },
                          icon: Icon(
                            Icons.skip_next,
                            size: 34,
                            color: Colors.white,
                          )),

                      audioPlayer.builderLoopMode(builder: (context, loop) {
                        return PlayerBuilder.isPlaying(
                            player: audioPlayer,
                            builder: (context, isPlaying) {
                              return LoopControll(
                                loopMode: loop,
                                toggleLoop: () {
                                  audioPlayer.toggleLoop();
                                },
                              );
                            });
                      }),
                      // IconButton(
                      //     onPressed: () {

                      //       // if (isLoop == false) {
                      //       //   isLoop = true;
                      //       //   setState(() {});
                      //       //   audioPlayer.setLoopMode(LoopMode.single);
                      //       //   audioPlayer.toggleLoop();
                      //       // } else {
                      //       //   isLoop = false;
                      //       //   setState(() {});
                      //       // }
                      //     },
                      //     icon: Icon(
                      //       Icons.loop_outlined,
                      //       size: 28,
                      //       color: isLoop == false
                      //           ? Colors.white
                      //           : Colors.blueGrey,
                      //     )),
                    ],
                  )
                ],
              ),
            )),
          );
        });
      }),
    );
  }
}

class PlayButton extends StatefulWidget {
  final bool initialIsPlaying;
  final Icon playIcon;
  final Icon pauseIcon;
  final VoidCallback onPressed;

  PlayButton({
    @required this.onPressed,
    this.initialIsPlaying = false,
    this.playIcon = const Icon(Icons.play_arrow),
    this.pauseIcon = const Icon(Icons.pause),
  }) : assert(onPressed != null);

  @override
  _PlayButtonState createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> with TickerProviderStateMixin {
  static const _kToggleDuration = Duration(milliseconds: 300);
  static const _kRotationDuration = Duration(seconds: 5);

  bool isPlaying;

  // rotation and scale animations
  AnimationController _rotationController;
  AnimationController _scaleController;
  double _rotation = 0;
  double _scale = 0.85;

  bool get _showWaves => !_scaleController.isDismissed;

  void _updateRotation() => _rotation = _rotationController.value * 2 * pi;
  void _updateScale() => _scale = (_scaleController.value * 0.2) + 0.85;

  @override
  void initState() {
    isPlaying = widget.initialIsPlaying;
    _rotationController =
        AnimationController(vsync: this, duration: _kRotationDuration)
          ..addListener(() => setState(_updateRotation))
          ..repeat();

    _scaleController =
        AnimationController(vsync: this, duration: _kToggleDuration)
          ..addListener(() => setState(_updateScale));

    super.initState();
  }

  void _onToggle() {
    setState(() => isPlaying = !isPlaying);

    if (_scaleController.isCompleted) {
      _scaleController.reverse();
    } else {
      _scaleController.forward();
    }

    widget.onPressed();
  }

  Widget _buildIcon(bool isPlaying) {
    return SizedBox.expand(
      key: ValueKey<bool>(isPlaying),
      child: IconButton(
        icon: isPlaying ? widget.pauseIcon : widget.playIcon,
        onPressed: _onToggle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 48, minHeight: 48),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_showWaves) ...[
            Blob(color: Color(0xff0092ff), scale: _scale, rotation: _rotation),
            Blob(
                color: Color(0xff4ac7b7),
                scale: _scale,
                rotation: _rotation * 2 - 30),
            Blob(
                color: Color(0xffa4a6f6),
                scale: _scale,
                rotation: _rotation * 3 - 45),
          ],
          Container(
            // constraints: BoxConstraints.expand(),
            height: 40,
            width: 60,
            child: AnimatedSwitcher(
              child: _buildIcon(isPlaying),
              duration: _kToggleDuration,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }
}

class Blob extends StatelessWidget {
  final double rotation;
  final double scale;
  final Color color;

  const Blob({this.color, this.rotation = 0, this.scale = 1});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Transform.rotate(
        angle: rotation,
        child: Container(
          height: 20,
          width: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(150), //250
              topRight: Radius.circular(140), //240
              bottomLeft: Radius.circular(120), //220
              bottomRight: Radius.circular(180), //180
            ),
          ),
        ),
      ),
    );
  }
}
