import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static final String authTokenKey = 'token';
  static Storage _instance;
  static SharedPreferences _preferences;

  static Future<Storage> getInstance() async {
    if (_instance == null) {
      _instance = Storage();
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
