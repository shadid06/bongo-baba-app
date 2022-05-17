import 'package:active_ecommerce_flutter/custom/listen_row.dart';
import 'package:active_ecommerce_flutter/custom/music_card.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/ui_sections/drawer.dart';
import 'package:flutter/material.dart';

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
