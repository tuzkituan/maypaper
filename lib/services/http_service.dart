import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:maypaper/utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HttpService {
  static Future<dynamic> getAPI(String url, final params) async {
    return http.get(
      Uri.https(BASE_URL_API, url, params),
      headers: {
        'Content-Type': 'application/json;charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        'Authorization': API_KEY,
      },
    ).then((http.Response response) {
      final int statusCode = response.statusCode;
      log('response ${response.body.toString()}');
      if (statusCode < 200 || statusCode > 400) {
        throw Exception("Error while fetching data");
      }
      return response.body;
    });
  }

  static Future<dynamic> postAPI(String url, Object payload) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = (prefs.getString('token') ?? "").toString();

    return http.post(
      Uri.https('link', url),
      body: json.encode(payload),
      headers: {
        'Content-Type': 'application/json;charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        'Authorization': 'Bearer $token',
      },
    ).then((http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400) {
        throw Exception("Error while calling API");
      }
      return response.body;
    });
  }
}
