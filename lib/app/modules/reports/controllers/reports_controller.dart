import 'dart:convert';
import 'package:dairy_portal/app/data/groupmodel.dart'; // Ensure your model Animalupdate and Detail are defined
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ReportsController extends GetxController {
  // Loading flags
  var isGroupListLoading = false.obs;
  var isMilkingSummaryLoading = false.obs;

  // Observables for category, groups, and milking summary
  RxString selectedCategory = "".obs;
  var groupList = <Detail>[].obs; // Groups fetched for category
  var milkingSummary = {}.obs; // API response for milking summary

  // RxMaps for type totals per category
  RxMap buffaloTypeTotals = {}.obs;
  RxMap cowTypeTotals = {}.obs;
  RxList<dynamic> buffaloDatewiseTotals = <dynamic>[].obs;
  RxList<dynamic> cowDatewiseTotals = <dynamic>[].obs;
  // Use a fixed date range for demo; you could also allow user input
  String startDate = "2025-03-19";
  String endDate = "2025-03-28";

  @override
  void onInit() {
    super.onInit();
    // Fetch type totals for both categories upon initialization.
    fetchTypeTotals("Buffalo");
    fetchTypeTotals("Cow");
  }

  // ----------------------------
  // Fetch groups by category (Cow/Buffalo)
  Future<void> fetchGroupsByCategory(String category) async {
    isGroupListLoading.value = true;
    try {
      final url = 'http://13.234.230.143/getAllGroups?groupCategory=$category';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print('Groups API Response: $data');
        Animalupdate animalUpdate = Animalupdate.fromJson(data);
        groupList.assignAll(animalUpdate.details);
      } else {
        throw Exception('Failed to load groups: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchGroupsByCategory: $e');
      Get.snackbar("Error", "Failed to fetch groups: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isGroupListLoading.value = false;
    }
  }

  // ----------------------------
  // Fetch milking summary by group id for a given date range
  Future<void> fetchMilkingSummaryByGroup(int groupId) async {
    isMilkingSummaryLoading.value = true;
    try {
      final url =
          'http://13.234.230.143/getMilkingSummaryByGroup?startDate=$startDate&endDate=$endDate&groupId=$groupId';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print('Milking Summary API Response: $data');
        milkingSummary.value = data;
      } else {
        throw Exception(
            'Failed to load milking summary: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchMilkingSummaryByGroup: $e');
      Get.snackbar("Error", "Failed to fetch milking summary: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isMilkingSummaryLoading.value = false;
    }
  }

  // Fetch type totals (including datewise totals) by category.
  Future<void> fetchTypeTotals(String category) async {
    try {
      final url =
          'http://13.234.230.143/getMilkingSummaryByAnimalType?startDate=$startDate&endDate=$endDate&animalType=$category';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print('Type Totals API Response for $category: $data');
        // The API returns details with both "type_totals" and "datewise_total"
        final details = data['details'] ?? {};
        if (category.toLowerCase() == "buffalo") {
          buffaloTypeTotals.value = details['type_totals'] ?? {};
          buffaloDatewiseTotals.assignAll(details['datewise_total'] ?? []);
        } else {
          cowTypeTotals.value = details['type_totals'] ?? {};
          cowDatewiseTotals.assignAll(details['datewise_total'] ?? []);
        }
      } else {
        throw Exception('Failed to load type totals: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchTypeTotals for $category: $e');
      Get.snackbar("Error", "Failed to fetch type totals for $category: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // Format a date string (e.g., "2025-03-27") to "MM/dd"
  String formatDate(String dateString) {
    final parsedDate = DateTime.parse(dateString);
    return DateFormat('MM/dd').format(parsedDate);
  }
}
