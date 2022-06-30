import 'dart:async';

import 'package:active_ecommerce_flutter/audio_provider/view_model_provider.dart';
import 'package:active_ecommerce_flutter/custom/listen_row.dart';
import 'package:active_ecommerce_flutter/custom/music_card.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/data_model/album_response.dart';
import 'package:active_ecommerce_flutter/data_model/artist_response.dart';
import 'package:active_ecommerce_flutter/data_model/generic_response.dart';
import 'package:active_ecommerce_flutter/data_model/mp3_response.dart';
import 'package:active_ecommerce_flutter/data_model/prayer_time_response.dart';
import 'package:active_ecommerce_flutter/data_model/salah_time_response.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/quran_app/database/dbhelper.dart';
import 'package:active_ecommerce_flutter/repositories/audio_repository.dart';
import 'package:active_ecommerce_flutter/repositories/prayertime_repository.dart';
import 'package:active_ecommerce_flutter/screens/all_album.dart';
import 'package:active_ecommerce_flutter/screens/all_artist.dart';
import 'package:active_ecommerce_flutter/screens/all_generic.dart';
import 'package:active_ecommerce_flutter/screens/all_mp3.dart';
import 'package:active_ecommerce_flutter/screens/music_list.dart';
import 'package:active_ecommerce_flutter/ui_sections/custom_text.dart';
import 'package:active_ecommerce_flutter/ui_sections/drawer.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

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
  var zhurCmpHour;
  var zhurCmpMinute;
  var asarCmpHour;
  var asarCmpMinute;
  var asar;
  var asarCmp;
  var sunsetCmp;
  var sunset;
  var magribCmp;
  var magrib;
  var isha;
  var ishaCmp;
  var percent = 0;
  String currentTime;
  var currentTimeSplit;
  var currentHour;
  var currentMinute;
  var selectedYakt = "";
  var selectedYaktTimeDifference;
  var selectedHour;
  var countDownHour;
  var countDownMinute;
  var differenInMinute = 1;
  var magribCmpHour;
  var ishaCmpHour;
  var totalAnimationTime;
  var fajar;
  var fajarCmp;
  var fajarCmpHour;
  var sunrise;
  var sunriseCmp;
  var sunriseCmpHour;
  var magribCmpMinute;
  var ishaCmpMinute;
  var fajarCmpMinute;
  var sunriseCmpMinute;
  var currentDate;
  String address = 'Dhaka,bngladesh';
  var latitude = 23.8103;
  var longitude = 90.4125;
  bool enableLocation = false;
  var progressTimeDifference;
  FlutterLocalNotificationsPlugin fltrNotification;
  var notificationTime;
  var notificationTitle;
  var notificationBody;
  String locality = "ঢাকা";
  SalahTimeModel _salahTimeModel;
  var salahItem;
  bool isSalahTime = true;
  DateTime fajarTime,
      sunriseTime,
      zhurTime,
      asarTime,
      magribTime,
      ishaTime,
      currentDateTime;

  ArtistResponse artistResponse;
  var artistList = [];
  AlbumResponse albumResponse;
  var albumList = [];
  GenericResponse genericResponse;
  var genericList = [];
  Mp3Response mp3response;
  List<Audio> audioList = [];
  List<Audio> audioListRecent = [];
  var mp3List = [];
  ViewModelProvider viewModelProvider;
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId("0");
  var recentMp3List = [];

  @override
  void initState() {
    super.initState();
    //fetchPrayerTime();
    viewModelProvider = Provider.of<ViewModelProvider>(context, listen: false);
    fetchSalahTime();
    getFeaturedMp3();
    getRecentMp3();
    getGeneric();
    getAlbum();
    getArtist();
    showTime();

    initializeNotification();
    // notificationTimeSelect();
    tz.initializeTimeZones();
    _showNotification();
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

  getRecentMp3() async {
    recentMp3List = await DBHelper().getRecentListSong();

    for (int i = 0; i < recentMp3List.length; i++) {
      //urlList.add("https://ayat-app.com/public/" + mp3List[i].file);
      audioListRecent.add(
        Audio.network(
          "https://ayat-app.com/public/" + recentMp3List[i].file,
          metas: Metas(
              title: recentMp3List[i].name,
              id: "https://ayat-app.com/public/" + recentMp3List[i].coverArt,
              album: recentMp3List[i].description,
              artist: recentMp3List[i].listens.toString()),
        ),
      );
    }
    setState(() {});
    print('recent lenth: ${recentMp3List.length}');
  }

  getFeaturedMp3() async {
    mp3response = await AudioRepository().getFeaturesMp3List();
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

    setState(() {});
  }

  getArtist() async {
    artistResponse = await AudioRepository().getArtistList();
    artistList.addAll(artistResponse.data);
    setState(() {});
  }

  getAlbum() async {
    albumResponse = await AudioRepository().getAlbumList();
    albumList.addAll(albumResponse.data);
    setState(() {});
  }

  getGeneric() async {
    genericResponse = await AudioRepository().getGenericList();
    genericList.addAll(genericResponse.data);
    setState(() {});
  }

  notificationTimeSelect() {
    // var now = DateTime.now();
    // currentDate = DateFormat('dd-MM-yyyy').format(now);
    // currentTime = DateFormat('HH:mm').format(now);
    // DateTime current = DateTime.now();
    DateTime current = tz.TZDateTime.now(tz.local);
    Stream timer = Stream.periodic(Duration(minutes: 1), (i) {
      current = current.add(Duration(minutes: 1));
      return current;
    });

    timer.listen((data) {
      var time = DateFormat('HH:mm').format(data);
      print(time);
      if (time.compareTo('11:44') == 0) {
        notificationTime = DateTime.now();
        notificationTitle = "Fajar";
        notificationBody = "yakt suru";
        setState(() {});
        _showNotification();
      }
      // if (time == prayerTimeResponse.data.timings.fajr) {
      // notificationTime = time;
      // notificationTitle = "Fajar";
      // notificationBody = "yakt suru";
      // setState(() {});
      // _showNotification();
      // } else if (time == prayerTimeResponse.data.timings.sunrise) {
      //   notificationTime = time;
      //   notificationTitle = "sunrise";
      //   notificationBody = "yakt suru";
      //   setState(() {});
      //   _showNotification();
      // } else if (time == prayerTimeResponse.data.timings.dhuhr) {
      //   notificationTime = time;
      //   notificationTitle = "Zhur";
      //   notificationBody = "yakt suru";
      //   setState(() {});
      //   _showNotification();
      // } else if (time == prayerTimeResponse.data.timings.asr) {
      //   notificationTime = time;
      //   notificationTitle = "asar";
      //   notificationBody = "yakt suru";
      //   setState(() {});
      //   _showNotification();
      // } else if (time == prayerTimeResponse.data.timings.maghrib) {
      //   notificationTime = time;
      //   notificationTitle = "magrib";
      //   notificationBody = "yakt suru";
      //   setState(() {});
      //   _showNotification();
      // } else if (time == prayerTimeResponse.data.timings.isha) {
      //   notificationTime = time;
      //   notificationTitle = "isha";
      //   notificationBody = "yakt suru";
      //   setState(() {});
      //   _showNotification();
      // }
    });
  }

  initializeNotification() async {
    fltrNotification = FlutterLocalNotificationsPlugin();
    var androidInitilize = new AndroidInitializationSettings('app_logo');
    var iOSinitilize = new IOSInitializationSettings();
    var initilizationsSettings = new InitializationSettings(
        android: androidInitilize, iOS: iOSinitilize);

    await fltrNotification.initialize(initilizationsSettings,
        onSelectNotification: notificationSelected);
  }

  Future _showNotification() async {
    var androidDetails = new AndroidNotificationDetails(
        "Channel ID", "ayat app",
        channelDescription: "This is my channel", importance: Importance.max);
    var iSODetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(android: androidDetails, iOS: iSODetails);

    // await fltrNotification.show(
    //     0, "Task", "You created a Task", generalNotificationDetails,
    //     payload: "Task");
    // var scheduledTime = DateTime.now().add(Duration(seconds: 5));
    // fltrNotification.schedule(1, notificationBody, notificationTitle,
    //     notificationTime, generalNotificationDetails,
    //     androidAllowWhileIdle: true);
    // var nowtime;
    // var time = DateFormat('HH:mm').format(tz.TZDateTime.now(tz.local));
    // if (time.compareTo('12:26') == 0) {
    //   nowtime = tz.TZDateTime.now(tz.local);
    // }
    fltrNotification.zonedSchedule(
        0,
        'scheduled title',
        'scheduled body',
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 120)),
        // nowtime,
        const NotificationDetails(
            android: AndroidNotificationDetails('1', 'ayat',
                channelDescription: 'your channel description')),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future notificationSelected(String payload) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("Notification : $payload"),
      ),
    );
  }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    // address =
    //     '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    locality = place.locality;
    address = '${place.locality},${place.country}';
    setState(() {});
    print(
        "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}, ${place.name}");
  }

  fetchSalahTime() async {
    _salahTimeModel =
        await PrayerTimeRepository().getSalahTime(locality: locality);

    isSalahTime = false;

    setState(() {});
    salahItem = _salahTimeModel.items;
    setState(() {});
    timeConvert();
  }

  fetchPrayerTime() async {
    prayerTimeResponse = await PrayerTimeRepository()
        .getPrayer(latitude: latitude, longitude: longitude);

    //timeConvert();

    isTimes = false;
    setState(() {});
  }

  showTime() {
    // currentDateTime = DateTime.now();
    var now = DateTime.now();
    var format12 = DateFormat('yyyy-MM-dd kk:mm:ss').format(now);
    currentDateTime = DateTime.parse(format12);
    print('format12: $currentDateTime');
    currentDate = DateFormat('yyyy-MM-dd').format(now);
    currentTime = DateFormat('h:mm').format(now);
    currentTimeSplit = currentTime.split(
      ':',
    );

    currentHour = int.parse(currentTimeSplit[0]);
    currentMinute = int.parse(currentTimeSplit[1]);
    // if (currentHour > zhurCmpHour && currentHour < asarCmpHour) {}
    print('current date time: $currentDateTime');
    print('current date: $currentDate');
    print('current time$currentTime'); //HH:mm:ss
    print(currentHour);
    print(currentMinute);
  }

  timeConvert() {
    fajar = salahItem[0].fajr.split(':');
    var f = salahItem[0].fajr.split(' ');
    var f0 = f[0];
    print(f0);
    fajarTime = DateTime.parse("$currentDate 0$f0:00");
    print('fajar converted: ${fajarTime}');
    sunrise = salahItem[0].shurooq.split(':');
    var s = salahItem[0].shurooq.split(' ');
    var s0 = s[0];
    sunriseTime = DateTime.parse("$currentDate 0$s0:00");
    zhur = salahItem[0].dhuhr.split(':');
    var z = salahItem[0].dhuhr.split(' ');
    var z0 = z[0];

    zhurTime = DateTime.parse("$currentDate $z0:00");
    asar = salahItem[0].asr.split(':');
    var a = salahItem[0].asr.split(' ');
    //var a0 = a[0].split(' ');
    //var a1 = a0.toString();
    //asarTime = DateTime.parse("$currentDate 0$a1:00");
    var ass = a[0].split(':');
    var as24 = int.parse(ass[0]) + 12;
    String as24s = as24.toString();

    asarTime = DateTime.parse("$currentDate $as24s:${ass[1]}:00");
    print('asarTime ${asarTime}');
    // sunset = prayerTimeResponse.data.timings.sunset.split(':');
    magrib = salahItem[0].maghrib.split(':');
    var m = salahItem[0].maghrib.split(' ');
    var m0 = m[0].split(':');
    var magribint = int.parse(m0[0]) + 12;
    String magribStr = magribint.toString();
    magribTime = DateTime.parse("$currentDate $magribStr:${m0[1]}:00");
    print('magribTime: $magribTime');
    isha = salahItem[0].isha.split(':');
    var i = salahItem[0].isha.split(' ');
    var i0 = i[0].split(':');
    var ishaInt = int.parse(i0[0]) + 12;
    var ishaStr = ishaInt.toString();
    ishaTime = DateTime.parse("$currentDate $ishaStr:${i0[1]}:00");
    print('ishaTime: $ishaTime');
    fajarCmpHour = int.parse(fajar[0]);
    var fjr = fajar[1].split(' ');

    fajarCmp = int.parse(fajar[0]);
    fajarCmpMinute = int.parse(fjr[0]);
    print('fjr min $fajarCmpMinute');
    sunriseCmpHour = int.parse(sunrise[0]);
    sunriseCmp = int.parse(sunrise[0]);
    var snr = sunrise[1].split(' ');
    sunriseCmpMinute = int.parse(snr[0]);

    var zh;
    zh = zhur[0];
    zhurCmpHour = int.parse(zh);
    zhurCmp = int.parse(zh);
    var zhr = zhur[1].split(' ');
    zhurCmpMinute = int.parse(zhr[0]);
    // if (zhurCmp >= 12) {
    //   zhurCmp = zhurCmp - 12;
    // }
    var as;
    as = asar[0];
    asarCmpHour = int.parse(as);
    print(asarCmpHour);
    var asr = asar[1].split(' ');
    print('asar min: $asr');
    asarCmpMinute = int.parse(asr[0]);

    asarCmp = int.parse(as);
    // if (asarCmp >= 12) {
    //   asarCmp = asarCmp - 12;
    // }
    // var sn;
    // sn = sunset[0];
    // sunsetCmp = int.parse(sn);
    // if (sunsetCmp >= 12) {
    //   sunsetCmp = sunsetCmp - 12;
    // }
    var mg;
    mg = magrib[0];
    magribCmpHour = int.parse(mg);
    magribCmp = int.parse(mg);
    var mgr = magrib[1].split(' ');
    magribCmpMinute = int.parse(mgr[0]);
    // print(magribCmpHour);
    // if (magribCmp >= 12) {
    //   magribCmp = magribCmp - 12;
    // }
    var ish;
    ish = isha[0];
    ishaCmpHour = int.parse(ish);
    ishaCmp = int.parse(ish);
    var isr = isha[1].split(' ');
    ishaCmpMinute = int.parse(isr[0]);
    // if (ishaCmp >= 12) {
    //   ishaCmp = ishaCmp - 12;
    // }
    yaktSelector();
    // progressTimePicker();
  }

  progressTimePicker() {
    var diff = magribCmpHour - asarCmpHour;
    progressTimeDifference = ((diff * 60) + magribCmpMinute) - asarCmpMinute;
    setState(() {});
    print('progresstime: $progressTimeDifference');
  }

  yaktSelector() {
    if ((currentDateTime.isAtSameMomentAs(sunriseTime) ||
            currentDateTime.isAfter(sunriseTime)) &&
        currentDateTime.isBefore(zhurTime)) {
      print("zhur baki");
      selectedYakt = "বাকি";
      differenInMinute = zhurTime.difference(currentDateTime).inMinutes;
      setState(() {});
    } else if ((currentDateTime.isAtSameMomentAs(zhurTime) ||
            currentDateTime.isAfter(zhurTime)) &&
        currentDateTime.isBefore(asarTime)) {
      selectedYakt = "যোহর";
      print("zhur cholse");
      print("asarTime: $asarTime");
      differenInMinute = asarTime.difference(currentDateTime).inMinutes;
      print('zhur diff n: $differenInMinute');
      setState(() {});
    } else if ((currentDateTime.isAtSameMomentAs(asarTime) ||
            currentDateTime.isAfter(asarTime)) &&
        currentDateTime.isBefore(magribTime)) {
      selectedYakt = "আছর";
      differenInMinute = magribTime.difference(currentDateTime).inMinutes;
      setState(() {});
    } else if ((currentDateTime.isAtSameMomentAs(magribTime) ||
            currentDateTime.isAfter(magribTime)) &&
        currentDateTime.isBefore(ishaTime)) {
      selectedYakt = "মাগরিব";
      differenInMinute = ishaTime.difference(currentDateTime).inMinutes;
      setState(() {});
    } else if ((currentDateTime.isAtSameMomentAs(ishaTime) ||
            currentDateTime.isAfter(ishaTime)) &&
        currentDateTime.isBefore(fajarTime)) {
      selectedYakt = "ইশা";
      differenInMinute = fajarTime.difference(currentDateTime).inMinutes;
      setState(() {});
    } else if ((currentDateTime.isAtSameMomentAs(fajarTime) ||
            currentDateTime.isAfter(fajarTime)) &&
        currentDateTime.isBefore(sunriseTime)) {
      selectedYakt = "ফজর";
      differenInMinute = sunriseTime.difference(currentDateTime).inMinutes;
      setState(() {});
    }
    // if (currentDateTime.compareTo(zhurTime) >= 0 &&
    //     currentDateTime.compareTo(asarTime) < 0) {
    //   selectedYakt = "যোহর";
    //   print("zhur");
    //   setState(() {
    //     var difHour = asarCmpHour - currentHour;
    //     differenInMinute = ((difHour * 60) + asarCmpMinute) - currentMinute;
    //     // totalAnimationTime = differenInMinute * 60000;
    //     setState(() {});
    //   });
    // }
    // if (currentHour >= zhurCmpHour && currentHour <= asarCmpHour) {
    //   selectedYakt = "যোহর";
    //   // setState(() {});
    //   var difHour = asarCmpHour - currentHour;
    //   differenInMinute = ((difHour * 60) + asarCmpMinute) - currentMinute;
    //   // totalAnimationTime = differenInMinute * 60000;
    //   setState(() {});
    //   print("zhur diff:$differenInMinute");
    //   // countDownHour = (differenInMinute / 60).floor();
    //   // countDownMinute = (differenInMinute % 60);
    //   // print(differenInMinute);
    //   // print(countDownHour);
    //   // print(countDownMinute);
    //   //যোহর আছর মাগরিব ইশা সাহরি	ইফতার সূর্যোদয় সূর্যাস্ত চলছে
    // }
    // else if (currentHour >= asarCmpHour && currentHour <= magribCmpHour) {
    //   selectedYakt = "আছর";

    //   var difHour = magribCmpHour - currentHour;
    //   differenInMinute = ((difHour * 60) + magribCmpMinute) - currentMinute;
    //   setState(() {});
    //   print("asar diff:$differenInMinute");
    //   // totalAnimationTime = differenInMinute * 60000;
    // } else if (currentHour >= magribCmpHour && currentHour <= ishaCmpHour) {
    //   selectedYakt = "মাগরিব";

    //   var difHour = ishaCmpHour - currentHour;
    //   differenInMinute = ((difHour * 60) + ishaCmpMinute) - currentMinute;
    //   // totalAnimationTime = differenInMinute * 60000;
    //   setState(() {});
    // } else if (currentHour >= ishaCmpHour && currentHour <= fajarCmpHour) {
    //   selectedYakt = "ইশা";

    //   var difHour = fajarCmpHour - currentHour;
    //   differenInMinute = ((difHour * 60) + fajarCmpMinute) - currentMinute;
    //   setState(() {});
    // } else if (currentHour >= fajarCmpHour && currentHour <= sunriseCmpHour) {
    //   selectedYakt = "ফজর";

    //   var difHour = sunriseCmpHour - currentHour;
    //   differenInMinute = ((difHour * 60) + sunriseCmpMinute) - currentMinute;
    //   setState(() {});
    // } else if (currentHour >= sunriseCmpHour && currentHour <= zhurCmpHour) {
    //   selectedYakt = "বাকি";

    //   var difHour = zhurCmpHour - currentHour;
    //   if (difHour > 0) {
    //     differenInMinute = ((difHour * 60) + zhurCmpMinute) - currentMinute;
    //     print('baki: $differenInMinute');
    //   } else {
    //     differenInMinute = zhurCmpMinute - currentMinute;
    //     print('baki: $differenInMinute');
    //   }
    //   setState(() {});
    //   print("zhur min $zhurCmpMinute");
    // }
  }

  double progress = 0;
  currentProgressColor() {
    if (progress >= 0.6 && progress < 0.8) {
      return Colors.orange;
    }
    if (progress >= 0.8) {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final size = MediaQuery.of(context).size;
    print(size.height);
    print(size.width);

    return Scaffold(
      key: _scaffoldKey,
      // backgroundColor: Color(0xffeafbf0),
      // backgroundColor: Color(0xff66E1E3),

      // appBar: buildAppBar(statusBarHeight, context),

      drawer: MainDrawer(),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/payertime_back-min.png"),
            fit: BoxFit.cover,
          ),
          // borderRadius: BorderRadius.circular(10)
        ),
        child: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(children: [
                viewModelProvider.isNavProvider == false
                    ? Positioned(
                        top: 50,
                        child: Container(
                          height: 50,
                          width: 200,
                          color: Colors.amber,
                          child: Text('false hoya ase',
                              style: TextStyle(color: Colors.black)),
                        ),
                      )
                    : Consumer<ViewModelProvider>(
                        builder: (_, viewModelProvider, __) => audioPlayer
                            .builderIsPlaying(builder: (context, isPlaying) {
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            viewModelProvider
                                                .selectedAudioProvider
                                                .metas
                                                .title,
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
                                          if (viewModelProvider
                                                  .globalIndexProvider >
                                              0) {
                                            viewModelProvider
                                                .globalIndexProvider--;
                                            viewModelProvider
                                                .setIsGlobalIndexProvider(
                                                    viewModelProvider
                                                        .globalIndexProvider);
                                            // setState(() {});
                                            viewModelProvider
                                                    .selectedAudioProvider =
                                                viewModelProvider
                                                        .audioListProvider[
                                                    viewModelProvider
                                                        .globalIndexProvider];
                                            viewModelProvider
                                                .setSelectedAudioProvider(
                                                    viewModelProvider
                                                        .selectedAudioProvider);
                                            audioPlayer.playlistPlayAtIndex(
                                                viewModelProvider
                                                    .globalIndexProvider);
                                            setState(() {});
                                          } else if (viewModelProvider
                                                  .globalIndexProvider ==
                                              0) {
                                            viewModelProvider
                                                    .globalIndexProvider =
                                                viewModelProvider
                                                        .audioListProvider
                                                        .length -
                                                    1;
                                            viewModelProvider
                                                .setIsGlobalIndexProvider(
                                                    viewModelProvider
                                                        .globalIndexProvider);
                                            // setState(() {});
                                            viewModelProvider
                                                    .selectedAudioProvider =
                                                viewModelProvider
                                                        .audioListProvider[
                                                    viewModelProvider
                                                        .globalIndexProvider];
                                            viewModelProvider
                                                .setSelectedAudioProvider(
                                                    viewModelProvider
                                                        .selectedAudioProvider);
                                            // player.previous(keepLoopMode: false);
                                            audioPlayer.playlistPlayAtIndex(
                                                viewModelProvider
                                                    .globalIndexProvider);
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
                                          isPlaying
                                              ? pauseMusic()
                                              : playMusic();
                                        },
                                        child: Icon(
                                          isPlaying
                                              ? Icons.pause
                                              : Icons.play_arrow,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (viewModelProvider
                                                  .globalIndexProvider ==
                                              (viewModelProvider
                                                      .audioListProvider
                                                      .length -
                                                  1)) {
                                            viewModelProvider
                                                .globalIndexProvider = 0;
                                            viewModelProvider
                                                .setIsGlobalIndexProvider(
                                                    viewModelProvider
                                                        .globalIndexProvider);
                                            // setState(() {});
                                            viewModelProvider
                                                    .selectedAudioProvider =
                                                viewModelProvider
                                                        .audioListProvider[
                                                    viewModelProvider
                                                        .globalIndexProvider];
                                            viewModelProvider
                                                .setSelectedAudioProvider(
                                                    viewModelProvider
                                                        .selectedAudioProvider);
                                            setState(() {});
                                          } else if (viewModelProvider
                                                  .globalIndexProvider <
                                              viewModelProvider
                                                      .audioListProvider
                                                      .length -
                                                  1) {
                                            viewModelProvider
                                                .globalIndexProvider++;
                                            viewModelProvider
                                                .setIsGlobalIndexProvider(
                                                    viewModelProvider
                                                        .globalIndexProvider);
                                            // setState(() {});
                                            viewModelProvider
                                                    .selectedAudioProvider =
                                                viewModelProvider
                                                        .audioListProvider[
                                                    viewModelProvider
                                                        .globalIndexProvider];
                                            viewModelProvider
                                                .setSelectedAudioProvider(
                                                    viewModelProvider
                                                        .selectedAudioProvider);
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
                        }),
                      ),
                Column(
                  children: [
                    isSalahTime == false
                        ? Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image:
                                    AssetImage("assets/payertime_back-min.png"),
                                fit: BoxFit.cover,
                              ),
                              // borderRadius: BorderRadius.circular(10)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 20, bottom: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(height: 10),
                                      CircularPercentIndicator(
                                        radius: 55.0,
                                        animation: true,

                                        animationDuration:
                                            differenInMinute * 60000,
                                        lineWidth: 7.0,
                                        percent: 100 / 100,

                                        // center: new Text(
                                        //   "40 hours",
                                        //   style: new TextStyle(
                                        //       fontWeight: FontWeight.bold,
                                        //       fontSize: 20.0),
                                        // ),
                                        center: Column(
                                          children: [
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              selectedYakt,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14),
                                            ),
                                            TweenAnimationBuilder<Duration>(
                                                duration: Duration(
                                                    minutes: differenInMinute),
                                                tween: Tween(
                                                    begin: Duration(
                                                        minutes:
                                                            differenInMinute),
                                                    end: Duration.zero),
                                                onEnd: () {
                                                  isSalahTime = true;
                                                  setState(() {});
                                                  fetchSalahTime();
                                                  showTime();
                                                  timeConvert();
                                                  setState(() {});
                                                },
                                                builder: (BuildContext context,
                                                    Duration value,
                                                    Widget child) {
                                                  final hours = value.inHours;
                                                  final minutes =
                                                      value.inMinutes % 60;
                                                  final seconds =
                                                      value.inSeconds % 60;
                                                  return Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 5),
                                                      child: Text(
                                                        '$hours:$minutes:$seconds',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            // color: Color(0xff5DAE7B),
                                                            // fontFamily: balooDa2,
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.9),
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ));
                                                }),
                                            GestureDetector(
                                              onTap: () {
                                                _showNotification();
                                              },
                                              child: Icon(
                                                Icons.notifications_outlined,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        circularStrokeCap:
                                            CircularStrokeCap.round,
                                        backgroundColor: Colors.amberAccent,
                                        progressColor: Colors.white,
                                      ),
                                      // SizedBox(
                                      //   height: 5,
                                      // ),
                                    ],
                                  ),
                                  // SizedBox(
                                  //   width: 6,
                                  // ),
                                  Column(
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      //যোহর আছর মাগরিব ইশা সাহরি	ইফতার সূর্যোদয় সূর্যাস্ত

                                      Row(
                                        children: [
                                          Container(
                                            height: size.height / 20.2,
                                            width: size.width / 3.38,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                    width: 2,
                                                    color: Colors.white
                                                        .withOpacity(0.65))),
                                            child: Center(
                                              child: Text(
                                                // "ফজর: ${prayerTimeResponse.data.timings.fajr} AM",
                                                "ফজর: ${_salahTimeModel.items[0].fajr}",
                                                style: TextStyle(
                                                    color: Colors.white
                                                        .withOpacity(0.9),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w800),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                              height: size.height / 20.2,
                                              width: size.width / 3.38,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  border: Border.all(
                                                      width: 2,
                                                      color: Colors.white
                                                          .withOpacity(0.65))),
                                              child: Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Text(
                                                    "সূর্যোদয়: ${_salahTimeModel.items[0].shurooq}",
                                                    style: TextStyle(
                                                        color: Colors.white
                                                            .withOpacity(0.9),
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w800),
                                                  ),
                                                ),
                                              ))
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            height: size.height / 20.2,
                                            width: size.width / 3.38,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                    width: 2,
                                                    color: Colors.white
                                                        .withOpacity(0.65))),
                                            child: Center(
                                              child: Text(
                                                "যোহর: ${_salahTimeModel.items[0].dhuhr}",
                                                style: TextStyle(
                                                    color: Colors.white
                                                        .withOpacity(0.9),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w800),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                              height: size.height / 20.2,
                                              width: size.width / 3.38,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  border: Border.all(
                                                      width: 2,
                                                      color: Colors.white
                                                          .withOpacity(0.65))),
                                              child: Center(
                                                child: Text(
                                                  "আছর: ${_salahTimeModel.items[0].asr}",
                                                  style: TextStyle(
                                                      color: Colors.white
                                                          .withOpacity(0.9),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w800),
                                                ),
                                              ))
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          // Container(
                                          //   height: 30,
                                          //   width: 96,
                                          //   decoration: BoxDecoration(
                                          //       borderRadius:
                                          //           BorderRadius.circular(20),
                                          //       border: Border.all(
                                          //           width: 2,
                                          //           color: Colors.white
                                          //               .withOpacity(0.65))),
                                          //   child: Center(
                                          //     child: Text(
                                          //       "সূর্যাস্ত: 0${sunsetCmp}:${sunset[1]} PM",
                                          //       style: TextStyle(
                                          //           color: Colors.white
                                          //               .withOpacity(0.9),
                                          //           fontSize: 12,
                                          //           fontWeight:
                                          //               FontWeight.w800),
                                          //     ),
                                          //   ),
                                          // ),

                                          Container(
                                              height: size.height / 20.2,
                                              width: size.width / 3.38,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  border: Border.all(
                                                      width: 2,
                                                      color: Colors.white
                                                          .withOpacity(0.65))),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Center(
                                                  child: Text(
                                                    "মাগরিব: ${_salahTimeModel.items[0].maghrib}",
                                                    style: TextStyle(
                                                        color: Colors.white
                                                            .withOpacity(0.9),
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w800),
                                                  ),
                                                ),
                                              )),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                              height: size.height / 20.2,
                                              width: size.width / 3.38,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  border: Border.all(
                                                      width: 2,
                                                      color: Colors.white
                                                          .withOpacity(0.65))),
                                              child: Center(
                                                child: Text(
                                                  "ইশা: 0${_salahTimeModel.items[0].isha}",
                                                  style: TextStyle(
                                                      color: Colors.white
                                                          .withOpacity(0.9),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w800),
                                                ),
                                              )),
                                        ],
                                      ),

                                      SizedBox(
                                        height: 5,
                                      ),
                                      enableLocation == false
                                          ? GestureDetector(
                                              onTap: () async {
                                                Position position =
                                                    await _getGeoLocationPosition();
                                                GetAddressFromLatLong(position);
                                                latitude = position.latitude;
                                                longitude = position.longitude;
                                                enableLocation = true;
                                                fetchPrayerTime();

                                                setState(() {});
                                                print(latitude);
                                                print(longitude);
                                              },
                                              child: Container(
                                                  height: 30,
                                                  // width: 96,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white
                                                          .withOpacity(0.95),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      border: Border.all(
                                                          width: 2,
                                                          color: Colors.white
                                                              .withOpacity(
                                                                  0.65))),
                                                  child: Center(
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Icon(
                                                          Icons
                                                              .location_on_rounded,
                                                          size: 15,
                                                          color: Colors.red,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      4),
                                                          child: Text(
                                                            "Enable Your Location  ",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .lightBlueAccent,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                            )
                                          : Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.calendar_today,
                                                      size: 15,
                                                      color: Colors.white,
                                                    ),
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    Text(currentDate,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.9))),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.location_on_rounded,
                                                      size: 15,
                                                      color: Colors.red,
                                                    ),
                                                    SizedBox(
                                                      width: 4,
                                                    ),
                                                    Text(address,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.9))),
                                                  ],
                                                )
                                              ],
                                            ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                        : Container(
                            //color: Colors.black,
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
                    Container(
                      // height: 40,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                  itemCount: audioList.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return MusicCard(
                                      songName: audioList[index].metas.title,
                                      artistName: "",
                                      imageUrl: audioList[index].metas.id,
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
                                  itemCount: audioListRecent.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return MusicCard(
                                      songName:
                                          audioListRecent[index].metas.title,
                                      artistName: "",
                                      imageUrl: audioListRecent[index].metas.id,
                                    );
                                  }),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ListenRow(
                              title: "Generic",
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Allgeneric()));
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 160,
                              child: genericList.isEmpty
                                  ? Text('')
                                  : ListView.builder(
                                      itemCount: genericList.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MusicList(
                                                          id: genericList[index]
                                                              .id,
                                                          checker: 2,
                                                        )));
                                          },
                                          child: MusicCard(
                                            songName: genericList[index].name,
                                            artistName: "",
                                            imageUrl:
                                                "https://ayat-app.com/public/" +
                                                    genericList[index].coverArt,
                                          ),
                                        );
                                      }),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ListenRow(
                              title: "Album",
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AllAlbum()));
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 160,
                              child: albumList.isEmpty
                                  ? Text('')
                                  : ListView.builder(
                                      itemCount: albumList.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MusicList(
                                                          id: albumList[index]
                                                              .id,
                                                          checker: 3,
                                                        )));
                                          },
                                          child: MusicCard(
                                            songName: albumList[index].name,
                                            artistName: "",
                                            imageUrl:
                                                "https://ayat-app.com/public/" +
                                                    albumList[index].coverArt,
                                          ),
                                        );
                                      }),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ListenRow(
                              title: "Artist",
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AllArtist()));
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 135,
                              child: artistList.isEmpty
                                  ? Text("Loading......")
                                  : ListView.builder(
                                      itemCount: artistList.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MusicList(
                                                          id: artistList[index]
                                                              .id,
                                                          checker: 1,
                                                        )));
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4),
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 89,
                                                  width: 90,
                                                  decoration: BoxDecoration(
                                                      // color: Colors.redAccent,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              45)),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            45),
                                                    child: Image.network(
                                                      // "https://i.cdn.newsbytesapp.com/images/l37220210424184951.png",
                                                      "https://ayat-app.com/public/" +
                                                          artistList[index]
                                                              .image,

                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                Container(
                                                  width: 100,
                                                  child: Text(
                                                    artistList[index].name,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ]),
            ],
          ),
        )),
      ),
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

  //   Widget buildPlayer() {
  //   var height = MediaQuery.of(context).size.height;
  //   var width = MediaQuery.of(context).size.width;

  //   return StatefulBuilder(
  //     builder: ((context, setState) {
  //       return audioPlayer.builderIsPlaying(builder: (context, isPlaying) {
  //         return Scaffold(
  //           backgroundColor: Colors.black,
  //           appBar: AppBar(
  //             centerTitle: true,
  //             backgroundColor: Colors.black,
  //             elevation: 0.0,
  //             leading: IconButton(
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                 },
  //                 icon: Icon(
  //                   Icons.expand_more,
  //                   color: Colors.white,
  //                   size: 26,
  //                 )),
  //             title: Column(
  //               children: [
  //                 CustomText(
  //                   text: viewModelProvider.selectedAudioProvider.metas.title,
  //                   fontSize: 12,
  //                   fontWeight: FontWeight.w400,
  //                   color: Colors.white,
  //                 ),
  //                 // CustomText(
  //                 //   text: selectedAudio.metas.artist,
  //                 //   fontSize: 12,
  //                 //   fontWeight: FontWeight.w800,
  //                 //   color: Colors.white,
  //                 // ),
  //               ],
  //             ),
  //             actions: [
  //               IconButton(
  //                 onPressed: () {},
  //                 icon: Icon(
  //                   Icons.more_vert,
  //                   size: 26,
  //                 ),
  //               )
  //             ],
  //           ),
  //           body: SafeArea(
  //               child: Padding(
  //             padding: EdgeInsets.symmetric(horizontal: 16),
  //             child: Column(
  //               children: [
  //                 SizedBox(
  //                   height: 40,
  //                 ),
  //                 Image.network(
  //                   viewModelProvider.selectedAudioProvider.metas.id,
  //                   height: height * 0.4,
  //                   width: double.infinity,
  //                 ),
  //                 SizedBox(
  //                   height: 30,
  //                 ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         CustomText(
  //                           text: viewModelProvider
  //                               .selectedAudioProvider.metas.title,
  //                           color: Colors.white,
  //                           fontSize: 16,
  //                           fontWeight: FontWeight.w600,
  //                         ),
  //                         // CustomText(
  //                         //   text: selectedAudio.metas.artist,
  //                         //   color: Colors.grey,
  //                         //   fontSize: 15,
  //                         //   fontWeight: FontWeight.w600,
  //                         // ),
  //                       ],
  //                     ),
  //                     IconButton(
  //                         onPressed: () {},
  //                         icon: Icon(
  //                           Icons.favorite_border_outlined,
  //                           size: 30,
  //                           color: Colors.white,
  //                         ))
  //                   ],
  //                 ),
  //                 SizedBox(
  //                   height: 16,
  //                 ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                   children: [
  //                     audioPlayer.builderRealtimePlayingInfos(
  //                         builder: ((context, infos) {
  //                       return Text(
  //                         infos.currentPosition.inSeconds < 60
  //                             ? '00:${infos.currentPosition.inSeconds}'
  //                             : '${(infos.currentPosition.inSeconds / 60).toInt()} : ${(infos.currentPosition.inSeconds % 60).toInt()}',
  //                         style: TextStyle(color: Colors.white),
  //                       );
  //                     })),
  //                     Container(
  //                       width: 250,
  //                       child: audioPlayer.builderRealtimePlayingInfos(
  //                         builder: (context, infos) {
  //                           return PositionSeekWidget(
  //                             currentPosition: infos.currentPosition,
  //                             duration: infos.duration,
  //                             seekTo: (to) {
  //                               audioPlayer.seek(to);
  //                             },
  //                           );
  //                         },
  //                       ),
  //                     ),
  //                     audioPlayer.builderRealtimePlayingInfos(
  //                         builder: ((context, infos) {
  //                       int minute = (infos.duration.inSeconds / 60).toInt();
  //                       int reminder = (infos.duration.inSeconds % 60);
  //                       return Text(
  //                         // infos.duration.inMinutes.toString(),
  //                         '${minute.toString()} : $reminder',
  //                         style: TextStyle(color: Colors.white),
  //                       );
  //                     })),
  //                   ],
  //                 ),
  //                 SizedBox(
  //                   height: 10,
  //                 ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                   children: [
  //                     IconButton(
  //                         onPressed: () {
  //                           // if (isShuffle == false) {
  //                           //   isShuffle = true;

  //                           //   int randomIndex =
  //                           //       rnd.nextInt((audioList.length - 1) - 0);
  //                           //   globalIndex = randomIndex;
  //                           //   setState(() {});
  //                           //   selectedAudio = audioList[globalIndex];
  //                           //   playMusic();
  //                           //   setState(() {});
  //                           // } else {
  //                           //   isNavShow = false;
  //                           //   setState(() {});
  //                           // }
  //                         },
  //                         icon: Icon(Icons.shuffle,
  //                             size: 28,
  //                             color: isShuffle == false
  //                                 ? Colors.white
  //                                 : Colors.blueGrey)),
  //                     IconButton(
  //                         onPressed: () {
  //                           if (viewModelProvider.globalIndexProvider > 0) {
  //                             viewModelProvider.globalIndexProvider--;
  //                             viewModelProvider.setIsGlobalIndexProvider(
  //                                 viewModelProvider.globalIndexProvider);
  //                             // setState(() {});
  //                             viewModelProvider.selectedAudioProvider =
  //                                 viewModelProvider.audioListProvider[
  //                                     viewModelProvider.globalIndexProvider];
  //                             viewModelProvider.setSelectedAudioProvider(
  //                                 viewModelProvider.selectedAudioProvider);
  //                             audioPlayer.playlistPlayAtIndex(
  //                                 viewModelProvider.globalIndexProvider);
  //                             setState(() {});
  //                           } else if (viewModelProvider.globalIndexProvider ==
  //                               0) {
  //                             viewModelProvider.globalIndexProvider =
  //                                 viewModelProvider.audioListProvider.length -
  //                                     1;
  //                             viewModelProvider.setIsGlobalIndexProvider(
  //                                 viewModelProvider.globalIndexProvider);
  //                             // setState(() {});
  //                             viewModelProvider.selectedAudioProvider =
  //                                 viewModelProvider.audioListProvider[
  //                                     viewModelProvider.globalIndexProvider];
  //                             viewModelProvider.setSelectedAudioProvider(
  //                                 viewModelProvider.selectedAudioProvider);
  //                             // player.previous(keepLoopMode: false);
  //                             audioPlayer.playlistPlayAtIndex(
  //                                 viewModelProvider.globalIndexProvider);
  //                             setState(() {});
  //                           }
  //                         },
  //                         icon: Icon(
  //                           Icons.skip_previous,
  //                           size: 34,
  //                           color: Colors.white,
  //                         )),
  //                     GestureDetector(
  //                       onTap: () {
  //                         // audioPlayerState == PlayerState.PLAYING
  //                         //     ? pauseMusic()
  //                         //     : playMusic();
  //                         // setState(() {});
  //                         isPlaying ? pauseMusic() : playMusic();
  //                       },
  //                       child: Icon(
  //                         // audioPlayerState == PlayerState.PLAYING
  //                         isPlaying
  //                             ? Icons.pause_circle_filled_outlined
  //                             : Icons.play_circle_fill_outlined,
  //                         size: 60,
  //                         color: Colors.white,
  //                       ),
  //                     ),
  //                     GestureDetector(
  //                       onTap: () {
  //                         // audioPlayerState == PlayerState.PLAYING
  //                         //     ? pauseMusic()
  //                         //     : playMusic();
  //                         // setState(() {});
  //                         audioPlayer.stop();
  //                       },
  //                       child: Icon(
  //                         // audioPlayerState == PlayerState.PLAYING
  //                         Icons.stop_sharp,
  //                         size: 60,
  //                         color: Colors.white,
  //                       ),
  //                     ),
  //                     IconButton(
  //                         onPressed: () {
  //                           if (viewModelProvider.globalIndexProvider ==
  //                               (viewModelProvider.audioListProvider.length -
  //                                   1)) {
  //                             viewModelProvider.globalIndexProvider = 0;
  //                             viewModelProvider.setIsGlobalIndexProvider(
  //                                 viewModelProvider.globalIndexProvider);
  //                             // setState(() {});
  //                             viewModelProvider.selectedAudioProvider =
  //                                 viewModelProvider.audioListProvider[
  //                                     viewModelProvider.globalIndexProvider];
  //                             viewModelProvider.setSelectedAudioProvider(
  //                                 viewModelProvider.selectedAudioProvider);
  //                             setState(() {});
  //                           } else if (viewModelProvider.globalIndexProvider <
  //                               viewModelProvider.audioListProvider.length -
  //                                   1) {
  //                             viewModelProvider.globalIndexProvider++;
  //                             viewModelProvider.setIsGlobalIndexProvider(
  //                                 viewModelProvider.globalIndexProvider);
  //                             // setState(() {});
  //                             viewModelProvider.selectedAudioProvider =
  //                                 viewModelProvider.audioListProvider[
  //                                     viewModelProvider.globalIndexProvider];
  //                             viewModelProvider.setSelectedAudioProvider(
  //                                 viewModelProvider.selectedAudioProvider);
  //                             setState(() {});
  //                           }
  //                           skipNext();
  //                         },
  //                         icon: Icon(
  //                           Icons.skip_next,
  //                           size: 34,
  //                           color: Colors.white,
  //                         )),

  //                     audioPlayer.builderLoopMode(builder: (context, loop) {
  //                       return PlayerBuilder.isPlaying(
  //                           player: audioPlayer,
  //                           builder: (context, isPlaying) {
  //                             return LoopControll(
  //                               loopMode: loop,
  //                               toggleLoop: () {
  //                                 audioPlayer.toggleLoop();
  //                               },
  //                             );
  //                           });
  //                     }),
  //                     // IconButton(
  //                     //     onPressed: () {

  //                     //       // if (isLoop == false) {
  //                     //       //   isLoop = true;
  //                     //       //   setState(() {});
  //                     //       //   audioPlayer.setLoopMode(LoopMode.single);
  //                     //       //   audioPlayer.toggleLoop();
  //                     //       // } else {
  //                     //       //   isLoop = false;
  //                     //       //   setState(() {});
  //                     //       // }
  //                     //     },
  //                     //     icon: Icon(
  //                     //       Icons.loop_outlined,
  //                     //       size: 28,
  //                     //       color: isLoop == false
  //                     //           ? Colors.white
  //                     //           : Colors.blueGrey,
  //                     //     )),
  //                   ],
  //                 )
  //               ],
  //             ),
  //           )),
  //         );
  //       });
  //     }),
  //   );
  // }
}
