import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  final mobilenumbercontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  RxBool ispasswordVisible = false.obs;

  Future login() async {
    String mobilenumber = mobilenumbercontroller.text.trim();
    String password = passwordcontroller.text.trim();

    bool _validate(String mobilenumber, String password) {
      if (mobilenumber.isEmpty || password.isEmpty) {
        return false;
      }
      if (!GetUtils.isPhoneNumber(mobilenumber)) return false;
      if (password.length < 6) return false;
      return true;
    }

    if (!_validate(mobilenumber, password)) {
      Get.snackbar("Error", "Please fill all fields correctly",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      final uri = Uri.parse("http://13.234.230.143/userLogin");
      final response = await http.post(uri, body: {
        "mobile_num": mobilenumber,
        "password": password,
      }).timeout(const Duration(seconds: 10));

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          responseData['message'] == "Login successful") {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('mobilenumber', mobilenumber);

        Get.offAllNamed("/add-datascreen");
      } else {
        // Show error message from the API
        Get.snackbar("Login Failed", responseData['message'] ?? "Unknown error",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong. Please try again.",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
