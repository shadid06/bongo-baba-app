import 'package:active_ecommerce_flutter/data_model/prayer_time_response.dart';
import 'package:active_ecommerce_flutter/data_model/salah_time_response.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:convert';

class PrayerTimeRepository {
  Future<PrayerTimeResponse> getPrayer({var latitude, var longitude}) async {
    Uri url = Uri.parse(
        "http://api.aladhan.com/v1/timings/1398332113?latitude=$latitude&longitude=$longitude&method=8");
    final response = await http.get(url);
    print(response.body.toString());

    return prayerTimeResponseFromJson(response.body);
  }

  Future<SalahTimeModel> getSalahTime({var locality}) async {
    Uri url = Uri.parse(
        "https://muslimsalat.com/$locality.json?key=fa69d444f79bb749174c9cbaa473e9ed");
    final response = await http.get(url);
    print(response.body.toString());
    return salahTimeModelFromJson(response.body);
  }
}
