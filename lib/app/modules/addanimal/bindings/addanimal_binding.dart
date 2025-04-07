import 'package:get/get.dart';

import '../controllers/addanimal_controller.dart';

class AddanimalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddanimalController>(
      () => AddanimalController(),
    );
  }
}
