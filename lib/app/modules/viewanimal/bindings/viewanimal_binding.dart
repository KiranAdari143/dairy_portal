import 'package:get/get.dart';

import '../controllers/viewanimal_controller.dart';

class ViewanimalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ViewanimalController>(
      () => ViewanimalController(),
    );
  }
}
