import 'package:active_ecommerce_flutter/custom/listen_row.dart';
import 'package:active_ecommerce_flutter/custom/music_card.dart';
import 'package:active_ecommerce_flutter/data_model/mp3_response.dart';
import 'package:active_ecommerce_flutter/repositories/audio_repository.dart';
import 'package:active_ecommerce_flutter/ui_sections/custom_text.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class Mp3Screen extends StatefulWidget {
  const Mp3Screen({Key key}) : super(key: key);

  @override
  State<Mp3Screen> createState() => _Mp3ScreenState();
}

class _Mp3ScreenState extends State<Mp3Screen> {
  Mp3Response mp3response;
  var mp3List = [];
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId("0");
  Audio selectedAudio;
  List<Audio> audioList = [];
  int globalIndex = 0;
  List<String> urlList = [];
  bool isNavShow = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMp3();
  }

  void setUpPlayer() async {
    await audioPlayer.open(
      Playlist(audios: audioList),
      showNotification: true,
      autoStart: false,
      notificationSettings: NotificationSettings(
        customPrevAction: (player) {
          if (globalIndex > 0) {
            globalIndex--;
            setState(() {});
            selectedAudio = audioList[globalIndex];
            setState(() {});
            player.playlistPlayAtIndex(globalIndex);
            setState(() {});
          } else if (globalIndex == 0) {
            globalIndex = audioList.length - 1;
            setState(() {});
            selectedAudio = audioList[globalIndex];
            setState(() {});
            // player.previous(keepLoopMode: false);
            player.playlistPlayAtIndex(globalIndex);
            setState(() {});
          }
        },
        customNextAction: (player) {
          if (globalIndex == (audioList.length - 1)) {
            globalIndex = 0;
            setState(() {});
            selectedAudio = audioList[globalIndex];
            setState(() {});
          } else if (globalIndex < audioList.length - 1) {
            globalIndex++;
            setState(() {});
            selectedAudio = audioList[globalIndex];
            setState(() {});
          }
          player.next();
        },
      ),
    );
  }

  playMusic() async {
    // await audioPlayer.play();
    await audioPlayer.playlistPlayAtIndex(globalIndex);
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

  getMp3() async {
    mp3response = await AudioRepository().getMp3List();
    mp3List.addAll(mp3response.data);
    for (int i = 0; i < mp3List.length; i++) {
      //urlList.add("https://ayat-app.com/public/" + mp3List[i].file);
      audioList.add(
        Audio.network("https://ayat-app.com/public/" + mp3List[i].file,
            metas: Metas(
                title: mp3List[i].name,
                id: "https://ayat-app.com/public/" + mp3List[i].coverArt)),
      );
    }

    setState(() {});
    setUpPlayer();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("MP3"),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListenRow(
                  title: "Trending Song",
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 140,
                  child: audioList.isEmpty
                      ? Text('')
                      : ListView.builder(
                          itemCount: audioList.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, globalIndex) {
                            return GestureDetector(
                              onTap: () async {
                                // globalIndex = index;
                                selectedAudio = audioList[globalIndex];
                                isNavShow = true;
                                print(globalIndex);
                                setState(() {});
                                playMusic();
                                print("play");
                              },
                              child: MusicCard(
                                songName: audioList[globalIndex].metas.title,
                                artistName: "",
                                imageUrl: audioList[globalIndex].metas.id,
                              ),
                            );
                          }),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: isNavShow == false
            ? Container(
                height: 50,
              )
            : audioPlayer.builderIsPlaying(builder: (context, isPlaying) {
                return GestureDetector(
                  onTap: () {
                    // showModalBottomSheet(
                    //     useRootNavigator: true,
                    //     isScrollControlled: true,
                    //     context: context,
                    //     builder: (context) {
                    //       return Container(
                    //         child: buildPlayer(),
                    //       );
                    //     });
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
                                selectedAudio.metas.id,
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
                                  selectedAudio.metas.title,
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
                            Icon(
                              Icons.favorite_border_outlined,
                              color: Colors.white,
                              size: 30,
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
}
