import 'package:get/get.dart';

class PriceController extends GetxController {
  RxList ls = [].obs;
  setService(list) {
    ls = list;
    update();
  }
}
