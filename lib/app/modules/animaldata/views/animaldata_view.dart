import 'package:dairy_portal/app/modules/Drawerscreen/views/drawerscreen_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/animaldata_controller.dart';

class AnimaldataView extends GetView<AnimaldataController> {
  const AnimaldataView({super.key});
  @override
  Widget build(BuildContext context) {
    AnimaldataController controller = Get.put(AnimaldataController());
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xFF0054A6),
                backgroundImage: AssetImage('images/Dhenusya_a.png'),
              ),
            ),
            SizedBox(width: Get.width * 0.05),
            Text(
              "Dairy Portal",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            )
          ],
        ),
        toolbarHeight: Get.height * 0.1,
        centerTitle: true,
        backgroundColor: Color(0xFF0054A6),
      ),
      drawer: DrawerscreenView(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        controller.toggleVaccinationVisibility();
                      },
                      icon: Icon(
                        controller.isVaccinationVisible.value
                            ? Icons.remove
                            : Icons.add,
                        color: Color(0xFF0054A6),
                      ),
                    ),
                    const Text(
                      "Vaccination",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0054A6),
                      ),
                    ),
                  ],
                )),
            Obx(() {
              if (controller.isVaccinationVisible.value) {
                return Column(
                  children: [
                    Obx(() => Container(
                          margin: const EdgeInsets.only(left: 20, bottom: 5),
                          child: Text(
                            "Animal id :${controller.animalId.value}",
                            style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0054A6)),
                          ),
                        )),
                    text_box(
                        label: "Vaccine Name", hintText: "Enter Vaccine Name"),
                    _buildDatePickerField(
                        label: "Vaccine Date",
                        context: context,
                        controller: TextEditingController(),
                        addanimalController: controller),
                    dropdown_box(
                      label: "Vaccine Type",
                      hint: "Select Vaccine Type",
                      items: ["Live", "Inactivated", "Subunit"],
                      selectedSkill: controller.type.value.isEmpty
                          ? null
                          : controller.type.value,
                      onChanged: (value) {
                        controller.type.value = value!;
                      },
                    ),
                    text_box(label: "Dosage", hintText: "Dosage"),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        controller.toggleMedicinationVisible();
                      },
                      icon: Icon(
                        controller.isMedicineVisible.value
                            ? Icons.remove
                            : Icons.add,
                        color: Color(0xFF0054A6),
                      ),
                    ),
                    const Text(
                      "Add Medicine",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0054A6),
                      ),
                    ),
                  ],
                )),
            Obx(() {
              if (controller.isMedicineVisible.value) {
                return Column(
                  children: [
                    Obx(() => Container(
                          margin: const EdgeInsets.only(left: 20, bottom: 5),
                          child: Text(
                            "Animal id :${controller.animalId.value}",
                            style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0054A6)),
                          ),
                        )),
                    text_box(
                        label: "Medicine Name",
                        hintText: "Enter Medicine Details"),
                    text_box(
                        label: "Medicine Description",
                        hintText: "Enter Medicine Description"),
                    _buildDatePickerField(
                      label: "Start date",
                      context: context,
                      controller: controller.startdate,
                      addanimalController: controller,
                    ),
                    _buildDatePickerField(
                      label: "End date",
                      context: context,
                      controller: controller.enddate,
                      addanimalController: controller,
                    ),
                    text_box(
                        label: "Medicine Type",
                        hintText: "Enter Medicine Type"),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        controller.toggleInseminationVisible();
                      },
                      icon: Icon(
                        controller.isInsemination.value
                            ? Icons.remove
                            : Icons.add,
                        color: Color(0xFF0054A6),
                      ),
                    ),
                    const Text(
                      "Insemination Details",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0054A6),
                      ),
                    ),
                  ],
                )),
            Obx(() {
              if (controller.isInsemination.value) {
                return Column(
                  children: [
                    Obx(() => Container(
                          margin: const EdgeInsets.only(left: 20, bottom: 5),
                          child: Text(
                            "Animal id :${controller.animalId.value}",
                            style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0054A6)),
                          ),
                        )),
                    _buildDatePickerField(
                      label: "Date of Insemination",
                      context: context,
                      controller: controller.inseminationdate,
                      addanimalController: controller,
                    ),
                    dropdown_box(
                      label: "Insemination Method",
                      hint: "Select Insemination Method",
                      items: ["AI", "Natural service"],
                      selectedSkill: controller.method.value.isEmpty
                          ? null
                          : controller.method.value,
                      onChanged: (value) {
                        controller.method.value = value!;
                      },
                    ),
                    text_box(
                        label: "Insemination Breed",
                        hintText: "Enter Insemination Breed"),
                    dropdown_box(
                      label: "Semen Type",
                      hint: "Select Semen Type",
                      items: ["Frozen", "Fresh", "Other"],
                      selectedSkill: controller.sementype.value.isEmpty
                          ? null
                          : controller.sementype.value,
                      onChanged: (value) {
                        controller.sementype.value = value!;
                      },
                    ),
                    dropdown_box(
                      label: "Insemination Status",
                      hint: "Select Insemination Status",
                      items: ["Success", "Failure", "Pending", "Other"],
                      selectedSkill: controller.inseminationstatus.value.isEmpty
                          ? null
                          : controller.inseminationstatus.value,
                      onChanged: (value) {
                        controller.inseminationstatus.value = value!;
                      },
                    ),
                    dropdown_box(
                      label: "Pregnancy Status",
                      hint: "Select Pregnancy Status",
                      items: ["Success", "Failure", "Pending", "noresult"],
                      selectedSkill: controller.pregnancystatus.value.isEmpty
                          ? null
                          : controller.pregnancystatus.value,
                      onChanged: (value) {
                        controller.pregnancystatus.value = value!;
                      },
                    ),
                    text_box(
                        label: "AI Technician Name",
                        hintText: "Enter AI Technician Name"),
                    text_box(
                        label: "AI Technician Notes",
                        hintText: "Enter AI Technician Notes"),
                    dropdown_box(
                      label: "Insemination Result",
                      hint: "Select Insemination Result",
                      items: ["Pregnant", "Not Pregnant", "No result", "Other"],
                      selectedSkill: controller.inseminationresult.value.isEmpty
                          ? null
                          : controller.inseminationresult.value,
                      onChanged: (value) {
                        controller.inseminationresult.value = value!;
                      },
                    ),
                    _buildDatePickerField(
                      label: "Pregnancy Test Date",
                      context: context,
                      controller: controller.pregnancydate,
                      addanimalController: controller,
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionButton("SKIP", Colors.white, Color(0xFF0054A6), () {
                  Get.toNamed("/viewanimal");
                }),
                _buildActionButton("ADD", Color(0xFF0054A6), Colors.white,
                    () async {
                  List<Future<bool>> apiCalls =
                      []; // List of Futures that return bool

                  // Add Vaccination API call if visible
                  if (controller.isVaccinationVisible.value) {
                    apiCalls.add(controller.addVaccination());
                  }

                  // Add Medicine API call if visible
                  if (controller.isMedicineVisible.value) {
                    apiCalls.add(controller.addMedicine());
                  }

                  // Add Insemination API call if visible
                  if (controller.isInsemination.value) {
                    apiCalls.add(controller.addInseminationdetails());
                  }

                  if (apiCalls.isNotEmpty) {
                    try {
                      // Execute all API calls and wait for them to complete
                      List<bool> results = await Future.wait(apiCalls);

                      // Check if all API calls were successful
                      bool allSuccessful =
                          results.every((result) => result == true);

                      if (allSuccessful) {
                        // Show success message
                        Get.snackbar("Success", "Data added successfully!",
                            backgroundColor: Colors.green,
                            colorText: Colors.white);
                        Get.toNamed("/viewanimal");
                      } else {
                        // Handle any API errors
                        Get.snackbar("Error", "Some data could not be added.",
                            backgroundColor: Colors.red,
                            colorText: Colors.white);
                      }
                    } catch (e) {
                      // Handle any other errors
                      Get.snackbar("Error", "Some data could not be added.",
                          backgroundColor: Colors.red, colorText: Colors.white);
                    }
                  } else {
                    // If no sections are visible
                    Get.snackbar("Info", "No data to add.",
                        backgroundColor: Colors.orange,
                        colorText: Colors.white);
                  }
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget text_box({
  required String label,
  required String hintText,
  TextInputType? keyboardType,
  int? maxLines,
  int? minLines,
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
              color: Color(0xFF0054A6)),
        ),
      ),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: TextField(
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
              color: Color(0xFF0054A6)),
        ),
      ),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: DropdownButtonFormField<String>(
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
      const SizedBox(height: 10),
    ],
  );
}

Widget _buildDatePickerField({
  required String label,
  required BuildContext context,
  required TextEditingController controller,
  required AnimaldataController addanimalController,
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
              color: Color(0xFF0054A6)),
        ),
      ),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: TextField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            hintText: "Select a date",
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
                  addanimalController.calculateAge(pickedDate);
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

Widget _buildActionButton(
    String label, Color backgroundColor, Color textColor, VoidCallback onTap) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20),
    child: ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 60.0),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(color: textColor)),
      ),
      child: Text(
        label,
        style: TextStyle(color: textColor),
      ),
    ),
  );
}
