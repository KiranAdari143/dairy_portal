import 'package:dairy_portal/app/modules/Drawerscreen/views/drawerscreen_view.dart';
import 'package:dairy_portal/app/modules/editanimal/controllers/editanimal_controller.dart';
import 'package:dairy_portal/app/modules/inseminationdetailsreen/controllers/inseminationdetailsreen_controller.dart';
import 'package:dairy_portal/app/modules/vaccinationdetailscreen/controllers/vaccinationdetailscreen_controller.dart';
import 'package:dairy_portal/app/modules/medicinescreendetail/controllers/medicinescreendetail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/editanimal_controller.dart';

class EditanimalView extends StatefulWidget {
  const EditanimalView({Key? key}) : super(key: key);

  @override
  _EditanimalViewState createState() => _EditanimalViewState();
}

class _EditanimalViewState extends State<EditanimalView> {
  String? selectedOption;
  final controller = Get.put(EditanimalController());
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

  // Define our color palette:
  final Color appBarColor = const Color(0xFF0054A6); // Deep Blue
  final Color backgroundColor = Colors.white; // White background
  final Color primaryTextColor =
      const Color(0xFF333333); // Dark Gray for primary text
  final Color secondaryTextColor =
      const Color(0xFF777777); // Medium Gray for subtitles

  @override
  Widget build(BuildContext context) {
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
            // Navigation Dropdown with fixed width
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 180,
                  child: DropdownButton<String>(
                    hint: Text(
                      "Select Option",
                      style: TextStyle(color: primaryTextColor, fontSize: 14),
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
                        (element) => element["label"] == newValue,
                      );
                      option["deleteController"]();
                      Get.toNamed(option["route"],
                          arguments: controller.animal);
                    },
                  ),
                ),
              ),
            ),
            const Text(
              "Edit Animal Details",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // TextFormFields updated with label text style using primaryTextColor.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: controller.animalids,
                decoration: InputDecoration(
                  labelText: "Animal Id",
                  labelStyle: TextStyle(color: primaryTextColor),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: controller.animaltype,
                decoration: InputDecoration(
                  labelText: "Animal Type",
                  labelStyle: TextStyle(color: primaryTextColor),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: controller.dob,
                decoration: InputDecoration(
                  labelText: "Date of birth",
                  labelStyle: TextStyle(color: primaryTextColor),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: controller.age,
                decoration: InputDecoration(
                  labelText: "Age",
                  labelStyle: TextStyle(color: primaryTextColor),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: controller.status,
                decoration: InputDecoration(
                  labelText: "Status",
                  labelStyle: TextStyle(color: primaryTextColor),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: controller.lactationno,
                decoration: InputDecoration(
                  labelText: "Lactation No",
                  labelStyle: TextStyle(color: primaryTextColor),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: controller.breedtype,
                decoration: InputDecoration(
                  labelText: "Breed Type",
                  labelStyle: TextStyle(color: primaryTextColor),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: controller.gender,
                decoration: InputDecoration(
                  labelText: "Gender",
                  labelStyle: TextStyle(color: primaryTextColor),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: controller.lastpregnantdate,
                decoration: InputDecoration(
                  labelText: "Last Pregnant Date",
                  labelStyle: TextStyle(color: primaryTextColor),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: controller.expecteddeliverydate,
                decoration: InputDecoration(
                  labelText: "Expected Delivery Date",
                  labelStyle: TextStyle(color: primaryTextColor),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: controller.lastheatdate,
                decoration: InputDecoration(
                  labelText: "Last Heat Date",
                  labelStyle: TextStyle(color: primaryTextColor),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: controller.lastinseminationdate,
                decoration: InputDecoration(
                  labelText: "Last Insemination Date",
                  labelStyle: TextStyle(color: primaryTextColor),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: controller.parenttagid,
                decoration: InputDecoration(
                  labelText: "Parent Tag Id",
                  labelStyle: TextStyle(color: primaryTextColor),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: controller.vendorname,
                decoration: InputDecoration(
                  labelText: "Vendor Name",
                  labelStyle: TextStyle(color: primaryTextColor),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: controller.farmerid,
                decoration: InputDecoration(
                  labelText: "Farmer Id",
                  labelStyle: TextStyle(color: primaryTextColor),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: controller.mothertag,
                decoration: InputDecoration(
                  labelText: "Mother Tag",
                  labelStyle: TextStyle(color: primaryTextColor),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: controller.fathertag,
                decoration: InputDecoration(
                  labelText: "Father Tag",
                  labelStyle: TextStyle(color: primaryTextColor),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: controller.weight,
                decoration: InputDecoration(
                  labelText: "Weight",
                  labelStyle: TextStyle(color: primaryTextColor),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: controller.milkingstatus,
                decoration: InputDecoration(
                  labelText: "Milking Status",
                  labelStyle: TextStyle(color: primaryTextColor),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Update Button
            ElevatedButton(
              onPressed: () {
                controller.updateAnimal();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: appBarColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 80.0),
              ),
              child: const Text('Update'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
