import 'package:active_ecommerce_flutter/data_model/album_response.dart';
import 'package:active_ecommerce_flutter/data_model/artist_response.dart';
import 'package:active_ecommerce_flutter/data_model/generic_response.dart';
import 'package:active_ecommerce_flutter/data_model/mp3_response.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:convert';

class AudioRepository {
  Future<ArtistResponse> getArtistList() async {
    Uri url = Uri.parse("https://ayat-app.com/api/v2/artists");
    final response = await http.get(url);
    print(response.body);
    return artistResponseFromJson(response.body);
  }

  Future<AlbumResponse> getAlbumList() async {
    Uri url = Uri.parse("https://ayat-app.com/api/v2/albums");
    final response = await http.get(url);
    print('album:${response.body}');
    return albumResponseFromJson(response.body);
  }

  Future<GenericResponse> getGenericList() async {
    Uri url = Uri.parse("https://ayat-app.com/api/v2/genres");
    final response = await http.get(url);
    print('generic:${response.body}');
    return genericResponseFromJson(response.body);
  }

  Future<Mp3Response> getMp3List() async {
    Uri url = Uri.parse("https://ayat-app.com/api/v2/mp3");
    final response = await http.get(url);
    print('mp3:${response.body}');
    return mp3ResponseFromJson(response.body);
  }

  Future<Mp3Response> getArtistMp3List(var id) async {
    Uri url = Uri.parse("https://ayat-app.com/api/v2/artistWiseMpThree/$id");
    final response = await http.get(url);
    print('artist mp3:${response.body}');
    return mp3ResponseFromJson(response.body);
  }

  Future<Mp3Response> getGenreMp3List(var id) async {
    Uri url = Uri.parse("https://ayat-app.com/api/v2/genreWiseMpThree/$id");
    final response = await http.get(url);
    print('genre mp3:${response.body}');
    return mp3ResponseFromJson(response.body);
  }

  Future<Mp3Response> getAlbumMp3List(var id) async {
    Uri url = Uri.parse("https://ayat-app.com/api/v2/albumWiseMpThree/$id");
    final response = await http.get(url);
    print('album mp3:${response.body}');
    return mp3ResponseFromJson(response.body);
  }
}
