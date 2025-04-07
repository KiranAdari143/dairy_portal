import 'package:get/get.dart';

import '../controllers/animaldata_controller.dart';

class AnimaldataBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AnimaldataController>(
      () => AnimaldataController(),
    );
  }
}
