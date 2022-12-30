import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageProvider with ChangeNotifier {
  late SharedPreferences prefs;

  // functions
  Future<dynamic> getBanners() async {
    // try {
    //   isLoading = true;
    //   notifyListeners();
    //   dynamic response = await _homePageService.getPost({"postType": "BANNER"});
    //   isLoading = false;
    //   notifyListeners();

    //   final statusCode = response['statusCode'];
    //   switch (statusCode) {
    //     case 200:
    //       log('get banner successfully');
    //       final List<BannerModel> loadedBanners = [];
    //       response['data'].forEach((item) {
    //         loadedBanners.add(BannerModel.fromJson(item));
    //       });
    //       banners = loadedBanners;
    //       notifyListeners();
    //       return response;
    //     case 401:
    //       return null;
    //     default:
    //       log('error get banner');
    //       notifyListeners();
    //       return {'statusCode': statusCode, 'message': response['message']};
    //   }
    // } catch (e) {
    //   log(e.toString());
    //   notifyListeners();
    //   return e.toString();
    // }
  }
}
