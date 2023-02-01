import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:maypaper/models/photo_model.dart';
import 'package:maypaper/services/home_page_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageProvider with ChangeNotifier {
  late SharedPreferences prefs;
  final HomePageService _homePageService = HomePageService();

  late List<Photos> photos = [];
  bool? isLoadingFetch = false;
  String prevSearchVal = '';

  // functions
  Future<dynamic> getImages(dynamic params) async {
    try {
      print('page' + params['page'].toString());
      String currentSearchVal = params['query'];
      if (prevSearchVal != currentSearchVal && currentSearchVal.isNotEmpty) {
        photos = [];
        prevSearchVal = currentSearchVal;
      }
      isLoadingFetch = true;
      notifyListeners();
      dynamic response = await _homePageService.getImages(params);
      isLoadingFetch = false;
      notifyListeners();
      log('Get images successfully');

      List<Photos> photosTemp = [];
      response['photos'].forEach((item) {
        photosTemp.add(Photos.fromJson(item));
      });

      photos = [...photos, ...photosTemp];
    } catch (e) {
      log(e.toString());
      notifyListeners();
      return e.toString();
    }
  }
}
