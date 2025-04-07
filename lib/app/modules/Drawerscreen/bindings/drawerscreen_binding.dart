import 'package:get/get.dart';

import '../controllers/drawerscreen_controller.dart';

class DrawerscreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DrawerscreenController>(
      () => DrawerscreenController(),
    );
  }
}
