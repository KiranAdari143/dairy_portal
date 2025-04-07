import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/reports_controller.dart';

class ReportsView extends GetView<ReportsController> {
  const ReportsView({super.key});

  Widget _buildDatewiseTotalsTable(
      String category, ReportsController controller) {
    RxList<dynamic> datewiseTotals = category.toLowerCase() == "cow"
        ? controller.cowDatewiseTotals
        : controller.buffaloDatewiseTotals;

    Map<String, Map<String, dynamic>> recordsMap = {};
    for (var record in datewiseTotals) {
      recordsMap[record["date"]] = record;
    }

    DateTime start = DateTime.parse(controller.startDate);
    DateTime end = DateTime.parse(controller.endDate);
    List<DateTime> dates = [];
    for (DateTime date = start;
        !date.isAfter(end);
        date = date.add(const Duration(days: 1))) {
      dates.add(date);
    }

    Widget fixedCell(String text, {Color? backgroundColor}) {
      return Container(
        height: 20,
        alignment: Alignment.center,
        color: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Text(
          text,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      );
    }

    return Table(
      defaultColumnWidth: const FlexColumnWidth(5),
      border: TableBorder.all(color: Colors.grey.shade300),
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade300),
          children: [
            fixedCell("Date"),
            fixedCell("Morning"),
            fixedCell("Evening"),
            fixedCell("Total"),
          ],
        ),
        for (DateTime date in dates)
          TableRow(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 243, 243, 243),
            ),
            children: [
              fixedCell(DateFormat("MM/dd").format(date)),
              fixedCell(recordsMap[DateFormat("yyyy-MM-dd").format(date)]
                          ?["am_total"]
                      ?.toString() ??
                  ""),
              fixedCell(recordsMap[DateFormat("yyyy-MM-dd").format(date)]
                          ?["pm_total"]
                      ?.toString() ??
                  ""),
              fixedCell(recordsMap[DateFormat("yyyy-MM-dd").format(date)]
                          ?["total"]
                      ?.toString() ??
                  ""),
            ],
          ),
      ],
    );
  }

  Future<void> _showDateRangePicker(BuildContext context,
      ReportsController controller, String animalType) async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: DateTime.parse(controller.startDate),
        end: DateTime.parse(controller.endDate),
      ),
    );

    if (picked != null) {
      controller.startDate = DateFormat('yyyy-MM-dd').format(picked.start);
      controller.endDate = DateFormat('yyyy-MM-dd').format(picked.end);
      await controller.fetchTypeTotals(animalType);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color appBarColor = const Color(0xFF0054A6);
    final Color blueLayer = appBarColor.withOpacity(0.3);
    final controller = Get.put(ReportsController());

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          toolbarHeight: Get.height * 0.1,
          centerTitle: true,
          backgroundColor: appBarColor,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  color: blueLayer,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Get.back(),
                      ),
                      const Expanded(
                        child: Text(
                          "Select Category",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCategoryCard("Buffalo", appBarColor),
                      _buildCategoryCard("Cow", appBarColor),
                    ],
                  ),
                ),
                const TabBar(
                  indicatorColor: Colors.blue,
                  labelColor: Colors.black,
                  tabs: [
                    Tab(text: 'Buffalo'),
                    Tab(text: 'Cow'),
                  ],
                ),
                Builder(
                  builder: (BuildContext innerContext) {
                    return Container(
                      padding: const EdgeInsets.only(right: 16.0, top: 16),
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: const Icon(Icons.search, size: 30),
                        onPressed: () {
                          int tabIndex =
                              DefaultTabController.of(innerContext).index;
                          String currentTab = tabIndex == 0 ? "Buffalo" : "Cow";
                          _showDateRangePicker(
                              innerContext, controller, currentTab);
                        },
                      ),
                    );
                  },
                ),
                Container(
                  height: 400,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TabBarView(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Buffalo",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Obx(() =>
                              _buildDatewiseTotalsTable("Buffalo", controller)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Cow",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Obx(() =>
                              _buildDatewiseTotalsTable("Cow", controller)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String category, Color appBarColor) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/reportspage', arguments: {"category": category});
      },
      child: Card(
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          width: 150,
          height: 150,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                category.toLowerCase() == "buffalo"
                    ? 'images/buffalo.png'
                    : 'images/cow.png',
                fit: BoxFit.cover,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  color: Colors.black45,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    category,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
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
