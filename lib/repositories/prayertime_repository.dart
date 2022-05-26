import 'package:active_ecommerce_flutter/data_model/prayer_time_response.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:convert';

class PrayerTimeRepository {
  Future<PrayerTimeResponse> getPrayer({var latitude, var longitude}) async {
    Uri url = Uri.parse(
        "http://api.aladhan.com/v1/timings/1398332113?latitude=$latitude&longitude=$longitude&method=11");
    final response = await http.get(url);
    print(response.body.toString());

    return prayerTimeResponseFromJson(response.body);
  }
}
