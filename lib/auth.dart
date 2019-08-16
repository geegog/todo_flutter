import 'package:shared_preferences/shared_preferences.dart';

class Auth {

  static final String authTokenKey = 'token';

  static void setToken(String token, SharedPreferences prefs) async {
    prefs.setString(authTokenKey, token);
  }

  static String getToken(SharedPreferences prefs) {
    String token = prefs.getString(authTokenKey) ?? null;
    return token;
  }

  static void removeToken(SharedPreferences prefs) {
    prefs.remove(authTokenKey);
  }
}