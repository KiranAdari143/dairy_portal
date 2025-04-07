import 'package:dairy_portal/app/data/getanimalmodel.dart';
import 'package:dairy_portal/app/modules/reports/controllers/reports_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/groupanimaldetailscreen_controller.dart';

class GroupanimaldetailscreenView
    extends GetView<GroupanimaldetailscreenController> {
  const GroupanimaldetailscreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final Color appBarColor = const Color(0xFF0054A6);
    final Color blueLayer = appBarColor.withOpacity(0.3);
    final int groupId = Get.arguments["groupId"] ?? 0;
    final String category = Get.arguments["category"] ?? "";

    final reportsController = Get.put(ReportsController());

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              color: blueLayer,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Get.back(),
                  ),
                  Expanded(
                    child: Text(
                      "Animal Detail Tables",
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
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () async {
                    await _DateRangePicker(
                      context,
                      reportsController,
                      groupId,
                    );
                  },
                  icon: const Icon(Icons.search),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(() {
                final details =
                    reportsController.milkingSummary['details'] ?? {};
                final animals = details['animals'] ?? [];
                return _buildAnimalTotalsPivotTable(
                  animals,
                  controller,
                  appBarColor,
                  blueLayer,
                  reportsController.startDate,
                  reportsController.endDate,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimalTotalsPivotTable(
    List<dynamic> animalsData,
    GroupanimaldetailscreenController groupController,
    Color appBarColor,
    Color blueLayer,
    String startDateStr,
    String endDateStr,
  ) {
    final Set<String> tagNos = {};
    for (var animal in animalsData) {
      final tagNo = animal['tag_no']?.toString() ?? '-';
      tagNos.add(tagNo);
    }
    final sortedTagNos = tagNos.toList()..sort();

    final List<DataColumn> columns = [
      const DataColumn(label: Text("Date")),
      for (var _ in sortedTagNos) ...[
        const DataColumn(label: Text("")),
        const DataColumn(label: Text("")),
        const DataColumn(label: Text("")),
      ],
    ];

    final Map<String, Map<String, Map<String, String>>> pivotData = {};
    for (var animal in animalsData) {
      final tagNo = animal['tag_no']?.toString() ?? '-';
      final records = animal['records'] ?? [];
      for (var rec in records) {
        final rawDate = rec['date']?.toString() ?? '';
        final am = rec['am_quantity']?.toString() ?? '-';
        final pm = rec['pm_quantity']?.toString() ?? '-';
        final total = rec['total_quantity']?.toString() ?? '-';
        if (rawDate.isNotEmpty) {
          pivotData.putIfAbsent(rawDate, () => {});
          pivotData[rawDate]!.putIfAbsent(tagNo, () => {});
          pivotData[rawDate]![tagNo]!['am'] = am;
          pivotData[rawDate]![tagNo]!['pm'] = pm;
          pivotData[rawDate]![tagNo]!['total'] = total;
        }
      }
    }

    final DateTime startDate = DateTime.tryParse(startDateStr) ??
        DateTime.now().subtract(const Duration(days: 7));
    final DateTime endDate = DateTime.tryParse(endDateStr) ?? DateTime.now();

    final List<String> allDates = [];
    for (DateTime date = startDate;
        date.isBefore(endDate.add(const Duration(days: 1)));
        date = date.add(const Duration(days: 1))) {
      allDates.add(DateFormat('yyyy-MM-dd').format(date));
    }

    final List<DataRow> rows = [];

    final List<DataCell> headerRow1 = [
      const DataCell(Text("")),
      for (var tag in sortedTagNos) ...[
        DataCell(Center(
            child: Text(tag,
                style: const TextStyle(fontWeight: FontWeight.bold)))),
        const DataCell(Text("")),
        const DataCell(Text("")),
      ]
    ];
    rows.add(DataRow(cells: headerRow1));

    final List<DataCell> headerRow2 = [
      const DataCell(
          Text("Date", style: TextStyle(fontWeight: FontWeight.bold))),
      for (var tag in sortedTagNos) ...[
        const DataCell(Text("AM", textAlign: TextAlign.center)),
        const DataCell(Text("PM", textAlign: TextAlign.center)),
        DataCell(
          Container(
            decoration: BoxDecoration(
              border: Border(
                right: tag != sortedTagNos.last
                    ? const BorderSide(color: Colors.grey)
                    : BorderSide.none,
              ),
            ),
            child: const Center(child: Text("Total")),
          ),
        ),
      ]
    ];
    rows.add(DataRow(cells: headerRow2));

    for (var date in allDates.reversed) {
      final formattedDate = groupController.formatDate(date);
      final List<DataCell> cells = [DataCell(Text(formattedDate))];
      for (var tag in sortedTagNos) {
        final amValue = pivotData[date]?[tag]?['am'] ?? '-';
        final pmValue = pivotData[date]?[tag]?['pm'] ?? '-';
        final totalValue = pivotData[date]?[tag]?['total'] ??
            (amValue != '-' && pmValue != '-'
                ? ((double.tryParse(amValue) ?? 0) +
                        (double.tryParse(pmValue) ?? 0))
                    .toString()
                : '-');
        cells.add(DataCell(Text(amValue, textAlign: TextAlign.center)));
        cells.add(DataCell(Text(pmValue, textAlign: TextAlign.center)));
        cells.add(
          DataCell(
            Container(
              decoration: BoxDecoration(
                border: Border(
                  right: tag != sortedTagNos.last
                      ? BorderSide(color: appBarColor.withOpacity(0.4))
                      : BorderSide.none,
                ),
              ),
              child: Center(child: Text(totalValue.toString())),
            ),
          ),
        );
      }
      rows.add(DataRow(cells: cells));
    }

    final List<DataCell> totalsRow = [
      const DataCell(Text("Overall Totals",
          style: TextStyle(fontWeight: FontWeight.bold))),
    ];
    for (var tag in sortedTagNos) {
      final animal = animalsData.firstWhere(
        (a) => a['tag_no']?.toString() == tag,
        orElse: () => null,
      );
      final amTotal = animal?['am_total']?.toString() ?? '-';
      final pmTotal = animal?['pm_total']?.toString() ?? '-';
      final total = animal?['total']?.toString() ?? '-';
      totalsRow.add(DataCell(Text(amTotal,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold))));
      totalsRow.add(DataCell(Text(pmTotal,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold))));
      totalsRow.add(
        DataCell(
          Container(
            decoration: BoxDecoration(
              border: Border(
                right: tag != sortedTagNos.last
                    ? BorderSide(color: appBarColor.withOpacity(0.4))
                    : BorderSide.none,
              ),
            ),
            child: Center(
              child: Text(
                total,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      );
    }
    rows.add(DataRow(cells: totalsRow));

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTableTheme(
        data: DataTableThemeData(
          headingRowColor: MaterialStateProperty.all(blueLayer),
          dataRowColor: MaterialStateProperty.resolveWith((states) {
            return states.contains(MaterialState.selected)
                ? appBarColor.withOpacity(0.15)
                : null;
          }),
          dividerThickness: 1.5,
        ),
        child: DataTable(
          columns: columns,
          rows: rows,
          columnSpacing: 10,
          dataRowHeight: 48,
          headingRowHeight: 0,
          showBottomBorder: true,
          dividerThickness: 1.5,
        ),
      ),
    );
  }
}

Future<void> _DateRangePicker(
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
