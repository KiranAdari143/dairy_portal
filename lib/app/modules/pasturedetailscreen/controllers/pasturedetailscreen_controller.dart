import 'dart:convert';

import 'package:dairy_portal/app/data/pasture.dart';
import 'package:dairy_portal/app/data/pasturemodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PasturedetailscreenController extends GetxController {
  RxList<PastureModel> pasturelist = <PastureModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPasture();
  }

  final pasturename = TextEditingController();
  final pasturecategory = TextEditingController();
  final pasturesize = TextEditingController();
  final leased = TextEditingController();

  // Fetch the medicines and update the reactive list.
  Future<void> fetchPasture() async {
    try {
      final response = await http
          .get(Uri.parse('http://13.234.230.143/getAllPastures'))
          .timeout(Duration(seconds: 15));
      // Debug print
      print("Fetch Pasture Response: ${response.body}");
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body)['details'];
        pasturelist.assignAll(
          jsonResponse.map((data) => PastureModel.fromJson(data)).toList(),
        );
      } else {
        throw Exception('Failed to load pasture details');
      }
    } catch (e) {
      print("Error fetching pasturedetails: $e");
      Get.snackbar("Error", "Failed to load pasture details",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> addPasture() async {
    // Trim and collect values from text fields
    String name = pasturename.text.trim();
    String category = pasturecategory.text.trim();
    String size = pasturesize.text.trim();
    String leasedpasture = leased.text.trim();

    // Attempt to parse numeric fields safely using int.tryParse

    const String apiUrl = "http://13.234.230.143/createPasture";

    // Create the medicine model instance using the parsed numbers
    final pasturedetails = Pasture(
        name: name, category: category, size: size, leased: leasedpasture);
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(pasturedetails.toJson()),
      );

      print("Response received: ${response.body}");
      print("response statuscode: ${response.statusCode}");

      if (response.statusCode == 200) {
        final responsedata = jsonDecode(response.body);
        Get.snackbar(
          "Success",
          "Pasture registered successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        fetchPasture();
        Get.back(); // Close the popup automatically.
      } else {
        final errorData = jsonDecode(response.body);
        print("Failed to register Pasture details: ${errorData['message']}");
        Get.snackbar(
          "Error",
          "Failed to register Pasture details: ${errorData['message']}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("An error occurred during animal Pasture details: $e");
      Get.snackbar(
        "Error",
        "An error occurred: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void clear() {
    pasturecategory.clear();
    pasturename.clear();
    pasturelist.clear();
    pasturesize.clear();
  }
}
