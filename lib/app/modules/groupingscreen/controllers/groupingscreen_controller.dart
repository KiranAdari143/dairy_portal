import 'dart:convert';
import 'package:dairy_portal/app/data/anmodel.dart';
import 'package:dairy_portal/app/data/groupmodel.dart';
import 'package:dairy_portal/app/data/models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class GroupingscreenController extends GetxController {
  var isLoading = true.obs;
  var groupList = <Detail>[].obs;
  var employeeList = <Employee>[].obs;
  var selectedEmployeeId = Rx<int?>(null);
  var selectedAnimalIds = <int>[].obs; // RxList for selected animal IDs
  RxList<AnimalModel> animals = <AnimalModel>[].obs;

  final groupNameController = TextEditingController();

  // Track which group IDs are selected for deletion.
  RxList<int> selectedGroupIds = <int>[].obs;

  @override
  void onInit() {
    fetchGroups();
    super.onInit();
  }

  void clear() {
    groupNameController.clear();
  }

  @override
  void dispose() {
    groupNameController.dispose();
    super.dispose();
  }

  // Toggle selection for a given group ID
  void toggleGroupSelection(int groupId) {
    if (selectedGroupIds.contains(groupId)) {
      selectedGroupIds.remove(groupId);
    } else {
      selectedGroupIds.add(groupId);
    }
  }

  // Delete selected groups
  Future<void> deleteSelectedGroups() async {
    final url = Uri.parse('http://13.234.230.143/deleteManyGroups');
    final body = jsonEncode({
      "groupIds": selectedGroupIds.toList(),
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        print("Groups deleted successfully: ${response.body}");
        Get.snackbar("Success", "Groups deleted successfully!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);

        // Clear selected IDs
        selectedGroupIds.clear();
        // Refresh group list
        await fetchGroups();
      } else {
        throw Exception('Failed to delete groups: ${response.statusCode}');
      }
    } catch (e) {
      print("Error deleting groups: $e");
      Get.snackbar(
        "Error",
        "Failed to delete groups: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> addGroup() async {
    String groupname = groupNameController.text.trim();

    try {
      final Url = Uri.parse("http://13.234.230.143/createGroup");
      final response = await http.post(Url,
          body: {"groupName": groupname}).timeout(Duration(seconds: 30));
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
          fetchGroups();
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

  Future<void> fetchEmployees() async {
    try {
      final response =
          await http.get(Uri.parse('http://13.234.230.143/getAllEmployeeData'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List<Employee> employees = (data['details'] as List)
            .map((json) => Employee.fromJson(json))
            .toList();
        employeeList.assignAll(employees);
      } else {
        throw Exception('Failed to load employee data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching employees: $e');
      Get.snackbar(
        "Error",
        "Failed to fetch employees: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> assignEmployeeToGroup(int groupId, int employeeId) async {
    try {
      final response = await http.post(
        Uri.parse('http://13.234.230.143/assignEmployeeToGroup'),
        body: jsonEncode({
          "groupId": groupId,
          "employeeId": employeeId,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          "Success",
          "Employee assigned successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        fetchGroups(); // Refresh group data
      } else {
        throw Exception('Failed to assign employee: ${response.statusCode}');
      }
    } catch (e) {
      print('Error assigning employee: $e');
      Get.snackbar(
        "Error",
        "Failed to assign employee: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> fetchAnimals() async {
    try {
      final response = await http
          .get(Uri.parse('http://13.234.230.143/getallAnimal'))
          .timeout(Duration(seconds: 15));
      print("Raw API Response: ${response.body}");

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['data'] != null) {
          List<AnimalModel> fetchedAnimals =
              (jsonResponse['data'] as List).map((data) {
            AnimalModel animal = AnimalModel.fromJson(data);
            return animal;
          }).toList();

          animals.assignAll(fetchedAnimals);
        } else {
          print("ERROR: 'data' field is missing or null in API response.");
        }
      } else {
        throw Exception('Failed to load animals');
      }
    } catch (e) {
      print("Error fetching animals: $e");
      Get.snackbar("Error", "Failed to load animals",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> addAnimalsToGroup(int groupid) async {
    final url = Uri.parse('http://13.234.230.143/addAnimalsToGroup');
    final body = jsonEncode({
      "groupId": groupid, // Replace with actual group ID
      "animalIds": selectedAnimalIds,
    });

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        print("Animals added successfully: ${response.body}");
        Get.snackbar("Success", "Animals added successfully!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
        fetchGroups();
      } else {
        throw Exception('Failed to add animals');
      }
    } catch (e) {
      print("Error adding animals: $e");
      Get.snackbar("Error", "Failed to add animals",
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
