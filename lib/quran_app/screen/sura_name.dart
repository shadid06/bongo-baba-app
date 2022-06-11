import 'dart:convert';

import 'package:active_ecommerce_flutter/quran_app/database/dbhelper.dart';
import 'package:active_ecommerce_flutter/quran_app/database/last_path_model.dart';
import 'package:active_ecommerce_flutter/quran_app/screen/bookmark.dart';
import 'package:active_ecommerce_flutter/quran_app/screen/sura_details.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  Future<void> suraName(name) async {
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
    getLastpath();
    suraName(controller.text);
  }

  bool isSearch = false;
  TextEditingController controller = TextEditingController();
  bool isshow = false;
  bool isLastPath = false;
  List<LastPathModel> lastPathModel = [];
  getLastpath() async {
    lastPathModel = await DBHelper().getLastPath();
    setState(() {
      isLastPath = true;
    });
    print(lastPathModel);
    return lastPathModel;
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
                height: 40,
                margin: EdgeInsets.only(top: 10, bottom: 10),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                      hintText: 'Enter Sura No. Or Sura Name',
                      hintStyle: TextStyle(fontSize: 15),
                      filled: true,
                      suffixIcon: IconButton(
                          onPressed: () {
                            suraName(controller.text);
                          },
                          icon: Icon(Icons.search)),
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.all(5),
                      border: OutlineInputBorder(
                        gapPadding: 5,
                      )),
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
              _SuraName.isEmpty
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.blue,
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: _SuraName.length,
                        itemBuilder: (context, index) {
                          if (controller.text.isEmpty) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SuraDetails(
                                              suraname: _SuraName[index]
                                                  ["sura_name"],
                                              suraNo: int.parse(
                                                  _SuraName[index]["sura_no"]),
                                            )));
                              },
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Container(
                                          height: 30,
                                          width: 30,
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
                                                  BorderRadius.circular(15)),
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                _SuraName[index]["sura_no"],
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
                                      _SuraName[index]["sura_name"],
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    subtitle: Row(
                                      children: [
                                        Text(
                                            'আয়ত - ${_SuraName[index]["total_ayat"]} টি,'),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            'পারা - ${_SuraName[index]["para"]}'),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.grey,
                                    height: 1,
                                  )
                                ],
                              ),
                            );
                          } else if (_SuraName[index]["sura_name"]
                                  .contains(controller.text) ||
                              _SuraName[index]["sura_no"]
                                  .contains(controller.text) ||
                              isSearch == false) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SuraDetails(
                                              suraname: _SuraName[index]
                                                  ["sura_name"],
                                              suraNo: int.parse(
                                                  _SuraName[index]["sura_no"]),
                                            )));
                              },
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                            color: Colors.teal,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Center(
                                            child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            _SuraName[index]["sura_no"],
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        )),
                                      ),
                                    ),
                                    title: Text(
                                      _SuraName[index]["sura_name"],
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    subtitle: Row(
                                      children: [
                                        Text(
                                            'আয়ত - ${_SuraName[index]["total_ayat"]} টি,'),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            'পারা - ${_SuraName[index]["para"]}'),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.grey,
                                    height: 1,
                                  )
                                ],
                              ),
                            );
                          }
                          return Container();
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
                child: lastPathModel.isEmpty
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
                        child: Center(
                            child: Text(
                          'সর্বশেষ পাঠ: ${lastPathModel[0].sura_name} -আয়ত: ${lastPathModel[0].VerseIDAr}',
                          style: TextStyle(
                              color: Color(0xfff2f2f2),
                              fontWeight: FontWeight.w500),
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
