import 'package:get/get.dart';

import '../controllers/editmedicine_controller.dart';

class EditmedicineBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditmedicineController>(
      () => EditmedicineController(),
    );
  }
}
