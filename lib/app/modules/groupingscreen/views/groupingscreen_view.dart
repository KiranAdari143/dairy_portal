import 'package:dairy_portal/app/data/anmodel.dart';
import 'package:dairy_portal/app/modules/Drawerscreen/views/drawerscreen_view.dart';
import 'package:dairy_portal/app/modules/viewgroupdetails/views/viewgroupdetails_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/groupingscreen_controller.dart';

class GroupingscreenView extends GetView<GroupingscreenController> {
  const GroupingscreenView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.put(GroupingscreenController());

    // Define color palette
    final Color appBarColor = const Color(0xFF0054A6); // Deep Blue
    final Color backgroundColor = Colors.white; // White background
    final Color cardColor = Colors.white; // White card background
    final Color primaryTextColor = const Color(0xFF333333); // Dark Gray
    final Color secondaryTextColor = const Color(0xFF777777); // Medium Gray

    // 30% opacity layer for the blue below the AppBar
    final Color blueLayer = appBarColor.withOpacity(0.3);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: appBarColor,
              backgroundImage: const AssetImage('images/Dhenusya_a.png'),
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
      drawer: const DrawerscreenView(),
      body: Column(
        children: [
          // Blue layer with delete button on the right
          Container(
            width: double.infinity,
            color: blueLayer,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: const Text(
                    "Groups List",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    if (controller.selectedGroupIds.isNotEmpty) {
                      controller.deleteSelectedGroups();
                    } else {
                      Get.snackbar(
                        "Info",
                        "Please select at least one group",
                        backgroundColor: Colors.orange,
                        colorText: Colors.white,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          // Main content: show groups in a list
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else if (controller.groupList.isEmpty) {
                return Center(
                  child: Text(
                    'No groups found. Please add groups',
                    style: TextStyle(fontSize: 20, color: appBarColor),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: controller.groupList.length,
                  itemBuilder: (context, index) {
                    var group = controller.groupList[index];

                    // Count animal types
                    int cowCount = 0;
                    int buffaloCount = 0;
                    int sheepCount = 0;
                    int goatCount = 0;
                    for (var animal in group.animals) {
                      final String animalName =
                          animal.name.toString().toLowerCase();
                      if (animalName == 'cow') {
                        cowCount++;
                      } else if (animalName == 'buffalo') {
                        buffaloCount++;
                      } else if (animalName == 'sheep') {
                        sheepCount++;
                      } else if (animalName == 'goat') {
                        goatCount++;
                      }
                    }

                    return GestureDetector(
                      onTap: () {
                        // Navigate to group detail screen if needed
                        Get.toNamed("/viewgroupdetails", arguments: group);
                      },
                      onLongPress: () {
                        // Toggle selection on long press
                        controller.toggleGroupSelection(group.groupId);
                      },
                      child: Card(
                        color: cardColor,
                        elevation: 4,
                        margin: const EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(10),
                          leading: Obx(() => Checkbox(
                                value: controller.selectedGroupIds
                                    .contains(group.groupId),
                                onChanged: (bool? selected) {
                                  controller
                                      .toggleGroupSelection(group.groupId);
                                },
                              )),
                          title: Text(
                            group.groupName,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: primaryTextColor,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Group ID: ${group.groupId}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: secondaryTextColor,
                                ),
                              ),
                              if (group.employeeName != null)
                                Text(
                                  'Employee: ${group.employeeName}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: secondaryTextColor,
                                  ),
                                ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Cow: $cowCount  "
                                "Buffalo: $buffaloCount  "
                                "Sheep: $sheepCount  "
                                "Goat: $goatCount",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: secondaryTextColor,
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed("/addgroup");
        },
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: appBarColor,
      ),
    );
  }
}
