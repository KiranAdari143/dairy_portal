import 'dart:convert';
import 'package:dairy_portal/app/data/pasturemodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AddemployeeController extends GetxController {
  RxList<PastureModel> pastureList = <PastureModel>[].obs;
  RxString selectedPastureId = "".obs;
  final employename = TextEditingController();
  final contactno = TextEditingController();
  final emergencynumber = TextEditingController();
  final address = TextEditingController();
  final accountnumber = TextEditingController();
  final salary = TextEditingController();
  final ifsccode = TextEditingController();
  final pancardnumber = TextEditingController();
  final adhaarcardnumber = TextEditingController();
  final age = TextEditingController();
  final experience = TextEditingController();
  final joiningdate = TextEditingController();
  final datecontroller = TextEditingController();
  RxString selectedGender = "Select Any".obs;
  RxString employetype = "Select Any".obs;
  RxString jobtype = "Select Any".obs; // Correct capitalization
  RxString department = "Select Any".obs;
  var isMobileValid = true.obs;

  @override
  void onInit() {
    super.onInit();
    getPastureids();
  }

  List<String> gender = ["Select Any", "Male", "Female"];
  List<String> employee = [
    "Select Any",
    "Full time",
    "Part time",
    "Temporary",
    "On request"
  ];
  List<String> job = [
    "Select Any", // Correct capitalization
    "Milk collector",
    "Veterinary doctor",
    "Grass cutter",
    "Farm supervisor"
  ];
  List<String> departmentList = [
    "Select Any", // Correct capitalization
    "Delivery",
    "Accounting",
    "Marketing"
  ];
  // Rx<File?> aadhaarFile = Rx<File?>(null);

  void clearfields() {
    employename.clear();
    contactno.clear();
    emergencynumber.clear();
    address.clear();
    accountnumber.clear();
    salary.clear();
    ifsccode.clear();
    pancardnumber.clear();
    adhaarcardnumber.clear();
    datecontroller.clear();
    age.clear();
    experience.clear();
    joiningdate.clear();
    selectedGender.value = "Select Any";
    employetype.value = "Select Any";
    jobtype.value = "Select Any";
    department.value = "Select Any";
  }

  Future<void> addemployee() async {
    String employeename = employename.text.trim();
    String contactnumber = contactno.text.trim();
    String emergency = emergencynumber.text.trim();
    String addresses = address.text.trim();
    String accountno = accountnumber.text.trim();
    String salarie = salary.text.trim();
    String ifsccodes = ifsccode.text.trim();
    String pancard = pancardnumber.text.trim();
    String adhar = adhaarcardnumber.text.trim();
    String dates = datecontroller.text.trim();
    String selectedGenders = selectedGender.value;
    String selectedEmployeeType = employetype.value;
    String selectedJobType = jobtype.value;
    String selectedDepartment = department.value;
    String ages = age.text.trim();
    String exper = experience.text.trim();
    String joindate = joiningdate.text.trim();

    try {
      final url = Uri.parse("http://13.234.230.143/addEmployee");
      final response = await http.post(url, body: {
        "employee_name": employeename,
        "age": ages,
        "aadharcard_no": adhar,
        "pancard_no": pancard,
        "address": addresses,
        "department": selectedDepartment,
        "years_of_experience": exper,
        "joining_date": joindate,
        "salary_amount": salarie,
        "bank_account_details": accountno,
        "gender": selectedGenders,
        "phone": contactnumber,
        "emergency_no": emergency,
        "employee_type": selectedEmployeeType,
        "job_role": selectedJobType,
        "ifsc_code": ifsccodes,
        "date_of_birth": dates,
        "farm_id": selectedPastureId.value,
      }).timeout(const Duration(seconds: 30));

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final responsedata = jsonDecode(response.body);
        final employeedetails = responsedata['details'];
        final employeid = employeedetails['employee_id'].toString();

        if (responsedata["message"] == "Employee added successfully!") {
          Get.snackbar(
            "Success",
            "Employee added successfully. Welcome id with $employeid!",
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          clearfields();
          Get.toNamed("/viewemploye");
        }
      } else if (response.statusCode == 500) {
        final responseData = jsonDecode(response.body);
        final errorMessage = responseData['error']?.toString() ?? "";

        // Check if the error message contains either "already in use" or "numeric field overflow"
        if (errorMessage.contains("already in use") ||
            errorMessage.contains("numeric field overflow")) {
          Get.snackbar(
            "Error",
            "Pancard, Aadhaar, or bank account details already exist in the database. Please use different details.",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        } else if (errorMessage.contains("duplicate key value") &&
            errorMessage.contains("employee_data_aadharcard_no_key")) {
          Get.snackbar(
            "Error",
            "Aadhaar number already exists. Please use a different Aadhaar number.",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            "Error",
            "Unexpected error: $errorMessage",
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

  Future<void> getPastureids() async {
    try {
      final url = Uri.parse("http://13.234.230.143/getAllPastures");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        // Extract the list from the "details" key
        final List<dynamic> pastureJson = decoded["details"];
        pastureList.value =
            pastureJson.map((data) => PastureModel.fromJson(data)).toList();
      } else {
        print("Error: Status code ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching pasture ids: $e");
    }
  }
}
