import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SignupController extends GetxController {
  final usernamecontroller = TextEditingController();
  final emailidcontroller = TextEditingController();
  final mobilenumbercontroller = TextEditingController();
  final passwordcontroller = TextEditingController();

  var isPasswordVisible = false.obs;
  var isEmailValid = true.obs;
  var isMobileValid = true.obs;

  void clearFields() {
    usernamecontroller.clear();
    emailidcontroller.clear();
    mobilenumbercontroller.clear();
    passwordcontroller.clear();
    isEmailValid.value = true;
    isMobileValid.value = true;
  }

  Future<void> signUp() async {
    String username = usernamecontroller.text.trim();
    String email = emailidcontroller.text.trim();
    String mobile = mobilenumbercontroller.text.trim();
    String password = passwordcontroller.text.trim();

    // Validation before API call
    bool _validate(
        String username, String email, String mobile, String password) {
      if (username.isEmpty ||
          mobile.isEmpty ||
          email.isEmpty ||
          password.isEmpty) {
        return false;
      }
      if (!GetUtils.isEmail(email)) return false;
      if (!GetUtils.isPhoneNumber(mobile)) return false;
      if (password.length < 6) return false;
      return true;
    }

    if (!_validate(username, email, mobile, password)) {
      Get.snackbar(
        "Error",
        "Please fill all fields correctly",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      final url = Uri.parse('http://13.234.230.143/userRegister');
      final response = await http.post(url, body: {
        'user_name': username,
        'mobile_num': mobile,
        'password': password,
        'email_id': email,
      }).timeout(Duration(seconds: 10));

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        print(responseData);

        if (responseData['message'] == "user registered!") {
          // Parse user details and token from the response
          final userDetails = responseData['details'][0];
          final tokenDetails = responseData['details'][1];

          String userId = userDetails['user_id'].toString();
          String userName = userDetails['user_name'];
          String userEmail = userDetails['email_id'];
          String token = tokenDetails['token'];

          // Success message
          Get.snackbar(
            "Success",
            "Signup successfully. Welcome $userName!",
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );

          // Log token and user data
          print("User ID: $userId");
          print("User Name: $userName");
          print("User Email: $userEmail");
          print("Token: $token");

          // Clear fields after successful signup
          clearFields();
        } else {
          Get.snackbar(
            "Error",
            "Unexpected response: ${responseData['message']}",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else if (response.statusCode == 400) {
        final responseData = jsonDecode(response.body);
        final errorMessage = responseData['message'];

        if (errorMessage.contains("email_id") &&
            errorMessage.contains("already exists")) {
          Get.snackbar(
            "Error",
            "Email already exists. Please use a different email.",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        } else if (errorMessage.contains("user_name") &&
            errorMessage.contains("already exists")) {
          Get.snackbar(
            "Error",
            "Username already exists. Please use a different Username.",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        } else if (errorMessage.contains("mobile_num") &&
            errorMessage.contains("already exists")) {
          Get.snackbar(
            "Error",
            "Mobile number already exists. Please use a different Mobile number.",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            "Error",
            "Signup failed",
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
}
