import 'dart:convert';
import 'package:dairy_portal/app/data/addmedicinemodels.dart';
import 'package:dairy_portal/app/data/inseminationmodel.dart';
import 'package:dairy_portal/app/data/vaccinationmodels.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AnimaldataController extends GetxController {
  var selectedspecies = ''.obs;
  var selectedBreed = ''.obs;
  var selecteddropdownitems = <String>[].obs;
  RxString selectedGender = ''.obs;
  RxString age = "".obs;
  RxString status = "".obs;
  RxBool isVaccinationVisible = false.obs;
  RxString type = "".obs;
  RxBool isMedicineVisible = false.obs;
  RxBool isInsemination = false.obs;
  RxString method = "".obs;
  RxString sementype = "".obs;
  RxString inseminationstatus = "".obs;
  RxString inseminationresult = "".obs;
  final RxBool isEmployeeExpanded = false.obs;
  final RxBool isAnimalExpanded = false.obs;
  RxString pregnancystatus = "".obs;

  RxInt animalId = 0.obs;

  @override
  void onInit() {
    if (Get.arguments != null && Get.arguments['animal_id'] != null) {
      animalId.value = Get.arguments["animal_id"];
      print("received animalid: $animalId");
    } else {
      print("Animal id not found in arguments");
    }
    super.onInit();
  }

  void calculateAge(DateTime dob) {
    final now = DateTime.now();
    int ageInYears = now.year - dob.year;
    int ageInMonths = now.month - dob.month;

    // If the birthday hasn't occurred yet this year, reduce the age by 1 year
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      ageInYears--;
      ageInMonths = (ageInMonths + 12) % 12; // Ensure months are positive
    }

    // If the month difference is negative, adjust the year calculation
    if (ageInMonths < 0) {
      ageInMonths += 12;
    }

    // Store the result
    age.value = "$ageInYears years ${ageInMonths} months";
  }

  void toggleVaccinationVisibility() {
    isVaccinationVisible.value = !isVaccinationVisible.value;
  }

  void toggleMedicinationVisible() {
    isMedicineVisible.value = !isMedicineVisible.value;
  }

  void toggleInseminationVisible() {
    isInsemination.value = !isInsemination.value;
  }

  final inseminationdate = TextEditingController();
  final pregnancydate = TextEditingController();
  final inseminationbreed = TextEditingController();
  final technicianname = TextEditingController();
  final techniciannotes = TextEditingController();

  final vaccinenamecontroller = TextEditingController();
  final dosagecontroller = TextEditingController();
  final vaccinedate = TextEditingController();

  final startdate = TextEditingController();
  final enddate = TextEditingController();
  final medicinename = TextEditingController();
  final medicinedescription = TextEditingController();
  final medicinetype = TextEditingController();

  Future<bool> addInseminationdetails() async {
    String inseminationdates = inseminationdate.text.trim();
    String pregnancydates = pregnancydate.text.trim();
    String inseminationbreeds = inseminationbreed.text.trim();
    String techniciannames = technicianname.text.trim();
    String techniciannotess = techniciannotes.text.trim();
    const String apiUrl = "http://13.234.230.143/addInsemination";

    final inseminationrequest = Insemination(
        animalId: animalId.value,
        inseminationType: method.value,
        inseminationDate: inseminationdates,
        inseminationBreed: inseminationbreeds,
        semenType: sementype.value,
        inseminationTechnician: techniciannames,
        inseminationStatus: inseminationstatus.value,
        technicianNotes: techniciannotess,
        pregnancyDate: pregnancydates,
        pregnancyStatus: pregnancystatus.value,
        inseminationResult: inseminationresult.value);

    print(inseminationrequest.toJson());

    try {
      final Response = await http.post(Uri.parse(apiUrl),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(inseminationrequest.toJson()));
      print("Response received: ${Response.statusCode}");
      print("Response body: ${Response.body}");
      if (Response.statusCode == 200) {
        final responsedata = jsonDecode(Response.body);
        Get.snackbar("Success", "Insemination details registered successfully!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
        return true;
      } else {
        final errorData = jsonDecode(Response.body);
        print(
            "Failed to register Insemination details: ${errorData['message']}");
        Get.snackbar("Error",
            "Failed to register Insemination details: ${errorData['message']}",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return false;
      }
    } catch (e) {
      print("An error occurred during animal insemination details: $e");
      Get.snackbar("Error", "An error occurred: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return false;
    }
  }

  Future<bool> addVaccination() async {
    String vaccinenamecontrollers = vaccinenamecontroller.text.trim();
    String dosagecontrollers = dosagecontroller.text.trim();
    String vaccinedates = vaccinedate.text.trim();

    const String apiUrl = "http://13.234.230.143/addVaccination";

    final vaccinationrequest = Vaccination(
        animalId: animalId.value,
        vaccineName: vaccinenamecontrollers,
        vaccineType: type.value,
        vaccineDate: vaccinedates,
        dosage: dosagecontrollers);

    try {
      final response = await http.post(Uri.parse(apiUrl),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(vaccinationrequest.toJson()));

      print("Response received: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final responsedata = jsonDecode(response.body);
        Get.snackbar("Success", "Vaccination registered successfully!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        print(
            "Failed to register vaccination details: ${errorData['message']}");
        Get.snackbar("Error",
            "Failed to register vaccination details: ${errorData['message']}",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return false;
      }
    } catch (e) {
      print("An error occurred during animal vaccination details: $e");
      Get.snackbar("Error", "An error occurred: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return false;
    }
  }

  Future<bool> addMedicine() async {
    String startdates = startdate.text.trim();
    String enddates = enddate.text.trim();
    String medicinenames = medicinename.text.trim();
    String medicinedesc = medicinedescription.text.trim();
    String medicinetypes = medicinetype.text.trim();

    const String apiUrl = "http://13.234.230.143/medicineRegister";

    final medicinedetails = Medicine(
        animalId: animalId.value,
        medicineName: medicinenames,
        medicineDescription: medicinedesc,
        startDate: startdates,
        endDate: enddates,
        medicineType: medicinetypes);

    try {
      final response = await http.post(Uri.parse(apiUrl),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(medicinedetails.toJson()));

      print("Response received: ${response.body}");
      print("response statuscode: ${response.statusCode}");

      if (response.statusCode == 200) {
        final responsedata = jsonDecode(response.body);
        Get.snackbar("Success", "Medicine registered successfully!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        print("Failed to register Medicine details: ${errorData['message']}");
        Get.snackbar("Error",
            "Failed to register Medicine details: ${errorData['message']}",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return false;
      }
    } catch (e) {
      print("An error occurred during animal Medicine details: $e");
      Get.snackbar("Error", "An error occurred: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return false;
    }
  }
}
