import 'package:get/get.dart';

import '../controllers/reportspage_controller.dart';

class ReportspageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportspageController>(
      () => ReportspageController(),
    );
  }
}
