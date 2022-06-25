// To parse this JSON data, do
//
//     final artistResponse = artistResponseFromJson(jsonString);

import 'dart:convert';

ArtistResponse artistResponseFromJson(String str) =>
    ArtistResponse.fromJson(json.decode(str));

String artistResponseToJson(ArtistResponse data) => json.encode(data.toJson());

class ArtistResponse {
  ArtistResponse({
    this.data,
    this.success,
    this.status,
  });

  List<Datum> data;
  bool success;
  int status;

  factory ArtistResponse.fromJson(Map<String, dynamic> json) => ArtistResponse(
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
    this.image,
  });

  int id;
  String name;
  String image;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
      };
}
