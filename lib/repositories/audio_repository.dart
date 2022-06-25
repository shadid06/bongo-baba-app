import 'package:active_ecommerce_flutter/data_model/artist_response.dart';
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
}
