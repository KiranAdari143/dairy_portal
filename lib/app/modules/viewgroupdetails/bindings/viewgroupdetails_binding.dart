import 'package:get/get.dart';

import '../controllers/viewgroupdetails_controller.dart';

class ViewgroupdetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ViewgroupdetailsController>(
      () => ViewgroupdetailsController(),
    );
  }
}
