import 'package:get/get.dart';

import '../controllers/addgroup_controller.dart';

class AddgroupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddgroupController>(
      () => AddgroupController(),
    );
  }
}
