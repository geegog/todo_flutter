import 'dart:async';
import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:todo_flutter/common/services/auth.dart';
import 'package:todo_flutter/common/services/service_locator.dart';
import 'package:todo_flutter/common/utils/api.dart';
import 'package:todo_flutter/user/dto/user.dart';
import 'package:todo_flutter/user/dto/user_request.dart';

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

  Future<String> register({
    @required String email,
    @required String password,
    @required String phone,
    @required String name,
    @required String confirmPassword,
  }) async {

    User user = User(
        name,
        email,
        phone,
        password,
        confirmPassword);

    String userRequest = jsonEncode(UserRequest(user));

    var response = await APIUtil().post('sign_up', userRequest);
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
