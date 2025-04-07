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
    final uri = Uri.parse("http://13.234.230.143/userLogin");
    final response = await http.post(uri, body: {
      "mobile_num": mobilenumber,
      "password": password,
    }).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      if (responseData['message'] == "Login successful") {
        // 1. Store the user's mobile number (or any other credentials).
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('mobilenumber', mobilenumber);
        // You can store more fields if needed, e.g. 'token'.

        // 2. Navigate to your main screen.
        Get.offAllNamed("/add-datascreen");
      } else {
        Get.snackbar("Error", "Unexpected: ${responseData['message']}",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    }
  }
}
