import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/medicine_managementscreen_controller.dart';

class MedicineManagementscreenView
    extends GetView<MedicineManagementscreenController> {
  const MedicineManagementscreenView({super.key});
  @override
  Widget build(BuildContext context) {
    MedicineManagementscreenController controller =
        Get.put(MedicineManagementscreenController());
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blue,
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
        backgroundColor: const Color.fromARGB(255, 69, 71, 193),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            Card(
              color: Colors.indigo,
              child: DrawerHeader(
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  child: Row(
                    children: [
                      SizedBox(
                        width: Get.width * 0.01,
                      ),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.blue,
                        backgroundImage: AssetImage('images/Dhenusya_a.png'),
                      ),
                      SizedBox(
                        width: Get.width * 0.1,
                      ),
                      Text(
                        "Dairy Portal",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )
                    ],
                  )),
            ),
            ListTile(
              title: Text("Employes"),
              leading: Icon(Icons.add),
              onTap: () {
                Get.toNamed("/editemploye");
              },
            ),
            ListTile(
              title: Text("Animal"),
              leading: Icon(Icons.add),
              onTap: () {
                Get.toNamed("/addanimal");
              },
            ),
            ListTile(
              title: Text("Medicine Management"),
              leading: Icon(Icons.add),
              onTap: () {
                Get.toNamed("/medicine-managementscreen");
              },
            ),
            ListTile(
              title: Text("Milk tracker"),
              leading: Icon(Icons.add),
              onTap: () {
                Get.toNamed("/milktrackerscreen");
              },
            ),
            ListTile(
              title: Text("Medicine"),
              leading: Icon(Icons.add),
              onTap: () {
                Get.toNamed("/editmedicine");
              },
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              SizedBox(height: Get.height * 0.049),
              text_box(label: "Animal Id", hintText: "Animal Id"),
              text_box(
                  label: "Medicine Selection", hintText: "Medicine Selection"),
              dropdown_box(
                  label: "Medicine Type",
                  hint: "Select Medicine type",
                  items: [
                    "Antibiotics",
                    "Hormonal",
                    "Pain Relivers",
                    "vaccines",
                    "others"
                  ],
                  selectedSkill: controller.medicineType.value.isEmpty
                      ? null
                      : controller.medicineType.value,
                  onChanged: (value) {
                    controller.medicineType.value = value!;
                  }),
              text_box(
                  label: "Medicine manufacturer & Expiration date",
                  hintText: "Medicine manufacturer and expiry date"),
              text_box(label: "Dosage amount", hintText: "Dosage amount")
            ],
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
              fontSize: 17, fontWeight: FontWeight.bold, color: Colors.indigo),
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
            color: Colors.indigo,
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
