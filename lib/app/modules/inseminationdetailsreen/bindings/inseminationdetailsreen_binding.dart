import 'package:get/get.dart';

import '../controllers/inseminationdetailsreen_controller.dart';

class InseminationdetailsreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InseminationdetailsreenController>(
      () => InseminationdetailsreenController(),
    );
  }
}
