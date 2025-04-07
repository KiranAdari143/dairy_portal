import 'dart:convert';

import 'package:dairy_portal/app/data/models.dart';
import 'package:dairy_portal/app/modules/viewemploye/controllers/viewemploye_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class EditemployeController extends GetxController {
  ViewemployeController controller = ViewemployeController();

  late final Employee employee;
  final employeid = TextEditingController();
  final nameController = TextEditingController();
  final gendercontroller = TextEditingController();
  final dobcontroller = TextEditingController();
  final contactnocontroller = TextEditingController();
  final agecontroller = TextEditingController();
  final experiencecontroller = TextEditingController();
  final joiningdatecontroller = TextEditingController();
  final emergencynocontroller = TextEditingController();
  final permanentaddresscontroller = TextEditingController();
  final employetypecontroller = TextEditingController();
  final jobrolecontroller = TextEditingController();
  final departmentcontroller = TextEditingController();
  final accountnocontroller = TextEditingController();
  final salarycontroller = TextEditingController();
  final ifsccontroller = TextEditingController();
  final pancardcontroller = TextEditingController();
  final adhaarnocontroller = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    controller.fetchEmployees();
    employee = Get.arguments as Employee;
    employeid.text = employee.employeeId.toString();
    nameController.text = employee.employeeName;
    gendercontroller.text = employee.gender;
    dobcontroller.text = employee.dateOfBirth;
    agecontroller.text = employee.age.toString();
    contactnocontroller.text = employee.phone;
    experiencecontroller.text = employee.yearsOfExperience.toString();
    joiningdatecontroller.text = employee.joiningDate;
    emergencynocontroller.text = employee.emergencyNo;
    permanentaddresscontroller.text = employee.address;
    employetypecontroller.text = employee.employeeType;
    jobrolecontroller.text = employee.jobRole;
    departmentcontroller.text = employee.department;
    accountnocontroller.text = employee.bankAccountDetails;
    salarycontroller.text = employee.salaryAmount.toString();
    ifsccontroller.text = employee.ifscCode;
    pancardcontroller.text = employee.pancardNo;
    adhaarnocontroller.text = employee.aadharcardNo;
  }

  Future<void> updateEmployee() async {
    final updateEmployee = Employee(
      employeeId: employee.employeeId,
      employeeName: nameController.text,
      age: int.parse(agecontroller.text),
      aadharcardNo: adhaarnocontroller.text,
      pancardNo: pancardcontroller.text,
      address: permanentaddresscontroller.text,
      department: departmentcontroller.text,
      yearsOfExperience: int.parse(experiencecontroller.text),
      joiningDate: joiningdatecontroller.text,
      salaryAmount: double.parse(salarycontroller.text),
      bankAccountDetails: accountnocontroller.text,
      gender: gendercontroller.text,
      phone: contactnocontroller.text,
      emergencyNo: emergencynocontroller.text,
      employeeType: employetypecontroller.text,
      jobRole: jobrolecontroller.text,
      ifscCode: ifsccontroller.text,
      dateOfBirth: dobcontroller.text,
    );

    try {
      print("Sending request: ${jsonEncode(updateEmployee.toJson())}");
      final response = await http
          .post(
            Uri.parse('http://13.234.230.143/updateEmployee'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(updateEmployee.toJson()),
          )
          .timeout(Duration(seconds: 10));

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final responsestate = jsonDecode(response.body);
        print("Responsestate: $responsestate");

        if (responsestate['message'] == "Employee updated successfully!" ||
            responsestate["statusCode"] == 200) {
          Get.snackbar("Success", "Employee updated successfully",
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.green,
              colorText: Colors.white);
          controller.fetchEmployees();
          Get.offAllNamed("/viewemploye");
        } else {
          Get.snackbar("Error",
              "Failed to update employee: ${responsestate['message'] ?? response.body}");
        }
      } else {
        Get.snackbar("Error", "Failed to update employee: ${response.body}");
      }
    } catch (e) {
      print("Exception: $e");
      Get.snackbar("Error", "An error occurred: $e");
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    gendercontroller.dispose();
    dobcontroller.dispose();
    contactnocontroller.dispose();
    agecontroller.dispose();
    experiencecontroller.dispose();
    joiningdatecontroller.dispose();
    emergencynocontroller.dispose();
    permanentaddresscontroller.dispose();
    employetypecontroller.dispose();
    jobrolecontroller.dispose();
    departmentcontroller.dispose();
    accountnocontroller.dispose();
    salarycontroller.dispose();
    ifsccontroller.dispose();
    pancardcontroller.dispose();
    adhaarnocontroller.dispose();
    super.onClose();
  }

  Future<List<Employee>> fetchEmployees() async {
    final response = await http
        .get(Uri.parse('http://13.234.230.143/getAllEmployeeData'))
        .timeout(Duration(seconds: 15));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['details'];
      return jsonResponse.map((data) => Employee.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load employees');
    }
  }

  Future<void> deleteEmployee(String employeeId) async {
    try {
      final response = await http.post(
        Uri.parse('http://13.234.230.143/deleteEmployee'),
        body: {
          "employee_id": employeeId,
        },
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Employee deleted successfully",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white);
        fetchEmployees(); // Refresh the list
        Get.offAllNamed("/viewemploye");
      } else {
        Get.snackbar("Error", "Failed to delete employee: ${response.body}");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    }
  }
}
