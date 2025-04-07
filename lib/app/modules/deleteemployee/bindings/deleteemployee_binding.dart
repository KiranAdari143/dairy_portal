import 'package:get/get.dart';

import '../controllers/deleteemployee_controller.dart';

class DeleteemployeeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DeleteemployeeController>(
      () => DeleteemployeeController(),
    );
  }
}
