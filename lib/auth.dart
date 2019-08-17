import 'package:shared_preferences/shared_preferences.dart';

class Auth {

  static final String authTokenKey = 'token';

  static void setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(authTokenKey, token);
  }

  static Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(authTokenKey) ?? null;
    return token;
  }

  static void removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(authTokenKey);
  }
}