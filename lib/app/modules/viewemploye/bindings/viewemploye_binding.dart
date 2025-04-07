import 'package:get/get.dart';

import '../controllers/viewemploye_controller.dart';

class ViewemployeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ViewemployeController>(
      () => ViewemployeController(),
    );
  }
}
