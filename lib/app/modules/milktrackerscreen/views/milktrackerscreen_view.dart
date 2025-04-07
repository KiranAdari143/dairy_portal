import 'package:dairy_portal/app/data/groupmodel.dart';
import 'package:dairy_portal/app/data/milkrecord.dart';
import 'package:dairy_portal/app/modules/Drawerscreen/views/drawerscreen_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/milktrackerscreen_controller.dart';

class MilktrackerscreenView extends GetView<MilktrackerscreenController> {
  MilktrackerscreenView({super.key});

  // Reactive variable for selected group id.
  final Rx<int?> selectedGroupId = Rx<int?>(null);

  @override
  Widget build(BuildContext context) {
    // Define the color palette.
    final Color appBarColor = const Color(0xFF0054A6); // Deep Blue
    final Color backgroundColor = Colors.white; // White
    final Color cardColor = Colors.white; // White (for cards)
    final Color primaryTextColor =
        const Color(0xFF333333); // Dark Gray (primary text)
    final Color secondaryTextColor =
        const Color(0xFF777777); // Medium Gray (subtitles)

    final controller = Get.put(MilktrackerscreenController());

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundColor: Color(0xFF0054A6),
              backgroundImage: AssetImage('images/Dhenusya_a.png'),
            ),
            SizedBox(width: Get.width * 0.05),
            const Text(
              "Dairy Portal",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        toolbarHeight: Get.height * 0.1,
        centerTitle: true,
        backgroundColor: appBarColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildDatePickerField(
              label: "Start date",
              context: context,
              controller: controller.startDateController,
              primaryTextColor: primaryTextColor,
            ),
            _buildDatePickerField(
              label: "End date",
              context: context,
              controller: controller.endDateController,
              primaryTextColor: primaryTextColor,
            ),
            Obx(() {
              if (controller.groupIds.isEmpty) {
                return Text(
                  "No groups available",
                  style: TextStyle(color: primaryTextColor),
                );
              }
              // Add -1 for "All"
              final allGroupIds = [-1, ...controller.groupIds];
              return DropdownButton<int>(
                hint: Text(
                  "Select Group ID",
                  style: TextStyle(color: primaryTextColor),
                ),
                value: selectedGroupId.value ?? -1,
                items: allGroupIds.map((id) {
                  if (id == -1) {
                    return DropdownMenuItem<int>(
                      value: id,
                      child: Text(
                        "All",
                        style: TextStyle(color: primaryTextColor),
                      ),
                    );
                  } else {
                    final group = controller.groupList.firstWhere(
                      (g) => g.groupId == id,
                      orElse: () => Detail(
                        groupId: -1,
                        groupName: 'Unknown Group',
                        employeeId: null,
                        employeeName: null,
                        animals: [],
                      ),
                    );
                    return DropdownMenuItem<int>(
                      value: id,
                      child: Text(
                        "$id (${group.groupName})",
                        style: TextStyle(color: primaryTextColor),
                      ),
                    );
                  }
                }).toList(),
                onChanged: (val) {
                  selectedGroupId.value = val == -1 ? null : val;
                },
              );
            }),
            _buildActionButton(
              "GET DETAILS",
              appBarColor,
              Colors.white,
              () async {
                String groupParam;
                if (selectedGroupId.value == null) {
                  groupParam = "";
                } else {
                  groupParam = selectedGroupId.value.toString();
                }
                await controller.fetchMilkingData(
                  groupid: groupParam,
                  startDate: controller.startDateController.text,
                  endDate: controller.endDateController.text,
                );
              },
              primaryTextColor: primaryTextColor,
            ),
            const SizedBox(height: 30),
            // Display the fetched milk records
            Obx(() {
              if (controller.isLoading.value) {
                return const CircularProgressIndicator();
              }
              if (controller.milkRecords.isEmpty) {
                return Text(
                  "No data available",
                  style: TextStyle(color: primaryTextColor),
                );
              }
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTableTheme(
                  data: DataTableThemeData(
                    headingRowColor: MaterialStateProperty.all(appBarColor),
                    headingTextStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    dividerThickness: 1.0,
                    dataRowColor: MaterialStateProperty.resolveWith<Color?>(
                      (states) => backgroundColor,
                    ),
                    dataTextStyle: TextStyle(
                      color: primaryTextColor,
                      fontSize: 14,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: appBarColor, width: 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text("Date")),
                        DataColumn(label: Text("TagNo")),
                        DataColumn(label: Text("AM")),
                        DataColumn(label: Text("PM")),
                      ],
                      rows: controller.milkRecords.map((record) {
                        return DataRow(
                          cells: [
                            DataCell(Text(record.type)),
                            DataCell(
                              GestureDetector(
                                onTap: () {
                                  controller.fetchAndGoToDetails(
                                    animalTagNo: record.animalTagNo,
                                  );
                                },
                                child: Text(
                                  record.animalTagNo ?? "",
                                  style: TextStyle(
                                    color: appBarColor,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(Text(record.amQuantity ?? "")),
                            DataCell(Text(record.pmQuantity ?? "")),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// Date Picker Field
Widget _buildDatePickerField({
  required String label,
  required BuildContext context,
  required TextEditingController controller,
  required Color primaryTextColor,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        margin: const EdgeInsets.only(left: 20, bottom: 5),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: primaryTextColor,
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: TextField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            hintText: "Select a date",
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    controller.clear();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1947),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      controller.text =
                          "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                    }
                  },
                ),
              ],
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      ),
      const SizedBox(height: 10),
    ],
  );
}

// Action Button
Widget _buildActionButton(
  String label,
  Color backgroundColor,
  Color textColor,
  VoidCallback onTap, {
  required Color primaryTextColor,
}) {
  return Container(
    alignment: Alignment.center,
    margin: const EdgeInsets.symmetric(horizontal: 20),
    child: ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 60.0),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: BorderSide(color: textColor),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(color: textColor),
      ),
    ),
  );
}
