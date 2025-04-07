import 'package:dairy_portal/app/data/getanimalmodel.dart';
import 'package:dairy_portal/app/modules/reports/controllers/reports_controller.dart';
import 'package:dairy_portal/app/modules/reportspage/controllers/reportspage_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ReportspageView extends StatefulWidget {
  const ReportspageView({super.key});

  @override
  State<ReportspageView> createState() => _ReportspageViewState();
}

class _ReportspageViewState extends State<ReportspageView> {
  final ReportsController controller = Get.put(ReportsController());
  int _expandedIndex = -1; // To track the currently expanded index

  @override
  void initState() {
    super.initState();
    final String category = Get.arguments["category"] ?? "";
    if (category.isNotEmpty) {
      controller.selectedCategory.value = category;
      controller.fetchGroupsByCategory(category);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color appBarColor = const Color(0xFF0054A6);
    final Color blueLayer = appBarColor.withOpacity(0.3);

    return Scaffold(
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
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              color: const Color(0xFFE0F2FF),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Get.back(),
                  ),
                  Expanded(
                    child: Text(
                      "${controller.selectedCategory} Groups",
                      style: const TextStyle(
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
            Expanded(
              child: Obx(() {
                if (controller.isGroupListLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.groupList.isEmpty) {
                  return const Center(child: Text("No groups found."));
                }
                return ListView.builder(
                  itemCount: controller.groupList.length,
                  itemBuilder: (context, index) {
                    final group = controller.groupList[index];
                    final isExpanded = _expandedIndex == index;

                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      elevation: 2,
                      clipBehavior: Clip.antiAlias,
                      child: ExpansionTile(
                        key: Key(index.toString()),
                        initiallyExpanded: isExpanded,
                        title: Text(
                          group.groupName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onExpansionChanged: (expanded) {
                          setState(() {
                            _expandedIndex = expanded ? index : -1;
                          });
                          if (expanded) {
                            controller
                                .fetchMilkingSummaryByGroup(group.groupId);
                          }
                        },
                        children: [
                          Obx(() {
                            if (controller.isMilkingSummaryLoading.value) {
                              return const Padding(
                                padding: EdgeInsets.all(16.0),
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            }

                            if (controller.milkingSummary.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text("No summary available."),
                              );
                            }

                            final details =
                                (controller.milkingSummary['details']
                                        as Map<String, dynamic>?) ??
                                    {};
                            final groupTotals = (details['group_totals']
                                    as Map<String, dynamic>?) ??
                                {};
                            final datewiseTotals =
                                (details['datewise_total'] as List<dynamic>?) ??
                                    [];

                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Group-wise Totals",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              Get.toNamed(
                                                "groupanimaldetailscreen",
                                                arguments: {
                                                  "category": controller
                                                      .selectedCategory.value,
                                                  "groupId": group.groupId,
                                                  "groupName": group.groupName,
                                                },
                                              );
                                            },
                                            icon: const Icon(Icons.visibility),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              _showDateRangePicker(context,
                                                  controller, group.groupId);
                                            },
                                            icon: const Icon(Icons.search),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  _buildDatewiseTotalsTable(
                                      datewiseTotals, controller, groupTotals),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatewiseTotalsTable(List<dynamic> datewise,
      ReportsController controller, Map<String, dynamic> groupTotals) {
    final List<DataRow> rows = [];

    final Map<String, dynamic> dataMap = {
      for (var record in datewise)
        controller.formatDate(record['date'] ?? ''): record
    };

    final DateTime start = DateTime.tryParse(controller.startDate) ??
        DateTime.now().subtract(const Duration(days: 7));
    final DateTime end =
        DateTime.tryParse(controller.endDate) ?? DateTime.now();
    final int totalDays = end.difference(start).inDays;

    for (int i = 0; i <= totalDays; i++) {
      final dateTime = end.subtract(Duration(days: i));
      final dateStr = controller.formatDate(dateTime.toIso8601String());

      final record = dataMap[dateStr] as Map<String, dynamic>? ?? {};
      final am = record['am_total']?.toString() ?? '-';
      final pm = record['pm_total']?.toString() ?? '-';
      final total = record['total']?.toString() ?? '-';

      rows.add(
        DataRow(
          color: MaterialStateProperty.resolveWith(
            (states) => i % 2 == 0 ? Colors.blue.shade50 : Colors.blue.shade100,
          ),
          cells: [
            DataCell(Text(dateStr)),
            DataCell(Text(am)),
            DataCell(Text(pm)),
            DataCell(Text(total)),
          ],
        ),
      );
    }

    rows.add(
      DataRow(
        color: MaterialStateProperty.all(Colors.grey.shade300),
        cells: [
          const DataCell(Text("Overall Totals",
              style: TextStyle(fontWeight: FontWeight.bold))),
          DataCell(Text(groupTotals['am_total']?.toString() ?? '-',
              style: const TextStyle(fontWeight: FontWeight.bold))),
          DataCell(Text(groupTotals['pm_total']?.toString() ?? '-',
              style: const TextStyle(fontWeight: FontWeight.bold))),
          DataCell(Text(groupTotals['total']?.toString() ?? '-',
              style: const TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTableTheme(
        data: DataTableThemeData(
          headingRowColor: MaterialStateProperty.all(Colors.grey.shade300),
        ),
        child: DataTable(
          columnSpacing: 20,
          dataRowHeight: 40,
          columns: const [
            DataColumn(label: Text("Date")),
            DataColumn(label: Text("Morning")),
            DataColumn(label: Text("Evening")),
            DataColumn(label: Text("Total")),
          ],
          rows: rows,
        ),
      ),
    );
  }
}

Future<void> _showDateRangePicker(
  BuildContext context,
  ReportsController controller,
  int groupid,
) async {
  DateTimeRange? picked = await showDateRangePicker(
    context: context,
    firstDate: DateTime(2023),
    lastDate: DateTime.now(),
    initialDateRange: DateTimeRange(
      start: DateTime.tryParse(controller.startDate) ??
          DateTime.now().subtract(const Duration(days: 7)),
      end: DateTime.tryParse(controller.endDate) ?? DateTime.now(),
    ),
  );

  if (picked != null) {
    controller.startDate = DateFormat('yyyy-MM-dd').format(picked.start);
    controller.endDate = DateFormat('yyyy-MM-dd').format(picked.end);
    await controller.fetchMilkingSummaryByGroup(groupid);
  }
}
