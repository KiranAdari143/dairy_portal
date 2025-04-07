import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Container(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      "images/Dhenusya_a.png",
                      height: 300,
                      width: double.infinity,
                    )),
                SizedBox(
                  height: 20,
                ),
                const Text("LOGIN DETAILS",
                    style: TextStyle(
                        color: Color(0xFF0054A6),
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: Get.height * 0.1,
                ),
                text_box(
                    label: "Mobile Number",
                    hintText: "Mobile number",
                    keyboardType: TextInputType.number,
                    controller: controller.mobilenumbercontroller),
                const SizedBox(
                  height: 10,
                ),
                passwordTextBox(controller),
                SizedBox(height: Get.height * 0.05),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      controller.login();
                    },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 60.0),
                        backgroundColor: Color(0xFF0054A6),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                    child: const Text(
                      "LOGIN",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.04,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 80),
                  child: Row(
                    children: [
                      const Text(
                        "Don't have an account?",
                        style:
                            TextStyle(fontSize: 16, color: Color(0xFF0054A6)),
                      ),
                      InkWell(
                        onTap: () {
                          Get.toNamed('/signup');
                        },
                        child: const Text(
                          "SIGNUP",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0054A6)),
                        ),
                      ),
                      const Text(
                        "?",
                        style:
                            TextStyle(fontSize: 16, color: Color(0xFF0054A6)),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget text_box(
    {required String label,
    required String hintText,
    TextInputType? keyboardType,
    required TextEditingController controller,
    bool? obscureText,
    IconButton? suffixIcon,
    int? maxLines,
    int? minLines}) {
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
          decoration: InputDecoration(
              hintText: hintText,
              hintStyle:
                  const TextStyle(color: Color.fromARGB(115, 157, 155, 155)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  gapPadding: BorderSide.strokeAlignOutside)),
        ),
      ),
      const SizedBox(height: 10),
    ],
  );
}

Widget passwordTextBox(HomeController controller) {
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
            obscureText: !controller.ispasswordVisible.value,
            decoration: InputDecoration(
              hintText: "Password",
              hintStyle:
                  const TextStyle(color: Color.fromARGB(115, 157, 155, 155)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  controller.ispasswordVisible.value
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: () {
                  controller.ispasswordVisible.value =
                      !controller.ispasswordVisible.value;
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
