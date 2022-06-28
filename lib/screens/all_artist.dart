import 'package:active_ecommerce_flutter/custom/music_card.dart';
import 'package:active_ecommerce_flutter/data_model/artist_response.dart';
import 'package:active_ecommerce_flutter/repositories/audio_repository.dart';
import 'package:active_ecommerce_flutter/screens/music_list.dart';
import 'package:flutter/material.dart';

class AllArtist extends StatefulWidget {
  const AllArtist({Key key}) : super(key: key);

  @override
  State<AllArtist> createState() => _AllArtistState();
}

class _AllArtistState extends State<AllArtist> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getArtist();
  }

  ArtistResponse artistResponse;
  var artistList = [];
  getArtist() async {
    artistResponse = await AudioRepository().getArtistList();
    artistList.addAll(artistResponse.data);
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
          "Artist",
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
          itemCount: artistList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MusicList(
                              id: artistList[index].id,
                              checker: 1,
                            )));
              },
              child: MusicCard(
                songName: artistList[index].name,
                artistName: "",
                imageUrl:
                    "https://ayat-app.com/public/" + artistList[index].image,
              ),
            );
          },
        ),
      ),
    );
  }
}
