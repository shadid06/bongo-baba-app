import 'package:active_ecommerce_flutter/quran_app/database/db_model.dart';
import 'package:active_ecommerce_flutter/quran_app/database/dbhelper.dart';
import 'package:flutter/material.dart';

class ShowData extends StatefulWidget {
  const ShowData({Key key}) : super(key: key);

  @override
  State<ShowData> createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
  List<AddAddressModel> addresses = [];
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAddresse();
  }

  getAddresse() async {
    var ad = await DBHelper().getAddresses();
    setState(() {
      addresses = ad;
      isLoading = false;
    });
    print(addresses);
    return ad;
  }

  deletedata() async {}
  var delete;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        title: Text("বুকমার্ক "),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: addresses.isEmpty && isLoading == false
              ? Center(
                  child: Column(
                  children: [
                    Image.asset(
                      "assets/bookmark.png",
                      height: 300,
                      width: 200,
                    ),
                    Text(
                      "No Book Marks",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ))
              : Center(
                  child: isLoading == true
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Colors.blueAccent,
                          ),
                        )
                      : ListView.builder(
                          itemCount: addresses.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 10,
                              shadowColor: Colors.black,
                              child: ListTile(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      addresses[index].sura_name,
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 14),
                                    ),
                                    GestureDetector(
                                        onTap: () async {
                                          isLoading = true;
                                          setState(() {});
                                          await DBHelper.deleteBook(
                                              addresses[index].sura);
                                          // ScaffoldMessenger.of(context)
                                          //     .showSnackBar(const SnackBar(
                                          //   content: Text('ডিলিট করা হয়েছে'),
                                          // ));
                                          setState(() {});

                                          print(isLoading);
                                          await getAddresse();
                                          setState(() {});
                                        },
                                        child: Icon(Icons.delete_outline))
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'আয়ত - ${addresses[index].VerseIDAr.toString()}'),
                                    Text(
                                      addresses[index].ayat,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18),
                                    ),
                                    Text(
                                      addresses[index].text,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                ),
        ),
      )),
    );
  }
}
