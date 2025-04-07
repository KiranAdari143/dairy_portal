import 'package:dairy_portal/app/modules/Drawerscreen/views/drawerscreen_view.dart';
import 'package:dairy_portal/app/modules/viewgroupdetails/views/viewgroupdetails_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/milkinganimals_controller.dart';
import 'package:dairy_portal/app/data/groupmodel.dart'; // Ensure this imports your updated models

class MilkinganimalsView extends GetView<MilkinganimalsController> {
  MilkinganimalsView({super.key});
  final Rx<int?> selectedGroupId = Rx<int?>(null);

  @override
  Widget build(BuildContext context) {
    // Define the color palette:
    final Color appBarColor = const Color(0xFF0054A6); // Deep Blue
    final Color backgroundColor = Colors.white; // White background
    final Color cardColor = Colors.white; // White cards
    final Color primaryTextColor =
        const Color(0xFF333333); // Dark Gray for primary text
    final Color secondaryTextColor =
        const Color(0xFF777777); // Medium Gray for subtitles

    final controller = Get.put(MilkinganimalsController());

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
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        toolbarHeight: Get.height * 0.1,
        centerTitle: true,
        backgroundColor: appBarColor,
      ),
      drawer: const DrawerscreenView(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),
                // Button to navigate to Milk Tracker Screen
                ElevatedButton(
                  onPressed: () {
                    Get.toNamed("/milktrackerscreen");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appBarColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("View Milk details"),
                ),
                const SizedBox(height: 30),
                _buildCurrentDatePickerField(
                  label: "Today's Date",
                  controller: controller.Datecontroller,
                  primaryTextColor: primaryTextColor,
                ),
                Obx(() {
                  if (controller.groupIds.isEmpty) {
                    return Text(
                      "No groups available",
                      style: TextStyle(color: primaryTextColor),
                    );
                  }
                  // Add -1 for "All"
                  final allGroupIds = [-1, ...controller.groupIds];
                  return DropdownButton<int>(
                    hint: Text(
                      "Select Group ID",
                      style: TextStyle(color: primaryTextColor),
                    ),
                    value: selectedGroupId.value ?? -1,
                    items: allGroupIds.map((id) {
                      if (id == -1) {
                        return DropdownMenuItem<int>(
                          value: id,
                          child: Text(
                            "All",
                            style: TextStyle(color: primaryTextColor),
                          ),
                        );
                      } else {
                        final group = controller.groupList.firstWhere(
                          (g) => g.groupId == id,
                          orElse: () => Detail(
                            groupId: -1,
                            groupName: 'Unknown Group',
                            employeeId: null,
                            employeeName: null,
                            animals: [],
                          ),
                        );
                        return DropdownMenuItem<int>(
                          value: id,
                          child: Text(
                            "$id (${group.groupName})",
                            style: TextStyle(color: primaryTextColor),
                          ),
                        );
                      }
                    }).toList(),
                    onChanged: (val) {
                      selectedGroupId.value = val == -1 ? null : val;
                      controller.updateSelectedGroup(selectedGroupId.value);
                    },
                  );
                }),
                _buildActionButton(
                  "GET DETAILS",
                  appBarColor,
                  Colors.white,
                  () {
                    controller.updateSelectedGroup(selectedGroupId.value);
                  },
                  primaryTextColor: primaryTextColor,
                ),
                const SizedBox(height: 30),
                Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.selectedGroupDetail.value == null) {
                    return const Center(
                        child: Text("No group details available"));
                  }
                  final group = controller.selectedGroupDetail.value!;
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            group.groupName,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: primaryTextColor,
                            ),
                          ),
                          Text(
                            "Group ID: ${group.groupId}",
                            style: TextStyle(color: secondaryTextColor),
                          ),
                          if (group.employeeName != null)
                            Text(
                              "Employee: ${group.employeeName}",
                              style: TextStyle(color: secondaryTextColor),
                            ),
                          const SizedBox(height: 20),
                          if (group.animals.isNotEmpty)
                            Column(
                              children: group.animals.map((animal) {
                                return Card(
                                  color: cardColor,
                                  margin: const EdgeInsets.only(bottom: 12.0),
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    // Assume AnimalCard is separately styled with the palette.
                                    child: AnimalCard(animal: animal),
                                  ),
                                );
                              }).toList(),
                            )
                          else
                            Center(
                              child: Text(
                                "No animals available",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: primaryTextColor,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}

Widget _buildCurrentDatePickerField({
  required String label,
  required TextEditingController controller,
  required Color primaryTextColor,
}) {
  // Set the initial date to today's date.
  controller.text =
      "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        margin: const EdgeInsets.only(left: 20, bottom: 5),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: primaryTextColor,
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: TextField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            hintText: "Today's date",
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                controller.text =
                    "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
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

Widget _buildActionButton(
  String label,
  Color backgroundColor,
  Color textColor,
  VoidCallback onTap, {
  required Color primaryTextColor,
}) {
  return Container(
    alignment: Alignment.center,
    margin: const EdgeInsets.symmetric(horizontal: 20),
    child: ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 60.0),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: BorderSide(color: textColor),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(color: textColor),
      ),
    ),
  );
}

class AnimalCard extends StatefulWidget {
  final Animal animal; // Using the Animal model directly

  const AnimalCard({Key? key, required this.animal}) : super(key: key);

  @override
  _AnimalCardState createState() => _AnimalCardState();
}

class _AnimalCardState extends State<AnimalCard> {
  String? selectedShift;
  final TextEditingController quantityController = TextEditingController();
  final MilkinganimalsController controller =
      Get.find<MilkinganimalsController>();

  // Define our color palette for the card content:
  final Color primaryTextColor = const Color(0xFF333333); // Dark Gray
  final Color appBarColor = const Color(0xFF0054A6); // Deep Blue

  // Declare and initialize the FocusNode.
  late FocusNode quantityFocusNode;
  bool isQuantityFocused = false;

  @override
  void initState() {
    super.initState();
    selectedShift = "AM";
    quantityFocusNode = FocusNode();
    // Listen to focus changes to update button style.
    quantityFocusNode.addListener(() {
      setState(() {
        isQuantityFocused = quantityFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    quantityController.dispose();
    quantityFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check for missing animal data.
    if ((widget.animal.name == null || widget.animal.name == "N/A") ||
        (widget.animal.tagNo == null || widget.animal.tagNo == "N/A")) {
      return Center(
        child: Text(
          "No animals in this group id ${widget.animal.groupId}",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: appBarColor),
        ),
      );
    }

    // Wrap the content in a Card for subtle elevation and rounded corners.
    return GestureDetector(
      onTap: () {
        // Unfocus when tapping outside.
        FocusScope.of(context).unfocus();
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display the Tag Number.
              Text(
                "Tag No: ${widget.animal.tagNo}",
                style: TextStyle(
                  color: primaryTextColor,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  // Shift selection dropdown.
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          "Shift: ",
                          style: TextStyle(color: primaryTextColor),
                        ),
                        const SizedBox(width: 10),
                        DropdownButton<String>(
                          value: selectedShift,
                          items: ["AM", "PM"].map((shift) {
                            return DropdownMenuItem(
                              value: shift,
                              child: Text(
                                shift,
                                style: TextStyle(color: primaryTextColor),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedShift = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Quantity TextField.
                  Expanded(
                    child: TextField(
                      focusNode: quantityFocusNode,
                      controller: quantityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Quantity",
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Save button.
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final quantity = quantityController.text;
                        if (quantity.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Please enter quantity",
                                style: TextStyle(color: primaryTextColor),
                              ),
                            ),
                          );
                          return;
                        }
                        try {
                          await controller.addMilkingRecord(
                            widget.animal.tagNo.toString(),
                            quantity,
                            selectedShift ?? "AM",
                          );
                          FocusScope.of(context).unfocus();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Milking record saved successfully",
                                style: TextStyle(color: primaryTextColor),
                              ),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Error saving record: $e",
                                style: TextStyle(color: primaryTextColor),
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isQuantityFocused ? appBarColor : Colors.grey,
                      ),
                      child: const Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
