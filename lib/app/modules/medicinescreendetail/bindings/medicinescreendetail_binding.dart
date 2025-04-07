import 'package:get/get.dart';

import '../controllers/medicinescreendetail_controller.dart';

class MedicinescreendetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MedicinescreendetailController>(
      () => MedicinescreendetailController(),
    );
  }
}
