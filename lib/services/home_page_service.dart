import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:maypaper/services/http_service.dart';

class HomePageService {
  Future<dynamic> getImages(dynamic params) async {
    try {
      dynamic response = await HttpService.getAPI("/api/posttenant", params);
      return json.decode(response);
    } on SocketException {
      // apiResponse.ApiError = ApiError(error: "Server error. Please retry");
    }
    return false;
  }
}
