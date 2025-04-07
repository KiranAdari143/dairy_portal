import 'dart:convert';

import 'package:dairy_portal/app/data/anmodel.dart';
import 'package:dairy_portal/app/data/groupmodel.dart';
import 'package:dairy_portal/app/data/models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DrawerscreenController extends GetxController {
  final RxBool isEmployeeExpanded = false.obs;
  final RxBool isAnimalExpanded = false.obs;
  final RxBool isGroupingExpanded = false.obs;
  var isLoading = true.obs;
  var groupList = <Detail>[].obs;

  @override
  void onInit() {
    fetchGroups();
    super.onInit();
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
