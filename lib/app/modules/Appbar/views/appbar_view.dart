import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/appbar_controller.dart';

class AppbarView extends GetView<AppbarController> {
  const AppbarView({super.key});

  @override
  Widget build(BuildContext context) {
    final Color appBarColor = const Color(0xFF0054A6);
    final Color blueLayer = appBarColor.withOpacity(0.3);

    return Scaffold(
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
      body: Padding(
        padding: const EdgeInsets.all(1),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
                      "Animals",
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
            GestureDetector(
              onTap: () {
                // Pass "Buffalo" as an argument
                Get.toNamed('/groupdetailscreen', arguments: 'Buffalo');
              },
              child: Card(
                elevation: 2,
                clipBehavior: Clip.antiAlias,
                child: Container(
                  width: 200,
                  height: 200,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        'images/buffalo.png',
                        fit: BoxFit.cover,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: double.infinity,
                          color: Colors.black45,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: const Text(
                            'Buffalo',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Card for Cow
            GestureDetector(
              onTap: () {
                // Pass "Cow" as an argument
                Get.toNamed('/groupdetailscreen', arguments: 'Cow');
              },
              child: Card(
                elevation: 2,
                clipBehavior: Clip.antiAlias,
                child: Container(
                  width: 200,
                  height: 200,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        'images/cow.png',
                        fit: BoxFit.cover,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: double.infinity,
                          color: Colors.black45,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: const Text(
                            'Cow',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
