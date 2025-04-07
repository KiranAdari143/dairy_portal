import 'dart:io';
import 'package:dairy_portal/app/modules/Drawerscreen/views/drawerscreen_view.dart';
import 'package:dairy_portal/app/modules/viewemploye/views/viewemploye_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/addemployee_controller.dart';

class AddemployeeView extends GetView<AddemployeeController> {
  const AddemployeeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller for the date input
    Rx<File?> selectedImage = Rx<File?>(null);

    Future<void> pickImage() async {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        selectedImage.value = File(image.path);
      }
    }

    return PopScope(
      // Allow the pop to occur so that the back action is detected
      canPop: true,
      // Called after the pop is handled.
      // Wrap navigation call in a Future.delayed to allow the pop to complete.
      onPopInvokedWithResult: (popHandled, dynamic result) {
        Future.delayed(Duration.zero, () {
          // Replace the entire stack with ViewemployeView.
          Get.offAll(() => ViewemployeView());
        });
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFF0054A6),
                  backgroundImage: const AssetImage('images/Dhenusya_a.png'),
                ),
              ),
              SizedBox(
                width: Get.width * 0.05,
              ),
              const Text("Dairy Portal",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          toolbarHeight: Get.height * 0.1,
          centerTitle: true,
          backgroundColor: const Color(0xFF0054A6),
        ),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: pickImage,
                  child: Obx(() => CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: selectedImage.value != null
                            ? FileImage(selectedImage.value!)
                            : null,
                        child: selectedImage.value == null
                            ? const Icon(Icons.add_a_photo,
                                color: Colors.white, size: 30)
                            : null,
                      )),
                ),
                const SizedBox(height: 20),
                _buildTextField(
                    label: "Full Name *",
                    hintText: "Full Name",
                    controller: controller.employename),
                _buildDropdownField(
                  label: "Gender",
                  hint: "Select a Gender",
                  items: controller.gender,
                  selectedSkill: controller.selectedGender,
                ),
                _buildDatePickerField(
                  label: "Date of Birth",
                  context: context,
                  controller: controller.datecontroller,
                ),
                mobileNumber(controller),
                _buildTextField(
                    label: "age", hintText: "age", controller: controller.age),
                _buildTextField(
                    label: "Years of experience",
                    hintText: "Years of experience",
                    controller: controller.experience),
                _buildDatePickerField(
                  label: "Joining date",
                  context: context,
                  controller: controller.joiningdate,
                ),
                _buildTextField(
                    label: "Emergency Number",
                    hintText: "Emergency Number",
                    controller: controller.emergencynumber,
                    keyboardType: TextInputType.number),
                _buildTextField(
                    label: "Permanent Address",
                    hintText: "Permanent Address",
                    maxLines: 200,
                    minLines: 100),
                _buildDropdownField(
                  label: "Employee Type",
                  hint: "Select Any",
                  items: controller.employee,
                  selectedSkill: controller.employetype,
                ),
                _buildDropdownField(
                  label: "Department",
                  hint: "Select Any",
                  items: controller.departmentList,
                  selectedSkill: controller.department,
                ),
                _buildDropdownField(
                  label: "Job role",
                  hint: "Select Any",
                  items: controller.job,
                  selectedSkill: controller.jobtype,
                ),
                _buildTextField(
                    label: "Account Number",
                    hintText: "Account Number",
                    length: 18,
                    controller: controller.accountnumber,
                    keyboardType: TextInputType.number),
                _buildTextField(
                    label: "Salary",
                    hintText: "Salary",
                    keyboardType: TextInputType.number,
                    controller: controller.salary),
                _buildTextField(
                    label: "IFSC Code",
                    hintText: "IFSC Code",
                    controller: controller.ifsccode),
                _buildTextField(
                    label: "Pan card number",
                    hintText: "Pan card number",
                    controller: controller.pancardnumber,
                    length: 10,
                    inputFormatters: [UpperCaseTextFormatter()],
                    textcapitalization: TextCapitalization.characters),
                _buildTextField(
                    label: "Enter Aadhaar No",
                    hintText: "Enter aadhar number",
                    controller: controller.adhaarcardnumber,
                    length: 12,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
                _buildPastureDropdown(controller),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildActionButton(
                        "CLEAR", Colors.white, const Color(0xFF0054A6), () {
                      controller.clearfields();
                    }),
                    _buildActionButton(
                        "ADD", const Color(0xFF0054A6), Colors.white, () {
                      controller.addemployee();
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPastureDropdown(AddemployeeController controller) {
    return Obx(() {
      if (controller.pastureList.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20, bottom: 5),
            child: const Text(
              "Select Pasture",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0054A6),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              hint: const Text("Select any"),
              value: controller.selectedPastureId.value.isEmpty
                  ? null
                  : controller.selectedPastureId.value,
              items: controller.pastureList.map((pasture) {
                return DropdownMenuItem<String>(
                  value: pasture.pastureId.toString(),
                  child: Text("${pasture.pastureId} - ${pasture.name}"),
                );
              }).toList(),
              onChanged: (newValue) {
                controller.selectedPastureId.value = newValue!;
              },
            ),
          ),
          const SizedBox(height: 10),
        ],
      );
    });
  }

  Widget _buildTextField({
    required String label,
    required String hintText,
    TextInputType? keyboardType,
    TextEditingController? controller,
    int? maxLines,
    int? minLines,
    List<TextInputFormatter>? inputFormatters,
    int? length,
    TextCapitalization textcapitalization = TextCapitalization.none,
    ValueChanged<String>? onChanged,
    String? errorText,
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
              color: Color(0xFF0054A6),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            textCapitalization: textcapitalization,
            maxLength: length,
            inputFormatters: inputFormatters,
            controller: controller,
            keyboardType: keyboardType,
            onChanged: onChanged,
            decoration: InputDecoration(
                hintText: hintText,
                hintStyle:
                    const TextStyle(color: Color.fromARGB(115, 157, 155, 155)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    gapPadding: BorderSide.strokeAlignOutside),
                errorText: errorText),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildDatePickerField({
    required String label,
    required BuildContext context,
    required TextEditingController controller,
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
              color: Color(0xFF0054A6),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            controller: controller,
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
                        "${pickedDate.year}/${pickedDate.month}/${pickedDate.day}";
                  }
                },
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  gapPadding: BorderSide.strokeAlignOutside),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required List<String> items,
    required RxString selectedSkill,
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
              color: Color(0xFF0054A6),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Obx(() => DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                hint: Text(hint),
                value: selectedSkill.value,
                items: items.map((String skill) {
                  return DropdownMenuItem<String>(
                    value: skill,
                    child: Text(skill),
                  );
                }).toList(),
                onChanged: (newValue) {
                  selectedSkill.value = newValue!;
                },
              )),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildActionButton(String label, Color backgroundColor,
      Color textColor, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 60.0),
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: BorderSide(color: textColor)),
        ),
        child: Text(
          label,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }

  Widget mobileNumber(AddemployeeController controller) {
    return Obx(() => Column(
          children: [
            _buildTextField(
                label: "mobile number",
                hintText: "enter 10 digits mobile number",
                controller: controller.contactno,
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  controller.isMobileValid.value =
                      GetUtils.isPhoneNumber(value);
                },
                errorText: controller.isMobileValid.value
                    ? null
                    : "Please enter a 10 digit mobile number")
          ],
        ));
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
