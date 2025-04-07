// milkinganimals_controller.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dairy_portal/app/data/groupmodel.dart'; // ensure this imports your updated models
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MilkinganimalsController extends GetxController {
  RxList<Detail> groupList = <Detail>[].obs;
  RxList<int> groupIds = <int>[].obs;
  var isLoading = false.obs;
  Rx<Detail?> selectedGroupDetail = Rx<Detail?>(null);
  final Datecontroller = TextEditingController();
  String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void onInit() {
    super.onInit();
    fetchGroups();
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
        print(currentDate);
        print(int.parse(animalTagNo));
        print(int.parse(quantity));
        print(session);
        Get.snackbar(
          "Added",
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

  Future<void> fetchGroups() async {
    try {
      isLoading(true);
      final response =
          await http.get(Uri.parse('http://13.234.230.143/getAllGroups'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        Animalupdate animalUpdate = Animalupdate.fromJson(data);
        groupList.assignAll(animalUpdate.details);

        // Instead of showing the first group, show "All Groups" by default.
        if (groupList.isNotEmpty) {
          updateSelectedGroup(null);
        }

        groupIds.assignAll(groupList.map((g) => g.groupId).toList());
      } else {
        throw Exception('Failed to load groups: ${response.statusCode}');
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

  void updateSelectedGroup(int? groupId) {
    if (groupId == null || groupId == -1) {
      // Combine all animals from all groups.
      List<Animal> allAnimals =
          groupList.expand((group) => group.animals).toList();

      selectedGroupDetail.value = Detail(
        groupId: -1,
        groupName: "All Groups",
        employeeId: null,
        employeeName: null,
        animals: allAnimals,
      );
    } else {
      selectedGroupDetail.value = groupList.firstWhere(
        (group) => group.groupId == groupId,
        orElse: () => Detail(
          groupId: -1,
          groupName: 'Unknown Group',
          employeeId: null,
          employeeName: null,
          animals: [],
        ),
      );
    }
  }
}
