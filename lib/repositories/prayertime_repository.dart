import 'package:active_ecommerce_flutter/data_model/prayer_time_response.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:convert';

class PrayerTimeRepository {
  Future<PrayerTimeResponse> getPrayer() async {
    Uri url = Uri.parse(
        "http://api.aladhan.com/v1/timings/1398332113?latitude=23.8103&longitude=90.4125&method=8");
    final response = await http.get(url);
    print(response.body.toString());

    return prayerTimeResponseFromJson(response.body);
  }
}
