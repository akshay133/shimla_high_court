import 'package:get/get.dart';

class AuthController extends GetxController {
  var token = "";
  setToken(tkn) {
    token = tkn;
    update();
  }
}
