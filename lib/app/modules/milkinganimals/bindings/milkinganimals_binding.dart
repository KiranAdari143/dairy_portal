import 'package:get/get.dart';

import '../controllers/milkinganimals_controller.dart';

class MilkinganimalsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MilkinganimalsController>(
      () => MilkinganimalsController(),
    );
  }
}
