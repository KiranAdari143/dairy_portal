import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/addmedicine_controller.dart';

class AddmedicineView extends GetView<AddmedicineController> {
  const AddmedicineView({super.key});

  @override
  Widget build(BuildContext context) {
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
            SizedBox(
              width: Get.width * 0.05, // Adjusted width to make them closer
            ),
            Text("Dairy Portal",
                textAlign: TextAlign.end,
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        toolbarHeight: Get.height * 0.1,
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 69, 71, 193),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Add your menu action here
          },
        ),
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
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Get.toNamed('/editmedicine');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor:
                Colors.white, // Use backgroundColor instead of primary
            foregroundColor:
                Colors.black, // Use foregroundColor instead of onPrimary
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            textStyle: const TextStyle(fontSize: 16),
            side: const BorderSide(color: Colors.black, width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, color: Colors.black),
              SizedBox(width: Get.width * 0.015),
              SizedBox(width: Get.height * 0.015),
              Text('Add Medicine', style: TextStyle(color: Colors.black)),
            ],
          ),
        ),
      ),
    );
  }
}
