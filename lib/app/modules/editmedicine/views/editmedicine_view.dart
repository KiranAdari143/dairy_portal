import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/editmedicine_controller.dart';

class EditmedicineView extends GetView<EditmedicineController> {
  const EditmedicineView({super.key});
  @override
  Widget build(BuildContext context) {
    // Controller for the date input
    TextEditingController dateController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blue,
                backgroundImage: AssetImage('images/Dhenusya_a.png'),
              ),
            ),
            SizedBox(
              width: Get.width * 0.05, // Adjusted width to make them closer
            ),
            Text("Dairy Portal",
                textAlign: TextAlign.end,
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        toolbarHeight: Get.height * 0.1,
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 69, 71, 193),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            Card(
              color: Colors.indigo,
              child: DrawerHeader(
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  child: Row(
                    children: [
                      SizedBox(
                        width: Get.width * 0.01,
                      ),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.blue,
                        backgroundImage: AssetImage('images/Dhenusya_a.png'),
                      ),
                      SizedBox(
                        width: Get.width * 0.1,
                      ),
                      Text(
                        "Dairy Portal",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )
                    ],
                  )),
            ),
            ListTile(
              title: Text("Employes"),
              leading: Icon(Icons.add),
              onTap: () {
                Get.toNamed("/editemploye");
              },
            ),
            ListTile(
              title: Text("Animal"),
              leading: Icon(Icons.add),
              onTap: () {
                Get.toNamed("/addanimal");
              },
            ),
            ListTile(
              title: Text("Medicine Management"),
              leading: Icon(Icons.add),
              onTap: () {
                Get.toNamed("/medicine-managementscreen");
              },
            ),
            ListTile(
              title: Text("Milk tracker"),
              leading: Icon(Icons.add),
              onTap: () {
                Get.toNamed("/milktrackerscreen");
              },
            ),
            ListTile(
              title: Text("Medicine"),
              leading: Icon(Icons.add),
              onTap: () {
                Get.toNamed("/editmedicine");
              },
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.only(right: 270),
                child: const Text(
                  "Medicine Name",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Medicine Name",
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(115, 157, 155, 155)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        gapPadding: BorderSide.strokeAlignOutside),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 350),
                child: const Text(
                  "Cost",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Cost",
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(115, 157, 155, 155)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        gapPadding: BorderSide.strokeAlignOutside),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 270),
                child: const Text(
                  "Medicine Type",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Medicine Type",
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(115, 157, 155, 155)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        gapPadding: BorderSide.strokeAlignOutside),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.only(right: 300),
                child: const Text(
                  "Description",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Description",
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(115, 157, 155, 155)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        gapPadding: BorderSide.strokeAlignOutside),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 320),
                child: const Text(
                  "Quantity",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Quantity",
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(115, 157, 155, 155)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        gapPadding: BorderSide.strokeAlignOutside),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 290),
                child: const Text(
                  "Expiry date",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: TextField(
                  controller: dateController,
                  decoration: InputDecoration(
                    hintText: "Expiry Date",
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(115, 157, 155, 155)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        gapPadding: BorderSide.strokeAlignOutside),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          String formattedDate =
                              "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                          dateController.text = formattedDate;
                        }
                      },
                    ),
                  ),
                  keyboardType: TextInputType.datetime,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 60.0),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: const BorderSide(color: Colors.indigo))),
                      child: const Text(
                        "CLEAR",
                        style: TextStyle(color: Colors.indigo),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 60.0),
                          backgroundColor: Colors.indigo,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                      child: const Text(
                        "ADD",
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
}
