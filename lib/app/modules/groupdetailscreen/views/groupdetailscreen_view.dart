import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dairy_portal/app/modules/groupdetailscreen/controllers/groupdetailscreen_controller.dart';

class GroupdetailscreenView extends GetView<GroupdetailscreenController> {
  const GroupdetailscreenView({Key? key}) : super(key: key);

  // Base Colors
  final Color backgroundColor = Colors.white;
  final Color primaryTextColor = const Color(0xFF333333);
  final Color appBarColor = const Color(0xFF0054A6);

  // New Color Scheme
  final Color verticalBarBackgroundColor = Colors.white;
  final Color buttonBackgroundColor = const Color(0xFF0054A6);
  final Color buttonTextColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GroupdetailscreenController());
    final Color headerBlueLayer = const Color(0xFF0054A6).withOpacity(0.3);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 20,
                backgroundColor: appBarColor,
                backgroundImage: const AssetImage('images/Dhenusya_a.png'),
              ),
            ),
            SizedBox(width: Get.width * 0.05),
            const Text(
              "Dairy Portal",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        toolbarHeight: Get.height * 0.1,
        centerTitle: true,
        backgroundColor: appBarColor,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with back button and group info
            Obx(() {
              final bool hasGroup = controller.groupDetails.isNotEmpty;
              return Container(
                width: double.infinity,
                height: 60,
                color: headerBlueLayer,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.centerLeft,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Get.back(),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: hasGroup
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(() {
                                  final groupData =
                                      controller.groupDetails['details'] ?? {};
                                  final groupName =
                                      groupData['group_name'] ?? '';
                                  final employeeName =
                                      groupData['employee_name'] ?? '';
                                  final employeeId =
                                      groupData['employee_id'] ?? '';
                                  return Text(
                                    "Group: $groupName\nEmployee: $employeeName   ID: $employeeId",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  );
                                }),
                              ],
                            )
                          : const Text(
                              "Select a group",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ],
                ),
              );
            }),

            // Main content area
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// LEFT SIDE: Fixed-width vertical bar
                  SizedBox(
                    width: 120,
                    child: Material(
                      elevation: 7, // Adjust shadow intensity
                      shadowColor:
                          Colors.black.withOpacity(0.5), // Shadow color
                      child: Container(
                        color: verticalBarBackgroundColor,
                        child: Obx(() {
                          if (controller.isGroupListLoading.value) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final groups = controller.groupList;
                          if (groups.isEmpty) {
                            return const Center(
                              child: Text("No groups found."),
                            );
                          }
                          return ListView.builder(
                            itemCount: groups.length,
                            itemBuilder: (context, index) {
                              final group = groups[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: buttonTextColor,
                                    backgroundColor: buttonBackgroundColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () async {
                                    // When selecting a group, only update the right side
                                    await controller
                                        .fetchGroupDetails(group.groupId);
                                  },
                                  child: Text(
                                    group.groupName,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      ),
                    ),
                  ),

                  /// RIGHT SIDE: Expanded area
                  Expanded(
                    child: Stack(
                      children: [
                        // Main right-side content
                        Obx(() {
                          if (controller.groupDetails.isEmpty) {
                            return const Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text("Select a group from the left."),
                              ),
                            );
                          }
                          final groupData =
                              controller.groupDetails['details'] ?? {};
                          final animals = groupData['animals'] ?? [];
                          if (animals.isEmpty) {
                            return const Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text("No animals found in this group."),
                              ),
                            );
                          }
                          return SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: animals.length,
                                  itemBuilder: (context, index) {
                                    final animal = animals[index];
                                    final tagNo =
                                        animal['tag_no']?.toString() ?? '';
                                    return Card(
                                      color: backgroundColor,
                                      child: Obx(() {
                                        final milkingData = controller
                                                .animalMilkingDetails[tagNo] ??
                                            [];
                                        final isAnimalLoading = controller
                                                .animalLoadingState[tagNo] ??
                                            false;
                                        return ExpansionTile(
                                          title: Row(
                                            children: [
                                              Expanded(
                                                child: Text("Tag No: $tagNo"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  controller.animalTagNo.text =
                                                      tagNo;
                                                  _addMilkdetails(context);
                                                },
                                                child: const Text("ADD MILK"),
                                              ),
                                            ],
                                          ),
                                          onExpansionChanged: (bool expanded) {
                                            if (expanded) {
                                              controller
                                                  .fetchAnimalDetailsByTagNo(
                                                      tagNo);
                                            }
                                          },
                                          children: [
                                            if (isAnimalLoading)
                                              const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              )
                                            else if (milkingData.isEmpty)
                                              const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  "No data found for this animal.",
                                                ),
                                              )
                                            else
                                              _buildDetailsTable(milkingData),
                                          ],
                                        );
                                      }),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        }),

                        // Loading overlay for group details (right side)
                        Obx(() {
                          if (controller.isGroupDetailsLoading.value) {
                            return Container(
                              color: Colors.black26,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

// DataTable for milking details (formatted as MM/dd)
  Widget _buildDetailsTable(List<dynamic> milkingData) {
    final today = controller.currentDate; // e.g., "2025-03-25"
    final filteredData =
        milkingData.where((record) => record['date'] == today).toList();

    if (filteredData.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text("No milk details for today."),
      );
    }

    // We'll track rowIndex manually for AM/PM rows.
    int rowIndex = 0;
    final List<DataRow> rows = [];

    for (var record in filteredData) {
      // If AM quantity is present, add an AM row
      if (record['am_quantity'] != null &&
          record['am_quantity'].toString().isNotEmpty) {
        rows.add(
          DataRow(
            // Alternate row color
            color: MaterialStateProperty.resolveWith((states) {
              return rowIndex % 2 == 0
                  ? Colors.blue.shade50
                  : Colors.blue.shade100;
            }),
            cells: [
              DataCell(Text(controller.formatToMMDD(today))),
              DataCell(Text(record['am_quantity'].toString())),
              DataCell(Text(record['employee_id']?.toString() ?? '')),
              const DataCell(Text("AM")),
            ],
          ),
        );
        rowIndex++;
      }

      // If PM quantity is present, add a PM row
      if (record['pm_quantity'] != null &&
          record['pm_quantity'].toString().isNotEmpty) {
        rows.add(
          DataRow(
            // Alternate row color
            color: MaterialStateProperty.resolveWith((states) {
              return rowIndex % 2 == 0
                  ? Colors.blue.shade50
                  : Colors.blue.shade100;
            }),
            cells: [
              DataCell(Text(controller.formatToMMDD(today))),
              DataCell(Text(record['pm_quantity'].toString())),
              DataCell(Text(record['employee_id']?.toString() ?? '')),
              const DataCell(Text("PM")),
            ],
          ),
        );
        rowIndex++;
      }
    }

    // Calculate dynamic column spacing based on screen width using GetX
    final double columnSpacing = Get.width * 0.03; // 5% of screen width

    return DataTable(
      columnSpacing: columnSpacing,
      headingRowColor: rowIndex % 2 == 0
          ? MaterialStateProperty.all(Colors.grey.shade300)
          : MaterialStateProperty.all(Colors.blue.shade100),
      dataRowColor: MaterialStateProperty.resolveWith((states) {
        return rowIndex % 2 == 0 ? Colors.grey.shade50 : Colors.blue.shade100;
      }),
      columns: const [
        DataColumn(label: Text("Date")),
        DataColumn(label: Text("Qty")),
        DataColumn(label: Text("EmpID")),
        DataColumn(label: Text("time")),
      ],
      rows: rows,
    );
  }

  void _addMilkdetails(BuildContext context) {
    final controller = Get.find<GroupdetailscreenController>();
    final groupData = controller.groupDetails['details'] ?? {};
    final String defaultEmployeeId =
        (groupData['employee_id'] ?? '').toString();

    // Text controller for Employee ID, pre-filled with default value.
    final TextEditingController employeeController =
        TextEditingController(text: defaultEmployeeId);

    // Update the controller’s selectedEmployeeId as well.
    controller.selectedEmployeeId.value = defaultEmployeeId;

    // Declare the boolean outside of StatefulBuilder to preserve state.
    bool showEmployeeField = false;

    // GlobalKey to get size and position of the text field container.
    final GlobalKey employeeFieldKey = GlobalKey();

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return Obx(() {
            return AlertDialog(
              title: const Text(
                "Add Milk details",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Show either the label or the text field.
                      if (!showEmployeeField)
                        Padding(
                          padding: const EdgeInsets.only(left: 20, bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Employee ID  $defaultEmployeeId",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  // When pencil icon is tapped, show the text field.
                                  setState(() {
                                    showEmployeeField = true;
                                  });
                                },
                              ),
                            ],
                          ),
                        )
                      else
                        // Assign the key here so we can compute the dropdown position.
                        Container(
                          key: employeeFieldKey,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextField(
                            controller: employeeController,
                            readOnly: true,
                            decoration: InputDecoration(
                              hintText:
                                  "Select Employee ID  $defaultEmployeeId",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  final renderBox = employeeFieldKey
                                      .currentContext!
                                      .findRenderObject() as RenderBox;
                                  final offset =
                                      renderBox.localToGlobal(Offset.zero);
                                  final size = renderBox.size;

                                  final double centerX =
                                      offset.dx + size.width / 2;
                                  final double top = offset.dy + size.height;
                                  final double left =
                                      centerX - (size.width / 2);
                                  final double right =
                                      MediaQuery.of(context).size.width -
                                          (left + size.width);
                                  final double bottom =
                                      MediaQuery.of(context).size.height - top;

                                  showMenu<String>(
                                    context: context,
                                    position: RelativeRect.fromLTRB(
                                        left, top, right, bottom),
                                    items: controller.employeeIds.map((e) {
                                      final empId = e.toString();
                                      return PopupMenuItem<String>(
                                        value: empId,
                                        child: Text(empId),
                                      );
                                    }).toList(),
                                  ).then((selectedValue) {
                                    if (selectedValue != null) {
                                      employeeController.text = selectedValue;
                                      controller.selectedEmployeeId.value =
                                          selectedValue;
                                    }
                                  });
                                },
                              ),
                            ),
                            onChanged: (value) {
                              controller.selectedEmployeeId.value = value;
                            },
                          ),
                        ),
                      const SizedBox(height: 16),
                      // Session Time Dropdown
                      dropdown_box(
                        label: "Session Time",
                        hint: "Select AM/PM",
                        items: const ["Am", "Pm"],
                        selectedSkill: controller.sessionresult.value.isEmpty
                            ? null
                            : controller.sessionresult.value,
                        onChanged: (value) {
                          controller.sessionresult.value = value!;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Quantity Field
                      text_box(
                        label: "Quantity",
                        hintText: "Enter Quantity",
                        controller: controller.quantity,
                        primaryTextColor: Colors.black,
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    // Clear the fields.
                    employeeController.clear();
                    controller.quantity.clear();
                    controller.sessionresult.value = '';
                    controller.selectedEmployeeId.value = '';

                    // Close the dialog.
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text("CLOSE"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // If no Employee ID was selected in the text field, use the default.
                    if (employeeController.text.trim().isEmpty) {
                      controller.selectedEmployeeId.value = defaultEmployeeId;
                    }
                    // 1. Validate session time.
                    if (controller.sessionresult.value.isEmpty) {
                      Get.snackbar(
                        "Missing Data",
                        "Please select a Session Time (AM/PM).",
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                      return;
                    }
                    // 2. Validate quantity.
                    if (controller.quantity.text.trim().isEmpty) {
                      Get.snackbar(
                        "Missing Data",
                        "Please enter a valid Quantity.",
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                      return;
                    }
                    // 3. Validate employee ID.
                    if (!controller.employeeIds
                            .map((e) => e.toString())
                            .contains(controller.selectedEmployeeId.value) ||
                        controller.selectedEmployeeId.value.isEmpty) {
                      Get.snackbar(
                        "Invalid Input",
                        "Please select a valid Employee ID.",
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                      return;
                    }
                    // Proceed with the API call.
                    await controller.addMilkingRecord(
                      controller.animalTagNo.text,
                      controller.quantity.text,
                      controller.sessionresult.value,
                      controller.selectedEmployeeId.value,
                    );
                    // Optionally re-fetch details for the animal.
                    await controller
                        .fetchAnimalDetailsByTagNo(controller.animalTagNo.text);
                    // Close the dialog immediately after saving.
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text("SAVE"),
                ),
              ],
            );
          });
        },
      ),
    );
  }
}

// Reusable text input field widget
Widget text_box({
  required String label,
  required String hintText,
  TextInputType? keyboardType,
  int? maxLines,
  int? minLines,
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
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Color.fromARGB(115, 157, 155, 155),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          maxLines: maxLines,
          minLines: minLines,
        ),
      ),
      const SizedBox(height: 10),
    ],
  );
}

// Reusable dropdown widget
Widget dropdown_box({
  required String label,
  required String hint,
  required List<String> items,
  String? selectedSkill,
  required ValueChanged<String?>? onChanged,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        margin: const EdgeInsets.only(left: 20, bottom: 5),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          width: double.infinity,
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            hint: Text(hint),
            value: selectedSkill,
            items: items.map((String skill) {
              return DropdownMenuItem<String>(
                value: skill,
                child: Text(skill),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
      const SizedBox(height: 10),
    ],
  );
}
