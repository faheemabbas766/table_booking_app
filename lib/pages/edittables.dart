import 'package:flutter/material.dart';
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
        backgroundColor: const Color.fromARGB(255, 55, 253, 18),
        title: Row(
          children: [
            SizedBox(width: RouteManager.width / 4.5),
            Text("Report All",
                style: TextStyle(fontSize: RouteManager.width / 17)),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  label: Text(
                      "From: ${fromDate != null ? DateFormat('dd-MM-yyyy').format(fromDate!) : 'Select Date'}"),
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
                  label: Text(
                      "To: ${toDate != null ? DateFormat('dd-MM-yyyy').format(toDate!) : 'Select Date'}"),
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: DataTable(
                columnSpacing: 16,
                headingRowColor:
                    WidgetStateColor.resolveWith((states) => Colors.blueGrey),
                dataRowColor:
                    WidgetStateColor.resolveWith((states) => Colors.white),
                columns: [
                  DataColumn(
                    label: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: const Text("Customer Name"),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: const Text("Booking Date"),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: const Text("Area"),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: const Text("Table"),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: const Text("Payment"),
                    ),
                  ),
                ],
                rows: List<DataRow>.generate(
                  searchProvider.searches.length,
                  (index) => DataRow(
                    cells: [
                      DataCell(SizedBox(
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: Text(searchProvider.searches[index].tablename),
                      )),
                      DataCell(SizedBox(
                        width: MediaQuery.of(context).size.width * 0.15,
                        child: Text(DateFormat('dd-MM-yyyy')
                            .format(searchProvider.searches[index].bookedon)),
                      )),
                      DataCell(SizedBox(
                        width: MediaQuery.of(context).size.width * 0.15,
                        child: Text(searchProvider.searches[index].areaname),
                      )),
                      DataCell(SizedBox(
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: Text(searchProvider.searches[index].tablename),
                      )),
                      DataCell(SizedBox(
                        width: MediaQuery.of(context).size.width * 0.15,
                        child: Text(
                            searchProvider.searches[index].advance.toString()),
                      )),
                    ],
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
