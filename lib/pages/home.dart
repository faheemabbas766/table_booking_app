import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:fluttertoast/fluttertoast.dart' as ft;
import '../Api & Routes/routes.dart';
// import '../Providers/alltablespro (deleted).dart';
import '../Providers/allareaspro.dart';
import '../Providers/alltablespro.dart';
import '../Providers/editareaspro.dart';
import '../Providers/homepro.dart';
import '../Providers/manageareapro.dart';
import '../Providers/searchpro.dart';
import '../myserver.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController areaname = TextEditingController();
  TextEditingController tablename = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<HomePro>(this.context, listen: false).timer = Timer.periodic(
      Duration(seconds: 3),
      (Timer t) async {
        DateTime currentdate = DateTime.now();
        print("CURRENT DATE IS :::::::::::::::::::::::::::::::::::::::::::$currentdate");
        print("EXPIRE  DATE IS :::::::::::::::::::::::::::::::::::::::::::${Provider.of<HomePro>(this.context, listen: false).expiredate!}");
        if (currentdate.isAfter(Provider.of<HomePro>(this.context, listen: false).expiredate!) || currentdate == Provider.of<HomePro>(this.context, listen: false).expiredate!) {
          showDialog(
              barrierDismissible: false,
              context: this.context,
              builder: (cont) {
                return Dialog(
                  // shadowColor: Colors.red,
                  elevation: RouteManager.width,
                  backgroundColor: Color.fromRGBO(35, 36, 37, 1),
                  child: Container(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(35, 36, 37, 1),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      height: RouteManager.width / 2.5,
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  "Your Key has Expired ",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: RouteManager.width / 17,
                                  ),
                                ),
                                Icon(
                                  Icons.warning,
                                  color: Colors.yellow,
                                  size: RouteManager.width / 12,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: RouteManager.width / 30),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                  255, 55, 253, 18),
                            ),
                            onPressed: () {
                              Navigator.of(cont, rootNavigator: true).pop();
                            },
                            child: Container(
                              width: RouteManager.width / 5,
                              height: RouteManager.width / 8,
                              child: Center(
                                child: Text(
                                  "OK",
                                  style: TextStyle(
                                    fontSize: RouteManager.width / 23,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                );
              }).then((value) {
            SharedPreferences.getInstance().then((prefs) async {
              prefs.clear();
              Navigator.of(this.context).pushNamedAndRemoveUntil(
                RouteManager.authenticationpage,
                (route) => false,
              );
              Provider.of<HomePro>(this.context, listen: false).clearAll();
              Provider.of<AllAreasPro>(this.context, listen: false).clearAll();
              Provider.of<AllTablesPro>(this.context, listen: false).clearAll();
              Provider.of<EditAreasPro>(this.context, listen: false).clearAll();
              Provider.of<ManageAreaPro>(this.context, listen: false).clearAll();
              Provider.of<SearchPro>(this.context, listen: false).clearAll();
            });
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              color: Color.fromARGB(255, 255, 18, 18),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          width: RouteManager.width / 2.4,
          elevation: 3,
          child: Padding(
            padding: EdgeInsets.only(left: RouteManager.width / 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: RouteManager.width / 13,
                ),
                Container(
                  width: RouteManager.width / 3.4,
                  height: RouteManager.width / 3.4,
                  child: Image.asset("images/logo.png"),
                ),
                SizedBox(
                  height: RouteManager.width / 10,
                ),
                InkWell(
                  onTap: () {
                    // Navigator.of(context).pushNamed(
                    //   RouteManager.createareapage,
                    // );
                    // return;
                    showDialog(
                        context: context,
                        builder: (cont) {
                          return AlertDialog(
                            title: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context, rootNavigator: true).pop();
                                  },
                                  child: Icon(
                                    Icons.close,
                                    size: RouteManager.width / 14,
                                    color: Colors.red,
                                  ),
                                ),
                                SizedBox(
                                  width: RouteManager.width / 6.2,
                                ),
                                Text(
                                  "New Area",
                                  style: TextStyle(
                                    fontSize: RouteManager.width / 21,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                            content: SizedBox(
                              width: RouteManager.width,
                              height: RouteManager.height / 7.7,
                              child: Column(children: [
                                TextField(
                                  controller: areaname,
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                                    hintText: "Enter Area Name",
                                    hintStyle: TextStyle(
                                      fontSize: RouteManager.width / 24,
                                    ),
                                  ),
                                ),
                                SizedBox(height: RouteManager.width / 23),
                                ElevatedButton(
                                    onPressed: () {
                                      if (areaname.text.isEmpty) {
                                        ft.Fluttertoast.showToast(
                                          msg: "Please Enter Area Name",
                                          toastLength: ft.Toast.LENGTH_SHORT,
                                        );
                                        return;
                                      }
                                      MyServer.addArea(areaname.text).then((value) {
                                        if (value) {
                                          Provider.of<HomePro>(context, listen: false).totalareas = Provider.of<HomePro>(context, listen: false).totalareas! + 1;
                                          Provider.of<HomePro>(context, listen: false).notifyListenerz();
                                          ft.Fluttertoast.showToast(
                                            msg: "Area '" + areaname.text + "' Added",
                                            toastLength: ft.Toast.LENGTH_SHORT,
                                          );
                                          Navigator.of(context, rootNavigator: true).pop();
                                          areaname.text = "";
                                        } else {
                                          ft.Fluttertoast.showToast(
                                            msg: "Area Already Exists",
                                            toastLength: ft.Toast.LENGTH_SHORT,
                                          );
                                        }
                                      });
                                    },
                                    child: Text(
                                      "Confirm",
                                      style: TextStyle(fontSize: RouteManager.width / 20),
                                    ))
                              ]),
                            ),
                          );
                        }).then((value) {
                      areaname.text = "";
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(RouteManager.width / 23),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(RouteManager.width / 23),
                        bottomLeft: Radius.circular(RouteManager.width / 23),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Icon(Icons.add_circle, color: Colors.white, size: RouteManager.width / 16),
                        Text(
                          "      Area",
                          style: TextStyle(fontSize: RouteManager.width / 20, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                // SizedBox(height: RouteManager.width / 19),
                // InkWell(
                //   onTap: () {
                //     if (Provider.of<HomePro>(context, listen: false).totalareas == 0) {
                //       return;
                //     }
                //     showDialog(
                //         context: context,
                //         builder: (cont) {
                //           return AlertDialog(
                //             title: const Text("New Table"),
                //             content: Container(
                //               width: RouteManager.width,
                //               height: RouteManager.height / 7.7,
                //               child: Column(children: [
                //                 TextField(
                //                   controller: tablename,
                //                   decoration: InputDecoration(
                //                     fillColor: Colors.white,
                //                     filled: true,
                //                     // labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: RouteManager.width / 16),
                //                     floatingLabelBehavior: FloatingLabelBehavior.auto,
                //                     // labelText: "New Area",
                //                     hintText: "Enter Table Name",
                //                     hintStyle: TextStyle(
                //                       // fontWeight: FontWeight.bold,
                //                       fontSize: RouteManager.width / 24,
                //                     ),
                //                   ),
                //                 ),
                //                 SizedBox(height: RouteManager.width / 23),
                //                 ElevatedButton(
                //                   onPressed: () {
                //                     if (tablename.text.isEmpty) {
                //                       ft.Fluttertoast.showToast(
                //                         msg: "Please Enter Table Name",
                //                         toastLength: ft.Toast.LENGTH_SHORT,
                //                       );
                //                       return;
                //                     }
                //                     MyServer.addTable(tablename.text).then((value) {
                //                       if (value) {
                //                         // Provider.of<HomePro>(context, listen: false).totalareas = Provider.of<HomePro>(context, listen: false).totalareas! + 1;
                //                         ft.Fluttertoast.showToast(
                //                           msg: "Table '" + tablename.text + "' Added",
                //                           toastLength: ft.Toast.LENGTH_SHORT,
                //                         );
                //                         tablename.text = "";
                //                         Navigator.of(context, rootNavigator: true).pop();
                //                       } else {
                //                         ft.Fluttertoast.showToast(
                //                           msg: "Table Already Exists",
                //                           toastLength: ft.Toast.LENGTH_SHORT,
                //                         );
                //                       }
                //                     });
                //                   },
                //                   child: Text(
                //                     "Confirm",
                //                     style: TextStyle(fontSize: RouteManager.width / 20),
                //                   ),
                //                 )
                //               ]),
                //             ),
                //           );
                //         }).then((value) {
                //       tablename.text = "";
                //     });
                //   },
                //   child: Container(
                //     padding: EdgeInsets.all(RouteManager.width / 23),
                //     decoration: BoxDecoration(
                //       color: Provider.of<HomePro>(context, listen: false).totalareas == 0 ? Colors.grey : Colors.blue,
                //       borderRadius: BorderRadius.only(
                //         topRight: Radius.circular(RouteManager.width / 23),
                //         bottomLeft: Radius.circular(RouteManager.width / 23),
                //       ),
                //     ),
                //     child: Stack(
                //       children: [
                //         Icon(Icons.add_circle, color: Colors.white, size: RouteManager.width / 16),
                //         Text(
                //           "      Table",
                //           style: TextStyle(fontSize: RouteManager.width / 20, color: Colors.white),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                SizedBox(height: RouteManager.width / 6),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      RouteManager.editareaspage,
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(RouteManager.width / 23),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    child: Stack(
                      children: [
                        Text(
                          " All Areas",
                          style: TextStyle(fontSize: RouteManager.width / 20, color: Colors.white),
                        ),
                        // Icon(Icons.arrow)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: RouteManager.width / 20),
                // InkWell(
                //   onTap: () {
                //     Navigator.of(context).pushNamed(
                //       RouteManager.edittablespage,
                //     );
                //   },
                //   child: Container(
                //     padding: EdgeInsets.all(RouteManager.width / 23),
                //     decoration: BoxDecoration(
                //       color: Colors.blue,
                //       borderRadius: BorderRadius.all(Radius.circular(50)),
                //     ),
                //     child: Stack(
                //       children: [
                //         Text(
                //           " All Tables",
                //           style: TextStyle(fontSize: RouteManager.width / 20, color: Colors.white),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                SizedBox(height: RouteManager.width / 6),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      RouteManager.searchpage,
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(RouteManager.width / 23),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 243, 75, 33),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(RouteManager.width / 23),
                        bottomRight: Radius.circular(RouteManager.width / 23),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Icon(Icons.search, color: Colors.white, size: RouteManager.width / 14),
                        Text(
                          "      Search",
                          style: TextStyle(fontSize: RouteManager.width / 20, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: RouteManager.width / 6),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      RouteManager.edittablespage,
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(RouteManager.width / 23),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 243, 75, 33),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(RouteManager.width / 23),
                        bottomRight: Radius.circular(RouteManager.width / 23),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Icon(Icons.report_rounded, color: Colors.white, size: RouteManager.width / 14),
                        Text(
                          "      Report",
                          style: TextStyle(fontSize: RouteManager.width / 20, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(
              255, 55, 253, 18),
          title: Row(
            children: [
              SizedBox(width: RouteManager.width / 6),
              Text("Book a Table", style: TextStyle(fontSize: RouteManager.width / 17)),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: RouteManager.width / 3,
                ),
                Container(
                  child: Image.asset("images/logo.png"),
                ),
                SizedBox(height: RouteManager.width / 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                        255, 55, 253, 18),
                    padding: EdgeInsets.all(RouteManager.width / 20),
                  ),
                  onPressed: () async {
                    if (Provider.of<HomePro>(context, listen: false).totalareas == 0) {
                      ft.Fluttertoast.showToast(
                        msg: "No Area Added Yet",
                        toastLength: ft.Toast.LENGTH_SHORT,
                      );
                      return;
                    }
                    Provider.of<HomePro>(context, listen: false).d = null;
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
                              primary: Color.fromARGB(
                                  255, 55, 253, 18), // <-- SEE HERE
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
                      Provider.of<HomePro>(context, listen: false).d = d;
                      // Provider.of<AllTablesPro>(context, listen: false).isbooking = true;
                      print("Value of d: ${Provider.of<HomePro>(context, listen: false).d}");
                      TimeOfDay? pickedTime = await showTimePicker(
                        initialTime: TimeOfDay.now(),
                        context: context, //context of current state
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: Color.fromARGB(
                                    255, 55, 253, 18), // <-- SEE HERE
                                onPrimary: Colors.white, // <-- SEE HERE
                                onSurface: Color.fromARGB(255, 0, 94, 255), // <-- SEE HERE
                                // onBackground: Color.fromARGB(
                                //                                 255, 55, 253, 18),
                                background: Color.fromARGB(
                                    255, 55, 253, 18),
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
                      if (pickedTime != null) {
                        Provider.of<HomePro>(context, listen: false).d = DateTime(
                          Provider.of<HomePro>(context, listen: false).d!.year,
                          Provider.of<HomePro>(context, listen: false).d!.month,
                          Provider.of<HomePro>(context, listen: false).d!.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                        print("VALUE OF D : " + Provider.of<HomePro>(context, listen: false).d!.toString());
                        Navigator.of(context).pushNamed(
                          RouteManager.allareaspage,
                        );
                      }
                    }
                  },
                  child: Text(
                    "Book Now",
                    style: TextStyle(fontSize: RouteManager.width / 20),
                  ),
                ),
                SizedBox(
                  height: RouteManager.width / 4,
                ),
                // InkWell(
                //   onTap: () {

                //   },
                //   child: Container(
                //     width: RouteManager.width / 3,
                //     height: RouteManager.width / 6,
                //     padding: EdgeInsets.all(RouteManager.width / 23),
                //     decoration: BoxDecoration(
                //       color: Colors.blue,
                //       borderRadius: BorderRadius.all(Radius.circular(RouteManager.width / 20)),
                //     ),
                //     child: Center(
                //       child: Text(
                //         "Add Area",
                //         style: TextStyle(
                //           color: Colors.white,
                //           fontSize: RouteManager.width / 20,
                //           fontWeight: FontWeight.w500,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: RouteManager.width / 25,
                // ),
                // InkWell(
                //   onTap: () {},
                //   child: Container(
                //     width: RouteManager.width / 3,
                //     height: RouteManager.width / 6,
                //     padding: EdgeInsets.all(RouteManager.width / 23),
                //     decoration: BoxDecoration(
                //       color: Provider.of<HomePro>(context, listen: false).totalareas == 0 ? Color.fromARGB(255, 187, 187, 187) : Colors.blue,
                //       borderRadius: BorderRadius.all(Radius.circular(RouteManager.width / 20)),
                //     ),
                //     child: Center(
                //       child: Text(
                //         "Add Table",
                //         style: TextStyle(
                //           color: Colors.white,
                //           fontSize: RouteManager.width / 20,
                //           fontWeight: FontWeight.w500,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: RouteManager.width / 25,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
