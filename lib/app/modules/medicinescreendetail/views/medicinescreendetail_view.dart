import 'package:dairy_portal/app/data/medicine.dart';
import 'package:dairy_portal/app/data/medicinemodel.dart';
import 'package:dairy_portal/app/modules/Drawerscreen/views/drawerscreen_view.dart';
import 'package:dairy_portal/app/modules/animaldata/controllers/animaldata_controller.dart';
import 'package:dairy_portal/app/modules/editanimal/controllers/editanimal_controller.dart';
import 'package:dairy_portal/app/modules/inseminationdetailsreen/controllers/inseminationdetailsreen_controller.dart';
import 'package:dairy_portal/app/modules/vaccinationdetailscreen/controllers/vaccinationdetailscreen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/medicinescreendetail_controller.dart';

class MedicinescreendetailView extends GetView<MedicinescreendetailController> {
  const MedicinescreendetailView({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the color palette:
    final Color appBarColor = const Color(0xFF0054A6); // Deep Blue
    final Color backgroundColor = Colors.white; // White background
    final Color cardColor = Colors.white; // White (for cards if needed)
    final Color primaryTextColor = const Color(0xFF333333); // Dark Gray
    final Color secondaryTextColor = const Color(0xFF777777); // Medium Gray

    final controller = Get.put(MedicinescreendetailController());

    return Scaffold(
      backgroundColor: backgroundColor,
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
              textAlign: TextAlign.end,
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
            // Navigation Dropdown at the top
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: NavigationDropdown(
                controller: controller,
                appBarColor: appBarColor,
                primaryTextColor: primaryTextColor,
              ),
            ),
            const SizedBox(height: 20),
            // "Add Medicine" Button
            ElevatedButton(
              onPressed: () {
                _showAddMedicinePopup(context, primaryTextColor, appBarColor);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: appBarColor,
                foregroundColor: Colors.white, // text color
              ),
              child: const Text("Add Medicine"),
            ),
            const SizedBox(height: 40),
            // Title
            Text(
              "Medicine Details",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryTextColor,
              ),
            ),
            const SizedBox(height: 20),
            Obx(() {
              if (controller.medicineList.isEmpty) {
                return Text(
                  "No Medicine details available",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                  ),
                );
              }
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(
                      label: Text(
                        "Name",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Date",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Description",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Cost",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Dosage",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                        ),
                      ),
                    ),
                  ],
                  rows: controller.medicineList.map((medicine) {
                    return DataRow(cells: [
                      DataCell(Text(
                        medicine.medicineName ?? "",
                        style: TextStyle(color: primaryTextColor),
                      )),
                      DataCell(Text(
                        medicine.medicineDate ?? "",
                        style: TextStyle(color: primaryTextColor),
                      )),
                      DataCell(Text(
                        medicine.medicineDescription ?? "",
                        style: TextStyle(color: primaryTextColor),
                      )),
                      DataCell(Text(
                        medicine.medicineCost?.toString() ?? "",
                        style: TextStyle(color: primaryTextColor),
                      )),
                      DataCell(Text(
                        medicine.dosage?.toString() ?? "",
                        style: TextStyle(color: primaryTextColor),
                      )),
                    ]);
                  }).toList(),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

/// Popup for adding medicine details
void _showAddMedicinePopup(
  BuildContext context,
  Color primaryTextColor,
  Color appBarColor,
) {
  final controller = Get.find<MedicinescreendetailController>();

  Get.dialog(
    AlertDialog(
      title: Text(
        "Add Medicine for Animal id: ${controller.animal.animalId}",
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
              label: "Medicine Name",
              hintText: "Enter medicine name",
              controller: controller.medicinename,
              primaryTextColor: primaryTextColor,
            ),
            text_box(
              label: "Medicine Description",
              hintText: "Enter Medicine Description",
              controller: controller.medicinedescription,
              primaryTextColor: primaryTextColor,
            ),
            _buildDatePickerField(
              label: "Medicine Date",
              context: context,
              controller: controller.medicinedate,
              primaryTextColor: primaryTextColor,
            ),
            text_box(
              label: "Medicine Cost",
              hintText: "Enter Medicine cost",
              controller: controller.medicineCost,
              primaryTextColor: primaryTextColor,
            ),
            text_box(
              label: "Dosage",
              hintText: "Dosage",
              controller: controller.dosage,
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
            await controller.addMedicine();
            Get.snackbar(
              "Success",
              "Saved details of Medicine",
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

/// Reusable widget for text input fields
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

/// Widget for a date picker field
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
            hintStyle: const TextStyle(
              color: Color.fromARGB(115, 157, 155, 155),
            ),
            suffixIcon: IconButton(
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

/// Navigation dropdown widget
class NavigationDropdown extends StatefulWidget {
  final MedicinescreendetailController controller;
  final Color appBarColor;
  final Color primaryTextColor;

  const NavigationDropdown({
    Key? key,
    required this.controller,
    required this.appBarColor,
    required this.primaryTextColor,
  }) : super(key: key);

  @override
  _NavigationDropdownState createState() => _NavigationDropdownState();
}

class _NavigationDropdownState extends State<NavigationDropdown> {
  String? selectedOption;

  final List<Map<String, dynamic>> options = [
    {
      "label": "Edit animal",
      "icon": Icons.edit,
      "route": "/editanimal",
      "deleteController": () => Get.delete<EditanimalController>(),
    },
    {
      "label": "Insemination",
      "icon": Icons.people,
      "route": "/inseminationdetailsreen",
      "deleteController": () => Get.delete<InseminationdetailsreenController>(),
    },
    {
      "label": "Vaccine",
      "icon": Icons.vaccines,
      "route": "/vaccinationdetailscreen",
      "deleteController": () => Get.delete<VaccinationdetailscreenController>(),
    },
    {
      "label": "Medicine",
      "icon": Icons.medication,
      "route": "/medicinescreendetail",
      "deleteController": () => Get.delete<MedicinescreendetailController>(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 180, // fixed width for dropdown
        child: DropdownButton<String>(
          hint: Text(
            "Select Option",
            style: TextStyle(color: widget.primaryTextColor, fontSize: 14),
          ),
          value: selectedOption,
          items: options.map((option) {
            return DropdownMenuItem<String>(
              value: option["label"],
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(option["icon"],
                      color: widget.primaryTextColor, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    option["label"],
                    style:
                        TextStyle(color: widget.primaryTextColor, fontSize: 14),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedOption = newValue;
            });
            final option =
                options.firstWhere((element) => element["label"] == newValue);
            option["deleteController"]();
            Get.toNamed(option["route"], arguments: widget.controller.animal);
          },
        ),
      ),
    );
  }
}
