// To parse this JSON data, do
//
//     final albumResponse = albumResponseFromJson(jsonString);

import 'dart:convert';

AlbumResponse albumResponseFromJson(String str) =>
    AlbumResponse.fromJson(json.decode(str));

String albumResponseToJson(AlbumResponse data) => json.encode(data.toJson());

class AlbumResponse {
  AlbumResponse({
    this.data,
    this.success,
    this.status,
  });

  List<Datum> data;
  bool success;
  int status;

  factory AlbumResponse.fromJson(Map<String, dynamic> json) => AlbumResponse(
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
  });

  int id;
  String name;
  String coverArt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        coverArt: json["cover_art"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "cover_art": coverArt,
      };
}
