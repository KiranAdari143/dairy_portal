import 'dart:convert';
import 'dart:ffi';
import 'package:dairy_portal/app/data/groupmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class GroupdetailscreenController extends GetxController {
  // Loading flags
  var isGroupListLoading = false.obs;
  var isGroupDetailsLoading = false.obs;

  // In your controller:
  var isSaving = false.obs;

  // Group details for the selected group (as a map)
  var groupDetails = {}.obs;

  // List of groups (fetched based on the category passed in arguments)
  var groupList = <Detail>[].obs;

  // Milk records per animal tag number
  var animalMilkingDetails = <String, List<dynamic>>{}.obs;
  // Local loading flag per animal (for ExpansionTile)
  var animalLoadingState = <String, bool>{}.obs;

  // Controllers for dialog fields
  final quantity = TextEditingController();
  final animalTagNo = TextEditingController();
  RxString sessionresult = "".obs;
  var employeeIds = <int>[].obs;
  RxString selectedEmployeeId = "".obs;

  // Current date string (e.g., "2025-03-21")
  String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  // The group category passed from the previous screen (e.g., "Buffalo" or "Cow")
  late String groupCategory;

  @override
  void onInit() {
    super.onInit();
    fetchemployeids();
    // Get the category from the passed arguments (default to empty string if null)
    groupCategory = Get.arguments as String? ?? "";
    // Fetch groups by category
    fetchGroupsByCategory(groupCategory);
  }

  Future<void> fetchemployeids() async {
    try {
      final url = "http://13.234.230.143/getAllEmployeeData";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final empid = data['details'];
        for (int i = 0; i < empid.length; i++) {
          employeeIds.add(empid[i]['employee_id']);
        }
        print("Employee Ids: $employeeIds");
      } else {
        throw Exception('Failed to load employee ids');
      }
    } catch (e) {
      print(e);
    }
  }

  // Fetch groups based on the passed category from arguments
  Future<void> fetchGroupsByCategory(String category) async {
    isGroupListLoading.value = true;
    try {
      final url = 'http://13.234.230.143/getAllGroups?groupCategory=$category';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print('API Response: $data');
        Animalupdate animalUpdate = Animalupdate.fromJson(data);
        groupList.assignAll(animalUpdate.details);
      } else {
        throw Exception('Failed to load groups: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      Get.snackbar("Error", "Failed to fetch groups: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isGroupListLoading.value = false;
    }
  }

  // Fetch details for a single group (when a group is selected from the left list)
  Future<void> fetchGroupDetails(int id) async {
    isGroupDetailsLoading.value = true;
    try {
      final url = 'http://13.234.230.143/getGroupDetails?groupId=$id';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        groupDetails.value = data;
        print("Group details: $data");
      } else {
        throw Exception('Failed to load group details');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch group details: $e');
    } finally {
      isGroupDetailsLoading.value = false;
    }
  }

  Future<void> addMilkingRecord(
    String animalTagNo,
    String quantity,
    String session,
    String empid,
  ) async {
    // If already saving, skip
    if (isSaving.value) return;

    isSaving.value = true; // start request
    final Map<String, dynamic> requestBody = {
      "animalTagNo": animalTagNo.toString(),
      "quantity": double.parse(quantity),
      "date": currentDate,
      "session": session,
      "employee_id": empid.toString()
    };

    try {
      // ... existing logic ...
      final response = await http.post(
        Uri.parse("http://13.234.230.143/upsertMilkingRecord"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(currentDate);
        Get.snackbar(
          "Added",
          "Success: ${responseData['message']}",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        print("Error: ${response.body}");
      }
    } catch (error) {
      print("Exception: $error");
      throw error;
    } finally {
      isSaving.value = false; // end request
    }
  }

  // Fetch milking details for a given animal tag number
  Future<void> fetchAnimalDetailsByTagNo(String tagNo) async {
    try {
      animalLoadingState[tagNo] = true;
      animalLoadingState.refresh();

      final url = Uri.parse(
          "http://13.234.230.143/getMilkingDataByAnimalTagNo?animalTagNo=$tagNo");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        final fetchedDetails = jsonBody["details"];
        if (fetchedDetails != null && fetchedDetails is List) {
          animalMilkingDetails[tagNo] = fetchedDetails;
        } else {
          animalMilkingDetails[tagNo] = [];
        }
        print("Fetched details for $tagNo: $fetchedDetails");
      } else {
        animalMilkingDetails[tagNo] = [];
      }
    } catch (e) {
      animalMilkingDetails[tagNo] = [];
      rethrow;
    } finally {
      animalLoadingState[tagNo] = false;
      animalLoadingState.refresh();
    }
  }

  // Helper to format a date string (assumed in "yyyy-MM-dd") to "MM/dd"
  String formatToMMDD(String dateString) {
    final parsedDate = DateTime.parse(dateString);
    return DateFormat('MM/dd').format(parsedDate);
  }
}
