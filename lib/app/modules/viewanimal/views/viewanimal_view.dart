import 'package:dairy_portal/app/core/utils/scaffold.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/viewanimal_controller.dart';

class ViewanimalView extends GetView<ViewanimalController> {
  const ViewanimalView({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ViewanimalController());

    // Define color palette.
    final Color appBarColor = const Color(0xFF0054A6); // Deep Blue
    final Color cardColor = Colors.white; // White card background
    final Color primaryTextColor = const Color(0xFF333333); // Dark Gray
    final Color secondaryTextColor = const Color(0xFF777777); // Medium Gray

    // Blue layer with 30% opacity.
    final Color blueLayer = appBarColor.withOpacity(0.3);

    return MainScaffold(
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
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        toolbarHeight: Get.height * 0.1,
        centerTitle: true,
        backgroundColor: appBarColor,
      ),
      body: Column(
        children: [
          // Blue layer container with a fixed delete button on the right.
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            color: blueLayer,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: const Text(
                    "Animal List",
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
                    if (controller.selectedanimalIds.isNotEmpty) {
                      controller.deleteSelectedAnimals();
                    } else {
                      Get.snackbar(
                        "Info",
                        "Please select at least one animal",
                        backgroundColor: Colors.orange,
                        colorText: Colors.white,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          // Main content: list of animals with checkboxes.
          Expanded(
            child: Obx(() {
              if (controller.animals.isEmpty) {
                return Center(
                  child: Text(
                    "No animals available",
                    style: TextStyle(fontSize: 18, color: appBarColor),
                  ),
                );
              }
              return ListView.builder(
                itemCount: controller.animals.length,
                itemBuilder: (context, index) {
                  final animal = controller.animals[index];
                  return GestureDetector(
                    onTap: () {
                      // Navigate to animal details if needed.
                      Get.toNamed("/animaldetailscreen", arguments: animal);
                      print("Navigating with animal id: ${animal.animalId}");
                    },
                    onLongPress: () {
                      controller.toggleAnimalSelection(animal.animalId);
                    },
                    child: Card(
                      color: cardColor,
                      elevation: 4,
                      margin: const EdgeInsets.all(8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: Obx(() => Checkbox(
                              value: controller.selectedanimalIds
                                  .contains(animal.animalId),
                              onChanged: (bool? selected) {
                                controller
                                    .toggleAnimalSelection(animal.animalId);
                              },
                            )),
                        title: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Text(
                                animal.tagNo!,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: primaryTextColor),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "Status: ${animal.status}",
                                style: TextStyle(
                                    fontSize: 16, color: secondaryTextColor),
                              ),
                            ],
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(8.0),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed("/addanimal");
        },
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: appBarColor,
      ),
    );
  }
}
