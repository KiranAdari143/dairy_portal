import 'package:dairy_portal/app/modules/editanimal/controllers/editanimal_controller.dart';
import 'package:dairy_portal/app/modules/inseminationdetailsreen/controllers/inseminationdetailsreen_controller.dart';
import 'package:dairy_portal/app/modules/medicinescreendetail/controllers/medicinescreendetail_controller.dart';
import 'package:dairy_portal/app/modules/vaccinationdetailscreen/controllers/vaccinationdetailscreen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class InseminationdetailsreenView extends StatefulWidget {
  const InseminationdetailsreenView({Key? key}) : super(key: key);

  @override
  _InseminationdetailsreenViewState createState() =>
      _InseminationdetailsreenViewState();
}

class _InseminationdetailsreenViewState
    extends State<InseminationdetailsreenView> {
  // Color Palette
  final Color appBarColor = const Color(0xFF0054A6); // Deep Blue
  final Color backgroundColor = Colors.white; // White background
  final Color cardColor = Colors.white; // White (if using cards)
  final Color primaryTextColor = const Color(0xFF333333); // Dark Gray
  final Color secondaryTextColor = const Color(0xFF777777); // Medium Gray

  String? selectedOption;
  String? selectedActionOption;

  // Navigation Dropdown Options
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

  // Action Dropdown Options
  List<Map<String, dynamic>> get actionOptions => [
        {
          "label": "Add Heat",
          "action": (BuildContext context) => _showheat(context),
        },
        {
          "label": "Add Breeding",
          "action": (BuildContext context) => _showBreeding(context),
        },
        {
          "label": "Add Pregnancy",
          "action": (BuildContext context) => _showpregnancy(context),
        },
      ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(InseminationdetailsreenController());
    if (controller.animal == null) {
      return const Center(child: CircularProgressIndicator());
    }
    print(
        "Building AnimalDetailScreen with animal id: ${controller.animal.animalId}");

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color.fromRGBO(255, 255, 255, 1)),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Dropdown: Navigation Options
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 180, // fixed width
                  child: DropdownButton<String>(
                    hint: Text(
                      "Select Option",
                      style: TextStyle(color: primaryTextColor),
                    ),
                    value: selectedOption,
                    items: options.map((option) {
                      return DropdownMenuItem<String>(
                        value: option["label"],
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(option["icon"], color: primaryTextColor),
                            const SizedBox(width: 8),
                            Text(
                              option["label"],
                              style: TextStyle(color: primaryTextColor),
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
                          (element) => element["label"] == newValue);
                      option["deleteController"]();
                      Get.toNamed(option["route"],
                          arguments: controller.animal);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Second Dropdown: Action Options for Dialogs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 180,
                  child: DropdownButton<String>(
                    hint: Text(
                      "Select Action",
                      style: TextStyle(color: primaryTextColor),
                    ),
                    value: selectedActionOption,
                    items: actionOptions.map((option) {
                      return DropdownMenuItem<String>(
                        value: option["label"],
                        child: Text(
                          option["label"],
                          style: TextStyle(color: primaryTextColor),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedActionOption = newValue;
                      });
                      final option = actionOptions.firstWhere(
                          (element) => element["label"] == newValue);
                      option["action"](context);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Breed Details
            Text(
              "Breed Details",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryTextColor,
              ),
            ),
            const SizedBox(height: 20),
            Obx(() {
              if (controller.breedList.isEmpty) {
                return Text(
                  "No breed details available",
                  style: TextStyle(color: primaryTextColor),
                );
              }
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
            }),
            const SizedBox(height: 20),
            // Heat Details
            Text(
              "Heat Details",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryTextColor,
              ),
            ),
            const SizedBox(height: 20),
            Obx(() {
              if (controller.heatList.isEmpty) {
                return Text(
                  "No Heat details available",
                  style: TextStyle(color: primaryTextColor),
                );
              }
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
            }),
            const SizedBox(height: 20),
            // Pregnancy Details
            Text(
              "Pregnancy Details",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryTextColor,
              ),
            ),
            const SizedBox(height: 20),
            Obx(() {
              if (controller.pregnancyList.isEmpty) {
                return Text(
                  "No Pregnancy details available",
                  style: TextStyle(color: primaryTextColor),
                );
              }
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(
                      label: Text(
                        "Identification method",
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
            }),
          ],
        ),
      ),
    );
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
    final controller = Get.put(InseminationdetailsreenController());

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
    final controller = Get.put(InseminationdetailsreenController());

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
    final controller = Get.put(InseminationdetailsreenController());

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
