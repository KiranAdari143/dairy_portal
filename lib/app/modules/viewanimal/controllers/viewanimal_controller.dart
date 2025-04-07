import 'dart:convert';
import 'package:dairy_portal/app/data/getanimalmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// Controller for viewing animals
class ViewanimalController extends GetxController {
  RxList<Animal> animals = <Animal>[].obs;
  RxList<int> selectedanimalIds = <int>[].obs;

  // Toggle selection for an animal by its ID.
  void toggleAnimalSelection(int id) {
    if (selectedanimalIds.contains(id)) {
      selectedanimalIds.remove(id);
    } else {
      selectedanimalIds.add(id);
    }
  }

  @override
  void onInit() {
    loadAnimals();
    super.onInit();
  }

  Future<List<Animal>> fetchAnimals() async {
    final response = await http
        .get(Uri.parse('http://13.234.230.143/getallAnimal'))
        .timeout(const Duration(seconds: 15));
    print("response: ${response.body}");
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['data'];
      return jsonResponse.map((data) => Animal.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load animals');
    }
  }

  Future<void> loadAnimals() async {
    try {
      final fetchedAnimals = await fetchAnimals();
      animals.assignAll(fetchedAnimals);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load animals',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> deleteSelectedAnimals() async {
    final url = 'http://13.234.230.143/deleteManyAnimals';
    final body = jsonEncode({
      "animalIds": selectedanimalIds.toList(),
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Animals deleted successfully",
            backgroundColor: Colors.green, colorText: Colors.white);
        // Clear selections.
        selectedanimalIds.clear();
        // Refresh the animal list.
        await loadAnimals();
      } else {
        Get.snackbar('Error', 'Failed to delete animals',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Exception', e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
