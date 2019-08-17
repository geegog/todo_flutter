import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'auth.dart';

class APIUtil {

  static Map<String, String> _headers = {HttpHeaders.contentTypeHeader: 'application/json'};
  //HttpHeaders.authorizationHeader: 'Bearer $jwt'};

  //static get jwt => Auth.getToken();

  static Future<dynamic> fetch(String uri) async {
    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      return response.body;
    } else {
      // If that response was not OK, throw an error.
      throw Exception(response.body);
    }
  }

  static Future<dynamic> post(String uri, String body) async {
    final response = await http.post(uri, headers: _headers, body: body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      // If server returns an OK response, parse the JSON.
      return response.body;
    } else {
      // If that response was not OK, throw an error.
      throw Exception(response.body);
    }
  }
}
