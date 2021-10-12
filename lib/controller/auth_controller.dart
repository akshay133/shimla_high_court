import 'package:get/get.dart';

class AuthController extends GetxController {
  var token = "";
  var name = "".obs;
  var email = "".obs;
  setUserData(tkn, nme, eml) {
    token = tkn;
    name = nme;
    email = eml;
    update();
  }
}
