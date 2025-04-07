import 'package:dairy_portal/app/modules/animaldetailscreen/controllers/animaldetailscreen_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:dotted_border/dotted_border.dart';

class AnimaldetailscreenView extends StatefulWidget {
  const AnimaldetailscreenView({Key? key}) : super(key: key);

  @override
  _AnimaldetailscreenViewState createState() => _AnimaldetailscreenViewState();
}

class _AnimaldetailscreenViewState extends State<AnimaldetailscreenView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AnimaldetailscreenController controller =
      Get.put(AnimaldetailscreenController());
  // Color Palette
  final Color appBarColor = const Color(0xFF0054A6); // Deep Blue
  final Color backgroundColor = Colors.white; // White background
  final Color cardColor = Colors.white; // White (if using cards)
  final Color primaryTextColor = const Color(0xFF333333); // Dark Gray
  final Color secondaryTextColor = const Color(0xFF777777); // Medium Gray

  String? selectedActionOption;

  final Color selectedTabColor = const Color(0xFF0054A6); // Blue text
  final Color unselectedTabColor = const Color(0xFF777777); // Gray text
  // Action Dropdown Options

  @override
  void initState() {
    super.initState();
    // For example, 5 tabs: Timeline, Breeding, Offspring, Performance, Health.
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Create a blue layer with 30% opacity.
    final Color blueLayer = appBarColor.withOpacity(0.3);

    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          iconTheme: const IconThemeData(color: Colors.white),
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
        body: Column(
          children: [
            // Blue layer container below AppBar.
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
                    "Animal Details",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.green),
                    onPressed: () {
                      Get.toNamed("/editanimal", arguments: controller.animal);
                    },
                  ),
                ],
              ),
            ),
            // TabBar section below the blue layer.
            Material(
              color: backgroundColor, // Background for the TabBar.
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: selectedTabColor,
                unselectedLabelColor: unselectedTabColor,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      spreadRadius: 1,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                tabs: const [
                  Tab(text: 'Timeline'),
                  Tab(text: 'Breeding'),
                  Tab(text: 'Health'),
                  Tab(text: 'Milking'),
                  Tab(text: 'Performance'),
                  Tab(text: 'Offspring'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Center(child: Text('Timeline Content')),
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),

                        // ------------------ BREEDING SECTION ------------------
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Left-aligned text: e.g. "Breeding (X breedings | active)"
                            Text(
                              "Breeding (${controller.breedList.length} breeding | active)",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: primaryTextColor,
                              ),
                            ),
                            // Right-aligned button: "New Breeding"
                            ElevatedButton(
                              onPressed: () {
                                _showBreeding(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: appBarColor,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text("Add Breeding"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        Obx(() {
                          if (controller.breedList.isEmpty) {
                            // If empty, show a dotted placeholder
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              child: DottedBorder(
                                color: Colors.grey,
                                strokeWidth: 1,
                                dashPattern: const [4, 3], // Adjust for style
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(8),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Add a breeding by clicking 'New Breeding'.",
                                    style: TextStyle(color: primaryTextColor),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            // If we have data, show a DataTable
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columns: [
                                  DataColumn(
                                    label: Text(
                                      "Breed",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: primaryTextColor,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Date",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: primaryTextColor,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Method",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: primaryTextColor,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Status",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: primaryTextColor,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: controller.breedList.map((breed) {
                                  return DataRow(cells: [
                                    DataCell(Text(
                                      breed.inseminationBreed,
                                      style: TextStyle(color: primaryTextColor),
                                    )),
                                    DataCell(Text(
                                      _formatDate(breed.inseminationDate),
                                      style: TextStyle(color: primaryTextColor),
                                    )),
                                    DataCell(Text(
                                      breed.inseminationType,
                                      style: TextStyle(color: primaryTextColor),
                                    )),
                                    DataCell(Text(
                                      breed.inseminationStatus,
                                      style: TextStyle(color: primaryTextColor),
                                    )),
                                  ]);
                                }).toList(),
                              ),
                            );
                          }
                        }),

                        const SizedBox(height: 30),

                        // ------------------ PREGNANCY CHECKS SECTION ------------------
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Pregnancy Checks (${controller.pregnancyList.length} checks)",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: primaryTextColor,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _showpregnancy(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: appBarColor,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text("Add Pregnancy "),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        Obx(() {
                          if (controller.pregnancyList.isEmpty) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              child: DottedBorder(
                                color: Colors.grey,
                                strokeWidth: 1,
                                dashPattern: const [4, 3],
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(8),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Add a pregnancy check by clicking 'New Pregnancy Check'.",
                                    style: TextStyle(color: primaryTextColor),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columns: [
                                  DataColumn(
                                    label: Text(
                                      "Identification",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: primaryTextColor,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Pregnancy Date",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: primaryTextColor,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Diagnostic Result",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: primaryTextColor,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Comments",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: primaryTextColor,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: controller.pregnancyList.map((pregnancy) {
                                  return DataRow(cells: [
                                    DataCell(Text(
                                      pregnancy.identificationtype,
                                      style: TextStyle(color: primaryTextColor),
                                    )),
                                    DataCell(Text(
                                      _formatDate(pregnancy.checkdate),
                                      style: TextStyle(color: primaryTextColor),
                                    )),
                                    DataCell(Text(
                                      pregnancy.diagnosticresult,
                                      style: TextStyle(color: primaryTextColor),
                                    )),
                                    DataCell(Text(
                                      pregnancy.comments,
                                      style: TextStyle(color: primaryTextColor),
                                    )),
                                  ]);
                                }).toList(),
                              ),
                            );
                          }
                        }),

                        const SizedBox(height: 30),

                        // ------------------ HEATS SECTION ------------------
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Heats (${controller.heatList.length} total)",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: primaryTextColor,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _showheat(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: appBarColor,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text("Add Heat"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        Obx(() {
                          if (controller.heatList.isEmpty) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              child: DottedBorder(
                                color: Colors.grey,
                                strokeWidth: 1,
                                dashPattern: const [4, 3],
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(8),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Add a heat by clicking 'New Heat'.",
                                    style: TextStyle(color: primaryTextColor),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columns: [
                                  DataColumn(
                                    label: Text(
                                      "Animal Tag",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: primaryTextColor,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Date",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: primaryTextColor,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Observed By",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: primaryTextColor,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Score",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: primaryTextColor,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: controller.heatList.map((heat) {
                                  return DataRow(cells: [
                                    DataCell(Text(
                                      heat.animalTagNo,
                                      style: TextStyle(color: primaryTextColor),
                                    )),
                                    DataCell(Text(
                                      _formatDate(heat.heatDate),
                                      style: TextStyle(color: primaryTextColor),
                                    )),
                                    DataCell(Text(
                                      heat.observedBy,
                                      style: TextStyle(color: primaryTextColor),
                                    )),
                                    DataCell(Text(
                                      heat.score,
                                      style: TextStyle(color: primaryTextColor),
                                    )),
                                  ]);
                                }).toList(),
                              ),
                            );
                          }
                        }),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),

                  // ------------------ MEDICINE SECTION ------------------
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "Medicine (${controller.medicineList.length} records)",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: primaryTextColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => _showAddMedicinePopup(
                                  context, primaryTextColor, appBarColor),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: appBarColor,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text("Add Medicine"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Obx(() {
                          if (controller.medicineList.isEmpty) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              child: DottedBorder(
                                color: Colors.grey,
                                strokeWidth: 1,
                                dashPattern: const [4, 3],
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(8),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Add a medicine by clicking 'Add Medicine'.",
                                    style: TextStyle(color: primaryTextColor),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columns: [
                                  DataColumn(
                                    label: Text(
                                      "Date",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: primaryTextColor,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Medicine",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: primaryTextColor,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Dosage",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: primaryTextColor,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Cost",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: primaryTextColor,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Description",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: primaryTextColor,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: controller.medicineList.map((medicine) {
                                  return DataRow(cells: [
                                    DataCell(Text(
                                      medicine.medicineDate,
                                      style: TextStyle(color: primaryTextColor),
                                    )),
                                    DataCell(Text(
                                      medicine.medicineName,
                                      style: TextStyle(color: primaryTextColor),
                                    )),
                                    DataCell(Text(
                                      medicine.dosage.toString(),
                                      style: TextStyle(color: primaryTextColor),
                                    )),
                                    DataCell(Text(
                                      medicine.medicineCost.toString(),
                                      style: TextStyle(color: primaryTextColor),
                                    )),
                                    DataCell(Text(
                                      medicine.medicineDescription,
                                      style: TextStyle(color: primaryTextColor),
                                    )),
                                  ]);
                                }).toList(),
                              ),
                            );
                          }
                        }),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "Vaccine (${controller.vaccineList.length} records)",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: primaryTextColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => _showvaccinepopup(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: appBarColor,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text("Add Vaccine"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Obx(() {
                          if (controller.vaccineList.isEmpty) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              child: DottedBorder(
                                color: Colors.grey,
                                strokeWidth: 1,
                                dashPattern: const [4, 3],
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(8),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Add a Vaccine by clicking 'Add Vaccine'.",
                                    style: TextStyle(color: primaryTextColor),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columns: [
                                  DataColumn(
                                    label: Text(
                                      "Vaccine Name",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: primaryTextColor,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Vaccine Type",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: primaryTextColor,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Vaccine Date",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: primaryTextColor,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Dosage",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: primaryTextColor,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: controller.vaccineList.map((vaccine) {
                                  return DataRow(cells: [
                                    DataCell(Text(
                                      vaccine.vaccineName,
                                      style: TextStyle(color: primaryTextColor),
                                    )),
                                    DataCell(Text(
                                      vaccine.vaccineType,
                                      style: TextStyle(color: primaryTextColor),
                                    )),
                                    DataCell(Text(
                                      vaccine.vaccineDate,
                                      style: TextStyle(color: primaryTextColor),
                                    )),
                                    DataCell(Text(
                                      vaccine.dosage.toString(),
                                      style: TextStyle(color: primaryTextColor),
                                    )),
                                  ]);
                                }).toList(),
                              ),
                            );
                          }
                        }),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),

                        // Title + "Search" button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Milking Summary",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color:
                                    primaryTextColor, // adjust color if needed
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () =>
                                  _showMilkingSearchDialog(context),
                              icon: const Icon(Icons.search),
                              label: const Text("Search"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: appBarColor,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Obx(() {
                          if (controller.milkingDataList.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                "No milking data found for this range.",
                                style: TextStyle(color: primaryTextColor),
                              ),
                            );
                          } else {
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTableTheme(
                                data: DataTableThemeData(
                                    // Set header background color
                                    headingRowColor: MaterialStateProperty.all(
                                        Colors.grey.shade300),
                                    // Set divider thickness to 0 to remove borders
                                    dividerThickness: 0,
                                    columnSpacing: 50),
                                child: DataTable(
                                  columns: [
                                    DataColumn(
                                      label: Text(
                                        "Date",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: primaryTextColor,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "EmpId",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: primaryTextColor,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "am",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: primaryTextColor,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "pm",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: primaryTextColor,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "Total",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: primaryTextColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                  rows: controller.milkingDataList
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    final index = entry.key;
                                    final milk = entry.value;
                                    // Alternate row colors for visual variety
                                    final Color rowColor = index % 2 == 0
                                        ? Colors.blue.shade50
                                        : Colors.blue.shade100;
                                    return DataRow(
                                      // Use MaterialStateProperty.resolveWith to apply our custom color
                                      color: MaterialStateProperty.resolveWith(
                                          (states) => rowColor),
                                      cells: [
                                        DataCell(
                                          Text(
                                            controller.formatToMMDD(milk.date),
                                            style: TextStyle(
                                                color: primaryTextColor),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            controller.animal.animalId
                                                .toString(),
                                            style: TextStyle(
                                                color: primaryTextColor),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            milk.am,
                                            style: TextStyle(
                                                color: primaryTextColor),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            milk.pm,
                                            style: TextStyle(
                                                color: primaryTextColor),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            milk.total,
                                            style: TextStyle(
                                                color: primaryTextColor),
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          }
                        }),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),

                  Center(child: Text('Offspring Content')),
                  Center(child: Text('Performance Content')),
                ],
              ),
            )
          ],
        ));
  }

  Future<void> _showMilkingSearchDialog(BuildContext context) async {
    // Default range: last 15 days to today
    DateTime startDate = DateTime.now().subtract(const Duration(days: 15));
    DateTime endDate = DateTime.now();
    final controller = Get.put(AnimaldetailscreenController());

    await showDialog(
      context: context,
      barrierDismissible: false, // user must tap a button
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Search Milking Data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Start Date
              ElevatedButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: ctx,
                    initialDate: startDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    startDate = picked;
                  }
                },
                child: Text(
                  "Select Start Date: ${_formatDates(startDate)}",
                ),
              ),
              const SizedBox(height: 10),
              // End Date
              ElevatedButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: ctx,
                    initialDate: endDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    endDate = picked;
                  }
                },
                child: Text(
                  "Select End Date: ${_formatDates(endDate)}",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(ctx).pop(); // close dialog
              },
            ),
            TextButton(
              child: const Text('Search'),
              onPressed: () {
                // Pass DateTime objects directly
                controller.fetchMilkingDataForAnimal(
                  startDate: startDate,
                  endDate: endDate,
                );
                Navigator.of(ctx).pop(); // close dialog
              },
            ),
          ],
        );
      },
    );
  }

// Example date formatter (or you can use your existing _formatDate function)
  String _formatDates(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // Format date strings to 'yyyy-MM-dd'
  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      DateTime dt = DateTime.parse(dateStr);
      return DateFormat('yyyy-MM-dd').format(dt);
    } catch (e) {
      return dateStr;
    }
  }

  // Show Breeding Dialog
  void _showBreeding(BuildContext context) {
    final controller = Get.put(AnimaldetailscreenController());

    Get.dialog(
      AlertDialog(
        title: Text(
          "Add Breeding for Animal id: ${controller.animal.animalId}",
          style:
              TextStyle(fontWeight: FontWeight.bold, color: primaryTextColor),
        ),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDatePickerField(
                  label: "Date of Insemination",
                  context: context,
                  controller: controller.inseminationdate,
                  primaryTextColor: primaryTextColor,
                ),
                dropdown_box(
                  label: "Insemination Method",
                  hint: "Select Insemination Method",
                  items: const ["AI", "Natural service"],
                  selectedSkill: controller.method.value.isEmpty
                      ? null
                      : controller.method.value,
                  onChanged: (value) {
                    controller.method.value = value!;
                  },
                ),
                text_box(
                  label: "Insemination Breed",
                  hintText: "Enter Insemination Breed",
                  controller: controller.inseminationbreed,
                  primaryTextColor: primaryTextColor,
                ),
                dropdown_box(
                  label: "Semen Type",
                  hint: "Select Semen Type",
                  items: const ["Frozen", "Fresh", "Other"],
                  selectedSkill: controller.sementype.value.isEmpty
                      ? null
                      : controller.sementype.value,
                  onChanged: (value) {
                    controller.sementype.value = value!;
                  },
                ),
                dropdown_box(
                  label: "Insemination Status",
                  hint: "Select Insemination Status",
                  items: const ["Success", "Failure", "Pending", "Other"],
                  selectedSkill: controller.inseminationstatus.value.isEmpty
                      ? null
                      : controller.inseminationstatus.value,
                  onChanged: (value) {
                    controller.inseminationstatus.value = value!;
                  },
                ),
                dropdown_box(
                  label: "Pregnancy Status",
                  hint: "Select Pregnancy Status",
                  items: const ["Success", "Failure", "Pending", "noresult"],
                  selectedSkill: controller.pregnancystatus.value.isEmpty
                      ? null
                      : controller.pregnancystatus.value,
                  onChanged: (value) {
                    controller.pregnancystatus.value = value!;
                  },
                ),
                text_box(
                  label: "AI Technician Name",
                  hintText: "Enter AI Technician Name",
                  controller: controller.technicianname,
                  primaryTextColor: primaryTextColor,
                ),
                text_box(
                  label: "AI Technician Notes",
                  hintText: "Enter AI Technician Notes",
                  controller: controller.techniciannotes,
                  primaryTextColor: primaryTextColor,
                ),
                dropdown_box(
                  label: "Insemination Result",
                  hint: "Select Insemination Result",
                  items: const [
                    "Pregnant",
                    "Not Pregnant",
                    "No result",
                    "Other"
                  ],
                  selectedSkill: controller.inseminationresult.value.isEmpty
                      ? null
                      : controller.inseminationresult.value,
                  onChanged: (value) {
                    controller.inseminationresult.value = value!;
                  },
                ),
                _buildDatePickerField(
                  label: "Pregnancy Test Date",
                  context: context,
                  controller: controller.pregnancydate,
                  primaryTextColor: primaryTextColor,
                ),
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: appBarColor,
              foregroundColor: Colors.white,
            ),
            child: const Text("CLOSE"),
          ),
          ElevatedButton(
            onPressed: () {
              // Optionally clear fields here if needed
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: appBarColor,
              foregroundColor: Colors.white,
            ),
            child: const Text("CLEAR"),
          ),
          ElevatedButton(
            onPressed: () async {
              await controller.addInseminationdetails();
              Get.snackbar(
                "Success",
                "Saved details of Breed",
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.green,
                colorText: Colors.white,
                margin: const EdgeInsets.all(10),
                borderRadius: 8,
                duration: const Duration(seconds: 2),
                snackStyle: SnackStyle.FLOATING,
              );
              await Future.delayed(const Duration(seconds: 1));
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: appBarColor,
              foregroundColor: Colors.white,
            ),
            child: const Text("SAVE"),
          ),
        ],
      ),
    );
  }

  // Show Heat Dialog
  void _showheat(BuildContext context) {
    final controller = Get.put(AnimaldetailscreenController());

    Get.dialog(
      AlertDialog(
        title: Text(
          "Add Heat for Animal id: ${controller.animal.animalId}",
          style:
              TextStyle(fontWeight: FontWeight.bold, color: primaryTextColor),
        ),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDatePickerField(
                  label: "Heat date",
                  context: context,
                  controller: controller.heatdate,
                  primaryTextColor: primaryTextColor,
                ),
                _buildTimePickerField(
                  label: "Select Time",
                  context: context,
                  controller: controller.heattimeController,
                  primaryTextColor: primaryTextColor,
                ),
                text_box(
                  label: "Observed By",
                  hintText: "Enter Technician Name",
                  controller: controller.observedby,
                  primaryTextColor: primaryTextColor,
                ),
                text_box(
                  label: "Score",
                  hintText: "Enter Score",
                  controller: controller.score,
                  primaryTextColor: primaryTextColor,
                ),
                text_box(
                  label: "Comments",
                  hintText: "Enter Comments",
                  controller: controller.comments,
                  primaryTextColor: primaryTextColor,
                ),
                _buildDatePickerField(
                  label: "Heat Identification Date",
                  context: context,
                  controller: controller.heatidentification,
                  primaryTextColor: primaryTextColor,
                ),
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: appBarColor,
              foregroundColor: Colors.white,
            ),
            child: const Text("CLOSE"),
          ),
          ElevatedButton(
            onPressed: () {
              // Optionally clear fields here if needed
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: appBarColor,
              foregroundColor: Colors.white,
            ),
            child: const Text("CLEAR"),
          ),
          ElevatedButton(
            onPressed: () async {
              await controller.addHeat();
              Get.snackbar(
                "Success",
                "Saved details of Heat",
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.green,
                colorText: Colors.white,
                margin: const EdgeInsets.all(10),
                borderRadius: 8,
                duration: const Duration(seconds: 2),
                snackStyle: SnackStyle.FLOATING,
              );
              await Future.delayed(const Duration(seconds: 1));
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: appBarColor,
              foregroundColor: Colors.white,
            ),
            child: const Text("SAVE"),
          ),
        ],
      ),
    );
  }

  // Show Pregnancy Dialog
  void _showpregnancy(BuildContext context) {
    final controller = Get.put(AnimaldetailscreenController());

    Get.dialog(
      AlertDialog(
        title: Text(
          "Add Pregnancy for Animal id: ${controller.animal.animalId}",
          style:
              TextStyle(fontWeight: FontWeight.bold, color: primaryTextColor),
        ),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDatePickerField(
                  label: "Pregnancy date",
                  context: context,
                  controller: controller.checkdat,
                  primaryTextColor: primaryTextColor,
                ),
                text_box(
                  label: "Identification Method",
                  hintText: "Enter Identification Method",
                  controller: controller.identification,
                  primaryTextColor: primaryTextColor,
                ),
                text_box(
                  label: "Diagnostic Result",
                  hintText: "Enter Diagnostic Result",
                  controller: controller.diagnostic,
                  primaryTextColor: primaryTextColor,
                ),
                text_box(
                  label: "Comments",
                  hintText: "Enter Comments",
                  controller: controller.comment,
                  primaryTextColor: primaryTextColor,
                ),
                text_box(
                  label: "Pregnancy Screening",
                  hintText: "Enter Pregnancy Screening",
                  controller: controller.pregnancyscreen,
                  primaryTextColor: primaryTextColor,
                ),
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: appBarColor,
              foregroundColor: Colors.white,
            ),
            child: const Text("CLOSE"),
          ),
          ElevatedButton(
            onPressed: () {
              // Optionally clear fields here if needed
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: appBarColor,
              foregroundColor: Colors.white,
            ),
            child: const Text("CLEAR"),
          ),
          ElevatedButton(
            onPressed: () async {
              await controller.addPregnancy();
              Get.snackbar(
                "Success",
                "Saved details of pregnancy",
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.green,
                colorText: Colors.white,
                margin: const EdgeInsets.all(10),
                borderRadius: 8,
                duration: const Duration(seconds: 2),
                snackStyle: SnackStyle.FLOATING,
              );
              await Future.delayed(const Duration(seconds: 1));
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: appBarColor,
              foregroundColor: Colors.white,
            ),
            child: const Text("SAVE"),
          ),
        ],
      ),
    );
  }
}

/// Popup for adding medicine details
void _showAddMedicinePopup(
  BuildContext context,
  Color primaryTextColor,
  Color appBarColor,
) {
  final controller = Get.find<AnimaldetailscreenController>();

  Get.dialog(
    AlertDialog(
      title: Text(
        "Add Medicine for Animal id: ${controller.animal.animalId}",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: primaryTextColor,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            text_box(
              label: "Medicine Name",
              hintText: "Enter medicine name",
              controller: controller.medicinename,
              primaryTextColor: primaryTextColor,
            ),
            text_box(
              label: "Medicine Description",
              hintText: "Enter Medicine Description",
              controller: controller.medicinedescription,
              primaryTextColor: primaryTextColor,
            ),
            _buildDatePickerField(
              label: "Medicine Date",
              context: context,
              controller: controller.medicinedate,
              primaryTextColor: primaryTextColor,
            ),
            text_box(
              label: "Medicine Cost",
              hintText: "Enter Medicine cost",
              controller: controller.medicineCost,
              primaryTextColor: primaryTextColor,
            ),
            text_box(
              label: "Dosage",
              hintText: "Dosage",
              controller: controller.dosage,
              primaryTextColor: primaryTextColor,
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Get.back();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: appBarColor,
            foregroundColor: Colors.white,
          ),
          child: const Text("CLOSE"),
        ),
        ElevatedButton(
          onPressed: () async {
            await controller.addMedicine();
            Get.snackbar(
              "Success",
              "Saved details of Medicine",
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.green,
              colorText: Colors.white,
              margin: const EdgeInsets.all(10),
              borderRadius: 8,
              duration: const Duration(seconds: 2),
              snackStyle: SnackStyle.FLOATING,
            );
            await Future.delayed(const Duration(seconds: 1));
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: appBarColor,
            foregroundColor: Colors.white,
          ),
          child: const Text("SAVE"),
        ),
      ],
    ),
  );
}

/// Popup for adding vaccine details.
void _showvaccinepopup(BuildContext context) {
  final controller = Get.find<AnimaldetailscreenController>();
  final Color appBarColor = const Color(0xFF0054A6);
  final Color primaryTextColor = const Color(0xFF333333);
  Get.dialog(
    AlertDialog(
      title: Text(
        "Add Vaccine for Animal id: ${controller.animal.animalId}",
        style: TextStyle(fontWeight: FontWeight.bold, color: primaryTextColor),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            text_box(
              label: "Vaccine Name",
              hintText: "Enter vaccine name",
              controller: controller.vaccinename,
              primaryTextColor: primaryTextColor,
            ),
            text_box(
              label: "Vaccine Type",
              hintText: "Enter Vaccine Description",
              controller: controller.vaccinedescription,
              primaryTextColor: primaryTextColor,
            ),
            _buildDatePickerField(
              label: "Vaccine Date",
              context: context,
              controller: controller.vaccinedate,
              primaryTextColor: primaryTextColor,
            ),
            text_box(
              label: "Dosage",
              hintText: "Dosage",
              controller: controller.dosage,
              primaryTextColor: primaryTextColor,
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Get.back();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: appBarColor,
          ),
          child: const Text(
            "CLOSE",
            style: TextStyle(color: Colors.white),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            await controller.addVaccine();
            Get.snackbar(
              "Success",
              "Saved details of Vaccine",
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.green,
              colorText: Colors.white,
              margin: const EdgeInsets.all(10),
              borderRadius: 8,
              duration: const Duration(seconds: 2),
              snackStyle: SnackStyle.FLOATING,
            );
            await Future.delayed(const Duration(seconds: 1));
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: appBarColor,
          ),
          child: const Text(
            "SAVE",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
  );
}

// Reusable text input field
Widget text_box({
  required String label,
  required String hintText,
  TextInputType? keyboardType,
  int? maxLines,
  int? minLines,
  required TextEditingController controller,
  required Color primaryTextColor,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        margin: const EdgeInsets.only(left: 20, bottom: 5),
        child: Text(
          label,
          style:
              TextStyle(fontWeight: FontWeight.bold, color: primaryTextColor),
        ),
      ),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Color.fromARGB(115, 157, 155, 155),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          maxLines: maxLines,
          minLines: minLines,
        ),
      ),
      const SizedBox(height: 10),
    ],
  );
}

// Date Picker
Widget _buildDatePickerField({
  required String label,
  required BuildContext context,
  required TextEditingController controller,
  required Color primaryTextColor,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        margin: const EdgeInsets.only(left: 20, bottom: 5),
        child: Text(
          label,
          style:
              TextStyle(fontWeight: FontWeight.bold, color: primaryTextColor),
        ),
      ),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: TextField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            hintText: "Select a date",
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1947),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  controller.text =
                      "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                }
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      ),
      const SizedBox(height: 10),
    ],
  );
}

// Dropdown widget
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
        margin: const EdgeInsets.only(left: 20, bottom: 5),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333), // Use primaryTextColor or brand color
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          width: double.infinity,
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            hint: Text(hint),
            value: selectedSkill,
            items: items.map((String skill) {
              return DropdownMenuItem<String>(
                value: skill,
                child: Text(skill),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
      const SizedBox(height: 10),
    ],
  );
}

// Time Picker
Widget _buildTimePickerField({
  required String label,
  required BuildContext context,
  required TextEditingController controller,
  required Color primaryTextColor,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        margin: const EdgeInsets.only(left: 20, bottom: 5),
        child: Text(
          label,
          style:
              TextStyle(fontWeight: FontWeight.bold, color: primaryTextColor),
        ),
      ),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: TextField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            hintText: "Select Time",
            suffixIcon: IconButton(
              icon: const Icon(Icons.access_time),
              onPressed: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  final localizations = MaterialLocalizations.of(context);
                  final formattedTime =
                      localizations.formatTimeOfDay(pickedTime);
                  controller.text = formattedTime;
                }
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      ),
      const SizedBox(height: 10),
    ],
  );
}
