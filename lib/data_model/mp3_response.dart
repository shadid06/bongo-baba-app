// To parse this JSON data, do
//
//     final mp3Response = mp3ResponseFromJson(jsonString);

import 'dart:convert';

Mp3Response mp3ResponseFromJson(String str) =>
    Mp3Response.fromJson(json.decode(str));

String mp3ResponseToJson(Mp3Response data) => json.encode(data.toJson());

class Mp3Response {
  Mp3Response({
    this.data,
    this.success,
    this.status,
  });

  List<Datum> data;
  bool success;
  int status;

  factory Mp3Response.fromJson(Map<String, dynamic> json) => Mp3Response(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        success: json["success"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "success": success,
        "status": status,
      };
}

class Datum {
  Datum({
    this.id,
    this.name,
    this.coverArt,
    this.file,
    this.artistId,
    this.genreId,
    this.listens,
    this.isFeatured,
    this.description,
  });

  int id;
  String name;
  String coverArt;
  String file;
  int artistId;
  int genreId;
  int listens;
  int isFeatured;
  String description;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        coverArt: json["cover_art"],
        file: json["file"],
        artistId: json["artist_id"],
        genreId: json["genre_id"],
        listens: json["listens"],
        isFeatured: json["is_featured"],
        description: json["description"] == null ? null : json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "cover_art": coverArt,
        "file": file,
        "artist_id": artistId,
        "genre_id": genreId,
        "listens": listens,
        "is_featured": isFeatured,
        "description": description == null ? null : description,
      };
}
