import 'dart:convert';

import 'package:dairy_portal/app/data/getanimalmodel.dart';
import 'package:dairy_portal/app/data/medicinemodel.dart';
import 'package:dairy_portal/app/data/vac.dart';
import 'package:dairy_portal/app/data/vaccine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class VaccinationdetailscreenController extends GetxController {
  late Animal animal; // Declare without initializing
  RxList<VaccineModel> vaccineList = <VaccineModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    animal = Get.arguments as Animal; // Get argument safely
    fetchVaccine();
  }

  final vaccinedate = TextEditingController();
  final medicineCost = TextEditingController();
  final vaccinename = TextEditingController();
  final vaccinedescription = TextEditingController();
  final dosage = TextEditingController();

  // Fetch the medicines and update the reactive list.
  Future<void> fetchVaccine() async {
    try {
      final response = await http
          .get(Uri.parse(
              'http://13.234.230.143/getVaccineByAnimalId?animalId=${animal.animalId}'))
          .timeout(Duration(seconds: 15));
      // Debug print
      print("Fetch Vaccine Response: ${response.body}");
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body)['details'];
        vaccineList.assignAll(
          jsonResponse.map((data) => VaccineModel.fromJson(data)).toList(),
        );
      } else {
        throw Exception('Failed to load Vaccines');
      }
    } catch (e) {
      print("Error fetching Vaccines: $e");
      Get.snackbar("Error", "Failed to load Vaccines",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> addVaccine() async {
    // Trim and collect values from text fields
    String vaccinedates = vaccinedate.text.trim();
    String vaccinenames = vaccinename.text.trim();
    String vaccinedesc = vaccinedescription.text.trim();
    String dosages = dosage.text.trim();

    // Validate that numeric fields are not empty
    if (dosages.isEmpty) {
      Get.snackbar(
        "Error",
        "Dosage and Medicine Cost cannot be empty.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Attempt to parse numeric fields safely using int.tryParse
    int? parsedDosage = int.tryParse(dosages);

    if (parsedDosage == null) {
      Get.snackbar(
        "Error",
        "Please enter valid numeric values for cost and dosage.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    const String apiUrl = "http://13.234.230.143/addVaccination";

    // Create the medicine model instance using the parsed numbers
    final vaccinedetails = Vaccin(
        animalId: animal.animalId,
        vaccineName: vaccinenames,
        vaccineType: vaccinedesc,
        vaccineDate: vaccinedates,
        dosage: dosages);

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(vaccinedetails.toJson()),
      );

      print("Response received: ${response.body}");
      print("response statuscode: ${response.statusCode}");

      if (response.statusCode == 200) {
        final responsedata = jsonDecode(response.body);
        Get.snackbar(
          "Success",
          "Vaccine registered successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        fetchVaccine();
        Get.back(); // Close the popup automatically.
      } else {
        final errorData = jsonDecode(response.body);
        print("Failed to register Vaccine details: ${errorData['message']}");
        Get.snackbar(
          "Error",
          "Failed to register Vaccine details: ${errorData['message']}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("An error occurred during animal Vaccine details: $e");
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
    vaccinedate.clear();
    medicineCost.clear();
    vaccinename.clear();
    vaccinedescription.clear();
    dosage.clear();
  }
}
