import 'package:get/get.dart';

import '../controllers/pasturedetailscreen_controller.dart';

class PasturedetailscreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PasturedetailscreenController>(
      () => PasturedetailscreenController(),
    );
  }
}
