import 'package:get_it/get_it.dart';
import 'package:todo_flutter/common/services/auth.dart';

GetIt services = GetIt.instance;

Future setupLocator() async {
  var instance = await Auth.getInstance();
  services.registerSingleton<Auth>(instance);
}
