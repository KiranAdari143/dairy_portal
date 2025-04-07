import 'package:get/get.dart';

import '../controllers/medicine_managementscreen_controller.dart';

class MedicineManagementscreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MedicineManagementscreenController>(
      () => MedicineManagementscreenController(),
    );
  }
}
