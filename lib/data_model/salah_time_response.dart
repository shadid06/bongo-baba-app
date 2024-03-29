// To parse this JSON data, do
//
//     final salahTimeModel = salahTimeModelFromJson(jsonString);

import 'dart:convert';

SalahTimeModel salahTimeModelFromJson(String str) =>
    SalahTimeModel.fromJson(json.decode(str));

String salahTimeModelToJson(SalahTimeModel data) => json.encode(data.toJson());

class SalahTimeModel {
  SalahTimeModel({
    this.title,
    this.query,
    this.salahTimeModelFor,
    this.method,
    this.prayerMethodName,
    this.daylight,
    this.timezone,
    this.mapImage,
    this.sealevel,
    this.todayWeather,
    this.link,
    this.qiblaDirection,
    this.latitude,
    this.longitude,
    this.address,
    this.city,
    this.state,
    this.postalCode,
    this.country,
    this.countryCode,
    this.items,
    this.statusValid,
    this.statusCode,
    this.statusDescription,
  });

  var title;
  var query;
  var salahTimeModelFor;
  var method;
  var prayerMethodName;
  var daylight;
  var timezone;
  var mapImage;
  var sealevel;
  TodayWeather todayWeather;
  var link;
  var qiblaDirection;
  var latitude;
  var longitude;
  var address;
  var city;
  var state;
  var postalCode;
  var country;
  var countryCode;
  List<Item> items;
  var statusValid;
  var statusCode;
  var statusDescription;

  factory SalahTimeModel.fromJson(Map<String, dynamic> json) => SalahTimeModel(
        title: json["title"],
        query: json["query"],
        salahTimeModelFor: json["for"],
        method: json["method"],
        prayerMethodName: json["prayer_method_name"],
        daylight: json["daylight"],
        timezone: json["timezone"],
        mapImage: json["map_image"],
        sealevel: json["sealevel"],
        todayWeather: TodayWeather.fromJson(json["today_weather"]),
        link: json["link"],
        qiblaDirection: json["qibla_direction"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        address: json["address"],
        city: json["city"],
        state: json["state"],
        postalCode: json["postal_code"],
        country: json["country"],
        countryCode: json["country_code"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        statusValid: json["status_valid"],
        statusCode: json["status_code"],
        statusDescription: json["status_description"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "query": query,
        "for": salahTimeModelFor,
        "method": method,
        "prayer_method_name": prayerMethodName,
        "daylight": daylight,
        "timezone": timezone,
        "map_image": mapImage,
        "sealevel": sealevel,
        "today_weather": todayWeather.toJson(),
        "link": link,
        "qibla_direction": qiblaDirection,
        "latitude": latitude,
        "longitude": longitude,
        "address": address,
        "city": city,
        "state": state,
        "postal_code": postalCode,
        "country": country,
        "country_code": countryCode,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "status_valid": statusValid,
        "status_code": statusCode,
        "status_description": statusDescription,
      };
}

class Item {
  Item({
    this.dateFor,
    this.fajr,
    this.shurooq,
    this.dhuhr,
    this.asr,
    this.maghrib,
    this.isha,
  });

  String dateFor;
  String fajr;
  String shurooq;
  String dhuhr;
  String asr;
  String maghrib;
  String isha;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        dateFor: json["date_for"],
        fajr: json["fajr"],
        shurooq: json["shurooq"],
        dhuhr: json["dhuhr"],
        asr: json["asr"],
        maghrib: json["maghrib"],
        isha: json["isha"],
      );

  Map<String, dynamic> toJson() => {
        "date_for": dateFor,
        "fajr": fajr,
        "shurooq": shurooq,
        "dhuhr": dhuhr,
        "asr": asr,
        "maghrib": maghrib,
        "isha": isha,
      };
}

class TodayWeather {
  TodayWeather({
    this.pressure,
    this.temperature,
  });

  int pressure;
  String temperature;

  factory TodayWeather.fromJson(Map<String, dynamic> json) => TodayWeather(
        pressure: json["pressure"],
        temperature: json["temperature"],
      );

  Map<String, dynamic> toJson() => {
        "pressure": pressure,
        "temperature": temperature,
      };
}
