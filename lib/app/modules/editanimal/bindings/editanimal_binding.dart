import 'package:get/get.dart';

import '../controllers/editanimal_controller.dart';

class EditanimalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditanimalController>(
      () => EditanimalController(),
    );
  }
}
