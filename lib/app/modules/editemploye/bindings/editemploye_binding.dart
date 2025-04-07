import 'package:get/get.dart';

import '../controllers/editemploye_controller.dart';

class EditemployeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditemployeController>(
      () => EditemployeController(),
    );
  }
}
