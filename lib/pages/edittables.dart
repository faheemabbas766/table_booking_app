import 'package:flutter/material.dart';
import 'package:table_booking/theme/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Api & Routes/routes.dart';
import '../Entities/searchobject.dart';
import '../Providers/searchpro.dart';
import '../myserver.dart';

// Import the necessary classes and models (e.g., SearchPro, SearchObject, RouteManager, MyServer)

class EditTables extends StatefulWidget {
  const EditTables({super.key});

  @override
  State<EditTables> createState() => _EditTablesState();
}

class _EditTablesState extends State<EditTables> {
  DateTime? fromDate;
  DateTime? toDate;

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchPro>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        centerTitle: true,
        title: Text("Report All",
            style: TextStyle(fontSize: RouteManager.width / 17)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Wrap(
              spacing: 12,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: fromDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        fromDate = selectedDate;
                      });
                    }
                  },
                  icon: const Icon(Icons.calendar_month),
                  label: Text(fromDate != null
                      ? "From: ${DateFormat('dd-MM-yyyy').format(fromDate!)}"
                      : "From Date"),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: toDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        toDate = selectedDate;
                      });
                    }
                  },
                  icon: const Icon(Icons.calendar_month),
                  label: Text(toDate != null
                      ? "To: ${DateFormat('dd-MM-yyyy').format(toDate!)}"
                      : "To Date"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await MyServer.searchAllBooking(context, fromDate, toDate);
                    setState(() {
                      searchProvider.searches =
                          List<SearchObject>.of(searchProvider.searches);
                    });
                  },
                  child: const Icon(Icons.search),
                ),
              ],
            ),
          ),
          Expanded(
            child: Scrollbar(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: DataTable(
                    columnSpacing: RouteManager.width / 28,
                    headingRowColor: WidgetStateColor.resolveWith(
                        (states) => AppTheme.primaryDark),
                    dataRowColor:
                        WidgetStateColor.resolveWith((states) => Colors.white),
                    columns: [
                      DataColumn(
                        label: SizedBox(
                          width: RouteManager.width * 0.24,
                          child: const Text("Customer Name"),
                        ),
                      ),
                      DataColumn(
                        label: SizedBox(
                          width: RouteManager.width * 0.18,
                          child: const Text("Booking Date"),
                        ),
                      ),
                      DataColumn(
                        label: SizedBox(
                          width: RouteManager.width * 0.18,
                          child: const Text("Area"),
                        ),
                      ),
                      DataColumn(
                        label: SizedBox(
                          width: RouteManager.width * 0.2,
                          child: const Text("Table"),
                        ),
                      ),
                      DataColumn(
                        label: SizedBox(
                          width: RouteManager.width * 0.16,
                          child: const Text("Payment"),
                        ),
                      ),
                    ],
                    rows: List<DataRow>.generate(
                      searchProvider.searches.length,
                      (index) => DataRow(
                        cells: [
                          DataCell(SizedBox(
                            width: RouteManager.width * 0.24,
                            child:
                                Text(searchProvider.searches[index].tablename),
                          )),
                          DataCell(SizedBox(
                            width: RouteManager.width * 0.18,
                            child: Text(DateFormat('dd-MM-yyyy').format(
                                searchProvider.searches[index].bookedon)),
                          )),
                          DataCell(SizedBox(
                            width: RouteManager.width * 0.18,
                            child:
                                Text(searchProvider.searches[index].areaname),
                          )),
                          DataCell(SizedBox(
                            width: RouteManager.width * 0.2,
                            child:
                                Text(searchProvider.searches[index].tablename),
                          )),
                          DataCell(SizedBox(
                            width: RouteManager.width * 0.16,
                            child: Text(searchProvider.searches[index].advance
                                .toString()),
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
