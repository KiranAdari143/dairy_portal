import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/signup_controller.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    final SignupController controller = Get.put(SignupController());
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        toolbarHeight: Get.height * 0.1,
        backgroundColor: const Color(0xFF0054A6),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              backgroundImage: const AssetImage('images/Dhenusya_a.png'),
            ),
            const SizedBox(width: 12),
            Text(
              "Dairy Portal",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  "REGISTER NOW",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0054A6),
                  ),
                ),
                const SizedBox(height: 30),
                textBoxWithValidation(
                  label: "Username",
                  hintText: "Enter your username",
                  controller: controller.usernamecontroller,
                ),
                emailTextBox(controller),
                mobileNumberTextBox(controller),
                passwordTextBox(controller),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: controller.clearFields,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF0054A6)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          "CLEAR",
                          style: TextStyle(color: Color(0xFF0054A6)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: controller.signUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0054A6),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          "SIGNUP",
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
      ),
    );
  }

  Widget emailTextBox(SignupController controller) {
    return Obx(() => textBoxWithValidation(
          label: "Email",
          hintText: "email@example.com",
          controller: controller.emailidcontroller,
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) {
            controller.isEmailValid.value = GetUtils.isEmail(value);
          },
          errorText: controller.isEmailValid.value
              ? null
              : "Please enter a valid email",
        ));
  }

  Widget mobileNumberTextBox(SignupController controller) {
    return Obx(() => textBoxWithValidation(
          label: "Mobile Number",
          hintText: "Enter your mobile number",
          controller: controller.mobilenumbercontroller,
          keyboardType: TextInputType.phone,
          onChanged: (value) {
            controller.isMobileValid.value = GetUtils.isPhoneNumber(value);
          },
          errorText: controller.isMobileValid.value
              ? null
              : "Please enter a valid mobile number",
        ));
  }

  Widget passwordTextBox(SignupController controller) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Password",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0054A6),
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: controller.passwordcontroller,
              obscureText: !controller.isPasswordVisible.value,
              decoration: InputDecoration(
                hintText: "Enter your password",
                hintStyle:
                    const TextStyle(color: Color.fromARGB(115, 157, 155, 155)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
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
            const SizedBox(height: 16),
          ],
        ));
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
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0054A6),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Color.fromARGB(115, 157, 155, 155),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            errorText: errorText,
          ),
        ),
      ],
    ),
  );
}
