import 'package:dairy_portal/app/modules/Appbar/controllers/appbar_controller.dart';
import 'package:dairy_portal/app/modules/groupdetailscreen/controllers/groupdetailscreen_controller.dart';
import 'package:dairy_portal/app/modules/groupingscreen/controllers/groupingscreen_controller.dart';
import 'package:dairy_portal/app/modules/pasturedetailscreen/controllers/pasturedetailscreen_controller.dart';
import 'package:dairy_portal/app/modules/viewanimal/controllers/viewanimal_controller.dart';
import 'package:dairy_portal/app/modules/viewemploye/controllers/viewemploye_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/drawerscreen_controller.dart';

class DrawerscreenView extends GetView<DrawerscreenController> {
  const DrawerscreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define our color palette:
    final Color appBarColor = const Color(0xFF0054A6); // Deep Blue
    final Color backgroundColor = Colors.white; // White background
    final Color primaryTextColor = const Color(0xFF333333); // Dark Gray

    // Use a SizedBox to limit the drawer's width.
    return SizedBox(
      width: 160, // Set a fixed narrower width
      child: Drawer(
        child: ListView(
          children: [
            // Drawer Header with only the logo
            // Card(
            //   color: appBarColor,
            //   child: DrawerHeader(
            //     margin: EdgeInsets.zero,
            //     padding: EdgeInsets.zero,
            //     child: Center(
            //       child: CircleAvatar(
            //         radius: 20, // fixed radius
            //         backgroundColor: appBarColor,
            //         backgroundImage: const AssetImage('images/Dhenusya_a.png'),
            //       ),
            //     ),
            //   ),
            // ),
            // Home
            Container(
              color: appBarColor,
              padding: const EdgeInsets.symmetric(vertical: 25.0),
              child: const Center(
                child: CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage('images/Dhenusya_a.png'),
                  backgroundColor: Colors.white,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.add,
                color: primaryTextColor,
                size: 24, // fixed icon size
              ),
              title: const Text(
                "Home",
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 16, // fixed font size
                ),
              ),
              onTap: () {
                Get.delete<dynamic>();
                Get.toNamed("/add-datascreen");
              },
            ),
            // Employee
            ListTile(
              leading: Icon(
                Icons.work,
                color: primaryTextColor,
                size: 24,
              ),
              title: const Text(
                "Employee",
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Get.delete<ViewemployeController>();
                Get.toNamed("/viewemploye");
              },
            ),
            // Animal
            ListTile(
              leading: Icon(
                Icons.pets_rounded,
                color: primaryTextColor,
                size: 24,
              ),
              title: const Text(
                "Animal",
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Get.delete<ViewanimalController>();
                Get.offNamed("/viewanimal");
              },
            ),
            // Grouping
            ListTile(
              leading: Icon(
                Icons.group,
                color: primaryTextColor,
                size: 24,
              ),
              title: const Text(
                "Grouping",
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Get.delete<GroupingscreenController>();
                Get.offNamed("/groupingscreen");
              },
            ),
            // Pasture
            ListTile(
              leading: Icon(
                Icons.house,
                color: primaryTextColor,
                size: 24,
              ),
              title: const Text(
                "Pasture",
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Get.delete<PasturedetailscreenController>();
                Get.toNamed("/pasturedetailscreen");
              },
            ),
            // Milk Records
            ListTile(
              leading: Icon(
                Icons.record_voice_over_outlined,
                color: primaryTextColor,
                size: 24,
              ),
              title: const Text(
                "Milk Records",
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Get.toNamed("/appbar");
              },
            ),
            ListTile(
              leading: Icon(
                Icons.repeat_on_rounded,
                color: primaryTextColor,
                size: 24,
              ),
              title: const Text(
                "Milk Reports",
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Get.toNamed("/reports");
              },
            ),
          ],
        ),
      ),
    );
  }
}
