import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_flutter/common/utils/api.dart';

class Auth {
  static final String authTokenKey = 'token';
  static final String userKey = 'user';
  static Auth _instance;
  static SharedPreferences _preferences;

  static Future<Auth> getInstance() async {
    if (_instance == null) {
      _instance = Auth();
    }
    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }
    return _instance;
  }

  void setToken(String token) {
    _preferences.setString(authTokenKey, token);
  }

  String getToken() {
    return _preferences.getString(authTokenKey);
  }

  void removeUser() {
    _preferences.remove(authTokenKey);
    _preferences.remove(userKey);
  }

  Map<String, dynamic> parseJwt(String token) {
    if (token == null) return null;

    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }
    return payloadMap;
  }

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!');
    }

    return utf8.decode(base64Url.decode(output));
  }

  bool isTokenExpired() {
    if (parseJwt(getToken()) == null) return true;
    DateTime exp =
        DateTime.fromMillisecondsSinceEpoch(parseJwt(getToken())['exp'] * 1000);
    return DateTime.now().isAfter(exp);
  }

  String getUserId() {
    if (parseJwt(getToken()) == null) throw Exception('Null token!');
    if (isTokenExpired()) throw Exception('Token expired!');
    return parseJwt(getToken())['sub'].toString();
  }

  saveUser() async {
    var response = await APIUtil().fetch('my_user');
    Map<String, dynamic> responseObj = json.decode(response);
    String name = responseObj['data']['name'];
    String email = responseObj['data']['email'];
    _preferences.setStringList(userKey, <String>[name, email]);
  }

  List<String> getUser() {
    return _preferences.getStringList(userKey);
  }

}
