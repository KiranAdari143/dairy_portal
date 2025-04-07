import 'package:get/get.dart';

import '../controllers/milkdetailscreen_controller.dart';

class MilkdetailscreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MilkdetailscreenController>(
      () => MilkdetailscreenController(),
    );
  }
}
