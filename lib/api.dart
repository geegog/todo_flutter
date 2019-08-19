import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'auth.dart';

class APIUtil {
  static Map<String, String> _headers = {
    HttpHeaders.contentTypeHeader: 'application/json'
  };
  //HttpHeaders.authorizationHeader: 'Bearer $jwt'};

  //static get jwt => Auth.getToken();

  static Future<dynamic> fetch(String uri) async {
    try {
      final response = await http.get(uri, headers: _headers);
      return (response.statusCode == 200)
          ? response.body
          : response.body;
    } catch (exception) {
      return exception.toString().contains('SocketException')
          ? {'error': 'NetworkError'}
          : {'error': 'Something unexpected happened'};
    }
  }

  static Future<dynamic> post(String uri, String body) async {
    try {
      final response = await http.post(uri, headers: _headers, body: body);
      return (response.statusCode == 200 || response.statusCode == 201)
          ? response.body
          : response.body;
    } catch (exception) {
      return exception.toString().contains('SocketException')
          ? {'error': 'NetworkError'}
          : {'error': 'Something unexpected happened'};
    }
  }
}
