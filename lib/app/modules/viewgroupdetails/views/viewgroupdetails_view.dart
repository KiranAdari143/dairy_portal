import 'package:dairy_portal/app/data/getanimalmodel.dart';
import 'package:dairy_portal/app/modules/Drawerscreen/views/drawerscreen_view.dart';
import 'package:dairy_portal/app/modules/viewgroupdetails/views/viewgroupdetails_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/viewgroupdetails_controller.dart';

class ViewgroupdetailsView extends GetView<ViewgroupdetailsController> {
  const ViewgroupdetailsView({super.key});

  // AlertDialog to assign an employee to a group.
  void _showEmployeeDialog(BuildContext context, int groupId) async {
    // Ensure employees are fetched
    await controller.fetchEmployees();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Define colors for the dialog.
        final Color primaryTextColor = const Color(0xFF333333);
        final Color appBarColor = const Color(0xFF0054A6);
        return AlertDialog(
          title: Text(
            'Assign Employee',
            style:
                TextStyle(fontWeight: FontWeight.bold, color: primaryTextColor),
          ),
          content: Obx(() {
            if (controller.employeeList.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<int>(
                    value: controller.selectedEmployeeId.value,
                    hint: Text('Select Employee',
                        style: TextStyle(color: primaryTextColor)),
                    items: controller.employeeList.map((employee) {
                      return DropdownMenuItem<int>(
                        value: employee.employeeId,
                        child: Text(
                          '${employee.employeeName} (${employee.employeeId})',
                          style: TextStyle(color: primaryTextColor),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      controller.selectedEmployeeId.value = value!;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (controller.selectedEmployeeId.value != null) {
                        controller.assignEmployeeToGroup(
                          groupId,
                          controller.selectedEmployeeId.value!,
                        );
                        Navigator.of(context).pop(); // Close the dialog
                      } else {
                        Get.snackbar(
                          "Error",
                          "Please select an employee",
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appBarColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Add'),
                  ),
                ],
              );
            }
          }),
        );
      },
    );
  }

  // AlertDialog to select animals for a group with search functionality.
  void showAnimalSelectionDialog(int groupId, BuildContext context) async {
    await controller.fetchAnimals();
    await controller.fetchGroups();

    // Gather initial selected and already assigned animal IDs.
    List<int> initialSelectedAnimalIds = [];
    List<int> otherAssignedAnimalIds = [];

    for (var group in controller.groupList) {
      if (group.groupId == groupId) {
        if (group.animals != null) {
          for (var animal in group.animals!) {
            if (animal.id != null) {
              initialSelectedAnimalIds.add(animal.id!);
            }
          }
        }
      } else {
        if (group.animals != null) {
          for (var animal in group.animals!) {
            if (animal.id != null) {
              otherAssignedAnimalIds.add(animal.id!);
            }
          }
        }
      }
    }

    // Create a reactive list for selected animal IDs.
    RxList<int> currentSelectedAnimalIds = <int>[].obs;
    currentSelectedAnimalIds.assignAll(initialSelectedAnimalIds);

    // Create a reactive search query.
    RxString searchQuery = ''.obs;

    // Define colors for the dialog.
    final Color primaryTextColor = const Color(0xFF333333);
    final Color appBarColor = const Color(0xFF0054A6);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Select Animals",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryTextColor,
            ),
          ),
          content: Obx(() {
            // Search bar at the top.
            final searchBar = TextField(
              decoration: InputDecoration(
                hintText: "Search by animal type or tag ID",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                searchQuery.value = value;
              },
            );

            // Filter available animals based on searchQuery.
            final availableAnimals = controller.animals.where((animal) {
              final id = animal.animalId;
              if (id == null) return false;
              bool isAssignable = initialSelectedAnimalIds.contains(id) ||
                  !otherAssignedAnimalIds.contains(id);
              if (!isAssignable) return false;
              // Convert both the search query and fields to lower case for case-insensitive search.
              final query = searchQuery.value.toLowerCase();
              final animalType = (animal.animalType ?? "").toLowerCase();
              final tagNo = (animal.tagNo ?? "").toString().toLowerCase();
              return query.isEmpty ||
                  animalType.contains(query) ||
                  tagNo.contains(query);
            }).toList();

            if (availableAnimals.isEmpty) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  searchBar,
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      "No animals available",
                      style: TextStyle(color: primaryTextColor),
                    ),
                  ),
                ],
              );
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  searchBar,
                  const SizedBox(height: 16),
                  Column(
                    children: availableAnimals.map((animal) {
                      bool isSelected =
                          currentSelectedAnimalIds.contains(animal.animalId);
                      return CheckboxListTile(
                        title: Text(
                          '${animal.animalType ?? "Unknown"} (${animal.tagNo ?? "No Tag"})',
                          style: TextStyle(color: primaryTextColor),
                        ),
                        value: isSelected,
                        onChanged: (bool? selected) {
                          if (selected == true) {
                            if (!currentSelectedAnimalIds
                                .contains(animal.animalId)) {
                              currentSelectedAnimalIds.add(animal.animalId!);
                            }
                          } else {
                            currentSelectedAnimalIds.remove(animal.animalId);
                          }
                          currentSelectedAnimalIds.refresh();
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          }),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: TextStyle(color: appBarColor),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context); // Close dialog

                List<int> newlyAddedAnimals = currentSelectedAnimalIds
                    .where((id) => !initialSelectedAnimalIds.contains(id))
                    .toList();
                List<int> removedAnimals = initialSelectedAnimalIds
                    .where((id) => !currentSelectedAnimalIds.contains(id))
                    .toList();

                if (newlyAddedAnimals.isNotEmpty) {
                  controller.selectedAnimalIds.assignAll(newlyAddedAnimals);
                  await controller.addAnimalsToGroup(groupId);
                }
                if (removedAnimals.isNotEmpty) {
                  await controller.removeAnimalsFromGroup(
                      groupId, removedAnimals);
                }

                await controller.fetchGroups();
                controller.selectedAnimalIds.clear();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: appBarColor,
                foregroundColor: Colors.white,
              ),
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Define our color palette:

    // Define your color palette
    final Color appBarColor = const Color(0xFF0054A6); // Deep Blue
    final Color backgroundColor = Colors.white; // White background
    final Color cardColor = Colors.white; // White card background
    final Color primaryTextColor = const Color(0xFF333333); // Dark Gray text
    final Color secondaryTextColor =
        const Color(0xFF777777); // Medium Gray text

    // 30% opacity blue layer
    final Color blueLayer = appBarColor.withOpacity(0.3);

    final controller = Get.put(ViewgroupdetailsController());

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Blue layer container below AppBar.
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              color: blueLayer,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      // Use Get.back() or Navigator.pop(context) to go back.
                      Get.back();
                    },
                  ),
                  Expanded(
                    child: Text(
                      "Group Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.groupDetail.value == null) {
                return const Center(child: Text("No group details available"));
              }

              final group = controller.groupDetail.value!;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Group Details
                      Text(
                        group.groupName,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                        ),
                      ),
                      Text(
                        "Group ID: ${group.groupId}",
                        style: TextStyle(color: secondaryTextColor),
                      ),
                      if (group.employeeName != null)
                        Text(
                          "Employee: ${group.employeeName}",
                          style: TextStyle(color: secondaryTextColor),
                        ),
                      const SizedBox(height: 20),
                      // Action Buttons: Add animal and Add Employee
                      Row(
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: appBarColor,
                              side: BorderSide(color: appBarColor),
                            ),
                            icon: Icon(Icons.pets, color: appBarColor),
                            label: Text(
                              "Add animal",
                              style: TextStyle(color: appBarColor),
                            ),
                            onPressed: () async {
                              showAnimalSelectionDialog(group.groupId, context);
                              await controller.fetchGroups();
                            },
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: appBarColor,
                              side: BorderSide(color: appBarColor),
                            ),
                            icon: Icon(Icons.people, color: appBarColor),
                            label: Text(
                              "Add Employee",
                              style: TextStyle(color: appBarColor),
                            ),
                            onPressed: () async {
                              _showEmployeeDialog(context, group.groupId);
                              await controller.fetchGroups();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Display Animals
                      if (group.animals != null &&
                          group.animals!.isNotEmpty) ...[
                        Builder(
                          builder: (context) {
                            final validAnimals = group.animals!.where((animal) {
                              return animal.id != null &&
                                  (animal.name != null &&
                                      animal.name!.isNotEmpty) &&
                                  (animal.tagNo != null &&
                                      animal.tagNo!.isNotEmpty);
                            }).toList();

                            if (validAnimals.isEmpty) {
                              return Center(
                                child: Text(
                                  "No animals available",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: primaryTextColor,
                                  ),
                                ),
                              );
                            } else {
                              return Column(
                                children: validAnimals.map((animal) {
                                  return Card(
                                    color: cardColor,
                                    margin: const EdgeInsets.only(bottom: 12.0),
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: ListTile(
                                        title: Text(
                                          'Tag ID: ${animal.tagNo}',
                                          style: TextStyle(
                                              color: primaryTextColor),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            }
                          },
                        ),
                      ] else ...[
                        Center(
                          child: Text(
                            "No animals available",
                            style: TextStyle(
                                fontSize: 16, color: primaryTextColor),
                          ),
                        ),
                      ],
                    ],
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
