import 'package:get/get.dart';
import 'package:high_court/screens/home_screen_main.dart';

class LoginController extends GetxController {
  var token = "".obs;
  @override
  void onInit() {
    ever(token, (callback) {
      if (token.toString() != "") {
        Get.to(const HomeScreenMain());
      }
    });
    super.onInit();
  }
}
