import 'package:active_ecommerce_flutter/custom/music_card.dart';
import 'package:active_ecommerce_flutter/data_model/album_response.dart';
import 'package:active_ecommerce_flutter/repositories/audio_repository.dart';
import 'package:active_ecommerce_flutter/screens/music_list.dart';
import 'package:flutter/material.dart';

class AllAlbum extends StatefulWidget {
  const AllAlbum({Key key}) : super(key: key);

  @override
  State<AllAlbum> createState() => _AllAlbumState();
}

class _AllAlbumState extends State<AllAlbum> {
  AlbumResponse albumResponse;
  var albumList = [];
  @override
  void initState() {
    super.initState();
    getAlbum();
  }

  getAlbum() async {
    albumResponse = await AudioRepository().getAlbumList();
    albumList.addAll(albumResponse.data);
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
          "Album",
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
          itemCount: albumList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MusicList(
                              id: albumList[index].id,
                              checker: 3,
                            )));
              },
              child: MusicCard(
                songName: albumList[index].name,
                artistName: "",
                imageUrl:
                    "https://ayat-app.com/public/" + albumList[index].coverArt,
              ),
            );
          },
        ),
      ),
    );
  }
}
