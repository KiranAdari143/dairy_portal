import 'package:dairy_portal/app/core/utils/scaffold.dart';
import 'package:dairy_portal/app/modules/Drawerscreen/views/drawerscreen_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pasturedetailscreen_controller.dart';

class PasturedetailscreenView extends GetView<PasturedetailscreenController> {
  const PasturedetailscreenView({super.key});
  @override
  @override
  Widget build(BuildContext context) {
    // Define the color palette:
    final Color appBarColor =
        const Color(0xFF0054A6); // Deep Blue for AppBar and FAB
    final Color blueLayer =
        appBarColor.withOpacity(0.3); // Extra layer below AppBar
    final Color backgroundColor = Colors.white; // White background
    final Color primaryTextColor =
        const Color(0xFF333333); // Dark Gray for primary text

    final controller = Get.put(PasturedetailscreenController());

    return MainScaffold(
      appBar: AppBar(
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
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            color: blueLayer,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Pasture Details",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87, // For contrast against blueLayer.
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          // Main Content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // Title for the screen

                const SizedBox(height: 20),
                Obx(() {
                  if (controller.pasturelist.isEmpty) {
                    return Text(
                      "No Pasture details available",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: appBarColor,
                      ),
                    );
                  }
                  return Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 25,
                        dataTextStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                        columns: [
                          DataColumn(
                            label: Text(
                              "id",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: primaryTextColor,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              " Name",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: primaryTextColor,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Category",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: primaryTextColor,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "size",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: primaryTextColor,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Leased",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: primaryTextColor,
                              ),
                            ),
                          ),
                        ],
                        rows: controller.pasturelist.map((pasture) {
                          return DataRow(
                            cells: [
                              DataCell(Text(
                                pasture.pastureId?.toString() ?? "",
                                style: TextStyle(color: primaryTextColor),
                              )),
                              DataCell(Text(
                                pasture.name ?? "",
                                style: TextStyle(color: primaryTextColor),
                              )),
                              DataCell(Text(
                                pasture.category ?? "",
                                style: TextStyle(color: primaryTextColor),
                              )),
                              DataCell(Text(
                                pasture.size?.toString() ?? "",
                                style: TextStyle(color: primaryTextColor),
                              )),
                              DataCell(Text(
                                pasture.leased?.toString() ?? "",
                                style: TextStyle(color: primaryTextColor),
                              )),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddPasturePopup(context);
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: appBarColor,
      ),
    );
  }
}

void _showAddPasturePopup(BuildContext context) {
  final controller = Get.find<PasturedetailscreenController>();
  // Define color palette for this popup
  final Color appBarColor = const Color(0xFF0054A6); // Deep Blue for buttons
  final Color primaryTextColor =
      const Color(0xFF333333); // Dark Gray for titles and labels

  Get.dialog(
    AlertDialog(
      title: Text(
        "Add Pasture Details",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: primaryTextColor,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            text_box(
              label: "Pasture Name",
              hintText: "Enter Pasture name",
              controller: controller.pasturename,
              primaryTextColor: primaryTextColor,
            ),
            text_box(
              label: "Pasture category",
              hintText: "Enter Pasture category",
              controller: controller.pasturecategory,
              primaryTextColor: primaryTextColor,
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Get.back();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: appBarColor,
            foregroundColor: Colors.white,
          ),
          child: const Text("CLOSE"),
        ),
        ElevatedButton(
          onPressed: () {
            controller.clear(); // Clears all the text fields
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: appBarColor,
            foregroundColor: Colors.white,
          ),
          child: const Text("CLEAR"),
        ),
        ElevatedButton(
          onPressed: () async {
            await controller.addPasture();
            Get.snackbar(
              "Success",
              "Saved details of Pasture",
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.green,
              colorText: Colors.white,
              margin: const EdgeInsets.all(10),
              borderRadius: 8,
              duration: const Duration(seconds: 2),
              snackStyle: SnackStyle.FLOATING,
            );
            await Future.delayed(const Duration(seconds: 1));
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: appBarColor,
            foregroundColor: Colors.white,
          ),
          child: const Text("SAVE"),
        ),
      ],
    ),
  );
}

/// Reusable widget for text input fields using the new color palette.
/// The label uses primaryTextColor (Dark Gray).
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
            fontSize: 17,
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
