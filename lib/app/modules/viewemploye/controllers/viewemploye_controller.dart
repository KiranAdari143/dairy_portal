import 'dart:convert';
import 'package:dairy_portal/app/data/models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ViewemployeController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    loadEmployees();
  }

  RxList<Employee> employees = <Employee>[].obs;
  RxList<int> selectedEmployeeIds = <int>[].obs;

  // Toggle selection method
  void toggleEmployeeSelection(int id) {
    if (selectedEmployeeIds.contains(id)) {
      selectedEmployeeIds.remove(id);
    } else {
      selectedEmployeeIds.add(id);
    }
  }

  Future<void> loadEmployees() async {
    try {
      final fetchedEmployees = await fetchEmployees();
      employees.assignAll(fetchedEmployees);
    } catch (e) {
      // In case of any error, try loading from local storage.
      final cachedEmployees = await loadEmployeesFromCache();
      if (cachedEmployees.isNotEmpty) {
        employees.assignAll(cachedEmployees);
        Get.snackbar('Offline Mode', 'Showing cached employee data',
            backgroundColor: Colors.orange, colorText: Colors.white);
      } else {
        Get.snackbar('Error', 'No employees to display',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    }
  }

  // This function checks connectivity and returns employees list accordingly.
  Future<List<Employee>> fetchEmployees() async {
    // Check connectivity status.
    var connectivityResult = await Connectivity().checkConnectivity();
    final box = Hive.box('employeesBox');

    // If no internet, load from local cache.
    if (connectivityResult == ConnectivityResult.none) {
      return await loadEmployeesFromCache();
    } else {
      // Try fetching from API.
      final response = await http
          .get(Uri.parse('http://13.234.230.143/getAllEmployeeData'))
          .timeout(Duration(seconds: 15));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body)['details'];
        List<Employee> fetchedEmployees =
            jsonResponse.map((data) => Employee.fromJson(data)).toList();

        // Cache the data locally.
        box.put('employees', jsonEncode(jsonResponse));
        return fetchedEmployees;
      } else {
        throw Exception('Failed to load employees');
      }
    }
  }

  Future<List<Employee>> loadEmployeesFromCache() async {
    if (!Hive.isBoxOpen('employeesBox')) {
      await Hive.openBox('employeesBox');
    }
    final box = Hive.box('employeesBox');
    final String? cachedData = box.get('employees');
    if (cachedData != null) {
      List decodedData = jsonDecode(cachedData);
      return decodedData.map((data) => Employee.fromJson(data)).toList();
    }
    return [];
  }

  Future<void> deleteSelectedEmployees() async {
    final url = 'http://13.234.230.143/deleteManyEmployees';
    final body = jsonEncode({
      "employeeIds": selectedEmployeeIds.toList(),
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Employees deleted successfully",
            backgroundColor: Colors.green, colorText: Colors.white);
        // Clear selections.
        selectedEmployeeIds.clear();
        // Refresh the employees list.
        await loadEmployees();
      } else {
        Get.snackbar('Error', 'Failed to delete employees',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Exception', e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
