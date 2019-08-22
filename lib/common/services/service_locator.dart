import 'package:get_it/get_it.dart';
import 'package:todo_flutter/common/services/storage.dart';

GetIt services = GetIt.instance;

Future setupLocator() async {
  var instance = await Storage.getInstance();
  services.registerSingleton<Storage>(instance);
}
