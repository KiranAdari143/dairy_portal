import 'dart:convert';
import 'dart:io';
import 'package:dairy_portal/app/data/animalmodels.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddanimalController extends GetxController {
  var selectedspecies = ''.obs;
  var selectedBreed = ''.obs;
  var selecteddropdownitems = <String>[].obs;
  RxString selectedGender = "".obs;
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
  Rx<File?> selectedImage = Rx<File?>(null);
  final RxBool isEmployeeExpanded = false.obs;
  final RxBool isAnimalExpanded = false.obs;
  final now = DateTime.now();
  var farmids = <int>[].obs;
  var farmides = "".obs; // Selected farm id as string

  final cowOptions = ["Holstein", "Jersey", "Friesian"];
  final buffaloOptions = ["Murrah", "Nili-Ravi", "Jafarabadi"];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchfarmIds();
  }

  void selectedimage() async {
    ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    print("Image selection initiated");
    if (image != null) {
      selectedImage.value = File(image.path);
      print("Image selected: ${image.path}");
    } else {
      print("No image selected");
    }
  }

  void updateselectdropdown(String species) {
    print("Dropdown update initiated for species: $species");
    if (species == "Cow") {
      selecteddropdownitems.assignAll(cowOptions);
      print("Dropdown updated with cow options: $cowOptions");
    } else if (species == "Buffalo") {
      selecteddropdownitems.assignAll(buffaloOptions);
      print("Dropdown updated with buffalo options: $buffaloOptions");
    } else {
      print("No matching species found. Dropdown remains unchanged.");
    }
  }

  void toggleVaccinationVisibility() {
    isVaccinationVisible.value = !isVaccinationVisible.value;
    print("Vaccination visibility toggled to: ${isVaccinationVisible.value}");
  }

  void toggleMedicinationVisible() {
    isMedicineVisible.value = !isMedicineVisible.value;
    print("Medicine visibility toggled to: ${isMedicineVisible.value}");
  }

  void toggleInseminationVisible() {
    isInsemination.value = !isInsemination.value;
    print("Insemination visibility toggled to: ${isInsemination.value}");
  }

  final farmerIdController = TextEditingController();
  final tagNoController = TextEditingController();
  final lastPregnantDateController = TextEditingController();
  final expectedDeliveryDateController = TextEditingController();
  final lastInseminationDateController = TextEditingController();
  final vendorNameController = TextEditingController();
  final motherTagController = TextEditingController();
  final fatherTagController = TextEditingController();
  final weightcontroller = TextEditingController();
  final dateController = TextEditingController();
  final lactationno = TextEditingController();

  void clearfields() {
    print("Clearing all form fields");
    farmerIdController.clear();
    tagNoController.clear();
    dateController.clear();
    status.value = "";
    weightcontroller.clear();
    lastPregnantDateController.clear();
    expectedDeliveryDateController.clear();
    lastInseminationDateController.clear();
    vendorNameController.clear();
    motherTagController.clear();
    fatherTagController.clear();
    selectedGender.value = "";
    selectedBreed.value = "";
    selectedspecies.value = "";
    print("All fields cleared");
  }

  Future<void> addAnimal() async {
    String tagNoControllers = tagNoController.text.trim();
    String dobs = dateController.text.trim();
    String lactationnos = lactationno.text.trim();
    String vendorNameControllers = vendorNameController.text.trim();
    String farmerIdControllers = farmerIdController.text.trim();
    String motherTagControllers = motherTagController.text.trim();
    String fatherTagControllers = fatherTagController.text.trim();
    String weightcontrollers = weightcontroller.text.trim();

    const String apiUrl = "http://13.234.230.143/animalRegister";

    final animalRequest = AnimalRegisterRequest(
      animalType: selectedspecies.value,
      tagNo: tagNoControllers,
      dob: dobs,
      status: status.value,
      lactationNo: lactationnos,
      breedType: selectedBreed.value,
      gender: selectedGender.value,
      lastPregnantDate:
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
      expectedDeliveryDate:
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
      lastInseminationDate:
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
      vendorName: vendorNameControllers,
      farmid: farmides.value,
      motherTag: motherTagControllers,
      fatherTag: fatherTagControllers,
      weight: weightcontrollers,
      milkingStatus: status.value,
    );

    print("Animal registration initiated with data: ${animalRequest.toJson()}");

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(animalRequest.toJson()),
      );
      print("Response received: ${response.statusCode}");
      print("Response body: ${response.body}");
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final animalId = responseData['details']['animal']['animal_id'];
        print("Animal registered successfully: $responseData");
        Get.snackbar("Success", "Animal registered successfully!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
        Get.toNamed("/animaldata", arguments: {"animal_id": animalId});
      } else {
        final errorData = jsonDecode(response.body);
        print("Failed to register animal: ${errorData['message']}");
        Get.snackbar(
            "Error", "Failed to register animal: ${errorData['message']}",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print("An error occurred during animal registration: $e");
      Get.snackbar("Error", "An error occurred: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> fetchfarmIds() async {
    final url = "http://13.234.230.143/getAllPastures";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final pastureids = data['details'];
        for (int i = 0; i < pastureids.length; i++) {
          farmids.add(pastureids[i]['pasture_id']);
        }
        print("Farm IDs: $farmids");
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }
}
