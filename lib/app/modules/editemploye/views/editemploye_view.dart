import 'package:dairy_portal/app/modules/Drawerscreen/views/drawerscreen_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/editemploye_controller.dart';

class EditemployeView extends GetView<EditemployeController> {
  const EditemployeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the color palette
    final Color appBarColor = const Color(0xFF0054A6); // Deep Blue
    final Color backgroundColor = Colors.white; // White background
    final Color primaryTextColor =
        const Color(0xFF333333); // Dark Gray for primary text
    // final Color secondaryTextColor = const Color(0xFF777777); // Medium Gray (if needed)
    final Color blueLayer =
        appBarColor.withOpacity(0.3); // Extra layer below AppBar

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              color: blueLayer,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      // Use Get.back() or Navigator.pop(context) to go back.
                      Get.back();
                    },
                  ),
                  const Text(
                    "Edit ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87, // For contrast against blueLayer.
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: controller.nameController,
                decoration: InputDecoration(
                  labelText: "Employee Name",
                  labelStyle: TextStyle(color: primaryTextColor),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: controller.gendercontroller,
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
                controller: controller.dobcontroller,
                decoration: InputDecoration(
                  labelText: "Date of Birth",
                  labelStyle: TextStyle(color: primaryTextColor),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: controller.agecontroller,
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
                controller: controller.contactnocontroller,
                decoration: InputDecoration(
                  labelText: "Contact Number",
                  labelStyle: TextStyle(color: primaryTextColor),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: controller.experiencecontroller,
                decoration: InputDecoration(
                  labelText: "Years of Experience",
                  labelStyle: TextStyle(color: primaryTextColor),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: controller.joiningdatecontroller,
                decoration: InputDecoration(
                  labelText: "Joining Date",
                  labelStyle: TextStyle(color: primaryTextColor),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: controller.emergencynocontroller,
                decoration: InputDecoration(
                  labelText: "Emergency Number",
                  labelStyle: TextStyle(color: primaryTextColor),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: controller.permanentaddresscontroller,
                decoration: InputDecoration(
                  labelText: "Permanent Address",
                  labelStyle: TextStyle(color: primaryTextColor),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: controller.employetypecontroller,
                decoration: InputDecoration(
                  labelText: "Employee Type",
                  labelStyle: TextStyle(color: primaryTextColor),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: controller.jobrolecontroller,
                decoration: InputDecoration(
                  labelText: "Job Role",
                  labelStyle: TextStyle(color: primaryTextColor),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: controller.departmentcontroller,
                decoration: InputDecoration(
                  labelText: "Department",
                  labelStyle: TextStyle(color: primaryTextColor),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: controller.accountnocontroller,
                decoration: InputDecoration(
                  labelText: "Account Number",
                  labelStyle: TextStyle(color: primaryTextColor),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: controller.salarycontroller,
                decoration: InputDecoration(
                  labelText: "Salary",
                  labelStyle: TextStyle(color: primaryTextColor),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: controller.ifsccontroller,
                decoration: InputDecoration(
                  labelText: "IFSC",
                  labelStyle: TextStyle(color: primaryTextColor),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: controller.pancardcontroller,
                decoration: InputDecoration(
                  labelText: "Pan Card Number",
                  labelStyle: TextStyle(color: primaryTextColor),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: controller.adhaarnocontroller,
                decoration: InputDecoration(
                  labelText: "Adhaar Card Number",
                  labelStyle: TextStyle(color: primaryTextColor),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    controller.updateEmployee();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appBarColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 80.0),
                  ),
                  child: const Text('Update'),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
