import 'dart:convert';

import 'package:dairy_portal/app/data/animalupdatemodels.dart';
import 'package:dairy_portal/app/data/getanimalmodel.dart';
import 'package:dairy_portal/app/modules/viewanimal/controllers/viewanimal_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class EditanimalController extends GetxController {
  ViewanimalController controller = Get.put(ViewanimalController());

  late final Animal animal;
  final animalids = TextEditingController();
  final animaltype = TextEditingController();
  final age = TextEditingController();
  final dob = TextEditingController();
  final status = TextEditingController();
  final lactationno = TextEditingController();
  final breedtype = TextEditingController();
  final gender = TextEditingController();
  final lastpregnantdate = TextEditingController();
  final expecteddeliverydate = TextEditingController();
  final lastheatdate = TextEditingController();
  final lastinseminationdate = TextEditingController();
  final parenttagid = TextEditingController();
  final vendorname = TextEditingController();
  final farmerid = TextEditingController();
  final mothertag = TextEditingController();
  final fathertag = TextEditingController();
  final weight = TextEditingController();
  final milkingstatus = TextEditingController();

  // Helper function to format dates
  String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      DateTime dateTime = DateTime.parse(dateStr);
      return DateFormat('yyyy-MM-dd').format(dateTime);
    } catch (e) {
      return dateStr; // Return original string if parsing fails
    }
  }

  @override
  void onInit() {
    super.onInit();
    controller.fetchAnimals();
    animal = Get.arguments as Animal;

    animalids.text = animal.animalId.toString();
    animaltype.text = animal.animalType;

    // Remove " years" from age string (if it's a string like "2 years")
    age.text = animal.age.toString().replaceAll(' years', '');

    // Format date fields to 'yyyy-MM-dd'
    dob.text = formatDate(animal.dob.toString());
    status.text = animal.status.toString();
    lactationno.text = animal.lactationNo.toString();
    breedtype.text = animal.breedType.toString();
    gender.text = animal.gender.toString();
    lastpregnantdate.text = formatDate(animal.lastPregnantDate.toString());
    expecteddeliverydate.text =
        formatDate(animal.expectedDeliveryDate.toString());
    lastheatdate.text = animal.lastHeatDate != null
        ? formatDate(animal.lastHeatDate.toString())
        : '';
    lastinseminationdate.text =
        formatDate(animal.lastInseminationDate.toString());
    parenttagid.text = animal.parentTagId.toString();
    vendorname.text = animal.vendorName.toString();
    farmerid.text = animal.farmId.toString();
    mothertag.text = animal.motherTag.toString();
    fathertag.text = animal.fatherTag.toString();
    weight.text = animal.weight.toString();
    milkingstatus.text = animal.milkingStatus.toString();
  }

  Future<void> updateAnimal() async {
    final int? parsedAge = int.tryParse(age.text.split(" ")[0]);

    // Prepare the request object with corrected data
    final animalUpdate = AnimalUpdateRequest(
      animalId: animalids.text,
      animalType: animaltype.text,
      age: parsedAge, // Ensure `age` is passed as a number
      dob: dob.text,
      status: status.text,
      lactationNo: lactationno.text,
      breedType: breedtype.text,
      gender: gender.text,
      lastPregnantDate: lastpregnantdate.text,
      expectedDeliveryDate: expecteddeliverydate.text,
      lastHeatDate:
          lastheatdate.text.isEmpty ? null : lastheatdate.text, // Handle nulls
      lastInseminationDate: lastinseminationdate.text,
      parentTagId:
          parenttagid.text.isEmpty ? null : parenttagid.text, // Handle nulls
      vendorName: vendorname.text,
      farmerId: farmerid.text,
      motherTag: mothertag.text,
      fatherTag: fathertag.text,
      weight: weight.text,
      milkingStatus: milkingstatus.text,
    );

    try {
      print("Sending request: ${jsonEncode(animalUpdate.toJson())}");
      final response = await http
          .post(
            Uri.parse('http://13.234.230.143/animalUpdate'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(animalUpdate.toJson()),
          )
          .timeout(Duration(seconds: 10));

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final responsestate = jsonDecode(response.body);

        if (responsestate['message'] == "Animal updated successfully" ||
            responsestate["statusCode"] == 200) {
          Get.snackbar("Success", "Animal updated successfully",
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.green,
              colorText: Colors.white);
          controller.fetchAnimals();
          Get.offAllNamed("/viewanimal");
        } else {
          Get.snackbar("Error",
              "Failed to update Animal: ${responsestate['message'] ?? response.body}");
        }
      } else {
        Get.snackbar(
            "Error", "Failed to update animal details: ${response.body}");
      }
    } catch (e) {
      print("Exception: $e");
      Get.snackbar("Error", "An error occurred: $e");
    }
  }
}
