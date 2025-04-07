import 'dart:convert';
import 'package:dairy_portal/app/data/anmodel.dart';
import 'package:dairy_portal/app/data/groupmodel.dart';
import 'package:dairy_portal/app/data/models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ViewgroupdetailsController extends GetxController {
  // Store selected sessions and text controllers per animal
  var selectedSessions = <String, String>{}.obs;
  var quantityControllers = <String, TextEditingController>{}.obs;
  var quantityController =
      TextEditingController(); // Controller for quantity input
  var selectedSession = ''.obs; // Ensure this is a String, not an int
  var isLoading = true.obs;
  var groupList = <Detail>[].obs;
  var groupDetail = Rx<Detail?>(null); // Reactive group data
  var employeeList = <Employee>[].obs;
  var selectedEmployeeId = Rx<int?>(null);
  var selectedAnimalIds = <int>[].obs; // RxList for selected animal IDs
  RxList<AnimalModel> animals = <AnimalModel>[].obs;
  final Detail group = Get.arguments as Detail;
  String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void onInit() {
    super.onInit();
    final Detail group = Get.arguments as Detail;
    fetchGroups();
  }

  Future<void> fetchGroups() async {
    try {
      isLoading(true);

      final response =
          await http.get(Uri.parse('http://13.234.230.143/getAllGroups'));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        Animalupdate animalUpdate = Animalupdate.fromJson(data);
        groupList.assignAll(animalUpdate.details);

        if (groupList.isNotEmpty) {
          groupDetail.value = groupList.firstWhere(
            (g) =>
                g.groupId ==
                group
                    .groupId, // Use `group` argument instead of `groupDetail.value`
            orElse: () => groupList.first, // Ensure a fallback
          );
        }

        // update();
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
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

  Future<void> addMilkingRecord(
      String animalTagNo, String quantity, String session) async {
    final String url = "http://13.234.230.143/upsertMilkingRecord";

    final Map<String, dynamic> requestBody = {
      "animalTagNo": int.parse(animalTagNo),
      "quantity": int.parse(quantity),
      "date": currentDate,
      "session": session
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        Get.snackbar(
          "added",
          "Success: ${responseData['message']}",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        print("Success: ${responseData['message']}");
      } else {
        print("Error: ${response.body}");
      }
    } catch (error) {
      print("Exception: $error");
      throw error;
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

  Future<void> removeAnimalsFromGroup(int groupId, List<int> animalIds) async {
    final url = Uri.parse('http://13.234.230.143/removeAnimalsFromGroup');
    final body = jsonEncode({
      "groupId": groupId,
      "animalIds": animalIds,
    });

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        print("Animals removed successfully: ${response.body}");
        Get.snackbar("Success", "Animals removed successfully!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } else {
        throw Exception('Failed to remove animals: ${response.statusCode}');
      }
    } catch (e) {
      print("Error removing animals: $e");
      Get.snackbar("Error", "Failed to remove animals",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  Future<void> addAnimalsToGroup(int groupId) async {
    final url = Uri.parse('http://13.234.230.143/addAnimalsToGroup');
    final body = jsonEncode({
      "groupId": groupId,
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
        var responseJson = jsonDecode(response.body);

        // Check the type of the 'details' field in the response
        if (responseJson['details'] is List) {
          // Assume success when 'details' is a List
          bool isSuccess = false;
          for (var detail in responseJson['details']) {
            if (detail['group_id'] == groupId) {
              isSuccess = true;
              break;
            }
          }
          if (isSuccess) {
            Get.snackbar(
              "Success",
              "Animals added successfully!",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
          } else {
            // If for some reason the expected group_id is not found, fallback
            Get.snackbar(
              "Error",
              "Unexpected response details",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        } else if (responseJson['details'] is Map) {
          // When details is a Map, check for the specific message.
          if (responseJson['details']['message'] ==
              "No animals were added to the group as they are already assigned to other groups.") {
            Get.snackbar(
              "Info",
              "Animal added in another group",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.orange,
              colorText: Colors.white,
            );
          } else {
            // Fallback in case the map doesn't contain the expected message.
            Get.snackbar(
              "Success",
              "Animals added successfully!",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
          }
        }

        await fetchGroups(); // Refresh group data
        selectedAnimalIds.clear(); // Clear selected animals
        update();
      } else {
        throw Exception('Failed to add animals');
      }
    } catch (e) {
      print("Error adding animals: $e");
      Get.snackbar(
        "Error",
        "Failed to add animals",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
