import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart' as ft;
import '../Api & Routes/routes.dart';
import '../Providers/alltablespro.dart';
import '../Providers/homepro.dart';
import '../myserver.dart';

class AllTables extends StatefulWidget {
  @override
  State<AllTables> createState() => _AllTablesState();
}

class _AllTablesState extends State<AllTables> {
  TextEditingController custname = TextEditingController();
  TextEditingController custphn = TextEditingController();
  TextEditingController ttlpersons = TextEditingController();
  TextEditingController ttladvance = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadWholeArea(this.context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  loadWholeArea(BuildContext context) async {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ],
    ).then((value) async {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        // setState(() {});
        if (mounted) {
          RouteManager.width = MediaQuery.of(context).size.width;
          RouteManager.height = MediaQuery.of(context).size.height;
          print("WIDTH=====================-----------------------" + RouteManager.width.toString());
          print("Height=====================-----------------------" + RouteManager.height.toString());
          while (true) {
            var value = await MyServer.getWholeAreaForBooking(Provider.of<AllTablesPro>(context, listen: false).areaid, Provider.of<HomePro>(context, listen: false).d!, context);
            if (value) {
              Provider.of<AllTablesPro>(context, listen: false).isloaded = true;
              Provider.of<AllTablesPro>(context, listen: false).notifyListenerz();
              break;
            }
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print("BUILD WIDTH=====================-----------------------" + RouteManager.width.toString());
    print("BUILD Height=====================-----------------------" + RouteManager.height.toString());
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          Provider.of<AllTablesPro>(context, listen: false).clearAll();
          setState(() {});
          return Future.value(true);
        },
        child: Scaffold(
          body: Container(
            padding: EdgeInsets.all(RouteManager.width / 100),
            child: Row(
              children: [
                Container(
                  width: RouteManager.width / 1.12,
                  height: RouteManager.height / 1.1,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 243, 216, 234),
                  ),
                  padding: EdgeInsets.all(RouteManager.height / 100),
                  child: !Provider.of<AllTablesPro>(context).isloaded
                      ? SizedBox()
                      : Builder(builder: (context) {
                          print(
                              "LOADED TABLES===========================================================----------------------" + Provider.of<AllTablesPro>(context, listen: false).mytables.toString());
                          List<Widget> mywlist = [];
                          for (int i = 0; i < Provider.of<AllTablesPro>(context, listen: false).mytables.length; i++) {
                            print("ADDEDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD");
                            mywlist.add(
                              StatefulBuilder(builder: (context, stateobj) {
                                return Column(
                                  children: [
                                    SizedBox(
                                      height: Provider.of<AllTablesPro>(context, listen: false).mytables[i].dy,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: Provider.of<AllTablesPro>(context, listen: false).mytables[i].dx,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            ft.Fluttertoast.showToast(
                                              msg: Provider.of<AllTablesPro>(context, listen: false).mytables[i].tablename,
                                              toastLength: ft.Toast.LENGTH_SHORT,
                                            );
                                            if (Provider.of<AllTablesPro>(context, listen: false).mytables[i].booking == null) {
                                              showDialog(
                                                  context: context,
                                                  builder: (cont) {
                                                    return SingleChildScrollView(
                                                      child: AlertDialog(
                                                        title: Row(
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                Navigator.of(context, rootNavigator: true).pop();
                                                              },
                                                              child: Icon(
                                                                Icons.close,
                                                                color: Colors.red,
                                                                size: RouteManager.height / 12,
                                                              ),
                                                            ),
                                                            SizedBox(width: RouteManager.height / 2.4),
                                                            Text(
                                                              "New Booking",
                                                              style: TextStyle(
                                                                fontSize: RouteManager.width / 36,
                                                                color: const Color.fromARGB(
                                                                    255, 55, 253, 18),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        content: Container(
                                                          // color: Colors.red,
                                                          // width: RouteManager.width/4,
                                                          // height: RouteManager.height / 1.675,
                                                          child: Stack(
                                                            children: [
                                                              Container(
                                                                child: Column(
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          "Area : ",
                                                                          style: TextStyle(
                                                                            fontSize: RouteManager.width / 42,
                                                                            fontWeight: FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          Provider.of<AllTablesPro>(cont, listen: false).areaname,
                                                                          style: TextStyle(
                                                                            fontSize: RouteManager.width / 42,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: RouteManager.width / 100,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          "Table : ",
                                                                          style: TextStyle(
                                                                            fontSize: RouteManager.width / 42,
                                                                            fontWeight: FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          Provider.of<AllTablesPro>(cont, listen: false).mytables[i].tablename,
                                                                          style: TextStyle(
                                                                            fontSize: RouteManager.width / 42,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: RouteManager.width / 100,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          "Date : ",
                                                                          style: TextStyle(
                                                                            fontSize: RouteManager.width / 42,
                                                                            fontWeight: FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          Provider.of<HomePro>(cont, listen: false).d!.day.toString() +
                                                                              " " +
                                                                              MyServer.months[Provider.of<HomePro>(cont, listen: false).d!.month].toString() +
                                                                              " " +
                                                                              Provider.of<HomePro>(cont, listen: false).d!.year.toString(),
                                                                          style: TextStyle(
                                                                            fontSize: RouteManager.width / 42,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: RouteManager.width / 100,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          "Day : ",
                                                                          style: TextStyle(
                                                                            fontSize: RouteManager.width / 42,
                                                                            fontWeight: FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          DateFormat('EEEE').format(Provider.of<HomePro>(cont, listen: false).d!),
                                                                          // Provider.of<HomePro>(context, listen: false).d!.year.toString() +
                                                                          //     "-" +
                                                                          //     Provider.of<HomePro>(context, listen: false).d!.month.toString() +
                                                                          //     "-" +
                                                                          //     Provider.of<HomePro>(context, listen: false).d!.day.toString(),
                                                                          style: TextStyle(
                                                                            fontSize: RouteManager.width / 42,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: RouteManager.width / 32,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  SizedBox(width: RouteManager.width / 3.8),
                                                                  Container(
                                                                    width: RouteManager.width / 3,
                                                                    child: Column(
                                                                      children: [
                                                                        // SizedBox(width: RouteManager.width / 4),
                                                                        TextField(
                                                                          controller: custname,
                                                                          decoration: InputDecoration(
                                                                            enabledBorder: const OutlineInputBorder(
                                                                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                                              borderSide: BorderSide(
                                                                                color: Color.fromARGB(
                                                                                    255, 55, 253, 18),
                                                                              ),
                                                                            ),
                                                                            focusedBorder: const OutlineInputBorder(
                                                                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                                              borderSide: BorderSide(
                                                                                color: Color.fromARGB(
                                                                                    255, 55, 253, 18),
                                                                              ),
                                                                            ),
                                                                            disabledBorder: const OutlineInputBorder(
                                                                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                                              borderSide: BorderSide(
                                                                                color: Color.fromARGB(
                                                                                    255, 55, 253, 18),
                                                                              ),
                                                                            ),
                                                                            fillColor: Colors.white,
                                                                            filled: true,
                                                                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                                                                            labelText: "Name",
                                                                            labelStyle: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: RouteManager.width / 45,
                                                                              color: const Color.fromARGB(
                                                                                  255, 55, 253, 18),
                                                                            ),
                                                                            hintText: "Enter Customer's Name",
                                                                            hintStyle: TextStyle(
                                                                              fontSize: RouteManager.width / 45,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(height: RouteManager.width / 80),
                                                                        TextField(
                                                                          controller: custphn,
                                                                          keyboardType: TextInputType.phone,
                                                                          decoration: InputDecoration(
                                                                            enabledBorder: const OutlineInputBorder(
                                                                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                                              borderSide: BorderSide(
                                                                                color: Color.fromARGB(
                                                                                    255, 55, 253, 18),
                                                                              ),
                                                                            ),
                                                                            focusedBorder: const OutlineInputBorder(
                                                                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                                              borderSide: BorderSide(
                                                                                color: Color.fromARGB(
                                                                                    255, 55, 253, 18),
                                                                              ),
                                                                            ),
                                                                            disabledBorder: const OutlineInputBorder(
                                                                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                                              borderSide: BorderSide(
                                                                                color: Color.fromARGB(
                                                                                    255, 55, 253, 18),
                                                                              ),
                                                                            ),
                                                                            fillColor: Colors.white,
                                                                            filled: true,
                                                                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                                                                            labelText: "Phn No.",
                                                                            labelStyle: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: RouteManager.width / 45,
                                                                              color: const Color.fromARGB(
                                                                                  255, 55, 253, 18),
                                                                            ),
                                                                            hintText: "Enter Customer's Phn.No",
                                                                            hintStyle: TextStyle(
                                                                              fontSize: RouteManager.width / 45,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(height: RouteManager.width / 80),
                                                                        TextField(
                                                                          controller: ttlpersons,
                                                                          keyboardType: TextInputType.phone,
                                                                          decoration: InputDecoration(
                                                                            enabledBorder: const OutlineInputBorder(
                                                                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                                              borderSide: BorderSide(
                                                                                color: Color.fromARGB(
                                                                                    255, 55, 253, 18),
                                                                              ),
                                                                            ),
                                                                            focusedBorder: const OutlineInputBorder(
                                                                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                                              borderSide: BorderSide(
                                                                                color: Color.fromARGB(
                                                                                    255, 55, 253, 18),
                                                                              ),
                                                                            ),
                                                                            disabledBorder: const OutlineInputBorder(
                                                                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                                              borderSide: BorderSide(
                                                                                color: Color.fromARGB(
                                                                                    255, 55, 253, 18),
                                                                              ),
                                                                            ),
                                                                            fillColor: Colors.white,
                                                                            filled: true,
                                                                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                                                                            labelText: "Persons",
                                                                            labelStyle: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: RouteManager.width / 45,
                                                                              color: const Color.fromARGB(
                                                                                  255, 55, 253, 18),
                                                                            ),
                                                                            hintText: "Enter Total Persons",
                                                                            hintStyle: TextStyle(
                                                                              fontSize: RouteManager.width / 45,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(height: RouteManager.width / 80),
                                                                        TextField(
                                                                          controller: ttladvance,
                                                                          keyboardType: TextInputType.phone,
                                                                          decoration: InputDecoration(
                                                                            enabledBorder: const OutlineInputBorder(
                                                                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                                              borderSide: BorderSide(
                                                                                color: Color.fromARGB(
                                                                                    255, 55, 253, 18),
                                                                              ),
                                                                            ),
                                                                            focusedBorder: const OutlineInputBorder(
                                                                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                                              borderSide: BorderSide(
                                                                                color: Color.fromARGB(
                                                                                    255, 55, 253, 18),
                                                                              ),
                                                                            ),
                                                                            disabledBorder: const OutlineInputBorder(
                                                                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                                              borderSide: BorderSide(
                                                                                color: Color.fromARGB(
                                                                                    255, 55, 253, 18),
                                                                              ),
                                                                            ),
                                                                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                                                                            labelText: "Advance",
                                                                            labelStyle: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: RouteManager.width / 45,
                                                                              color: const Color.fromARGB(
                                                                                  255, 55, 253, 18),
                                                                            ),
                                                                            fillColor: Colors.white,
                                                                            filled: true,
                                                                            hintText: "Enter Total Advance",
                                                                            hintStyle: TextStyle(
                                                                              fontSize: RouteManager.width / 45,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(height: RouteManager.width / 80),
                                                                        ElevatedButton(
                                                                          style: ElevatedButton.styleFrom(
                                                                            backgroundColor: const Color.fromARGB(
                                                                                255, 55, 253, 18),
                                                                          ),
                                                                          onPressed: () {
                                                                            if (custname.text.isEmpty || custphn.text.isEmpty || ttlpersons.text.isEmpty || ttladvance.text.isEmpty) {
                                                                              ft.Fluttertoast.showToast(
                                                                                msg: "Please fill all fields",
                                                                                toastLength: ft.Toast.LENGTH_SHORT,
                                                                              );
                                                                              return;
                                                                            }
                                                                            try {
                                                                              if (int.parse(ttlpersons.text) <= 0) {
                                                                                ft.Fluttertoast.showToast(
                                                                                  msg: "Invalid Total Persons",
                                                                                  toastLength: ft.Toast.LENGTH_SHORT,
                                                                                );
                                                                                return;
                                                                              }
                                                                            } catch (e) {
                                                                              ft.Fluttertoast.showToast(
                                                                                msg: "Invalid Total Persons",
                                                                                toastLength: ft.Toast.LENGTH_SHORT,
                                                                              );
                                                                              return;
                                                                            }
                                                                            MyServer.addBooking(
                                                                              Provider.of<AllTablesPro>(cont, listen: false).areaid,
                                                                              Provider.of<AllTablesPro>(cont, listen: false).mytables[i].tableid,
                                                                              Provider.of<HomePro>(cont, listen: false).d!,
                                                                              custname.text,
                                                                              custphn.text,
                                                                              int.parse(ttlpersons.text),
                                                                              int.parse(ttladvance.text),
                                                                              context,
                                                                            ).then((value) {
                                                                              setState(() {});
                                                                              setState(() {});
                                                                              if (value) {
                                                                                setState(() {});
                                                                                setState(() {});
                                                                                ft.Fluttertoast.showToast(
                                                                                  msg: "Table Booked",
                                                                                  toastLength: ft.Toast.LENGTH_SHORT,
                                                                                );
                                                                                Navigator.of(context, rootNavigator: true).pop();
                                                                              } else {
                                                                                setState(() {});
                                                                                setState(() {});
                                                                                ft.Fluttertoast.showToast(
                                                                                  msg: "Failed",
                                                                                  toastLength: ft.Toast.LENGTH_SHORT,
                                                                                );
                                                                              }
                                                                              setState(() {});
                                                                              setState(() {});
                                                                            });
                                                                          },
                                                                          child: Text(
                                                                            "Confirm",
                                                                            style: TextStyle(fontSize: RouteManager.width / 45),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }).then((value) {
                                                setState(() {});
                                                custname.text = "";
                                                custphn.text = "";
                                                ttlpersons.text = "";
                                                ttladvance.text = "";
                                              });
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder: (cont) {
                                                    DateTime todaydate = DateTime.now();
                                                    print("TODAY DATE:::::::::::::::::::::::::::::::::::::;;"+todaydate.toString());
                                                    return SingleChildScrollView(
                                                      child: AlertDialog(
                                                        title: Row(
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                Navigator.of(context, rootNavigator: true).pop();
                                                              },
                                                              child: Icon(
                                                                Icons.close,
                                                                color: Colors.red,
                                                                size: RouteManager.height / 13,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: RouteManager.width / 15,
                                                            ),
                                                            Text(
                                                              "Booking Details",
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: RouteManager.width / 40,
                                                                color: Colors.red,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        content: Container(
                                                          width: RouteManager.width / 1.9,
                                                          // height: RouteManager.height / 1.5,
                                                          child: Column(
                                                            children: [
                                                              SizedBox(height: RouteManager.width / 70),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    "Name :  ",
                                                                    style: TextStyle(
                                                                      fontSize: RouteManager.width / 45,
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    constraints: BoxConstraints(
                                                                      maxWidth: RouteManager.width / 1.5,
                                                                    ),
                                                                    child: Text(
                                                                      Provider.of<AllTablesPro>(cont, listen: false).mytables[i].booking!.name,
                                                                      softWrap: true,
                                                                      style: TextStyle(
                                                                        fontSize: RouteManager.width / 45,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(height: RouteManager.width / 60),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    "Contact :  ",
                                                                    style: TextStyle(
                                                                      fontSize: RouteManager.width / 45,
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    constraints: BoxConstraints(
                                                                      maxWidth: RouteManager.width / 1.5,
                                                                    ),
                                                                    child: Text(
                                                                      Provider.of<AllTablesPro>(cont, listen: false).mytables[i].booking!.phn,
                                                                      style: TextStyle(
                                                                        fontSize: RouteManager.width / 45,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(height: RouteManager.width / 60),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    "Booked On : ",
                                                                    style: TextStyle(
                                                                      fontSize: RouteManager.width / 45,
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    constraints: BoxConstraints(
                                                                      maxWidth: RouteManager.width / 1.5,
                                                                    ),
                                                                    child: Text(
                                                                      Provider.of<AllTablesPro>(cont, listen: false).mytables[i].booking!.booked_on.day.toString() +
                                                                          " " +
                                                                          MyServer.months[Provider.of<AllTablesPro>(cont, listen: false).mytables[i].booking!.booked_on.month] +
                                                                          " " +
                                                                          Provider.of<AllTablesPro>(cont, listen: false).mytables[i].booking!.booked_on.year.toString(),
                                                                      style: TextStyle(
                                                                        fontSize: RouteManager.width / 45,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(height: RouteManager.width / 60),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    "Booked For : ",
                                                                    style: TextStyle(
                                                                      fontSize: RouteManager.width / 45,
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    constraints: BoxConstraints(
                                                                      maxWidth: RouteManager.width / 3.3,
                                                                    ),
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                          Provider.of<AllTablesPro>(cont, listen: false).mytables[i].booking!.booked_for.day.toString() +
                                                                              " " +
                                                                              MyServer.months[Provider.of<AllTablesPro>(cont, listen: false).mytables[i].booking!.booked_for.month] +
                                                                              " " +
                                                                              Provider.of<AllTablesPro>(cont, listen: false).mytables[i].booking!.booked_for.year.toString() +
                                                                              " ",
                                                                          style: TextStyle(
                                                                            fontSize: RouteManager.width / 45,
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          decoration: BoxDecoration(
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
                                                                              String hour = Provider.of<AllTablesPro>(cont, listen: false).mytables[i].booking!.booked_for.hour.toString();
                                                                              String minute = Provider.of<AllTablesPro>(cont, listen: false).mytables[i].booking!.booked_for.minute.toString();
                                                                              if (hour.length <= 1) {
                                                                                hour = "0" + hour;
                                                                              }
                                                                              if (minute.length <= 1) {
                                                                                minute = "0" + minute;
                                                                              }
                                                                              return Text(
                                                                                hour + ":" + minute,
                                                                                style: TextStyle(
                                                                                  color: Colors.white,
                                                                                  fontSize: RouteManager.width / 45,
                                                                                ),
                                                                              );
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(height: RouteManager.width / 60),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    "Total Persons :  ",
                                                                    style: TextStyle(
                                                                      fontSize: RouteManager.width / 45,
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    constraints: BoxConstraints(
                                                                      maxWidth: RouteManager.width / 1.5,
                                                                    ),
                                                                    child: Text(
                                                                      Provider.of<AllTablesPro>(cont, listen: false).mytables[i].booking!.ttlpersons.toString(),
                                                                      style: TextStyle(
                                                                        fontSize: RouteManager.width / 45,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(height: RouteManager.width / 60),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    "Advance :  ",
                                                                    style: TextStyle(
                                                                      fontSize: RouteManager.width / 45,
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    constraints: BoxConstraints(
                                                                      maxWidth: RouteManager.width / 1.5,
                                                                    ),
                                                                    child: Text(
                                                                      Provider.of<AllTablesPro>(cont, listen: false).mytables[i].booking!.advance.toString(),
                                                                      style: TextStyle(
                                                                        fontSize: RouteManager.width / 45,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    " DH",
                                                                    style: TextStyle(
                                                                      fontSize: RouteManager.width / 45,
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(height: RouteManager.width / 60),
                                                              Provider.of<AllTablesPro>(cont, listen: false).mytables[i].booking!.check_in != null
                                                                  ? Column(
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            Text(
                                                                              "Check In Time :  ",
                                                                              style: TextStyle(
                                                                                fontSize: RouteManager.width / 45,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              Provider.of<AllTablesPro>(cont, listen: false).mytables[i].booking!.check_in!.year.toString() +
                                                                                  " " +
                                                                                  MyServer.months[Provider.of<AllTablesPro>(cont, listen: false).mytables[i].booking!.check_in!.month] +
                                                                                  " " +
                                                                                  Provider.of<AllTablesPro>(cont, listen: false).mytables[i].booking!.check_in!.day.toString() +
                                                                                  " ",
                                                                              style: TextStyle(
                                                                                fontSize: RouteManager.width / 45,
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              decoration: BoxDecoration(
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
                                                                                  String hour = Provider.of<AllTablesPro>(cont, listen: false).mytables[i].booking!.check_in!.hour.toString();
                                                                                  String minute = Provider.of<AllTablesPro>(cont, listen: false).mytables[i].booking!.check_in!.minute.toString();
                                                                                  if (hour.length <= 1) {
                                                                                    hour = "0" + hour;
                                                                                  }
                                                                                  if (minute.length <= 1) {
                                                                                    minute = "0" + minute;
                                                                                  }
                                                                                  return Text(
                                                                                    hour + ":" + minute,
                                                                                    style: TextStyle(
                                                                                      color: Colors.white,
                                                                                      fontSize: RouteManager.width / 45,
                                                                                    ),
                                                                                  );
                                                                                },
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(height: RouteManager.width / 60),
                                                                      ],
                                                                    )
                                                                  : SizedBox(),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Provider.of<AllTablesPro>(cont, listen: false).mytables[i].booking!.check_in == null
                                                                      ? ElevatedButton(
                                                                          style: ElevatedButton.styleFrom(
                                                                            backgroundColor: Colors.red,
                                                                          ),
                                                                          onPressed: () {
                                                                            MyServer.cancel(
                                                                              Provider.of<AllTablesPro>(cont, listen: false).mytables[i].booking!.bookid,
                                                                            ).then((value) {
                                                                              if (value) {
                                                                                ft.Fluttertoast.showToast(
                                                                                  msg: "Cancelled",
                                                                                  toastLength: ft.Toast.LENGTH_SHORT,
                                                                                );
                                                                                Provider.of<AllTablesPro>(cont, listen: false).mytables[i].booking = null;
                                                                                setState(() {});
                                                                              }
                                                                            });
                                                                            Navigator.of(context, rootNavigator: true).pop();
                                                                          },
                                                                          child: Text(
                                                                            "Cancel Booking",
                                                                            style: TextStyle(fontSize: RouteManager.width / 45),
                                                                          ),
                                                                        )
                                                                      : ElevatedButton(
                                                                          style: ElevatedButton.styleFrom(
                                                                            backgroundColor: Colors.red,
                                                                          ),
                                                                          onPressed: () {
                                                                            DateTime dd = DateTime.now();
                                                                            MyServer.checkOut(Provider.of<AllTablesPro>(cont, listen: false).mytables[i].booking!.bookid, dd).then((value) {
                                                                              if (value) {
                                                                                ft.Fluttertoast.showToast(
                                                                                  msg: "Checked Out",
                                                                                  toastLength: ft.Toast.LENGTH_SHORT,
                                                                                );
                                                                              }
                                                                              Navigator.of(context, rootNavigator: true).pop();
                                                                              Provider.of<AllTablesPro>(cont, listen: false).mytables[i].booking = null;
                                                                              setState(() {});
                                                                            });
                                                                            print("VALUE IS : : : : :" + Provider.of<AllTablesPro>(cont, listen: false).mytables[i].booking!.check_in.toString());
                                                                          },
                                                                          child: Text(
                                                                            "Check Out",
                                                                            style: TextStyle(fontSize: RouteManager.width / 45),
                                                                          ),
                                                                        ),
                                                                  Provider.of<AllTablesPro>(cont, listen: false).mytables[i].booking!.check_in == null &&
                                                                          Provider.of<HomePro>(context).d!.year.toString() +
                                                                                  "-" +
                                                                                  Provider.of<HomePro>(context).d!.month.toString() +
                                                                                  "-" +
                                                                                  Provider.of<HomePro>(context).d!.day.toString() ==
                                                                              todaydate.year.toString() + "-" + todaydate.month.toString() + "-" + todaydate.day.toString()
                                                                      ? Row(
                                                                          children: [
                                                                            SizedBox(
                                                                              width: RouteManager.width / 50,
                                                                            ),
                                                                            ElevatedButton(
                                                                              style: ElevatedButton.styleFrom(
                                                                                backgroundColor: Colors.green,
                                                                              ),
                                                                              onPressed: () {
                                                                                DateTime dd = DateTime.now();
                                                                                MyServer.checkIn(
                                                                                  Provider.of<AllTablesPro>(cont, listen: false).mytables[i].booking!.bookid,
                                                                                  dd,
                                                                                ).then((value) {
                                                                                  if (value) {
                                                                                    ft.Fluttertoast.showToast(
                                                                                      msg: "Checked In",
                                                                                      toastLength: ft.Toast.LENGTH_SHORT,
                                                                                    );
                                                                                  }
                                                                                  Navigator.of(context, rootNavigator: true).pop();
                                                                                  Provider.of<AllTablesPro>(cont, listen: false).mytables[i].booking!.check_in = dd;
                                                                                  setState(() {});
                                                                                });
                                                                                print("VALUE IS : : : : :" + Provider.of<AllTablesPro>(cont, listen: false).mytables[i].booking!.check_in.toString());
                                                                              },
                                                                              child: Text(
                                                                                "Check In",
                                                                                style: TextStyle(fontSize: RouteManager.width / 45),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        )
                                                                      : SizedBox(),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            }
                                          },
                                          child: Stack(
                                            children: [
                                              Container(
                                                width: RouteManager.height / 5.5,
                                                height: RouteManager.height / 5.5,
                                                decoration: BoxDecoration(
                                                  // border: Provider.of<AllTablesPro>(context, listen: false).mytables[i].booking != null
                                                  //     ? Provider.of<AllTablesPro>(context, listen: false).mytables[i].booking!.check_in == null
                                                  //         ? Border.all(
                                                  //             color: Colors.red,
                                                  //             width: RouteManager.height / 40,
                                                  //           )
                                                  //         : Border.all(
                                                  //             color: Colors.green,
                                                  //             width: RouteManager.height / 40,
                                                  //           )
                                                  //     : null,
                                                  shape: Provider.of<AllTablesPro>(context, listen: false).mytables[i].shape == "circle" ? BoxShape.circle : BoxShape.rectangle,
                                                  image:Provider.of<AllTablesPro>(context, listen: false).mytables[i].shape == "circle" ? DecorationImage(image: AssetImage("images/circle.png"), fit: BoxFit.fill):DecorationImage(image: AssetImage("images/square.png"), fit: BoxFit.fill),
                                                ),
                                              ),
                                              SizedBox(
                                                width: RouteManager.height / 5.5,
                                                height: RouteManager.height / 5.5,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Container(
                                                          constraints: BoxConstraints(maxWidth: RouteManager.height / 5.511),
                                                          padding: EdgeInsets.all(RouteManager.height / 80),
                                                          decoration: const BoxDecoration(
                                                            color: Color.fromARGB(
                                                                255, 55, 253, 18),
                                                            borderRadius: BorderRadius.all(
                                                              Radius.circular(20),
                                                            ),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Flexible(
                                                                child: DefaultTextStyle(
                                                                  style: TextStyle(
                                                                    fontSize: RouteManager.height / 30,
                                                                    color: Colors.white,
                                                                  ),
                                                                  child: Text(
                                                                    Provider.of<AllTablesPro>(context, listen: false).mytables[i].tablename,
                                                                    maxLines: 1,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    style: TextStyle(
                                                                      fontSize: RouteManager.height / 30,
                                                                      color: Colors.white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Opacity(
                                                opacity: Provider.of<AllTablesPro>(context, listen: false).mytables[i].booking != null ? 0.88 : 0,
                                                child: Container(
                                                  width: RouteManager.height / 5.5,
                                                  height: RouteManager.height / 5.5,
                                                  decoration: BoxDecoration(
                                                    color: const Color.fromARGB(255, 184, 184, 184),
                                                    shape: Provider.of<AllTablesPro>(context, listen: false).mytables[i].shape == "circle" ? BoxShape.circle : BoxShape.rectangle,
                                                    // image: DecorationImage(image: AssetImage("images/wood.jpg"), fit: BoxFit.fill),
                                                  ),
                                                ),
                                              ),
                                              Provider.of<AllTablesPro>(context, listen: false).mytables[i].booking != null
                                                  ? Column(
                                                      children: [
                                                        SizedBox(
                                                          height: Provider.of<AllTablesPro>(context, listen: false).mytables[i].booking!.check_in == null
                                                              ? RouteManager.width / 40
                                                              : RouteManager.width / 60,
                                                        ),
                                                        Transform.rotate(
                                                          angle: 18,
                                                          child: Text(
                                                            Provider.of<AllTablesPro>(context, listen: false).mytables[i].booking!.check_in == null ? "Booked" : " Checked\r\n      In",
                                                            style: TextStyle(
                                                              color: Provider.of<AllTablesPro>(context, listen: false).mytables[i].booking!.check_in == null
                                                                  ? Colors.red
                                                                  : const Color.fromARGB(255, 60, 145, 63),
                                                              fontSize: Provider.of<AllTablesPro>(context, listen: false).mytables[i].booking!.check_in == null
                                                                  ? RouteManager.width / 50
                                                                  : RouteManager.width / 57,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : SizedBox(),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }),
                            );
                            print("ADDED TO MYWLIST----------------" + i.toString());
                          }
                          Provider.of<AllTablesPro>(context, listen: false).tables = Stack(children: [...mywlist]);
                          // Provider.of<AllTablesPro>(context, listen: false).notifyListenerz();
                          return Provider.of<AllTablesPro>(context, listen: false).tables;
                        }),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: RouteManager.height / 90,
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(
                                255, 55, 253, 18),
                          ),
                          child: IconButton(
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true).pop();
                              },
                              icon: Icon(Icons.arrow_back_ios_new_rounded, size: RouteManager.width / 30)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: RouteManager.height / 2,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
