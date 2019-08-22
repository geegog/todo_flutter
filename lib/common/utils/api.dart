import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:todo_flutter/common/services/service_locator.dart';

import '../services/storage.dart';

class APIUtil {
  static final String developmentHost =
      'https://gentle-bayou-12059.herokuapp.com/api/v1/';

  static get jwt => services.get<Storage>().getToken();

  static Map<String, String> _headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer $jwt'
  };

  static Future<dynamic> fetch(String uri) async {
    try {
      final response = await http.get(developmentHost + uri, headers: _headers);
      return (response.statusCode == 200) ? response.body : response.body;
    } catch (exception) {
      return exception.toString().contains('SocketException')
          ? '{"error": "Network Error"}'
          : '{"error": "Something unexpected happened"}';
    }
  }

  static Future<dynamic> post(String uri, String body) async {
    try {
      final response =
          await http.post(developmentHost + uri, headers: _headers, body: body);
      return (response.statusCode == 200 || response.statusCode == 201)
          ? response.body
          : response.body;
    } catch (exception) {
      print(exception);
      return exception.toString().contains('SocketException')
          ? '{"error": "Network Error"}'
          : '{"error": "Something unexpected happened"}';
    }
  }
}
