import 'package:dairy_portal/app/modules/Drawerscreen/views/drawerscreen_view.dart';
import 'package:dairy_portal/app/modules/editanimal/controllers/editanimal_controller.dart';
import 'package:dairy_portal/app/modules/inseminationdetailsreen/controllers/inseminationdetailsreen_controller.dart';
import 'package:dairy_portal/app/modules/medicinescreendetail/controllers/medicinescreendetail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/vaccinationdetailscreen_controller.dart';

class VaccinationdetailscreenView extends StatefulWidget {
  const VaccinationdetailscreenView({Key? key}) : super(key: key);

  @override
  _VaccinationdetailscreenViewState createState() =>
      _VaccinationdetailscreenViewState();
}

class _VaccinationdetailscreenViewState
    extends State<VaccinationdetailscreenView> {
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
    final controller = Get.put(VaccinationdetailscreenController());

    // Define our color palette.
    final Color appBarColor = const Color(0xFF0054A6); // Deep Blue
    final Color backgroundColor = Colors.white; // White background
    final Color cardColor = Colors.white; // White cards
    final Color primaryTextColor =
        const Color(0xFF333333); // Dark Gray (Primary)
    final Color secondaryTextColor =
        const Color(0xFF777777); // Medium Gray (Secondary)

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
            // Dropdown for navigation with a fixed width.
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 180, // Adjust this width as desired
                  child: DropdownButton<String>(
                    hint: Text(
                      "Select Option",
                      style: TextStyle(
                        color: primaryTextColor,
                        fontSize: 14,
                      ),
                    ),
                    value: selectedOption,
                    items: options.map((option) {
                      return DropdownMenuItem<String>(
                        value: option["label"],
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(option["icon"],
                                color: primaryTextColor, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              option["label"],
                              style: TextStyle(
                                color: primaryTextColor,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedOption = newValue;
                      });
                      final option = options.firstWhere(
                          (element) => element["label"] == newValue);
                      option["deleteController"]();
                      Get.toNamed(option["route"],
                          arguments: controller.animal);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // "Add Vaccine" Button
            ElevatedButton(
              child: const Text("Add Vaccine"),
              style: ElevatedButton.styleFrom(
                backgroundColor: appBarColor, // Deep Blue
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                _showAddMedicinePopup(context);
              },
            ),
            const SizedBox(height: 20),
            // Title for Vaccine Details
            Text(
              "Vaccine Details",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryTextColor,
              ),
            ),
            const SizedBox(height: 20),
            Obx(() {
              if (controller.vaccineList.isEmpty) {
                return Text(
                  "No Vaccine details available",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: primaryTextColor),
                );
              }
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(
                        label: Text("Animal id",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: primaryTextColor))),
                    DataColumn(
                        label: Text("Vaccine Name",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: primaryTextColor))),
                    DataColumn(
                        label: Text("Vaccine Date",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: primaryTextColor))),
                    DataColumn(
                        label: Text("Vaccine Type",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: primaryTextColor))),
                    DataColumn(
                        label: Text("Dosage",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: primaryTextColor))),
                  ],
                  rows: controller.vaccineList.map((vaccine) {
                    return DataRow(cells: [
                      DataCell(Text(
                        vaccine.animalId.toString(),
                        style: TextStyle(color: primaryTextColor),
                      )),
                      DataCell(Text(
                        vaccine.vaccineName ?? "",
                        style: TextStyle(color: primaryTextColor),
                      )),
                      DataCell(Text(
                        vaccine.vaccineDate ?? "",
                        style: TextStyle(color: primaryTextColor),
                      )),
                      DataCell(Text(
                        vaccine.vaccineType?.toString() ?? "",
                        style: TextStyle(color: primaryTextColor),
                      )),
                      DataCell(Text(
                        vaccine.dosage?.toString() ?? "",
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

/// Popup for adding vaccine details.
void _showAddMedicinePopup(BuildContext context) {
  final controller = Get.find<VaccinationdetailscreenController>();
  final Color appBarColor = const Color(0xFF0054A6);
  final Color primaryTextColor = const Color(0xFF333333);
  Get.dialog(
    AlertDialog(
      title: Text(
        "Add Vaccine for Animal id: ${controller.animal.animalId}",
        style: TextStyle(fontWeight: FontWeight.bold, color: primaryTextColor),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            text_box(
              label: "Vaccine Name",
              hintText: "Enter vaccine name",
              controller: controller.vaccinename,
              primaryTextColor: primaryTextColor,
            ),
            text_box(
              label: "Vaccine Type",
              hintText: "Enter Vaccine Description",
              controller: controller.vaccinedescription,
              primaryTextColor: primaryTextColor,
            ),
            _buildDatePickerField(
              label: "Vaccine Date",
              context: context,
              controller: controller.vaccinedate,
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
          ),
          child: const Text(
            "CLOSE",
            style: TextStyle(color: Colors.white),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            controller.clear(); // Clears all the text fields
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: appBarColor,
          ),
          child: const Text(
            "CLEAR",
            style: TextStyle(color: Colors.white),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            await controller.addVaccine();
            Get.snackbar(
              "Success",
              "Saved details of Vaccine",
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
          ),
          child: const Text(
            "SAVE",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
  );
}

/// Reusable widget for text input fields.
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
          style:
              TextStyle(fontWeight: FontWeight.bold, color: primaryTextColor),
        ),
      ),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle:
                const TextStyle(color: Color.fromARGB(115, 157, 155, 155)),
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

/// Widget for a date picker field.
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
          style:
              TextStyle(fontWeight: FontWeight.bold, color: primaryTextColor),
        ),
      ),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: TextField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            hintText: "Select a date",
            hintStyle:
                const TextStyle(color: Color.fromARGB(115, 157, 155, 155)),
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
