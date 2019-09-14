import 'dart:async';
import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:todo_flutter/common/services/auth.dart';
import 'package:todo_flutter/common/services/service_locator.dart';
import 'package:todo_flutter/common/utils/api.dart';

class UserRepository {
  Future<String> authenticate({
    @required String email,
    @required String password,
  }) async {
    String loginRequest = jsonEncode({
      'email': email,
      'password': password
    });
    var response = await APIUtil().post('sign_in', loginRequest);
    return response;
  }

  void signOut() {
    services.get<Auth>().removeUser();
  }

  Future<void> persistUser(String token) async {
    await services.get<Auth>().saveUser();
  }

  void persistToken(String token) {
    return services.get<Auth>().setToken(token);
  }

  List<String> getUser() {
    return services.get<Auth>().getUser();
  }

  bool hasValidToken() {
    return !services.get<Auth>().isTokenExpired();
  }
}
