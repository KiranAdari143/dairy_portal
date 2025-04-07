import 'dart:convert';

import 'package:dairy_portal/app/data/BREED.dart';
import 'package:dairy_portal/app/data/breedingmodel.dart';
import 'package:dairy_portal/app/data/getanimalmodel.dart';
import 'package:dairy_portal/app/data/heat.dart';
import 'package:dairy_portal/app/data/pregnancy.dart';
import 'package:dairy_portal/app/data/pregnancymodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class InseminationdetailsreenController extends GetxController {
  late Animal animal; // Declare without initializing
  RxString sementype = "".obs;
  RxString inseminationstatus = "".obs;
  RxString inseminationresult = "".obs;
  RxString pregnancystatus = "".obs;
  RxString method = "".obs;
  // Reactive lists for breed and heat details.
  RxList<Breed> breedList = <Breed>[].obs;
  RxList<Heat> heatList = <Heat>[].obs;
  RxList<PregnancyModel> pregnancyList = <PregnancyModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    animal = Get.arguments as Animal; // Get argument safely
    fetchBreed();
    fetchHeat();
    fetchpregnant();
  }

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
}
