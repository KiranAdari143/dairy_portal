import 'dart:convert';
import 'dart:ffi';
import 'package:dairy_portal/app/data/groupmodel.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddgroupController extends GetxController {
  var isLoading = true.obs;
  var groupList = <Detail>[].obs;

  final groupNameController = TextEditingController();

  // List of group types (Strings)
  var animalTypes = <String>[].obs;
  var selectedAnimalType = "".obs;

  // List of farm IDs (stored as int) and selected farm ID (as String)
  var farmids = <int>[].obs;
  var farmides = "".obs; // Selected farm id as string

  RxString selectedcategory = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchTypes();
    fetchfarmIds();
    fetchGroups();
  }

  void clear() {
    groupNameController.clear();
  }

  Future<void> addGroup(String grptype, String farmids, String Category) async {
    String groupname = groupNameController.text.trim();
    if (groupname.isNotEmpty) {
      try {
        final Url = Uri.parse("http://13.234.230.143/createGroup");
        final response = await http.post(Url, body: {
          "groupName": groupname,
          "farm_id": farmids,
          "groupType": grptype,
          "groupCategory": Category
        }).timeout(Duration(seconds: 30));
        print("Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");

        if (response.statusCode == 200) {
          final responsedata = jsonDecode(response.body);
          if (responsedata["message"] == "Group created successfully") {
            Get.snackbar(
              "Success",
              "Group added successfully",
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
            clear();
            fetchGroups();
            Get.offAllNamed("/groupingscreen");
          } else {
            Get.snackbar(
              "Error",
              "Unexpected response: ${responsedata['message']}",
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        } else if (response.statusCode == 500) {
          final responseData = jsonDecode(response.body);
          final errorMessage = responseData['error'];

          if (errorMessage.contains("duplicate key value") &&
              errorMessage.contains("employee_data_pancard_no_key")) {
            Get.snackbar(
              "Error",
              "Pancardno already exists. Please use a different pancardno.",
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          } else if (errorMessage.contains("duplicate key value") &&
              errorMessage.contains("employee_data_bank_account_details_key")) {
            Get.snackbar(
              "Error",
              "bankaccountnumber already exists. Please use a different accountnumber.",
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          } else if (errorMessage.contains("duplicate key value") &&
              errorMessage.contains("employee_data_aadharcard_no_key")) {
            Get.snackbar(
              "Error",
              "adharnumber already exists. Please use a different adharnumber.",
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          } else {
            Get.snackbar(
              "Error",
              "adding employee failed",
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        } else {
          Get.snackbar(
            "Error",
            "Unexpected status code: ${response.statusCode}",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } catch (e) {
        Get.snackbar(
          "Error",
          "An error occurred: $e",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else {
      Get.snackbar(
        "Error",
        "Please enter the group name",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> fetchTypes() async {
    final url = "http://13.234.230.143/getAllGroupTypes";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final animalType = data['details'];
        for (int i = 0; i < animalType.length; i++) {
          animalTypes.add(animalType[i]['group_type']);
        }
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
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

  Future<void> fetchGroups() async {
    try {
      isLoading(true);
      final response =
          await http.get(Uri.parse('http://13.234.230.143/getAllGroups'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print('API Response: $data'); // Debugging: Print the API response
        Animalupdate animalUpdate = Animalupdate.fromJson(data);
        groupList.assignAll(animalUpdate.details);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e'); // Debugging: Print any errors
      Get.snackbar(
        "Error",
        "Failed to fetch groups: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }
}
