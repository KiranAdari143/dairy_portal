import 'package:get/get.dart';

import '../controllers/add_datascreen_controller.dart';

class AddDatascreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddDatascreenController>(
      () => AddDatascreenController(),
    );
  }
}
