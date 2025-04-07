import 'package:get/get.dart';

import '../controllers/milktrackerscreen_controller.dart';

class MilktrackerscreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MilktrackerscreenController>(
      () => MilktrackerscreenController(),
    );
  }
}
