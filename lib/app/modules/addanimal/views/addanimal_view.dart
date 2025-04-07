import 'dart:io';

import 'package:dairy_portal/app/modules/Drawerscreen/views/drawerscreen_view.dart';
import 'package:dairy_portal/app/modules/viewanimal/views/viewanimal_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/addanimal_controller.dart';

class AddanimalView extends GetView<AddanimalController> {
  const AddanimalView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddanimalController());

    List<String> species = ["Cow", "Buffalo"];
    List<String> status = [
      "Milking",
      "Inseminated Milking",
      "Pregnant Milking",
      "Pregnant",
      "Dry",
      "Heifer"
    ];
    Rx<File?> selectedImage = Rx<File?>(null);

    Future<void> pickImage() async {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        selectedImage.value = File(image.path);
      }
    }

    return PopScope(
      // Allow the pop to occur so that the back action is detected
      canPop: true,
      // Called after the pop is handled.
      // Wrap navigation call in a Future.delayed to allow the pop to complete.
      onPopInvokedWithResult: (popHandled, dynamic result) {
        Future.delayed(Duration.zero, () {
          // Replace the entire stack with ViewemployeView.
          Get.offAll(() => ViewanimalView());
        });
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
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
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                SizedBox(height: 20),
                GestureDetector(
                  onTap: pickImage,
                  child: Obx(() => CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: selectedImage.value != null
                            ? FileImage(selectedImage.value!)
                            : null,
                        child: selectedImage.value == null
                            ? const Icon(Icons.add_a_photo,
                                color: Colors.white, size: 30)
                            : null,
                      )),
                ),
                text_box(
                    label: "Ear tag number",
                    hintText: "Ear tag number",
                    controller: controller.tagNoController,
                    keyboardType: TextInputType.number),
                text_box(
                    label: "lactation no",
                    hintText: "lactation no",
                    controller: controller.lactationno,
                    keyboardType: TextInputType.number),
                Obx(() => dropdown_box(
                    label: "Animal Type",
                    hint: "Select Animal Type",
                    items: species,
                    selectedSkill: controller.selectedspecies.value.isEmpty
                        ? null
                        : controller.selectedspecies.value,
                    onChanged: (value) {
                      controller.selectedspecies.value = value!;
                      controller.updateselectdropdown(value);
                    })),
                Obx(() => dropdown_box(
                      label: "Animal Breed",
                      hint: "Select Breed",
                      items: controller.selecteddropdownitems
                          .toSet()
                          .toList(), // Ensure unique values
                      selectedSkill:
                          controller.selectedBreed.value.isNotEmpty &&
                                  controller.selecteddropdownitems
                                      .contains(controller.selectedBreed.value)
                              ? controller.selectedBreed.value
                              : null, // Only set if it exists in the items list
                      onChanged: (value) {
                        if (value != null &&
                            controller.selecteddropdownitems.contains(value)) {
                          controller.selectedBreed.value = value;
                        }
                      },
                    )),
                Obx(() => dropdown_box(
                    label: "Gender",
                    hint: "Select Gender",
                    items: ["Male", "Female"],
                    selectedSkill: controller.selectedGender.value.isEmpty
                        ? null
                        : controller.selectedGender.value,
                    onChanged: (value) {
                      controller.selectedGender.value = value!;
                    })),
                _buildDatePickerField(
                    label: "Date of Birth",
                    context: context,
                    controller: controller.dateController,
                    addanimalController: controller),
                text_box(
                    label: "Mother tag number",
                    hintText: "Mother tag number",
                    controller: controller.motherTagController,
                    keyboardType: TextInputType.number),
                text_box(
                    label: "Father tag number",
                    hintText: "Father tag number",
                    controller: controller.fatherTagController,
                    keyboardType: TextInputType.number),
                text_box(
                    label: "vendor name",
                    hintText: "vendor name",
                    controller: controller.vendorNameController),
                text_box(
                    label: "weight",
                    hintText: "weight",
                    keyboardType: TextInputType.number,
                    controller: controller.weightcontroller),
                Obx(() => dropdown_box(
                      label: "Milking status",
                      hint: "status",
                      items: status,
                      selectedSkill: controller.status.value.isEmpty
                          ? null
                          : controller.status.value,
                      onChanged: (value) {
                        controller.status.value = value!;
                      },
                    )),
                Obx(() => dropdown_box(
                      label: "select Farmids",
                      hint: "Farm ids",
                      items:
                          controller.farmids.map((i) => i.toString()).toList(),
                      selectedSkill: controller.farmides.value.isEmpty
                          ? null
                          : controller.farmides.value,
                      onChanged: (value) {
                        controller.farmides.value = value!;
                      },
                    )),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildActionButton("CLEAR", Colors.white, Color(0xFF0054A6),
                        () {
                      controller.clearfields();
                    }),
                    _buildActionButton("ADD", Color(0xFF0054A6), Colors.white,
                        () {
                      controller.addAnimal();
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget text_box(
    {required String label,
    required String hintText,
    TextInputType? keyboardType,
    TextEditingController? controller,
    int? maxLines,
    int? minLines}) {
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
          keyboardType: keyboardType,
          decoration: InputDecoration(
              hintText: hintText,
              hintStyle:
                  const TextStyle(color: Color.fromARGB(115, 157, 155, 155)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  gapPadding: BorderSide.strokeAlignOutside)),
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
        margin: EdgeInsets.only(left: 20, bottom: 5),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0054A6),
          ),
        ),
      ),
      Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(border: OutlineInputBorder()),
          hint: Text(hint),
          value: selectedSkill,
          items: items.map((String skill) {
            return DropdownMenuItem<String>(
              value: skill,
              child: Text(skill),
            );
          }).toList(),
          onChanged: onChanged, // Correct type assignment
        ),
      ),
      const SizedBox(
        height: 10,
      ),
    ],
  );
}

Widget _buildDatePickerField({
  required String label,
  required BuildContext context,
  required TextEditingController controller,
  required AddanimalController addanimalController,
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
            color: Color(0xFF0054A6),
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
