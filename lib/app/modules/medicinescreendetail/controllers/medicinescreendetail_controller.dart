import 'dart:convert';

import 'package:dairy_portal/app/data/addmedicinemodels.dart';
import 'package:dairy_portal/app/data/getanimalmodel.dart';
import 'package:dairy_portal/app/data/medicinemodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class MedicinescreendetailController extends GetxController {
  late Animal animal; // Declare without initializing
  RxList<MedicineModel> medicineList = <MedicineModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    animal = Get.arguments as Animal; // Get argument safely
    fetchMedicine();
  }

  final medicinedate = TextEditingController();
  final medicineCost = TextEditingController();
  final medicinename = TextEditingController();
  final medicinedescription = TextEditingController();
  final dosage = TextEditingController();

  // Fetch the medicines and update the reactive list.
  Future<void> fetchMedicine() async {
    try {
      final response = await http
          .get(Uri.parse(
              'http://13.234.230.143/getMedicinesByAnimalTag?animal_id=${animal.animalId}'))
          .timeout(Duration(seconds: 15));
      // Debug print
      print("Fetch Medicine Response: ${response.body}");
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body)['details'];
        medicineList.assignAll(
          jsonResponse.map((data) => MedicineModel.fromJson(data)).toList(),
        );
      } else {
        throw Exception('Failed to load medicines');
      }
    } catch (e) {
      print("Error fetching medicines: $e");
      Get.snackbar("Error", "Failed to load medicines",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> addMedicine() async {
    // Trim and collect values from text fields.
    String medicineDateText = medicinedate.text.trim();
    String medicineNameText = medicinename.text.trim();
    String medicineDescText = medicinedescription.text.trim();
    String dosageText = dosage.text.trim();
    String medicineCostText = medicineCost.text.trim();

    // Validate that numeric fields are not empty.
    if (dosageText.isEmpty || medicineCostText.isEmpty) {
      Get.snackbar(
        "Error",
        "Dosage and Medicine Cost cannot be empty.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Attempt to parse numeric fields safely.
    int? parsedDosage = int.tryParse(dosageText);
    int? parsedCost = int.tryParse(medicineCostText);

    if (parsedDosage == null || parsedCost == null) {
      Get.snackbar(
        "Error",
        "Please enter valid numeric values for cost and dosage.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // API endpoint URL.
    const String apiUrl = "http://13.234.230.143/medicineRegister";

    // Create the MedicineModel instance.
    final medicinedetails = MedicineModel(
      animalId: animal.animalId,
      medicineName: medicineNameText,
      medicineDescription: medicineDescText,
      medicineDate: medicineDateText,
      medicineCost: parsedCost,
      dosage: parsedDosage,
    );

    try {
      // Send the POST request.
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(medicinedetails.toJson()),
      );

      print("Response received: ${response.body}");
      print("Response status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        // If the response is successful, show success snackbar.
        Get.snackbar(
          "Success",
          "Medicine registered successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        await fetchMedicine();
        Get.back(); // Close the popup automatically.
      } else {
        // Otherwise, decode the error message and show error snackbar.
        final errorData = jsonDecode(response.body);
        print("Failed to register Medicine details: ${errorData['message']}");
        Get.snackbar(
          "Error",
          "Failed to register Medicine details: ${errorData['message']}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Handle any exceptions during the HTTP call.
      print("An error occurred during medicine registration: $e");
      Get.snackbar(
        "Error",
        "An error occurred: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void clear() {
    medicinedate.clear();
    medicineCost.clear();
    medicinename.clear();
    medicinedescription.clear();
    dosage.clear();
  }
}
