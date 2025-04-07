import 'package:dairy_portal/app/core/utils/scaffold.dart';
import 'package:dairy_portal/app/modules/Drawerscreen/views/drawerscreen_view.dart';
import 'package:dairy_portal/app/modules/viewemploye/controllers/viewemploye_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewemployeView extends GetView<ViewemployeController> {
  const ViewemployeView({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ViewemployeController());

    // Define our color palette.
    final Color appBarColor = const Color(0xFF0054A6);
    final Color backgroundColor = Colors.white;
    final Color cardColor = Colors.white;
    final Color primaryTextColor = const Color(0xFF333333);
    final Color secondaryTextColor = const Color(0xFF777777);

    // Create a layer with 30% opacity blue
    final Color blueLayer = appBarColor.withOpacity(0.3);

    return MainScaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: appBarColor,
              backgroundImage: const AssetImage('images/Dhenusya_a.png'),
            ),
            SizedBox(width: Get.width * 0.05),
            const Text(
              "Dairy Portal",
              textAlign: TextAlign.end,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        toolbarHeight: Get.height * 0.1,
        centerTitle: true,
        backgroundColor: appBarColor,
        // You can remove the delete button from actions if you want it only in the blue layer.
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            color: blueLayer,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Employee List",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87, // For contrast against blueLayer.
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    if (controller.selectedEmployeeIds.isNotEmpty) {
                      controller.deleteSelectedEmployees();
                    } else {
                      Get.snackbar(
                        "Info",
                        "Please select any employee",
                        backgroundColor: Colors.orange,
                        colorText: Colors.white,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          // Main content: Employee list.
          Expanded(
            child: Obx(() {
              if (controller.employees.isEmpty) {
                return Center(
                  child: Text(
                    'No employees Added. Please add employees',
                    style: TextStyle(fontSize: 18, color: appBarColor),
                  ),
                );
              }
              return ListView.builder(
                itemCount: controller.employees.length,
                itemBuilder: (context, index) {
                  final employee = controller.employees[index];
                  return GestureDetector(
                    onLongPress: () {
                      controller.toggleEmployeeSelection(employee.employeeId);
                    },
                    onTap: () {
                      if (controller.selectedEmployeeIds.isNotEmpty) {
                        controller.toggleEmployeeSelection(employee.employeeId);
                      } else {
                        Get.toNamed('/editemploye', arguments: employee);
                      }
                    },
                    child: Card(
                      color: cardColor,
                      elevation: 4,
                      margin: const EdgeInsets.all(8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Obx(() => Checkbox(
                                  value: controller.selectedEmployeeIds
                                      .contains(employee.employeeId),
                                  onChanged: (bool? selected) {
                                    controller.toggleEmployeeSelection(
                                        employee.employeeId);
                                  },
                                )),
                            Text(
                              employee.employeeId.toString(),
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: primaryTextColor),
                            ),
                          ],
                        ),
                        title: Text(
                          employee.employeeName,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: primaryTextColor),
                        ),
                        subtitle: Text(
                          'Department: ${employee.department}',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: secondaryTextColor),
                        ),
                        isThreeLine: true,
                        contentPadding: const EdgeInsets.all(8.0),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed("/addemployee");
        },
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: appBarColor,
      ),
    );
  }
}
