import 'dart:convert';

import 'package:active_ecommerce_flutter/providers/locale_provider.dart';
import 'package:active_ecommerce_flutter/quran_app/database/db_model.dart';
import 'package:active_ecommerce_flutter/quran_app/database/dbhelper.dart';
import 'package:active_ecommerce_flutter/quran_app/database/last_path_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'dart:math';

import 'bookmark.dart';

class SuraDetails extends StatefulWidget {
  String suraname;
  String suraNo;

  SuraDetails({
    this.suraname,
    this.suraNo,
  });

  @override
  State<SuraDetails> createState() => _SuraDetailsState();
}

class _SuraDetailsState extends State<SuraDetails> {
  List suraArList = [];
  List suraBnList = [];
  List data = [];
  List data2 = [];
  double fontsize = 16;
  Future<void> suraAr() async {
    // final String response = await rootBundle.loadString('assets/ayats_ar.json');
    // final data = await json.decode(response);
    // setState(() {
    //   // _items = data;
    // });
    // final String response = await rootBundle.loadString('assets/ayats_ar.json');
    final String response = await rootBundle.loadString('assets/ayats_ar.json');
    data = await json.decode(response);
    // print(widget.suraNo);
    // print(data);
    for (int i = 0; i < data.length; i++) {
      if (widget.suraNo.compareTo(data[i]["sura"]) == 0) {
        // suraArList = data[i];
        suraArList.add(data[i]);
      }
    }

    setState(() {});

    print("ar: ${suraArList.length}");
  }

  Future<void> suraBn() async {
    // final String response = await rootBundle.loadString('assets/ayats_ar.json');
    // final data = await json.decode(response);
    // setState(() {
    //   // _items = data;
    // });
    final String response = await rootBundle.loadString('assets/ayats_bn.json');
    data2 = await json.decode(response);
    // print(data);
    for (int i = 0; i < data2.length; i++) {
      if (widget.suraNo.compareTo(data2[i]["sura"]) == 0) {
        // suraArList = data[i];
        suraBnList.add(data2[i]);
      }
    }

    setState(() {});
    //  match();
    //  setState(() {

    //  });
    print("bn: ${suraBnList.length}");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    getLastpath();
    suraAr();
    suraBn();

    // print(suraBn());
  }

  bool isSearch = false;
  bool isshow = false;
  var textbn;
  var textar;
  var verseIDar;
  var suraNo;
  var suraNama;
  var uniqId;
  var savedId;
  int searchIndex;
  List<LastPathModel> lastPathModel = [];
  TextEditingController controller = TextEditingController();
  LocaleProvider localeProvider;

  getLastpath() async {
    lastPathModel = await DBHelper().getLastPath();
    localeProvider.lastPathProvider = lastPathModel;
    localeProvider.setLastpathProvider(localeProvider.lastPathProvider);
    // savedId = lastPathModel[0].VerseIDAr;
    setState(() {});
    // print(lastPathModel[0].VerseIDAr);
    return lastPathModel;
  }

  final ItemScrollController _itemScrollController = ItemScrollController();

  // This function will be triggered when the user presses the floating button
  void _scrollToIndex(int index) {
    _itemScrollController.scrollTo(
        index: index,
        duration: const Duration(seconds: 2),
        curve: Curves.easeInOutCubic);
  }
  // match() {
  //   for (int i = 0; i < suraArList.length; i++) {
  //     if (suraArList[i]['VerseIDAr'] == savedId) {
  //       print("matched");
  //     } else {
  //       print("does not matched");
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.blueGrey,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff8aed93), Color(0xff00CED1)],
              stops: [0.15, 1.0],
            ),
          ),
        ),
        centerTitle: true,
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
                      hintText: 'আয়াত নম্বর',
                      hintStyle: TextStyle(fontSize: 12),
                      //filled: true,
                      suffixIcon: GestureDetector(
                          onTap: () {
                            // suraAr(controller.text);

                            searchIndex = int.parse(controller.text) - 1;
                            _scrollToIndex(searchIndex);
                            print(searchIndex);
                            setState(() {});
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
                      searchIndex = int.parse(val) - 1;
                      _scrollToIndex(searchIndex);
                    },
                  ),
                ),
              )
            : Text(widget.suraname),
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
        Column(
          children: [
            suraArList != null
                ? Expanded(
                    child: ScrollablePositionedList.builder(
                        itemScrollController: _itemScrollController,
                        itemCount: suraArList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onLongPress: () {
                              _showText(context);
                              textar = suraArList[index]["ayat"];
                              textbn = suraBnList[index]["text"];
                              verseIDar = suraArList[index]["VerseIDAr"];
                              suraNo = suraArList[index]["sura"];
                              suraNama = widget.suraname;
                              uniqId = suraArList[index]['id'];
                              print(textar);
                              print(textbn);
                              print(uniqId);
                            },
                            child: Card(
                              key: ValueKey(suraArList[index]),
                              margin: const EdgeInsets.all(10),
                              color: searchIndex == index
                                  ? Colors.grey[300]
                                  : Colors.white,
                              child: ListTile(
                                //  leading: Text(suraArList[index]["sura_no"]),
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${suraArList[index]["VerseIDAr"]}',
                                      style: TextStyle(
                                          fontSize: fontsize,
                                          color: Colors.black),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _showText(context);
                                        textar = suraArList[index]["ayat"];
                                        textbn = suraBnList[index]["text"];
                                        verseIDar =
                                            suraArList[index]["VerseIDAr"];
                                        suraNo = suraArList[index]["sura"];
                                        suraNama = widget.suraname;
                                        uniqId = suraArList[index]['id'];
                                        print(textar);
                                        print(textbn);
                                        print(uniqId);
                                      },
                                      child: Icon(
                                        Icons.more_horiz_outlined,
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: Text(
                                                  suraArList[index]["ayat"],
                                                  style: TextStyle(
                                                      fontSize: fontsize + 4,
                                                      color: Colors.black))),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      width: double.infinity,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            suraBnList.isEmpty
                                                ? ""
                                                : suraBnList[index]["text"],
                                            style: TextStyle(
                                                fontSize: fontsize,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    //     SizedBox(
                                    //       width: 15,
                                    //     ),
                                    //     Text('পারা - ${suraArList[index]["para"]}'),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  )
          ],
        ),
        isshow
            ? Positioned(
                top: size.height / 1.6,
                right: 5,
                child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xff8aed93), Color(0xff00CED1)],
                          stops: [0.15, 1.0],
                        ),

                        // color: Colors.blueGrey.withOpacity(.8),
                        borderRadius: BorderRadius.circular(10)),
                    width: 130,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            onPressed: () {
                              if (fontsize == 12.0) {
                              } else {
                                setState(() {
                                  fontsize--;
                                });
                              }
                            },
                            icon: Container(
                                padding: EdgeInsets.only(bottom: 20),
                                child: Icon(
                                  Icons.minimize,
                                  color: Colors.white,
                                ))),
                        Text(
                          fontsize.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Container(
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  fontsize++;
                                });
                              },
                              icon: Container(
                                  child: Icon(
                                Icons.add,
                                color: Colors.white,
                              ))),
                        )
                      ],
                    )),
              )
            : Container()
      ]),
      floatingActionButton: FloatingActionButton(
        // backgroundColor: Colors.blueGrey,

        onPressed: () {},
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
          child: IconButton(
            onPressed: () {
              setState(() {
                isshow = !isshow;
              });
            },
            icon: isshow
                ? Container(
                    padding: EdgeInsets.only(bottom: 0),
                    child: Icon(Icons.close))
                : Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(
        ClipboardData(text: "'${verseIDar}' \n '${textar}' \n '${textbn}'"));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Copied to clipboard'),
    ));
  }

  _showText(BuildContext context) {
    showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 225,
              child: Column(
                children: [
                  Container(
                    child: Text(
                      'আয়ত টি...',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      _copyToClipboard();
                      Navigator.pop(context);
                    },
                    child: Card(
                        shadowColor: Colors.black,
                        elevation: 10,
                        child: Container(
                            width: 200,
                            padding: EdgeInsets.all(10),
                            child: Center(child: Text('কপি করুন')))),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () async {
                      await DBHelper().saveToAddressList(AddAddressModel(
                          sura: uniqId,
                          sura_name: suraNama.toString(),
                          VerseIDAr: verseIDar,
                          text: textbn,
                          ayat: textar

                          // city:verseIDar ,
                          // houseNo: suraNama.toString(),
                          // mobileNo: suraNo,
                          // fname: textar,
                          // lname: textbn

                          // city: valueChoose,
                          // fname: firstNameCtlr.text,
                          // lname: lastNameCtlr.text,
                          // houseNo: houseNoCtlr.text,
                          // mobileNo: mobileNoCtlr.text

                          ));
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('বুকমার্ক এ সংরক্ষন করা হয়েছে'),
                      ));
                      // print('Indert data');

                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => ShowData()));
                    },
                    child: Card(
                        shadowColor: Colors.black,
                        elevation: 10,
                        child: Container(
                            width: 200,
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: Text('বুকমার্ক এ সংরক্ষন করুন'),
                            ))),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (lastPathModel.isNotEmpty) {
                        await DBHelper().deleteLastPath();
                        await DBHelper().saveToLastPath(LastPathModel(
                          sura: uniqId,
                          sura_name: suraNama.toString(),
                          VerseIDAr: verseIDar,
                        ));

                        await getLastpath();
                      } else {
                        await DBHelper().saveToLastPath(LastPathModel(
                          sura: uniqId,
                          sura_name: suraNama.toString(),
                          VerseIDAr: verseIDar,
                        ));

                        await getLastpath();
                      }

                      // await DBHelper().updateLastpath(LastPathModel(
                      //   sura: uniqId,
                      //   sura_name: suraNama.toString(),
                      //   VerseIDAr: verseIDar,
                      // ));
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('সর্বশেষ পাঠ সংরক্ষন করা হয়েছে'),
                      ));
                    },
                    child: Card(
                        shadowColor: Colors.black,
                        elevation: 10,
                        child: Container(
                            width: 200,
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: Text('সর্বশেষ পাঠ নির্বাচন করুন '),
                            ))),
                  ),
                ],
              ),
            ),
            // actions: <Widget>[
            //   Card(
            //     shadowColor: Colors.black,
            //     elevation: 20,
            //     child: new FlatButton(
            //         onPressed: () {
            //           Navigator.of(context).pop();
            //         },
            //         child: Padding(
            //           padding: const EdgeInsets.all(10.0),
            //           child: new Text("OK"),
            //         )),
            //   )
            // ],
          );
        });
  }
}
