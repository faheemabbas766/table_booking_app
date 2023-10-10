import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:fluttertoast/fluttertoast.dart' as ft;
import 'package:table_booking/Entities/areaobject.dart';
import 'package:table_booking/Providers/searchpro.dart';
import '../Api & Routes/routes.dart';
import '../Entities/tableobject.dart';
import '../Providers/alltablespro (deleted).dart';
import '../Providers/homepro.dart';
import '../myserver.dart';

class Search extends StatefulWidget {
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController cust = TextEditingController();

  TextEditingController custname = TextEditingController();
  // TextEditingController custemail = TextEditingController();
  TextEditingController custphn = TextEditingController();
  TextEditingController custadvance = TextEditingController();
  TextEditingController custpersons = TextEditingController();
  DateTime? bookedfor;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadSearch(this.context);
  }

  void loadSearch(BuildContext context) async {
    while (true) {
      var value = await MyServer.getAllSearch(context);
      if (value) {
        if (Provider.of<SearchPro>(context, listen: false).areas.isNotEmpty) {
          Provider.of<SearchPro>(context, listen: false).areas.insert(0, AreaObject(0, "All"));
          // Provider.of<SearchPro>(context, listen: false).tables.insert(0, TableObject(0, "All", null,0,0,""));
          Provider.of<SearchPro>(context, listen: false).loaded1 = true;
        } else {
          Provider.of<SearchPro>(context, listen: false).loaded1 = false;
        }
        Provider.of<SearchPro>(context, listen: false).notifyListenerz();
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 55, 253, 18),
          title: Row(
            children: [
              SizedBox(width: RouteManager.width / 4.5),
              Text("Search", style: TextStyle(fontSize: RouteManager.width / 17)),
            ],
          ),
        ),
        body: WillPopScope(
          onWillPop: () {
            cust.text = "";
            Provider.of<SearchPro>(context, listen: false).clearAll();
            return Future.value(true);
          },
          child: Provider.of<SearchPro>(context).loaded1 == null
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 55, 253, 18),
                  ),
                )
              : !Provider.of<SearchPro>(context).loaded1!
                  ? Center(
                      child: Text(
                        "Total Area/Table are empty 😔",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 55, 253, 18),
                          fontSize: RouteManager.width / 20,
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: RouteManager.width / 60,
                          ),
                          TextButton(
                            onPressed: () async {
                              var d = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now().subtract(const Duration(days: 9999999)),
                                lastDate: DateTime.now().add(
                                  const Duration(days: 365),
                                ),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: const ColorScheme.light(
                                        primary: Color.fromARGB(255, 55, 253, 18), // <-- SEE HERE
                                        onPrimary: Colors.white, // <-- SEE HERE
                                        onSurface: Color.fromARGB(255, 0, 94, 255), // <-- SEE HERE
                                      ),
                                      textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.red,
                                        ),
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (d != null) {
                                Provider.of<SearchPro>(context, listen: false).d = d;
                                Provider.of<SearchPro>(context, listen: false).datetext = "${d.year}-${d.month}-${d.day}";
                              }
                              Provider.of<SearchPro>(context, listen: false).notifyListenerz();
                            },
                            child: Text(
                              Provider.of<SearchPro>(context).datetext,
                              style: TextStyle(
                                color: const Color.fromARGB(255, 55, 253, 18),
                                fontSize: RouteManager.width / 21,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: RouteManager.width / 30,
                          ),
                          Center(
                            child: SizedBox(
                              width: RouteManager.width / 1.7,
                              height: RouteManager.width / 6.5,
                              child: TextField(
                                controller: cust,
                                cursorColor: const Color.fromARGB(255, 55, 253, 18),
                                decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 8, 9, 8),
                                    ),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 55, 253, 18),
                                    ),
                                  ),
                                  disabledBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 55, 253, 18),
                                    ),
                                  ),
                                  // border:
                                  filled: true,
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: RouteManager.width / 23,
                                    color: const Color.fromARGB(255, 55, 253, 18),
                                  ),
                                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                                  labelText: "Customer's Name",
                                  hintText: "Enter Name",
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: RouteManager.width / 23,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: RouteManager.width / 20,
                          ),
                          Row(
                            children: [
                              SizedBox(width: RouteManager.width / 12),
                              DropdownButton<AreaObject>(
                                hint: Text(
                                  "Pick Area",
                                  style: TextStyle(color: const Color.fromARGB(255, 55, 253, 18), fontSize: RouteManager.width / 23, fontWeight: FontWeight.bold),
                                ),
                                value: Provider.of<SearchPro>(context).selectedarea,
                                items: Provider.of<SearchPro>(context).areas.map((AreaObject area) {
                                  return DropdownMenuItem<AreaObject>(
                                    value: area,
                                    child: area.areaname != "All"
                                        ? Text(area.areaname, style: TextStyle(fontSize: RouteManager.width / 23))
                                        : Text(
                                            area.areaname,
                                            style: TextStyle(
                                              fontSize: RouteManager.width / 23,
                                              color: const Color.fromARGB(255, 55, 253, 18),
                                            ),
                                          ),
                                  );
                                }).toList(),
                                onChanged: (AreaObject? selected) {
                                  Provider.of<SearchPro>(context, listen: false).selectedarea = selected;
                                  Provider.of<SearchPro>(context, listen: false).notifyListenerz();
                                  // Provider.of<AvailableItemsPro>(context, listen: false).selectedgender = selected!;
                                  // _selectedgender = selected!;
                                  // setState(() {});
                                },
                              ),
                              SizedBox(width: RouteManager.width / 3.4),
                              // DropdownButton<TableObject>(
                              //   hint: Text(
                              //     "Pick Table",
                              //     style: TextStyle(color: const Color.fromARGB(255, 55, 253, 18), fontSize: RouteManager.width / 23, fontWeight: FontWeight.bold),
                              //   ),
                              //   value: Provider.of<SearchPro>(context).selectedtable,
                              //   items: Provider.of<SearchPro>(context).tables.map((TableObject table) {
                              //     return DropdownMenuItem<TableObject>(
                              //       value: table,
                              //       child: table.tablename != "All"
                              //           ? Text(table.tablename, style: TextStyle(fontSize: RouteManager.width / 23))
                              //           : Text(
                              //               table.tablename,
                              //               style: TextStyle(
                              //                 fontSize: RouteManager.width / 23,
                              //                 color: const Color.fromARGB(255, 55, 253, 18),
                              //               ),
                              //             ),
                              //     );
                              //   }).toList(),
                              //   onChanged: (TableObject? selected) {
                              //     Provider.of<SearchPro>(context, listen: false).selectedtable = selected;
                              //     Provider.of<SearchPro>(context, listen: false).notifyListenerz();
                              //     // Provider.of<AvailableItemsPro>(context, listen: false).selectedgender = selected!;
                              //     // _selectedgender = selected!;
                              //     // setState(() {});
                              //   },
                              // ),
                            ],
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 55, 253, 18),
                            ),
                            onPressed: Provider.of<SearchPro>(context).d == null
                                ? null
                                : () {
                                    if (Provider.of<SearchPro>(context, listen: false).selectedarea == null) {
                                      Provider.of<SearchPro>(context, listen: false).selectedarea = Provider.of<SearchPro>(context, listen: false).areas[0];
                                    }
                                    // if (Provider.of<SearchPro>(context, listen: false).selectedtable == null) {
                                    //   Provider.of<SearchPro>(context, listen: false).selectedtable = Provider.of<SearchPro>(context, listen: false).tables[0];
                                    // }
                                    Provider.of<SearchPro>(context, listen: false).nothingsearched = false;
                                    Provider.of<SearchPro>(context, listen: false).loaded2 = false;
                                    // Provider.of<SearchPro>(context, listen: false).selectedarea = Provider.of<SearchPro>(context, listen: false).areas[0];
                                    Provider.of<SearchPro>(context, listen: false).notifyListenerz();
                                    MyServer.searchBooking(
                                      "${Provider.of<SearchPro>(context, listen: false).d!.year}-${Provider.of<SearchPro>(context, listen: false).d!.month}-${Provider.of<SearchPro>(context, listen: false).d!.day}",
                                      cust.text,
                                      Provider.of<SearchPro>(context, listen: false).selectedarea == null ? AreaObject(0, "") : Provider.of<SearchPro>(context, listen: false).selectedarea!,
                                      // Provider.of<SearchPro>(context, listen: false).selectedtable == null ? TableObject(0, "", null,0,0,"") : Provider.of<SearchPro>(context, listen: false).selectedtable!,
                                      context,
                                    ).then((value) {
                                      Provider.of<SearchPro>(context, listen: false).loaded2 = true;
                                      Provider.of<SearchPro>(context, listen: false).notifyListenerz();
                                    });
                                  },
                            child: Text(
                              "Search",
                              style: TextStyle(fontSize: RouteManager.width / 21),
                            ),
                          ),
                          SizedBox(height: RouteManager.width / 40),
                          Opacity(
                            opacity: 0.5,
                            child: Container(
                              color: Colors.grey,
                              width: RouteManager.width / 1.2,
                              height: RouteManager.width / 300,
                            ),
                          ),
                          SizedBox(height: RouteManager.width / 40),
                          !Provider.of<SearchPro>(context).nothingsearched
                              ? Container(
                                  // color: Colors.blue,
                                  width: RouteManager.width / 1.02,
                                  height: RouteManager.height / 1.69,
                                  child: !Provider.of<SearchPro>(context).loaded2
                                      ? const Center(
                                          child: CircularProgressIndicator(
                                            color: Color.fromARGB(255, 55, 253, 18),
                                          ),
                                        )
                                      : Provider.of<SearchPro>(context).searches.isEmpty
                                          ? Center(
                                              child: Text(
                                                "No Results Found",
                                                style: TextStyle(
                                                  fontSize: RouteManager.width / 20,
                                                  color: const Color.fromARGB(255, 55, 253, 18),
                                                ),
                                              ),
                                            )
                                          : ListView.builder(
                                              itemCount: Provider.of<SearchPro>(context).searches.length,
                                              itemBuilder: (cont, index) {
                                                return SizedBox(
                                                  // color: Colors.red,
                                                  // width: 2,
                                                  height: RouteManager.height / 1.98,
                                                  child: Card(
                                                    color: const Color.fromARGB(255, 230, 230, 230),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                backgroundColor: const Color.fromARGB(255, 55, 253, 18),
                                                              ),
                                                              onPressed: () {
                                                                custname.text = Provider.of<SearchPro>(context, listen: false).searches[index].name;
                                                                custphn.text = Provider.of<SearchPro>(context, listen: false).searches[index].phn;
                                                                custadvance.text = Provider.of<SearchPro>(context, listen: false).searches[index].advance.toString();
                                                                custpersons.text = Provider.of<SearchPro>(context, listen: false).searches[index].ttlpersons.toString();
                                                                bookedfor = Provider.of<SearchPro>(context, listen: false).searches[index].bookedfor;
                                                                showDialog(
                                                                  context: context,
                                                                  builder: (context) {
                                                                    return StatefulBuilder(builder: (context, setState) {
                                                                      return AlertDialog(
                                                                        title: Row(
                                                                          children: [
                                                                            InkWell(
                                                                              onTap: () {
                                                                                Navigator.of(context, rootNavigator: true).pop();
                                                                              },
                                                                              child: const Icon(
                                                                                Icons.close_sharp,
                                                                                color: Color.fromARGB(255, 55, 253, 18),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: RouteManager.width / 8,
                                                                            ),
                                                                            Text(
                                                                              "Update Booking",
                                                                              style: TextStyle(
                                                                                color: const Color.fromARGB(255, 55, 253, 18),
                                                                                fontSize: RouteManager.width / 21,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        content: SingleChildScrollView(
                                                                          child: SizedBox(
                                                                            width: RouteManager.width,
                                                                            height: RouteManager.height / 2.1,
                                                                            child: Column(
                                                                              children: [
                                                                                SizedBox(
                                                                                  height: RouteManager.width / 50,
                                                                                ),
                                                                                TextField(
                                                                                  controller: custname,
                                                                                  decoration: InputDecoration(
                                                                                    enabledBorder: const OutlineInputBorder(
                                                                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                                                      borderSide: BorderSide(
                                                                                        color: Color.fromARGB(255, 55, 253, 18),
                                                                                      ),
                                                                                    ),
                                                                                    focusedBorder: const OutlineInputBorder(
                                                                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                                                      borderSide: BorderSide(
                                                                                        color: Color.fromARGB(255, 55, 253, 18),
                                                                                      ),
                                                                                    ),
                                                                                    disabledBorder: const OutlineInputBorder(
                                                                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                                                      borderSide: BorderSide(
                                                                                        color: Color.fromARGB(255, 55, 253, 18),
                                                                                      ),
                                                                                    ),
                                                                                    fillColor: Colors.white,
                                                                                    filled: true,
                                                                                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                                                                                    labelText: "Customer Name",
                                                                                    labelStyle: TextStyle(
                                                                                      fontWeight: FontWeight.bold,
                                                                                      fontSize: RouteManager.width / 20,
                                                                                      color: const Color.fromARGB(255, 55, 253, 18),
                                                                                    ),
                                                                                    hintText: "Enter Customer's Name",
                                                                                    hintStyle: TextStyle(
                                                                                      fontSize: RouteManager.width / 28,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                SizedBox(height: RouteManager.width / 20),
                                                                                TextField(
                                                                                  controller: custphn,
                                                                                  decoration: InputDecoration(
                                                                                    enabledBorder: const OutlineInputBorder(
                                                                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                                                      borderSide: BorderSide(
                                                                                        color: Color.fromARGB(255, 55, 253, 18),
                                                                                      ),
                                                                                    ),
                                                                                    focusedBorder: const OutlineInputBorder(
                                                                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                                                      borderSide: BorderSide(
                                                                                        color: Color.fromARGB(255, 55, 253, 18),
                                                                                      ),
                                                                                    ),
                                                                                    disabledBorder: const OutlineInputBorder(
                                                                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                                                      borderSide: BorderSide(
                                                                                        color: Color.fromARGB(255, 55, 253, 18),
                                                                                      ),
                                                                                    ),
                                                                                    fillColor: Colors.white,
                                                                                    filled: true,
                                                                                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                                                                                    labelText: "Customer Phn",
                                                                                    labelStyle: TextStyle(
                                                                                      fontWeight: FontWeight.bold,
                                                                                      fontSize: RouteManager.width / 20,
                                                                                      color: const Color.fromARGB(255, 55, 253, 18),
                                                                                    ),
                                                                                    hintText: "Enter Customer's Phn",
                                                                                    hintStyle: TextStyle(
                                                                                      fontSize: RouteManager.width / 28,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                SizedBox(height: RouteManager.width / 20),
                                                                                TextField(
                                                                                  controller: custadvance,
                                                                                  keyboardType: TextInputType.number,
                                                                                  decoration: InputDecoration(
                                                                                    enabledBorder: const OutlineInputBorder(
                                                                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                                                      borderSide: BorderSide(
                                                                                        color: Color.fromARGB(255, 55, 253, 18),
                                                                                      ),
                                                                                    ),
                                                                                    focusedBorder: const OutlineInputBorder(
                                                                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                                                      borderSide: BorderSide(
                                                                                        color: Color.fromARGB(255, 55, 253, 18),
                                                                                      ),
                                                                                    ),
                                                                                    disabledBorder: const OutlineInputBorder(
                                                                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                                                      borderSide: BorderSide(
                                                                                        color: Color.fromARGB(255, 55, 253, 18),
                                                                                      ),
                                                                                    ),
                                                                                    fillColor: Colors.white,
                                                                                    filled: true,
                                                                                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                                                                                    labelText: "Advance",
                                                                                    labelStyle: TextStyle(
                                                                                      fontWeight: FontWeight.bold,
                                                                                      fontSize: RouteManager.width / 20,
                                                                                      color: const Color.fromARGB(255, 55, 253, 18),
                                                                                    ),
                                                                                    hintText: "Enter Advance",
                                                                                    hintStyle: TextStyle(
                                                                                      fontSize: RouteManager.width / 28,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                SizedBox(height: RouteManager.width / 20),
                                                                                TextField(
                                                                                  controller: custpersons,
                                                                                  keyboardType: TextInputType.number,
                                                                                  decoration: InputDecoration(
                                                                                    enabledBorder: const OutlineInputBorder(
                                                                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                                                      borderSide: BorderSide(
                                                                                        color: Color.fromARGB(255, 55, 253, 18),
                                                                                      ),
                                                                                    ),
                                                                                    focusedBorder: const OutlineInputBorder(
                                                                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                                                      borderSide: BorderSide(
                                                                                        color: Color.fromARGB(255, 55, 253, 18),
                                                                                      ),
                                                                                    ),
                                                                                    disabledBorder: const OutlineInputBorder(
                                                                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                                                      borderSide: BorderSide(
                                                                                        color: Color.fromARGB(255, 55, 253, 18),
                                                                                      ),
                                                                                    ),
                                                                                    fillColor: Colors.white,
                                                                                    filled: true,
                                                                                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                                                                                    labelText: "Total Persons",
                                                                                    labelStyle: TextStyle(
                                                                                      fontWeight: FontWeight.bold,
                                                                                      fontSize: RouteManager.width / 20,
                                                                                      color: const Color.fromARGB(255, 55, 253, 18),
                                                                                    ),
                                                                                    hintText: "Enter Total Persons",
                                                                                    hintStyle: TextStyle(
                                                                                      fontSize: RouteManager.width / 28,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                SizedBox(height: RouteManager.width / 40),
                                                                                TextButton(
                                                                                  child: Text(
                                                                                    bookedfor == null
                                                                                        ? "Booking Date"
                                                                                        : bookedfor!.year.toString() + "-" + bookedfor!.month.toString() + "-" + bookedfor!.day.toString(),
                                                                                    style: TextStyle(
                                                                                      color: const Color.fromARGB(255, 55, 253, 18),
                                                                                      fontSize: RouteManager.width / 21,
                                                                                    ),
                                                                                  ),
                                                                                  onPressed: () async {
                                                                                    var d = await showDatePicker(
                                                                                      context: context,
                                                                                      initialDate: DateTime.now(),
                                                                                      firstDate: DateTime.now(),
                                                                                      lastDate: DateTime.now().add(
                                                                                        const Duration(days: 365),
                                                                                      ),
                                                                                      builder: (context, child) {
                                                                                        return Theme(
                                                                                          data: Theme.of(context).copyWith(
                                                                                            colorScheme: const ColorScheme.light(
                                                                                              primary: Color.fromARGB(255, 55, 253, 18), // <-- SEE HERE
                                                                                              onPrimary: Colors.white, // <-- SEE HERE
                                                                                              onSurface: Color.fromARGB(255, 0, 94, 255), // <-- SEE HERE
                                                                                            ),
                                                                                            textButtonTheme: TextButtonThemeData(
                                                                                              style: TextButton.styleFrom(
                                                                                                foregroundColor: Colors.red,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          child: child!,
                                                                                        );
                                                                                      },
                                                                                    );
                                                                                    if (d != null) {
                                                                                      print("AYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAa");
                                                                                      setState(() {
                                                                                        bookedfor = d;
                                                                                      });
                                                                                      print("STATE SETTEDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDdd" + bookedfor.toString());
                                                                                    }
                                                                                  },
                                                                                ),
                                                                                ElevatedButton(
                                                                                  style: ElevatedButton.styleFrom(
                                                                                    backgroundColor: const Color.fromARGB(255, 55, 253, 18),
                                                                                  ),
                                                                                  child: Text(
                                                                                    "Update",
                                                                                    style: TextStyle(fontSize: RouteManager.width / 22),
                                                                                  ),
                                                                                  onPressed: () {
                                                                                    if (custname.text == "" || custphn.text == "" || custadvance.text == "" || custpersons.text == "") {
                                                                                      ft.Fluttertoast.showToast(
                                                                                        msg: "Please Fill all Fields",
                                                                                        toastLength: ft.Toast.LENGTH_SHORT,
                                                                                      );
                                                                                      return;
                                                                                    }
                                                                                    MyServer.updateBooking(
                                                                                      Provider.of<SearchPro>(context, listen: false).searches[index].bookid,
                                                                                      bookedfor!,
                                                                                      custname.text,
                                                                                      custphn.text,
                                                                                      int.parse(custadvance.text),
                                                                                      int.parse(custpersons.text),
                                                                                      context,
                                                                                    ).then((value) {
                                                                                      Provider.of<SearchPro>(context, listen: false).searches[index].name = custname.text;
                                                                                      Provider.of<SearchPro>(context, listen: false).searches[index].phn = custphn.text;
                                                                                      Provider.of<SearchPro>(context, listen: false).searches[index].advance = int.parse(custadvance.text);
                                                                                      Provider.of<SearchPro>(context, listen: false).searches[index].ttlpersons = int.parse(custpersons.text);
                                                                                      Provider.of<SearchPro>(context, listen: false).searches[index].bookedfor = bookedfor!;
                                                                                      Provider.of<SearchPro>(context, listen: false).notifyListenerz();
                                                                                      ft.Fluttertoast.showToast(
                                                                                        msg: "Updated",
                                                                                        toastLength: ft.Toast.LENGTH_SHORT,
                                                                                      );
                                                                                      Navigator.of(context, rootNavigator: true).pop();
                                                                                    });
                                                                                  },
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    });
                                                                  },
                                                                );
                                                              },
                                                              child: Row(
                                                                mainAxisSize: MainAxisSize.min,
                                                                children: [
                                                                  Text(
                                                                    "Edit ",
                                                                    style: TextStyle(fontSize: RouteManager.width / 21),
                                                                  ),
                                                                  const Icon(Icons.edit),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: RouteManager.width / 40,
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: RouteManager.width / 90,
                                                        ),
                                                        Row(
                                                          children: [
                                                            SizedBox(width: RouteManager.width / 23),
                                                            Text(
                                                              "Customer's Name  :  ",
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: RouteManager.width / 24,
                                                                color: const Color.fromARGB(255, 55, 253, 18),
                                                              ),
                                                            ),
                                                            Text(
                                                              Provider.of<SearchPro>(context).searches[index].name,
                                                              style: TextStyle(
                                                                // fontWeight: FontWeight.bold,
                                                                fontSize: RouteManager.width / 24,
                                                                // color: const Color.fromARGB(255, 55, 253, 18),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: RouteManager.width / 30),
                                                        Row(
                                                          children: [
                                                            SizedBox(width: RouteManager.width / 23),
                                                            Text(
                                                              "Customer's Phn     :  ",
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: RouteManager.width / 24,
                                                                color: const Color.fromARGB(255, 55, 253, 18),
                                                              ),
                                                            ),
                                                            Text(
                                                              Provider.of<SearchPro>(context).searches[index].phn,
                                                              style: TextStyle(
                                                                // fontWeight: FontWeight.bold,
                                                                fontSize: RouteManager.width / 24,
                                                                // color: const Color.fromARGB(255, 55, 253, 18),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: RouteManager.width / 30),
                                                        Row(
                                                          children: [
                                                            SizedBox(width: RouteManager.width / 23),
                                                            Text(
                                                              "Booked On              :  ",
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: RouteManager.width / 24,
                                                                color: const Color.fromARGB(255, 55, 253, 18),
                                                              ),
                                                            ),
                                                            Text(
                                                              "${Provider.of<SearchPro>(context).searches[index].bookedon.year} ${MyServer.months[Provider.of<SearchPro>(context).searches[index].bookedon.month]} ${Provider.of<SearchPro>(context).searches[index].bookedon.day}",
                                                              style: TextStyle(
                                                                // fontWeight: FontWeight.bold,
                                                                fontSize: RouteManager.width / 24,
                                                                // color: const Color.fromARGB(255, 55, 253, 18),
                                                              ),
                                                            ),
                                                          ],
                                                        ),

                                                        SizedBox(height: RouteManager.width / 30),
                                                        Row(
                                                          children: [
                                                            SizedBox(width: RouteManager.width / 23),
                                                            Text(
                                                              "Booked For             :  ",
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: RouteManager.width / 24,
                                                                color: const Color.fromARGB(255, 55, 253, 18),
                                                              ),
                                                            ),
                                                            Text(
                                                              "${Provider.of<SearchPro>(context).searches[index].bookedfor.year} ${MyServer.months[Provider.of<SearchPro>(context).searches[index].bookedfor.month]} ${Provider.of<SearchPro>(context).searches[index].bookedfor.day}  ",
                                                              style: TextStyle(
                                                                // fontWeight: FontWeight.bold,
                                                                fontSize: RouteManager.width / 24,
                                                                // color: const Color.fromARGB(255, 55, 253, 18),
                                                              ),
                                                            ),
                                                            Container(
                                                              decoration: const BoxDecoration(
                                                                borderRadius: BorderRadius.all(
                                                                  Radius.circular(20),
                                                                ),
                                                                color: Color.fromARGB(255, 214, 77, 68),
                                                              ),
                                                              padding: EdgeInsets.all(
                                                                RouteManager.width / 100,
                                                              ),
                                                              child: Builder(
                                                                builder: (context) {
                                                                  String hour = Provider.of<SearchPro>(context).searches[index].bookedfor.hour.toString();
                                                                  String minute = Provider.of<SearchPro>(context).searches[index].bookedfor.minute.toString();
                                                                  if (hour.length <= 1) {
                                                                    hour = "0$hour";
                                                                  }
                                                                  if (minute.length <= 1) {
                                                                    minute = "0$minute";
                                                                  }
                                                                  return Text(
                                                                    "$hour:$minute",
                                                                    style: TextStyle(
                                                                      color: Colors.white,
                                                                      fontSize: RouteManager.width / 24,
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),

                                                        SizedBox(height: RouteManager.width / 30),
                                                        Row(
                                                          children: [
                                                            SizedBox(width: RouteManager.width / 23),
                                                            Text(
                                                              "Area Name             :  ",
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: RouteManager.width / 24,
                                                                color: const Color.fromARGB(255, 55, 253, 18),
                                                              ),
                                                            ),
                                                            Text(
                                                              Provider.of<SearchPro>(context).searches[index].areaname,
                                                              style: TextStyle(
                                                                // fontWeight: FontWeight.bold,
                                                                fontSize: RouteManager.width / 24,
                                                                // color: const Color.fromARGB(255, 55, 253, 18),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: RouteManager.width / 30),
                                                        Row(
                                                          children: [
                                                            SizedBox(width: RouteManager.width / 23),
                                                            Text(
                                                              "Table Name            :  ",
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: RouteManager.width / 24,
                                                                color: const Color.fromARGB(255, 55, 253, 18),
                                                              ),
                                                            ),
                                                            Text(
                                                              Provider.of<SearchPro>(context).searches[index].tablename,
                                                              style: TextStyle(
                                                                // fontWeight: FontWeight.bold,
                                                                fontSize: RouteManager.width / 24,
                                                                // color: const Color.fromARGB(255, 55, 253, 18),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: RouteManager.width / 30),
                                                        Row(
                                                          children: [
                                                            SizedBox(width: RouteManager.width / 23),
                                                            Text(
                                                              "Total Persons         :  ",
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: RouteManager.width / 24,
                                                                color: const Color.fromARGB(255, 55, 253, 18),
                                                              ),
                                                            ),
                                                            Text(
                                                              Provider.of<SearchPro>(context).searches[index].ttlpersons.toString(),
                                                              style: TextStyle(
                                                                // fontWeight: FontWeight.bold,
                                                                fontSize: RouteManager.width / 24,
                                                                // color: const Color.fromARGB(255, 55, 253, 18),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: RouteManager.width / 30),
                                                        Row(
                                                          children: [
                                                            SizedBox(width: RouteManager.width / 23),
                                                            Text(
                                                              "Advance                  :  ",
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: RouteManager.width / 24,
                                                                color: const Color.fromARGB(255, 55, 253, 18),
                                                              ),
                                                            ),
                                                            Text(
                                                              Provider.of<SearchPro>(context).searches[index].advance.toString(),
                                                              style: TextStyle(
                                                                fontSize: RouteManager.width / 24,
                                                              ),
                                                            ),
                                                            Text(
                                                              " DH",
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: RouteManager.width / 24,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: RouteManager.width / 30),
                                                        Row(
                                                          children: [
                                                            SizedBox(width: RouteManager.width / 23),
                                                            Text(
                                                              "Checked In              :  ",
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: RouteManager.width / 24,
                                                                color: const Color.fromARGB(255, 55, 253, 18),
                                                              ),
                                                            ),
                                                            Builder(
                                                              builder: (context) {
                                                                String hour = "";
                                                                String minute = "";
                                                                if (Provider.of<SearchPro>(context).searches[index].checkin != null) {
                                                                  hour = Provider.of<SearchPro>(context).searches[index].checkin!.hour.toString();
                                                                  minute = Provider.of<SearchPro>(context).searches[index].checkin!.minute.toString();
                                                                  if (hour.length <= 1) {
                                                                    hour = "0" + hour;
                                                                  }
                                                                  if (minute.length <= 1) {
                                                                    minute = "0" + minute;
                                                                  }
                                                                }
                                                                return Text(
                                                                  Provider.of<SearchPro>(context).searches[index].checkin == null ? "Not Checked In" : hour + " : " + minute,
                                                                  style: TextStyle(
                                                                    // fontWeight: FontWeight.bold,
                                                                    fontSize: RouteManager.width / 24,
                                                                    // color: const Color.fromARGB(255, 55, 253, 18),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: RouteManager.width / 30),
                                                        Row(
                                                          children: [
                                                            SizedBox(width: RouteManager.width / 23),
                                                            Text(
                                                              "Checked Out           :  ",
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: RouteManager.width / 24,
                                                                color: const Color.fromARGB(255, 55, 253, 18),
                                                              ),
                                                            ),
                                                            Builder(builder: (context) {
                                                              String hour = "";
                                                              String minute = "";
                                                              if (Provider.of<SearchPro>(context).searches[index].checkout != null) {
                                                                hour = Provider.of<SearchPro>(context).searches[index].checkout!.hour.toString();
                                                                minute = Provider.of<SearchPro>(context).searches[index].checkout!.minute.toString();
                                                                if (hour.length <= 1) {
                                                                  hour = "0$hour";
                                                                }
                                                                if (minute.length <= 1) {
                                                                  minute = "0$minute";
                                                                }
                                                              }
                                                              return Text(
                                                                Provider.of<SearchPro>(context).searches[index].checkout == null ? "Not Checked Out" : hour + " : " + minute,
                                                                style: TextStyle(
                                                                  // fontWeight: FontWeight.bold,
                                                                  fontSize: RouteManager.width / 24,
                                                                  // color: const Color.fromARGB(255, 55, 253, 18),
                                                                ),
                                                              );
                                                            }),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}
