import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:maypaper/services/http_service.dart';

class HomePageService {
  Future<dynamic> getImages(dynamic params) async {
    try {
      String api =
          params['query'].toString().isNotEmpty ? "/v1/search" : "/v1/curated";

      dynamic response = await HttpService.getAPI(api, params);
      return json.decode(response);
    } on SocketException {
      // apiResponse.ApiError = ApiError(error: "Server error. Please retry");
    }
    return false;
  }
}
