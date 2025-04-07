import 'package:get/get.dart';

import '../controllers/groupanimaldetailscreen_controller.dart';

class GroupanimaldetailscreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GroupanimaldetailscreenController>(
      () => GroupanimaldetailscreenController(),
    );
  }
}
