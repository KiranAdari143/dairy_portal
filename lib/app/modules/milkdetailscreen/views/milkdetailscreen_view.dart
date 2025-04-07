import 'package:dairy_portal/app/data/milkqty.dart';
import 'package:dairy_portal/app/modules/Drawerscreen/views/drawerscreen_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/milkdetailscreen_controller.dart';
import 'package:intl/intl.dart';

class MilkdetailscreenView extends GetView<MilkdetailscreenController> {
  const MilkdetailscreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MilkdetailscreenController>();
    final records = Get.arguments as List<Milkqty>;

    // Define the color palette.
    final Color appBarColor = const Color(0xFF0054A6); // Deep Blue
    final Color backgroundColor = Colors.white; // White background
    final Color primaryTextColor =
        const Color(0xFF333333); // Dark Gray for primary text
    final Color secondaryTextColor =
        const Color(0xFF777777); // Medium Gray for subtitles

    return Scaffold(
      backgroundColor: backgroundColor,
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
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                "Animal Tag No Details:",
                style: TextStyle(
                  color: primaryTextColor,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              DataTableTheme(
                data: DataTableThemeData(
                  headingRowColor: MaterialStateProperty.all(appBarColor),
                  headingTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  dividerThickness: 1.0,
                  dataRowColor: MaterialStateProperty.all(backgroundColor),
                  dataTextStyle: TextStyle(
                    color: primaryTextColor,
                    fontSize: 14,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: appBarColor, width: 1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text("Date")),
                      DataColumn(label: Text("TagNo")),
                      DataColumn(label: Text("AM")),
                      DataColumn(label: Text("PM")),
                    ],
                    rows: records.map((record) {
                      // Format date (assumes record.date is parsable)
                      final dateString = record.date.toString().split(' ')[0];
                      return DataRow(
                        cells: [
                          DataCell(
                            Text(
                              dateString,
                              style: TextStyle(color: primaryTextColor),
                            ),
                          ),
                          DataCell(
                            Text(
                              record.animalTagNo ?? "",
                              style: TextStyle(color: primaryTextColor),
                            ),
                          ),
                          DataCell(
                            Text(
                              record.amQuantity ?? "",
                              style: TextStyle(color: primaryTextColor),
                            ),
                          ),
                          DataCell(
                            Text(
                              record.pmQuantity ?? "",
                              style: TextStyle(color: primaryTextColor),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
