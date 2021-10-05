import 'package:get/get.dart';

class ProfileController extends GetxController {
  var name = "";
  var email = "";
  void setName(String username) {
    name = username;
    update();
  }

  void setEmail(String userEmail) {
    email = userEmail;
    update();
  }
}
