import 'package:get/get.dart';

import '../controllers/groupingscreen_controller.dart';

class GroupingscreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GroupingscreenController>(
      () => GroupingscreenController(),
    );
  }
}
