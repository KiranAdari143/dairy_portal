import 'dart:convert';
import 'package:dairy_portal/app/data/groupmodel.dart'; // Adjust import if needed
import 'package:dairy_portal/app/data/milkqty.dart';
import 'package:dairy_portal/app/data/milkrecord.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class MilktrackerscreenController extends GetxController {
  // Existing text controllers for dates.
  final startdate = TextEditingController();
  final enddate = TextEditingController();

  // Reactive variables for groups.
  RxList<Detail> groupList = <Detail>[].obs;
  Rx<Detail?> groupDetail = Rx<Detail?>(null);
  // New reactive list to store group IDs.
  RxList<int> groupIds = <int>[].obs;

  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

  // Reactive list of MilkRecord
  var milkRecords = <MilkRecord>[].obs;

  // A loading indicator
  var isLoading = false.obs;

  // Example fetch method: adjust the query parameters as needed
  Future<void> fetchMilkingData({
    required String groupid,
    String? startDate,
    String? endDate,
  }) async {
    try {
      isLoading(true);

      // Example URL:
      // http://13.234.230.143/getMilkingDataByAnimalTagNo?animalTagNo=412&startDate=2025-02-16&endDate=2025-02-21
      final url = Uri.parse('http://13.234.230.143/getCumulativeMilkingData'
          '?startDate=$startDate'
          '&endDate=$endDate'
          '&groupId=$groupid');

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List details = data['details'] ?? [];

        // Parse each item in 'details' into a MilkRecord
        final records = details
            .map((item) => MilkRecord.fromJson(item))
            .toList()
            .cast<MilkRecord>();

        // Update the reactive list
        milkRecords.assignAll(records);
      } else {
        throw Exception('Failed to load milking data: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch milking data: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchGroups() async {
    try {
      isLoading(true);
      final response =
          await http.get(Uri.parse('http://13.234.230.143/getAllGroups'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        // Assuming your Group model is handled by Animalupdate.fromJson:
        Animalupdate animalUpdate = Animalupdate.fromJson(data);
        groupList.assignAll(animalUpdate.details);

        if (groupList.isNotEmpty) {
          // If you have a default group passed, you can use that.
          // For now, we take the first group in the list.
          groupDetail.value = groupList.first;
        }

        // Extract group IDs from groupList.
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

  Future<void> fetchAndGoToDetails({
    String? animalTagNo,
  }) async {
    try {
      isLoading(true);

      // Example:
      // http://13.234.230.143/getMilkingDataByAnimalTagNo?animalTagNo=412&startDate=2025-02-16&endDate=2025-02-21
      final url = Uri.parse(
          'http://13.234.230.143/getMilkingDataByAnimalTagNo?animalTagNo=$animalTagNo');
      print("Fetching URL: $url");

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List details = jsonData['details'] ?? [];

        // Parse each record
        final records = details
            .map((item) => Milkqty.fromJson(item))
            .toList()
            .cast<Milkqty>();

        print("Parsed records: $records"); // Check if this list is non-empty

        // Navigate to /milkdetailscreen, passing 'records' as arguments.
        Get.toNamed("/milkdetailscreen", arguments: records);
      } else {
        throw Exception('Failed to load milking data: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to fetch milking data: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Fetch groups when the controller initializes.
    fetchGroups();
  }
}
