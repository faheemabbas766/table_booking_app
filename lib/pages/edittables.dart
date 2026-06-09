import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_booking/Entities/searchobject.dart';
import 'package:table_booking/Providers/searchpro.dart';
import 'package:table_booking/theme/app_theme.dart';

import '../myserver.dart';

class EditTables extends StatefulWidget {
  const EditTables({super.key});

  @override
  State<EditTables> createState() => _EditTablesState();
}

class _EditTablesState extends State<EditTables> {
  DateTime? fromDate;
  DateTime? toDate;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SearchPro>(context);
    final totalAdvance =
        provider.searches.fold<int>(0, (sum, item) => sum + item.advance);
    final totalPersons =
        provider.searches.fold<int>(0, (sum, item) => sum + item.ttlpersons);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Reports"),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("Date Range",
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 10,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => _pickDate(isFrom: true),
                        icon: const Icon(Icons.calendar_month),
                        label: Text(fromDate == null
                            ? "From date"
                            : DateFormat('dd MMM yyyy').format(fromDate!)),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => _pickDate(isFrom: false),
                        icon: const Icon(Icons.calendar_month),
                        label: Text(toDate == null
                            ? "To date"
                            : DateFormat('dd MMM yyyy').format(toDate!)),
                      ),
                      ElevatedButton.icon(
                        onPressed: loading ? null : _loadReport,
                        icon: const Icon(Icons.search),
                        label: const Text("Run Report"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _SummaryTile(
                          label: "Bookings",
                          value: provider.searches.length.toString(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _SummaryTile(
                          label: "Persons",
                          value: totalPersons.toString(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _SummaryTile(
                          label: "Advance",
                          value: "Rs $totalAdvance",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : provider.searches.isEmpty
                    ? const _ReportEmptyState()
                    : _ReportTable(results: provider.searches),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final initial = isFrom ? fromDate : toDate;
    final selected = await showDatePicker(
      context: context,
      initialDate: initial ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(data: AppTheme.pickerTheme(context), child: child!);
      },
    );
    if (selected == null) {
      return;
    }
    setState(() {
      if (isFrom) {
        fromDate = selected;
      } else {
        toDate = selected;
      }
    });
  }

  Future<void> _loadReport() async {
    setState(() => loading = true);
    await MyServer.searchAllBooking(context, fromDate, toDate);
    if (!mounted) {
      return;
    }
    setState(() => loading = false);
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}

class _ReportTable extends StatelessWidget {
  const _ReportTable({required this.results});

  final List<SearchObject> results;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor:
                WidgetStateColor.resolveWith((states) => AppTheme.primaryDark),
            dataRowColor:
                WidgetStateColor.resolveWith((states) => Colors.white),
            columns: const [
              DataColumn(label: Text("Customer")),
              DataColumn(label: Text("Date")),
              DataColumn(label: Text("Area")),
              DataColumn(label: Text("Table")),
              DataColumn(label: Text("Persons")),
              DataColumn(label: Text("Advance")),
            ],
            rows: results.map((item) {
              return DataRow(
                cells: [
                  DataCell(Text(item.name)),
                  DataCell(
                      Text(DateFormat('dd MMM yyyy').format(item.bookedfor))),
                  DataCell(Text(item.areaname)),
                  DataCell(Text(item.tablename)),
                  DataCell(Text(item.ttlpersons.toString())),
                  DataCell(Text("Rs ${item.advance}")),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _ReportEmptyState extends StatelessWidget {
  const _ReportEmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.assessment_outlined,
                size: 46, color: AppTheme.textSecondary),
            const SizedBox(height: 12),
            Text("No report loaded",
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(
              "Choose a date range and run the report.",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
