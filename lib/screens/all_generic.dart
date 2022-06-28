import 'package:active_ecommerce_flutter/custom/music_card.dart';
import 'package:active_ecommerce_flutter/data_model/generic_response.dart';
import 'package:active_ecommerce_flutter/repositories/audio_repository.dart';
import 'package:active_ecommerce_flutter/screens/music_list.dart';
import 'package:flutter/material.dart';

class Allgeneric extends StatefulWidget {
  const Allgeneric({Key key}) : super(key: key);

  @override
  State<Allgeneric> createState() => _AllgenericState();
}

class _AllgenericState extends State<Allgeneric> {
  GenericResponse genericResponse;
  var genericList = [];
  @override
  void initState() {
    super.initState();
    getGeneric();
  }

  getGeneric() async {
    genericResponse = await AudioRepository().getGenericList();
    genericList.addAll(genericResponse.data);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Generic",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
          ),
          itemCount: genericList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MusicList(
                              id: genericList[index].id,
                              checker: 2,
                            )));
              },
              child: MusicCard(
                songName: genericList[index].name,
                artistName: "",
                imageUrl: "https://ayat-app.com/public/" +
                    genericList[index].coverArt,
              ),
            );
          },
        ),
      ),
    );
  }
}
