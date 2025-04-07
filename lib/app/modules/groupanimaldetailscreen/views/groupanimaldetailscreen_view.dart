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
            // Header area with title and back button.
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              color: Colors.blue.shade100,
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
                    await _showDateRangePicker(
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

  /// Builds a pivot table with custom header rows and a final totals row.
  /// The design (column spacing, row height, header color, and alternating row colors)
  /// is set to match your sample _buildDatewiseTotalsTable widget.
  Widget _buildAnimalTotalsPivotTable(
    List<dynamic> animalsData,
    GroupanimaldetailscreenController groupController,
    Color appBarColor,
    Color blueLayer,
    String startDateStr,
    String endDateStr,
  ) {
    // Get unique tag numbers.
    final Set<String> tagNos = {};
    for (var animal in animalsData) {
      final tagNo = animal['tag_no']?.toString() ?? '-';
      tagNos.add(tagNo);
    }
    final sortedTagNos = tagNos.toList()..sort();

    // Build DataColumn headers.
    final List<DataColumn> columns = [
      const DataColumn(label: Text("Date")),
      for (var _ in sortedTagNos) ...[
        const DataColumn(label: Text("")),
        const DataColumn(label: Text("")),
        const DataColumn(label: Text("")),
      ],
    ];

    if (animalsData.isEmpty) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(columns: columns, rows: []),
      );
    }

    // Build pivot data from records.
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

    // Generate all dates between startDate and endDate.
    final DateTime startDate = DateTime.tryParse(startDateStr) ??
        DateTime.now().subtract(const Duration(days: 7));
    final DateTime endDate = DateTime.tryParse(endDateStr) ?? DateTime.now();
    final List<String> allDates = [];
    for (DateTime date = startDate;
        !date.isAfter(endDate);
        date = date.add(const Duration(days: 1))) {
      allDates.add(DateFormat('yyyy-MM-dd').format(date));
    }

    // Build DataRows.
    final List<DataRow> rows = [];

    // Header Row 1: Tag Numbers.
    final List<DataCell> headerRow1 = [
      const DataCell(Text("")),
      for (var tag in sortedTagNos) ...[
        DataCell(
          Center(
            child:
                Text(tag, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        const DataCell(Text("")),
        const DataCell(Text("")),
      ]
    ];
    rows.add(DataRow(cells: headerRow1));

    // Header Row 2: Labels for each tag group.
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
            child:
                const Center(child: Text("Total", textAlign: TextAlign.center)),
          ),
        ),
      ]
    ];
    rows.add(DataRow(cells: headerRow2));

    // Main data rows.
    for (int i = 0; i < allDates.length; i++) {
      final date = allDates[i];
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
              child: Center(
                  child:
                      Text(totalValue.toString(), textAlign: TextAlign.center)),
            ),
          ),
        );
      }
      // Alternate row colors like your sample table.
      rows.add(
        DataRow(
          color: MaterialStateProperty.all(
            i % 2 == 0 ? Colors.blue.shade50 : Colors.blue.shade100,
          ),
          cells: cells,
        ),
      );
    }

    // Final Totals Row.
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
              child: Text(total,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      );
    }
    rows.add(DataRow(
        cells: totalsRow,
        color: MaterialStateProperty.all(Colors.grey.shade300)));

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTableTheme(
        data: DataTableThemeData(
          headingRowColor: MaterialStateProperty.all(Colors.grey.shade300),
          dataTextStyle: const TextStyle(fontSize: 14, color: Colors.black87),
          dividerThickness: 1.5,
        ),
        child: DataTable(
          columns: columns,
          rows: rows,
          columnSpacing: 20,
          dataRowHeight: 40,
          headingRowHeight: 40,
          showBottomBorder: true,
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
