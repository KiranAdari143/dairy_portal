import 'package:get/get.dart';

import '../controllers/animaldetailscreen_controller.dart';

class AnimaldetailscreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AnimaldetailscreenController>(
      () => AnimaldetailscreenController(),
    );
  }
}
