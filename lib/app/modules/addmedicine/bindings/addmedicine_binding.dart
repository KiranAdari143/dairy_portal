import 'package:get/get.dart';

import '../controllers/addmedicine_controller.dart';

class AddmedicineBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddmedicineController>(
      () => AddmedicineController(),
    );
  }
}
