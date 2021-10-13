import 'package:get/get.dart';

class ListController extends GetxController {
  RxList ls = [].obs;
  setService(list) {
    ls = list;
    update();
  }
}
