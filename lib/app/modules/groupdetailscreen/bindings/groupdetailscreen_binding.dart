import 'package:get/get.dart';

import '../controllers/groupdetailscreen_controller.dart';

class GroupdetailscreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GroupdetailscreenController>(
      () => GroupdetailscreenController(),
    );
  }
}
