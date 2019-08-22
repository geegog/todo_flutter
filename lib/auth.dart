import 'package:shared_preferences/shared_preferences.dart';

class Auth {

  static final String authTokenKey = 'token';
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

  void removeToken() {
    _preferences.remove(authTokenKey);
  }
}
