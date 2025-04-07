import 'package:dairy_portal/app/data/getanimalmodel.dart';
import 'package:dairy_portal/app/data/medicinemodel.dart';
import 'package:dairy_portal/app/data/milkingdata.dart';
import 'package:dairy_portal/app/data/vac.dart';
import 'package:dairy_portal/app/data/vaccine.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:dairy_portal/app/data/BREED.dart';
import 'package:dairy_portal/app/data/breedingmodel.dart';
import 'package:dairy_portal/app/data/heat.dart';
import 'package:dairy_portal/app/data/pregnancy.dart';
import 'package:dairy_portal/app/data/pregnancymodel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AnimaldetailscreenController extends GetxController {
  late Animal animal; // Declare without initializing
  RxList<MedicineModel> medicineList = <MedicineModel>[].obs;
  RxList<VaccineModel> vaccineList = <VaccineModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    animal = Get.arguments as Animal; // Get argument safely
    print("Received animal id: ${animal.animalId}");
    print("Received animal id: ${animal.tagNo}");

    fetchBreed();
    fetchHeat();
    fetchpregnant();
    fetchMedicine();
    fetchVaccine();
    fetchMilkingDataForAnimal();
  }

  RxString sementype = "".obs;
  RxString inseminationstatus = "".obs;
  RxString inseminationresult = "".obs;
  RxString pregnancystatus = "".obs;
  RxString method = "".obs;
  // Reactive lists for breed and heat details.
  RxList<Breed> breedList = <Breed>[].obs;
  RxList<Heat> heatList = <Heat>[].obs;
  RxList<PregnancyModel> pregnancyList = <PregnancyModel>[].obs;

  final vaccinedate = TextEditingController();
  final medicineCosts = TextEditingController();
  final vaccinename = TextEditingController();
  final vaccinedescription = TextEditingController();
  final dosages = TextEditingController();

  final medicinedate = TextEditingController();
  final medicineCost = TextEditingController();
  final medicinename = TextEditingController();
  final medicinedescription = TextEditingController();
  final dosage = TextEditingController();

  final inseminationdate = TextEditingController();
  final pregnancydate = TextEditingController();
  final inseminationbreed = TextEditingController();
  final technicianname = TextEditingController();
  final techniciannotes = TextEditingController();

  final heatdate = TextEditingController();
  final heattime = TextEditingController();
  final observedby = TextEditingController();
  final score = TextEditingController();
  final comments = TextEditingController();
  final heatidentification = TextEditingController();
  final heattimeController = TextEditingController();

  final checkdat = TextEditingController();
  final identification = TextEditingController();
  final diagnostic = TextEditingController();
  final comment = TextEditingController();
  final pregnancyscreen = TextEditingController();

  // Fetch Breed Details and update the reactive list.
  Future<void> fetchBreed() async {
    print(animal.tagNo);
    final response = await http
        .get(Uri.parse(
            'http://13.234.230.143/getInseminationByAnimalTag?animalTagNo=${animal.tagNo}'))
        .timeout(Duration(seconds: 15));
    print("Breed response: ${response.body}");
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['details'];
      breedList
          .assignAll(jsonResponse.map((data) => Breed.fromJson(data)).toList());
    } else {
      throw Exception('Failed to load insemination details');
    }
  }

  Future<void> fetchpregnant() async {
    print(animal.tagNo);
    final response = await http
        .get(Uri.parse(
            'http://13.234.230.143/getPregnancyRecordsByAnimalTag?animalTagNo=${animal.tagNo}'))
        .timeout(Duration(seconds: 15));
    print("Breed response: ${response.body}");
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['details'];
      pregnancyList.assignAll(
          jsonResponse.map((data) => PregnancyModel.fromJson(data)).toList());
    } else {
      throw Exception('Failed to load Pregnancy details');
    }
  }

  // Fetch Heat Details and update the reactive list.
  Future<void> fetchHeat() async {
    print(animal.tagNo);
    final response = await http
        .get(Uri.parse(
            'http://13.234.230.143/getAllHeatRecordsByAnimalTag?animalTagNo=${animal.tagNo}'))
        .timeout(Duration(seconds: 15));
    print("Heat response: ${response.body}");
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['details'];
      heatList
          .assignAll(jsonResponse.map((data) => Heat.fromJson(data)).toList());
    } else {
      throw Exception('Failed to load heat details');
    }
  }

  Future<void> addInseminationdetails() async {
    String inseminationdates = inseminationdate.text.trim();
    String pregnancydates = pregnancydate.text.trim();
    String inseminationbreeds = inseminationbreed.text.trim();
    String techniciannames = technicianname.text.trim();
    String techniciannotess = techniciannotes.text.trim();
    const String apiUrl = "http://13.234.230.143/addInsemination";

    final inseminationrequest = Breedingmodel(
        animalTagno: animal.tagNo!,
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
        await fetchBreed();
        Get.back();
      } else {
        final errorData = jsonDecode(Response.body);
        print(
            "Failed to register Insemination details: ${errorData['message']}");
        Get.snackbar("Error",
            "Failed to register Insemination details: ${errorData['message']}",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      print("An error occurred during animal insemination details: $e");
      Get.snackbar("Error", "An error occurred: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  Future<void> addHeat() async {
    String heatdates = heatdate.text.trim();
    String heattimes = heattimeController.text.trim();
    String observed = observedby.text.trim();
    String scores = score.text.trim();
    String comment = comments.text.trim();
    String heatindentity = heatidentification.text.trim();
    const String apiUrl = "http://13.234.230.143/createHeatRecord";

    final heatRequest = Heat(
        animalTagNo: animal.tagNo!,
        heatDate: heatdates,
        heatTime: heattimes,
        observedBy: observed,
        score: scores,
        heatIdentificationDate: heatindentity,
        comments: comment);

    print(heatRequest.toJson());

    try {
      final Response = await http.post(Uri.parse(apiUrl),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(heatRequest.toJson()));
      print("Response received: ${Response.statusCode}");
      print("Response body: ${Response.body}");
      if (Response.statusCode == 200) {
        final responsedata = jsonDecode(Response.body);
        Get.snackbar("Success", "Heat details registered successfully!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
        await fetchHeat();
        Get.back();
      } else {
        final errorData = jsonDecode(Response.body);
        print("Failed to register HEAT details: ${errorData['message']}");
        Get.snackbar(
            "Error", "Failed to register heat details: ${errorData['message']}",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      print("An error occurred during animal Heat details: $e");
      Get.snackbar("Error", "An error occurred: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  Future<void> addPregnancy() async {
    String checkdates = checkdat.text.trim();
    String identity = identification.text.trim();
    String diagon = diagnostic.text.trim();
    String comm = comment.text.trim();
    String screening = pregnancyscreen.text.trim();
    const String apiUrl = "http://13.234.230.143/createPregnancyRecord";

    final pregnancyrequest = Pregnancy(
        animalTagNo: animal.tagNo!,
        checkdate: checkdates,
        identificationtype: identity,
        diagnosticresult: diagon,
        pregnancyscreening: screening,
        comments: comm);

    print(pregnancyrequest.toJson());

    try {
      final Response = await http.post(Uri.parse(apiUrl),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(pregnancyrequest.toJson()));
      print("Response received: ${Response.statusCode}");
      print("Response body: ${Response.body}");
      if (Response.statusCode == 200) {
        final responsedata = jsonDecode(Response.body);
        Get.snackbar("Success", "Pregnancy details registered successfully!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
        await fetchpregnant();
        Get.back();
      } else {
        final errorData = jsonDecode(Response.body);
        print("Failed to register Pregnancy details: ${errorData['message']}");
        Get.snackbar("Error",
            "Failed to register pregnancy details: ${errorData['message']}",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      print("An error occurred during animal pregnancy details: $e");
      Get.snackbar("Error", "An error occurred: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

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

  var milkingDataList = <MilkingData>[].obs;
  Future<void> fetchMilkingDataForAnimal({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final now = DateTime.now();
      final defaultStart = now.subtract(const Duration(days: 15));
      final sDate = startDate ?? defaultStart;
      final eDate = endDate ?? now;

      final formattedStart = DateFormat('yyyy-MM-dd').format(sDate);
      final formattedEnd = DateFormat('yyyy-MM-dd').format(eDate);

      final url = Uri.parse(
        'http://13.234.230.143/getMilkingSummaryForAnimal'
        '?startDate=$formattedStart'
        '&endDate=$formattedEnd'
        '&animalTagNo=${animal.tagNo}',
      );

      print("Fetching data from URL: $url"); // Debug: print URL

      final response = await http.get(url);
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List<dynamic> dataList = decoded['details'] ?? [];
        print("Data list length: ${dataList.length}");

        milkingDataList.value = dataList.map((item) {
          return MilkingData.fromJson(item);
        }).toList();
      } else {
        print('Error fetching milking data. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception while fetching milking data: $e');
    }
  }

  // Helper to format a date string (assumed in "yyyy-MM-dd") to "MM/dd"
  String formatToMMDD(String dateString) {
    final parsedDate = DateTime.parse(dateString);
    return DateFormat('MM/dd').format(parsedDate);
  }
}
