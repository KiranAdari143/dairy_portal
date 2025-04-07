import 'package:dairy_portal/app/core/utils/scaffold.dart';
import 'package:dairy_portal/app/modules/Drawerscreen/views/drawerscreen_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_datascreen_controller.dart';

class AddDatascreenView extends GetView<AddDatascreenController> {
  const AddDatascreenView({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MainScaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xFF0054A6),
                backgroundImage: AssetImage('images/Dhenusya_a.png'),
              ),
              SizedBox(width: Get.width * 0.05),
              const Text(
                "Dairy Portal",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )
            ],
          ),
          toolbarHeight: 100,
          centerTitle: true,
          backgroundColor: Color(0xFF0054A6),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () {
                controller.logout();
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            children: [
              Column(
                children: [
                  Text(
                    "Dashboard",
                    style: TextStyle(fontSize: 20),
                  )
                ],
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFF0054A6),
          onPressed: () {
            Get.toNamed("/groupingscreen");
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
