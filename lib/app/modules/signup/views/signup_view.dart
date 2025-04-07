import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/signup_controller.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    final SignupController controller = Get.put(SignupController());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: Get.height * 0.1,
        title: Row(
          children: [
            Center(
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xFF0054A6),
                backgroundImage: AssetImage('images/Dhenusya_a.png'),
              ),
            ),
            SizedBox(width: Get.width * 0.1),
            Text(
              "Dairy Portal",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Color(0xFF0054A6),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: Get.height * 0.051),
              Text(
                "REGISTER NOW",
                style: TextStyle(
                    color: Color(0xFF0054A6),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: Get.height * 0.051),
              textBoxWithValidation(
                label: "Username",
                hintText: "username",
                controller: controller.usernamecontroller,
              ),
              emailTextBox(controller),
              mobileNumberTextBox(controller),
              passwordTextBox(controller),
              SizedBox(height: Get.height * 0.031),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: ElevatedButton(
                      onPressed: controller.clearFields,
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 60.0),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side:
                                  const BorderSide(color: Color(0xFF0054A6)))),
                      child: const Text(
                        "CLEAR",
                        style: TextStyle(color: Color(0xFF0054A6)),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: ElevatedButton(
                      onPressed: controller.signUp,
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 60.0),
                          backgroundColor: Color(0xFF0054A6),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                      child: const Text(
                        "SIGNUP",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget emailTextBox(SignupController controller) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textBoxWithValidation(
            label: "Email",
            hintText: "email@example.com",
            controller: controller.emailidcontroller,
            onChanged: (value) {
              controller.isEmailValid.value = GetUtils.isEmail(value);
            },
            errorText: controller.isEmailValid.value
                ? null
                : "Please enter a valid email",
          ),
        ],
      ),
    );
  }

  Widget mobileNumberTextBox(SignupController controller) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textBoxWithValidation(
            label: "Mobile Number",
            hintText: "1234567890",
            controller: controller.mobilenumbercontroller,
            keyboardType: TextInputType.phone,
            onChanged: (value) {
              controller.isMobileValid.value = GetUtils.isPhoneNumber(value);
            },
            errorText: controller.isMobileValid.value
                ? null
                : "Please enter a valid mobile number",
          ),
        ],
      ),
    );
  }

  Widget passwordTextBox(SignupController controller) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20, bottom: 5),
            child: const Text(
              "Password",
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0054A6)),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: controller.passwordcontroller,
              obscureText: !controller.isPasswordVisible.value,
              decoration: InputDecoration(
                hintText: "Password",
                hintStyle:
                    const TextStyle(color: Color.fromARGB(115, 157, 155, 155)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isPasswordVisible.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    controller.isPasswordVisible.value =
                        !controller.isPasswordVisible.value;
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

Widget textBoxWithValidation({
  required String label,
  required String hintText,
  TextInputType? keyboardType,
  required TextEditingController controller,
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
              color: Color(0xFF0054A6)),
        ),
      ),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle:
                const TextStyle(color: Color.fromARGB(115, 157, 155, 155)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            errorText: errorText,
          ),
        ),
      ),
      const SizedBox(height: 10),
    ],
  );
}
