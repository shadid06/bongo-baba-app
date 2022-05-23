import 'package:active_ecommerce_flutter/custom/listen_row.dart';
import 'package:active_ecommerce_flutter/custom/music_card.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/data_model/prayer_time_response.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/repositories/prayertime_repository.dart';
import 'package:active_ecommerce_flutter/ui_sections/drawer.dart';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shimmer/shimmer.dart';

class Listen extends StatefulWidget {
  Listen({Key key, this.title, this.show_back_button = false, go_back = true})
      : super(key: key);
  final String title;
  bool show_back_button;
  bool go_back;
  @override
  State<Listen> createState() => _ListenState();
}

class _ListenState extends State<Listen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PrayerTimeResponse prayerTimeResponse;
  var timesList = [];
  bool isTimes = true;
  var zhur;
  var zhurCmp;
  var asar;
  var asarCmp;
  var sunsetCmp;
  var sunset;
  var magribCmp;
  var magrib;
  var isha;
  var ishaCmp;

  @override
  void initState() {
    super.initState();
    fetchPrayerTime();
  }

  fetchPrayerTime() async {
    prayerTimeResponse = await PrayerTimeRepository().getPrayer();

    timeConvert();

    isTimes = false;
    setState(() {});
  }

  timeConvert() {
    zhur = prayerTimeResponse.data.timings.dhuhr.split(':');
    asar = prayerTimeResponse.data.timings.asr.split(':');
    sunset = prayerTimeResponse.data.timings.sunset.split(':');
    magrib = prayerTimeResponse.data.timings.maghrib.split(':');
    isha = prayerTimeResponse.data.timings.isha.split(':');
    var zh;
    zh = zhur[0];
    zhurCmp = int.parse(zh);
    if (zhurCmp >= 12) {
      zhurCmp = zhurCmp - 12;
    }
    var as;
    as = asar[0];
    asarCmp = int.parse(as);
    if (asarCmp >= 12) {
      asarCmp = asarCmp - 12;
    }
    var sn;
    sn = sunset[0];
    sunsetCmp = int.parse(sn);
    if (sunsetCmp >= 12) {
      sunsetCmp = sunsetCmp - 12;
    }
    var mg;
    mg = magrib[0];
    magribCmp = int.parse(mg);
    if (magribCmp >= 12) {
      magribCmp = magribCmp - 12;
    }
    var ish;
    ish = isha[0];
    ishaCmp = int.parse(ish);
    if (ishaCmp >= 12) {
      ishaCmp = ishaCmp - 12;
    }
  }
  // final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId("0");
  // Audio selectedAudio;
  // int globalIndex = 0;
  // List<Audio> audioList = [
  //   Audio.network(
  //       'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-13.mp3',
  //       metas: Metas(
  //           title: 'Song1',
  //           artist: 'Artist1',
  //           album: 'album1',
  //           //: MetasImage.network("assets/images/country.jpg"),
  //           id: 'https://thumbs.dreamstime.com/b/environment-earth-day-hands-trees-growing-seedlings-bokeh-green-background-female-hand-holding-tree-nature-field-gra-130247647.jpg')),
  //   Audio.network(
  //       'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-14.mp3',
  //       metas: Metas(
  //           title: 'Song2',
  //           artist: 'Artist2',
  //           album: 'album1',
  //           id: 'https://tinypng.com/images/social/website.jpg')),
  //   Audio.network(
  //       'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-15.mp3',
  //       metas: Metas(
  //           title: 'Song3',
  //           artist: 'Artist3',
  //           album: 'album1',
  //           id: 'https://static.addtoany.com/images/dracaena-cinnabari.jpg')),
  // ];
  // @override
  // void initState() {
  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  //   audioPlayer.dispose();
  // }

  // void setupPlaylist() async {
  //   audioPlayer.open(
  //     Playlist(audios: audioList),
  //     notificationSettings: NotificationSettings(
  //       customPrevAction: (player) {
  //         if (globalIndex > 0) {
  //           globalIndex--;
  //           setState(() {});
  //           selectedAudio = audioList[globalIndex];
  //           setState(() {});
  //           player.playlistPlayAtIndex(globalIndex);
  //           setState(() {});
  //         } else if (globalIndex == 0) {
  //           globalIndex = audioList.length - 1;
  //           setState(() {});
  //           selectedAudio = audioList[globalIndex];
  //           setState(() {});
  //           // player.previous(keepLoopMode: false);
  //           player.playlistPlayAtIndex(globalIndex);
  //           setState(() {});
  //         }
  //       },
  //       customNextAction: (player) {
  //         if (globalIndex == (audioList.length - 1)) {
  //           globalIndex = 0;
  //           setState(() {});
  //           selectedAudio = audioList[globalIndex];
  //           setState(() {});
  //         } else if (globalIndex < audioList.length - 1) {
  //           globalIndex++;
  //           setState(() {});
  //           selectedAudio = audioList[globalIndex];
  //           setState(() {});
  //         }
  //         player.next();
  //       },
  //     ),
  //     showNotification: true,
  //     autoStart: false,
  //     // loopMode: isLoop == true ? LoopMode.single : LoopMode.none
  //   );
  // }

  // playMusic() async {
  //   // await audioPlayer.play();
  //   await audioPlayer.playlistPlayAtIndex(globalIndex);
  // }

  // pauseMusic() async {
  //   await audioPlayer.pause();
  // }

  // skipPrevious() async {
  //   await audioPlayer.previous();
  //   // await audioPlayer.prev();
  // }

  // skipNext() async {
  //   await audioPlayer.next(keepLoopMode: true);
  //   // globalIndex++;
  //   // setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xffeafbf0),
      appBar: buildAppBar(statusBarHeight, context),
      drawer: MainDrawer(),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(10)),
                child: isTimes == false
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 100,
                              width: 120,
                              child: Center(
                                child: CircularPercentIndicator(
                                  radius: 50.0,
                                  animation: true,
                                  animationDuration: 1200,
                                  lineWidth: 15.0,
                                  percent: 0.4,
                                  // center: new Text(
                                  //   "40 hours",
                                  //   style: new TextStyle(
                                  //       fontWeight: FontWeight.bold,
                                  //       fontSize: 20.0),
                                  // ),
                                  center: TweenAnimationBuilder<Duration>(
                                      duration: Duration(minutes: 3),
                                      tween: Tween(
                                          begin: Duration(minutes: 3),
                                          end: Duration.zero),
                                      onEnd: () {
                                        print('Timer ended');
                                      },
                                      builder: (BuildContext context,
                                          Duration value, Widget child) {
                                        final minutes = value.inMinutes;
                                        final seconds = value.inSeconds % 60;
                                        return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Text(
                                              '$minutes:$seconds',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  // color: Color(0xff5DAE7B),
                                                  // fontFamily: balooDa2,
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600),
                                            ));
                                      }),
                                  circularStrokeCap: CircularStrokeCap.butt,
                                  backgroundColor: Colors.yellow,
                                  progressColor: Colors.white,
                                ),
                              ),
                              // child: TweenAnimationBuilder<Duration>(
                              //     duration: Duration(minutes: 3),
                              //     tween: Tween(
                              //         begin: Duration(minutes: 3),
                              //         end: Duration.zero),
                              //     onEnd: () {
                              //       print('Timer ended');
                              //     },
                              //     builder: (BuildContext context,
                              //         Duration value, Widget child) {
                              //       final minutes = value.inMinutes;
                              //       final seconds = value.inSeconds % 60;
                              //       return Padding(
                              //           padding: const EdgeInsets.symmetric(
                              //               vertical: 5),
                              //           child: Text(
                              //             '$minutes:$seconds',
                              //             textAlign: TextAlign.center,
                              //             style: TextStyle(
                              //                 // color: Color(0xff5DAE7B),
                              //                 // fontFamily: balooDa2,
                              //                 color: Colors.white,
                              //                 fontSize: 14,
                              //                 fontWeight: FontWeight.w600),
                              //           ));
                              //     }),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //যোহর আছর মাগরিব ইশা সাহরি	ইফতার সূর্যোদয় সূর্যাস্ত
                                Text(
                                    "ফজর ${prayerTimeResponse.data.timings.fajr} AM"),
                                Text(
                                    "সূর্যোদয় ${prayerTimeResponse.data.timings.sunrise} AM"),
                                Text(zhurCmp < 12
                                    ? "যোহর ${prayerTimeResponse.data.timings.dhuhr} AM"
                                    : "যোহর 0${zhurCmp}:${zhur[1]} PM"),
                                Text("আছর 0${asarCmp}:${asar[1]} PM"),
                                Text("সূর্যাস্ত 0${sunsetCmp}:${sunset[1]} PM"),
                                Text("মাগরিব 0${magribCmp}:${magrib[1]} PM"),
                                Text("ইশা 0${ishaCmp}:${isha[1]} PM"),
                              ],
                            )
                          ],
                        ),
                      )
                    : Container(
                        color: Colors.black,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                          child: Shimmer.fromColors(
                            baseColor: MyTheme.shimmer_base,
                            highlightColor: MyTheme.shimmer_highlighted,
                            child: Container(
                              height: 140,
                              width: double.infinity,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
              ),
              SizedBox(
                height: 20,
              ),
              ListenRow(
                title: "Trending Song",
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 140,
                child: ListView.builder(
                    itemCount: 4,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return MusicCard(
                        songName: "Song Name",
                        artistName: "Artist Name",
                        imageUrl:
                            "https://i.cdn.newsbytesapp.com/images/l37220210424184951.png",
                      );
                    }),
              ),
              SizedBox(
                height: 20,
              ),
              ListenRow(
                title: "Recently Played",
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 140,
                child: ListView.builder(
                    itemCount: 4,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return MusicCard(
                        songName: "Song Name",
                        artistName: "Artist Name",
                        imageUrl:
                            "https://i.cdn.newsbytesapp.com/images/l37220210424184951.png",
                      );
                    }),
              ),
              SizedBox(
                height: 20,
              ),
              ListenRow(
                title: "Album",
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 140,
                child: ListView.builder(
                    itemCount: 4,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return MusicCard(
                        songName: "Song Name",
                        artistName: "Artist Name",
                        imageUrl:
                            "https://i.cdn.newsbytesapp.com/images/l37220210424184951.png",
                      );
                    }),
              ),
              SizedBox(
                height: 20,
              ),
              ListenRow(
                title: "Artist",
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 110,
                child: ListView.builder(
                    itemCount: 4,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Column(
                          children: [
                            Container(
                              height: 90,
                              width: 90,
                              decoration: BoxDecoration(
                                  // color: Colors.redAccent,
                                  borderRadius: BorderRadius.circular(45)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(45),
                                child: Image.network(
                                  "https://i.cdn.newsbytesapp.com/images/l37220210424184951.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              "artistName",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      )),
    );
  }

  AppBar buildAppBar(double statusBarHeight, BuildContext context) {
    return AppBar(
      backgroundColor: MyTheme.blue_color,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            // Color(0xff0fc744),
            // Color(0xff3fcad2)
            Color.fromRGBO(206, 35, 43, 1),
            Color.fromRGBO(237, 101, 85, 1),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
      ),
      //backgroundColor:   Colors.green[900],
      leading: GestureDetector(
        onTap: () {
          _scaffoldKey.currentState.openDrawer();
        },
        child: widget.show_back_button
            ? Builder(
                builder: (context) => IconButton(
                    icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
                    onPressed: () {
                      if (!widget.go_back) {
                        return;
                      }
                      return Navigator.of(context).pop();
                    }),
              )
            : Builder(
                builder: (context) => Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 18.0, horizontal: 0.0),
                  child: Container(
                    child: Image.asset(
                      'assets/hamburger.png',
                      height: 16,
                      color: MyTheme.white,
                      //color: MyTheme.dark_grey,
                    ),
                  ),
                ),
              ),
      ),
      title: Container(
        height: kToolbarHeight +
            statusBarHeight -
            (MediaQuery.of(context).viewPadding.top > 40 ? 16.0 : 16.0),
        //MediaQuery.of(context).viewPadding.top is the statusbar height, with a notch phone it results almost 50, without a notch it shows 24.0.For safety we have checked if its greater than thirty
        child: Container(
          child: Padding(
              padding: app_language_rtl.$
                  ? const EdgeInsets.only(top: 14.0, bottom: 14, left: 12)
                  : const EdgeInsets.only(top: 14.0, bottom: 14, right: 12),
              // when notification bell will be shown , the right padding will cease to exist.
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return;
                      //  Filter();
                    }));
                  },
                  child: buildHomeSearchBox(context))),
        ),
      ),
      elevation: 0.0,
      titleSpacing: 0,
      actions: <Widget>[
        InkWell(
          onTap: () {
            // ToastComponent.showDialog(
            //     AppLocalizations.of(context).common_coming_soon, context,
            //     gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
          },
          child: Visibility(
            visible: false,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 18.0, horizontal: 12.0),
              child: Image.asset(
                'assets/bell.png',
                height: 16,
                color: MyTheme.dark_grey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  buildHomeSearchBox(BuildContext context) {
    return Center(
      child: Container(
        // padding: EdgeInsets.only(top: 3),
        // margin: EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 15),
        child: TextFormField(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return;
              // Filter();
            }));
          },
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.all(5),
              prefixIcon: Icon(Icons.search),
              hintText: 'Search ',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        ),
      ),
    );
  }
}
