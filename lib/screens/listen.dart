import 'dart:async';

import 'package:active_ecommerce_flutter/custom/listen_row.dart';
import 'package:active_ecommerce_flutter/custom/music_card.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/data_model/prayer_time_response.dart';
import 'package:active_ecommerce_flutter/data_model/salah_time_response.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/repositories/prayertime_repository.dart';
import 'package:active_ecommerce_flutter/ui_sections/drawer.dart';

import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
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

  @override
  void initState() {
    super.initState();
    fetchPrayerTime();
    fetchSalahTime();
    showTime();

    initializeNotification();
    // notificationTimeSelect();
    tz.initializeTimeZones();
    _showNotification();
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
    var now = DateTime.now();
    currentDate = DateFormat('dd-MM-yyyy').format(now);
    currentTime = DateFormat('h:mm').format(now);
    currentTimeSplit = currentTime.split(
      ':',
    );

    currentHour = int.parse(currentTimeSplit[0]);
    currentMinute = int.parse(currentTimeSplit[1]);
    // if (currentHour > zhurCmpHour && currentHour < asarCmpHour) {}
    print('current time$currentTime'); //HH:mm:ss
    print(currentHour);
    print(currentMinute);
  }

  timeConvert() {
    fajar = salahItem[0].fajr.split(':');
    sunrise = salahItem[0].shurooq.split(':');
    zhur = salahItem[0].dhuhr.split(':');
    asar = salahItem[0].asr.split(':');
    // sunset = prayerTimeResponse.data.timings.sunset.split(':');
    magrib = salahItem[0].maghrib.split(':');
    isha = salahItem[0].isha.split(':');
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
    if ((currentHour >= zhurCmpHour && currentMinute > asarCmpMinute) &&
        currentHour <= asarCmpHour) {
      selectedYakt = "যোহর";
      // setState(() {});
      var difHour = asarCmpHour - currentHour;
      differenInMinute = ((difHour * 60) + asarCmpMinute) - currentMinute;
      // totalAnimationTime = differenInMinute * 60000;
      setState(() {});
      print("zhur diff:$differenInMinute");
      // countDownHour = (differenInMinute / 60).floor();
      // countDownMinute = (differenInMinute % 60);
      // print(differenInMinute);
      // print(countDownHour);
      // print(countDownMinute);
      //যোহর আছর মাগরিব ইশা সাহরি	ইফতার সূর্যোদয় সূর্যাস্ত চলছে
    } else if (currentHour >= asarCmpHour && currentHour <= magribCmpHour) {
      selectedYakt = "আছর";

      var difHour = magribCmpHour - currentHour;
      differenInMinute = ((difHour * 60) + magribCmpMinute) - currentMinute;
      setState(() {});
      print("asar diff:$differenInMinute");
      // totalAnimationTime = differenInMinute * 60000;
    } else if (currentHour >= magribCmpHour && currentHour <= ishaCmpHour) {
      selectedYakt = "মাগরিব";

      var difHour = ishaCmpHour - currentHour;
      differenInMinute = ((difHour * 60) + ishaCmpMinute) - currentMinute;
      // totalAnimationTime = differenInMinute * 60000;
      setState(() {});
    } else if (currentHour >= ishaCmpHour || currentHour <= fajarCmpHour) {
      selectedYakt = "ইশা";

      var difHour = fajarCmpHour - currentHour;
      differenInMinute = ((difHour * 60) + fajarCmpMinute) - currentMinute;
      setState(() {});
    } else if (currentHour >= fajarCmpHour && currentHour <= sunriseCmpHour) {
      selectedYakt = "ফজর";

      var difHour = sunriseCmpHour - currentHour;
      differenInMinute = ((difHour * 60) + sunriseCmpMinute) - currentMinute;
      setState(() {});
    } else if (currentHour >= sunriseCmpHour && currentHour <= zhurCmpHour) {
      selectedYakt = "বাকি";

      var difHour = zhurCmpHour - currentHour;
      if (difHour > 0) {
        differenInMinute = ((difHour * 60) + zhurCmpMinute) - currentMinute;
      } else {
        differenInMinute = zhurCmpMinute - currentMinute;
      }
      setState(() {});
      print("zhur min $zhurCmpMinute");
    }
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
                                                onEnd: () async {
                                                  print('Timer ended');
                                                  await showTime();
                                                  await yaktSelector();
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 90,
                                            width: 90,
                                            decoration: BoxDecoration(
                                                // color: Colors.redAccent,
                                                borderRadius:
                                                    BorderRadius.circular(45)),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(45),
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
}
