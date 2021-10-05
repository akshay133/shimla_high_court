import 'package:get/get.dart';

class DashBoardDataController extends GetxController {
  var title = "";
  void setTitle(String txt) {
    title = txt;
    update();
  }
}
