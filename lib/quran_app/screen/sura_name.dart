import 'dart:convert';

import 'package:active_ecommerce_flutter/providers/locale_provider.dart';
import 'package:active_ecommerce_flutter/quran_app/database/dbhelper.dart';
import 'package:active_ecommerce_flutter/quran_app/database/last_path_model.dart';
import 'package:active_ecommerce_flutter/quran_app/screen/bookmark.dart';
import 'package:active_ecommerce_flutter/quran_app/screen/sura_details.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SuraName extends StatefulWidget {
  const SuraName({Key key}) : super(key: key);

  @override
  _SuraNameState createState() => _SuraNameState();
}

class _SuraNameState extends State<SuraName> {
  // List _itemss = [];
  List _SuraName = [];

  // Fetch content from the json file
  // Future<void> readJson() async {
  //   // final String response = await rootBundle.loadString('assets/ayats_ar.json');
  //   // final data = await json.decode(response);
  //   // setState(() {
  //   //   // _items = data;
  //   // });
  // final String responses = await rootBundle.loadString('assets/ayats_bn.json');
  //   final datas = await json.decode(responses);
  //   print(datas);
  //   setState(() {
  //     _itemss = datas;
  //   });

  // }
  Future<void> suraName() async {
    // final String response = await rootBundle.loadString('assets/ayats_ar.json');
    // final data = await json.decode(response);
    // setState(() {
    //   // _items = data;
    // });
    final String response = await rootBundle.loadString('assets/sura.json');
    final data = await json.decode(response);
    print(data);
    setState(() {
      _SuraName = data;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    getLastpath();
    suraName();
  }

  bool isSearch = false;
  TextEditingController controller = TextEditingController();
  bool isshow = false;
  bool isLastPath = false;
  List<LastPathModel> lastPathModel = [];
  LocaleProvider localeProvider;
  int searchIndex;
  int indexGlobal = 0;
  getLastpath() async {
    lastPathModel = await DBHelper().getLastPath();
    localeProvider.lastPathProvider = lastPathModel;
    localeProvider.setLastpathProvider(localeProvider.lastPathProvider);
    setState(() {
      isLastPath = true;
    });
    print(lastPathModel);
    return lastPathModel;
  }

  final double _height = 80;
  final _scrollController = ScrollController();
  void _scrollToIndex(index) {
    _scrollController.animateTo(_height * index,
        duration: const Duration(seconds: 2), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        // backgroundColor: Colors.blueGrey,

        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ShowData()));
        },
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              colors: [Color(0xff8aed93), Color(0xff00CED1)],
              stops: [0.15, 1.0],
            ),
          ),
          child: Icon(Icons.bookmark),
        ),
        // child: IconButton(
        //   onPressed: () {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => ShowData()));
        //   },
        //   icon: Icon(Icons.bookmark),
        // ),
      ),
      appBar: AppBar(
        centerTitle: true,
        // backgroundColor: Colors.blueGrey,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff8aed93), Color(0xff00CED1)],
              stops: [0.15, 1.0],
            ),
          ),
        ),
        title: isSearch
            ? Container(
                height: 30,
                width: size.width / 1.5,

                //margin: EdgeInsets.only(top: 10, bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'সূরা নাম অথবা সূরা নম্বর',
                      hintStyle: TextStyle(fontSize: 12),
                      //filled: true,
                      suffixIcon: GestureDetector(
                          onTap: () {
                            // suraName(controller.text);
                            //_SuraName = null;
                            try {
                              searchIndex = int.parse(controller.text);
                              searchIndex = searchIndex - 1;
                              _scrollToIndex(searchIndex);
                              //suraName();
                              // indexGlobal = searchIndex;
                              print(searchIndex);

                              setState(() {});
                            } on FormatException {
                              searchIndex = _SuraName.indexWhere((element) =>
                                  element["sura_name"] == controller.text);
                              _scrollToIndex(searchIndex);
                              setState(() {});
                            }
                            // if (_SuraName.contains(controller.text)) {

                            // }
                          },
                          child: Icon(Icons.search)),
                      // suffixIcon: IconButton(
                      //     onPressed: () {
                      //       suraName(controller.text);
                      //     },
                      //     icon: Icon(Icons.search)),
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.only(bottom: 18, left: 16),
                      // border: OutlineInputBorder(
                      //   gapPadding: 5,
                      // )
                    ),
                    onChanged: (val) {
                      try {
                        searchIndex = int.parse(val) - 1;
                        _scrollToIndex(searchIndex);
                      } on FormatException {
                        searchIndex = _SuraName.indexWhere(
                            (element) => element["sura_name"] == val);
                        _scrollToIndex(searchIndex);
                      }
                    },
                  ),
                ),
              )
            : Text('বাংলা কুরআন'),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isSearch = !isSearch;
                });
              },
              icon: isSearch ? Icon(Icons.close) : Icon(Icons.search))
        ],
      ),
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            children: [
              // ElevatedButton(
              //   child: const Text('Load Data'),
              //   onPressed: readJson,
              // ),

              // Display the data loaded from sample.json
              SizedBox(
                height: 16,
              ),
              _SuraName == null
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.blue,
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: _SuraName.length,
                        itemBuilder: (context, indexGlobal) {
                          print('ind: $indexGlobal');
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SuraDetails(
                                            suraname: _SuraName[indexGlobal]
                                                ["sura_name"],
                                            suraNo: int.parse(
                                                _SuraName[indexGlobal]
                                                    ["sura_no"]),
                                          )));
                            },
                            child: Column(
                              children: [
                                Container(
                                  height: _height,
                                  color: searchIndex == indexGlobal
                                      ? Colors.grey[300]
                                      : Colors.white,
                                  child: ListTile(
                                    leading: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(17),
                                        ),
                                        child: Container(
                                          height: 34,
                                          width: 34,
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color(0xff8aed93),
                                                  Color(0xff00CED1)
                                                ],
                                                stops: [0.15, 1.0],
                                              ),
                                              // color: int.parse(_SuraName[index]
                                              //                 ["sura_no"]) %
                                              //             2 ==
                                              //         0
                                              //     ? Color(0xff00CED1)
                                              //     : Color(0xff8aed93),
                                              borderRadius:
                                                  BorderRadius.circular(17)),
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                _SuraName[indexGlobal]
                                                    ["sura_no"],
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      _SuraName[indexGlobal]["sura_name"],
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    subtitle: Row(
                                      children: [
                                        Text(
                                            'আয়ত - ${_SuraName[indexGlobal]["total_ayat"]} টি,'),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            'পারা - ${_SuraName[indexGlobal]["para"]}'),
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(
                                  color: Colors.grey,
                                  height: 1,
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    )
            ],
          ),
        ),
        isLastPath
            ? Positioned(
                top: 4,
                left: size.width / 3.3,
                child: localeProvider.lastPathProvider.isEmpty
                    ? Container()
                    : Container(
                        alignment: Alignment.center,
                        padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                            // color: Colors.blueGrey.withOpacity(.8),
                            gradient: LinearGradient(
                              colors: [Color(0xff8aed93), Color(0xff00CED1)],
                              stops: [0.15, 1.0],
                            ),
                            borderRadius: BorderRadius.circular(12)),
                        // width: 160,
                        child: Center(child: Consumer<LocaleProvider>(
                          builder: ((context, localeProvider, child) {
                            return Text(
                              'সর্বশেষ পাঠ: ${localeProvider.lastPathProvider[0].sura_name} -আয়ত: ${localeProvider.lastPathProvider[0].VerseIDAr}',
                              style: TextStyle(
                                  color: Color(0xfff2f2f2),
                                  fontWeight: FontWeight.w500),
                            );
                          }),
                        ))),
              )
            : Container(),
        // isshow
        //     ? Positioned(
        //         top: 400,
        //         right: 5,
        //         child: GestureDetector(
        //           onTap: () {
        //             Navigator.push(context,
        //                 MaterialPageRoute(builder: (context) => ShowData()));
        //           },
        //           child: Container(
        //               padding: EdgeInsets.all(10),
        //               decoration: BoxDecoration(
        //                   color: Colors.blueGrey.withOpacity(.8),
        //                   borderRadius: BorderRadius.circular(10)),
        //               width: 160,
        //               child: Center(child: Text('বুকমার্ক দেখুন'))),
        //         ),
        //       )
        //     : Container(),
        isshow
            ? Positioned(
                top: 540,
                right: 5,
                child: GestureDetector(
                  // onTap: () {
                  //   Navigator.push(context,
                  //       MaterialPageRoute(builder: (context) => ShowData()));
                  // },
                  child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.blueGrey.withOpacity(.8),
                          borderRadius: BorderRadius.circular(10)),
                      width: 160,
                      child: Center(child: Text('সর্বশেষ পাঠ দেখুন'))),
                ),
              )
            : Container()
      ]),
    );
  }
}
