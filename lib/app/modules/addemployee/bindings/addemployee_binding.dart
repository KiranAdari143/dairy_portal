import 'package:get/get.dart';

import '../controllers/addemployee_controller.dart';

class AddemployeeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddemployeeController>(
      () => AddemployeeController(),
    );
  }
}
