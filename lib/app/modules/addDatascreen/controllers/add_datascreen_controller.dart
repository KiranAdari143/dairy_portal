import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddDatascreenController extends GetxController {
  final RxBool isEmployeeExpanded = false.obs;
  final RxBool isAnimalExpanded = false.obs;

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('mobilenumber');
    Get.offAllNamed("/home"); // or your login route
  }
}
