import 'package:active_ecommerce_flutter/custom/listen_row.dart';
import 'package:active_ecommerce_flutter/custom/music_card.dart';
import 'package:active_ecommerce_flutter/data_model/mp3_response.dart';
import 'package:active_ecommerce_flutter/repositories/audio_repository.dart';
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMp3();
    setUpPlayer();
  }

  void setUpPlayer() async {
    await audioPlayer.open(
      Playlist(audios: audioList),
      showNotification: true, autoStart: false,
      //     notificationSettings: NotificationSettings(customNextAction: (player) {
      //   globalIndex++;
      //   setState(() {});
      // }
      // )
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
    print(audioList.length);
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
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            globalIndex = index;
                            setState(() {});
                            playMusic();
                            print("play");
                          },
                          child: MusicCard(
                            songName: audioList[index].metas.title,
                            artistName: "",
                            imageUrl: audioList[index].metas.id,
                          ),
                        );
                      }),
            ),
          ],
        ),
      )),
    );
  }
}
