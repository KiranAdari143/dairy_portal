import 'dart:convert';
import 'package:dairy_portal/app/data/getanimalmodel.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ReportspageController extends GetxController {
  // Holds the list of fetched animal details.
  RxList<Animal> animals = <Animal>[].obs;

  final selectedCategory = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Read the passed argument if available.
    final args = Get.arguments;
    if (args != null && args['category'] != null) {
      selectedCategory.value = args['category'];
    }
  }

  // Fetch animals by tag number.
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
}
