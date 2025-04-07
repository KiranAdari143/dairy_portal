import 'dart:convert';

import 'package:dairy_portal/app/data/getanimalmodel.dart';
import 'package:dairy_portal/app/modules/reports/controllers/reports_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class GroupanimaldetailscreenController extends GetxController {
  RxList<Animal> animals = <Animal>[].obs;

  final selectedCategory = ''.obs;
  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    if (args != null) {
      selectedCategory.value = args['category'] ?? '';
    }
    final groupId = args["groupId"];
    if (groupId != null) {
      final controller = Get.find<ReportsController>();
      controller.fetchMilkingSummaryByGroup(groupId);
    }
  }

  // This function expects the API to return a single animal in the "details" key.
  Future<List<Animal>> fetchAnimals(String tagno) async {
    final response = await http
        .get(Uri.parse('http://13.234.230.143/getAnimalByTagNo?tag_no=$tagno'))
        .timeout(const Duration(seconds: 15));
    print("response: ${response.body}");
    if (response.statusCode == 200) {
      // Use "details" because the API returns a single animal object there.
      final jsonResponse = json.decode(response.body)['details'];
      // Convert the object to an Animal instance.
      final animalObj = Animal.fromJson(jsonResponse);
      // Assign it in a list.
      animals.assignAll([animalObj]);
      // Navigate to animal details screen, passing the Animal instance directly.
      Get.toNamed('/animaldetailscreen', arguments: animalObj);
      return animals;
    } else {
      throw Exception('Failed to load animals');
    }
  }

  String formatDate(String dateString) {
    final parsedDate = DateTime.parse(dateString);
    return DateFormat('MM/dd').format(parsedDate);
  }
}
