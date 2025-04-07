import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dairy_portal/app/modules/Drawerscreen/controllers/drawerscreen_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Open the employeesBox before using it anywhere
  await Hive.openBox('employeesBox');

  Get.put(DrawerscreenController());

  final prefs = await SharedPreferences.getInstance();
  final mobilenumber = prefs.getString('mobilenumber');

  String initialRoute;
  if (mobilenumber != null && mobilenumber.isNotEmpty) {
    // user is logged in
    initialRoute = "/add-datascreen";
  } else {
    // not logged in
    initialRoute = "/home";
  }

  runApp(
    GetMaterialApp(
      title: "Dairy_Portal",
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      getPages: AppPages.routes,
    ),
  );
}
