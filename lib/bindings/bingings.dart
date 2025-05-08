import 'package:get/get.dart';
import 'package:oov/controllers/LoginController.dart';
import 'package:oov/controllers/VpnController.dart';

class MyBindings implements Bindings{
  @override
  void dependencies() {
   Get.put(VpnController());
   Get.put(LoginController());
  }
  }
  