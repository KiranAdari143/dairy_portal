import 'package:get/get.dart';

import '../controllers/vaccinationdetailscreen_controller.dart';

class VaccinationdetailscreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VaccinationdetailscreenController>(
      () => VaccinationdetailscreenController(),
    );
  }
}
