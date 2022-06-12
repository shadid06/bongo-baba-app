import 'package:active_ecommerce_flutter/quran_app/database/db_model.dart';
import 'package:active_ecommerce_flutter/quran_app/database/last_path_model.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale;
  Locale get locale {
    return _locale = Locale(app_mobile_language.$, '');
  }

  List<LastPathModel> lastPathProvider = [];

  void setLocale(String code) {
    _locale = Locale(code, '');
    notifyListeners();
  }

  setLastpathProvider(last) {
    lastPathProvider = last;
    notifyListeners();
  }
}
