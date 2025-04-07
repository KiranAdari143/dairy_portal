import 'package:dairy_portal/app/core/utils/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/addgroup_controller.dart';

class AddgroupView extends GetView<AddgroupController> {
  const AddgroupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddgroupController());
    // Define color palette
    final Color appBarColor = const Color(0xFF0054A6);
    final Color backgroundColor = Colors.white;
    final Color primaryTextColor = const Color(0xFF333333);
    final Color blueLayer = appBarColor.withOpacity(0.3);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                color: blueLayer,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Get.back(),
                    ),
                    Expanded(
                      child: Text(
                        "Group Details",
                        style: const TextStyle(
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
              const SizedBox(height: 20),
              Text(
                'Adding Group Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor,
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                label: "Enter group name",
                hintText: "Enter Group name",
                controller: controller.groupNameController,
                primaryTextColor: primaryTextColor,
              ),
              const SizedBox(height: 20),
              // Dropdown for group type
              Obx(() => dropdown_box(
                    label: "select group type",
                    hint: "group type",
                    items: controller.animalTypes,
                    selectedSkill: controller.selectedAnimalType.value.isEmpty
                        ? null
                        : controller.selectedAnimalType.value,
                    onChanged: (value) {
                      controller.selectedAnimalType.value = value!;
                    },
                  )),

              Obx(() => dropdown_box(
                    label: "select Farmids",
                    hint: "Farm ids",
                    items: controller.farmids.map((i) => i.toString()).toList(),
                    selectedSkill: controller.farmides.value.isEmpty
                        ? null
                        : controller.farmides.value,
                    onChanged: (value) {
                      controller.farmides.value = value!;
                    },
                  )),

              Obx(() => dropdown_box(
                    label: "select Category",
                    hint: "category",
                    items: const ['Buffalo', 'Cow'],
                    selectedSkill: controller.selectedcategory.value.isEmpty
                        ? null
                        : controller.selectedcategory.value,
                    onChanged: (value) {
                      controller.selectedcategory.value = value!;
                    },
                  )),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildActionButton(
                    "CLEAR",
                    Colors.white,
                    appBarColor,
                    () {
                      controller.clear();
                    },
                  ),
                  _buildActionButton(
                    "ADD",
                    appBarColor,
                    Colors.white,
                    () {
                      controller.addGroup(
                        controller.selectedAnimalType.value,
                        controller.farmides.value,
                        controller.selectedcategory.value,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Reusable text field widget.
Widget _buildTextField({
  required String label,
  required String hintText,
  TextInputType? keyboardType,
  TextEditingController? controller,
  List<TextInputFormatter>? inputFormatters,
  int? length,
  TextCapitalization textcapitalization = TextCapitalization.none,
  ValueChanged<String>? onChanged,
  String? errorText,
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
          textCapitalization: textcapitalization,
          maxLength: length,
          inputFormatters: inputFormatters,
          controller: controller,
          keyboardType: keyboardType,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Color.fromARGB(115, 157, 155, 155),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              gapPadding: 4,
            ),
            errorText: errorText,
          ),
        ),
      ),
      const SizedBox(height: 10),
    ],
  );
}

/// Reusable action button widget.
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

/// Reusable dropdown widget.
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
