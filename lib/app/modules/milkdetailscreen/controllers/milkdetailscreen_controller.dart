import 'package:dairy_portal/app/data/milkqty.dart';
import 'package:get/get.dart';

class MilkdetailscreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    print("MilkdetailscreenController initialized");
    print("Raw arguments: ${Get.arguments}");
    if (Get.arguments == null) {
      print("No arguments passed to MilkdetailscreenController");
      return;
    }
    final List<Milkqty> records = Get.arguments as List<Milkqty>;
    records.forEach((record) {
      print("AM Quantity: ${record.amQuantity}");
      print("PM Quantity: ${record.pmQuantity}");
    });
  }
}
