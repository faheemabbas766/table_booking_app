import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:table_booking/Entities/areaobject.dart';
import 'package:table_booking/Entities/bookingobject.dart';
import 'package:table_booking/Entities/searchobject.dart';
import 'package:fluttertoast/fluttertoast.dart' as ft;
import 'Api & Routes/routes.dart';
import 'Entities/tableobject.dart';
import 'Providers/allareaspro.dart';
import 'Providers/alltablespro.dart';
import 'Providers/editareaspro.dart';
import 'Providers/manageareapro.dart';
import 'Providers/searchpro.dart';

class MyServer {
  static List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'June',
    'July',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  static Database? db;

  static showLoading(String text, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Stack(
            children: [
              Opacity(
                opacity: 0.2,
                child: SizedBox(
                  width: RouteManager.width,
                  height: RouteManager.height,
                ),
              ),
              Center(
                child: SizedBox(
                  width: RouteManager.width / 2,
                  height: RouteManager.height / 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: RouteManager.width / 7,
                        height: RouteManager.width / 7,
                        child: const CircularProgressIndicator(
                          color: Color.fromARGB(255, 243, 110, 100),
                        ),
                      ),
                      DefaultTextStyle(
                        style: TextStyle(fontSize: RouteManager.width / 20),
                        child: Text(text),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<bool> addArea(String areaname) async {
    try {
      var result = await db!.query("areas");
      for (var i in result) {
        if (i["name"].toString() == areaname) {
          return false;
        }
      }
      await db!.execute("INSERT INTO Areas ('areaid', 'name') values (?, ?)",
          [null, areaname]);
      return true;
    } catch (e) {
      print("ROLAAAAAAAAAAAAAAAAAAAAAAAAA" + e.toString());
      return false;
    }
  }

  static Future<bool> addTable(String tablename) async {
    try {
      var result = await db!.query("tables");
      for (var i in result) {
        if (i["name"].toString() == tablename) {
          return false;
        }
      }
      await db!.execute("INSERT INTO Tables ('tableid', 'name') values (?, ?)",
          [null, tablename]);
      return true;
    } catch (e) {
      print("ROLAAAAAAAAAAAAAAAAAAAAAAAAA" + e.toString());
      return false;
    }
  }

  static Future<bool> checkTablesCount(int areaid) async {
    var result = await db!.query("tables");
    for (var i in result) {
      if (int.parse(i["areaid"].toString()) == areaid) {
        return true;
      }
    }
    ft.Fluttertoast.showToast(
      msg: "No Tables",
      toastLength: ft.Toast.LENGTH_SHORT,
    );
    return false;
  }

  static Future<bool> addBooking(int areaid, int tableid, DateTime bookdate,
      String custname, String custphn, int ttlpersons, int ttladvance,
      BuildContext context) async {
    try {
      DateTime d = DateTime.now();
      await db!.execute(
          "INSERT INTO Bookings ('bookid', 'areaid', 'tableid', 'bookdate', 'customername', 'customerphn', 'totalpersons', 'advance', 'checkin', 'checkout', 'deleted', 'sysdate') values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
          [
            null,
            areaid,
            tableid,
            "${bookdate.year}-${bookdate.month}-${bookdate.day} ${bookdate
                .hour}:${bookdate.minute}:${bookdate.second}",
            custname,
            custphn,
            ttlpersons,
            ttladvance,
            null,
            null,
            null,
            "${d.year}-${d.month}-${d.day}",
          ]);

      var bookingresult = await db!.query("Bookings");
      // CustomerObject? co;
      // for (var j in bookingresult) {
      //   if (j["areaid"] == areaid &&
      //       j["tableid"] == tableid &&
      //       j["bookdate"] == bookdate.year.toString() + "-" + bookdate.month.toString() + "-" + bookdate.day.toString() &&
      //       j[""]) {
      // print("AYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
      // co = CustomerObject(
      //   j["customername"].toString(),
      //   j["customeremail"].toString(),
      //   j["customerphn"].toString(),
      //   DateTime(
      //     int.parse(
      //       j["sysdate"].toString().split("-")[0],
      //     ),
      //     int.parse(
      //       j["sysdate"].toString().split("-")[1],
      //     ),
      //     int.parse(
      //       j["sysdate"].toString().split("-")[2],
      //     ),
      //   ),
      // );
      // break;
      //   }
      // }
      for (int i = 0; i < Provider
          .of<AllTablesPro>(context, listen: false)
          .mytables
          .length; i++) {
        if (Provider
            .of<AllTablesPro>(context, listen: false)
            .mytables[i].tableid == tableid) {
          Provider
              .of<AllTablesPro>(context, listen: false)
              .mytables[i].booking = BookingObject(
            int.parse(
                bookingresult[bookingresult.length - 1]["bookid"].toString()),
            custname,
            custphn,
            d,
            bookdate,
            null,
            null,
            null,
            ttlpersons,
            ttladvance,
          );
        }
      }
      return true;
    } catch (e) {
      print("ROLAAAAAAAAAAAAAAAAAAAAAAAAA" + e.toString());
      return false;
    }
  }

  static Future<bool> getAllAreas(BuildContext context) async {
    try {
      var result = await db!.query("areas");
      List<AreaObject> list = [];
      for (var i in result) {
        AreaObject ao = AreaObject(
            int.parse(i["areaid"].toString()), i["name"].toString());
        list.add(ao);
      }
      Provider
          .of<AllAreasPro>(context, listen: false)
          .areas = list;
      print(result.toString());
      return true;
    } catch (e) {
      print("ROLAAAAAAAAAAAAAAAAAAAAAAAAA$e");
      return false;
    }
  }

  static Future<bool> deleteArea(int areaid) async {
    await db!.execute(
      "delete from areas where areaid=$areaid",
    );
    //  await db!.execute(
    //   "delete from tables where areaid=$areaid",
    // );
    //  await db!.execute(
    //   "delete from bookings where areaid=$areaid",
    // );
    return true;
  }

  static Future<bool> getAllSearch(BuildContext context) async {
    try {
      var result = await db!.query("areas");
      List<AreaObject> arealist = [];
      for (var i in result) {
        AreaObject ao = AreaObject(
            int.parse(i["areaid"].toString()), i["name"].toString());
        arealist.add(ao);
      }
      Provider
          .of<SearchPro>(context, listen: false)
          .areas = arealist;
      result = await db!.query("tables");
      List<TableObject> tablelist = [];
      for (var i in result) {
        // TableObject to = TableObject(int.parse(i["tableid"].toString()), i["name"].toString(), null);
        // tablelist.add(to);
      }
      // Provider.of<SearchPro>(context, listen: false).tables = tablelist;
      return true;
    } catch (e) {
      print("ROLAAAAAAAAAAAAAAAAAAAAAAAAA$e");
      return false;
    }
  }

  static Future<bool> addTablesInArea(int areaid,
      List<TableObject> tblist) async {
    try {
      if (tblist.isEmpty) {
        await db!.execute(
          "delete from tables where areaid=$areaid",
        );
        return true;
      }
      print(
          "LENGTH OF LIST==================================>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${tblist
              .length}");
      var result = await db!.query("tables");
      var finalresult = [];
      for (var i in result) {
        if (i["areaid"].toString() == areaid.toString()) {
          print(
              "ADDED FINAL RESULT-------------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$i");
          finalresult.add(i);
        }
      }

      for (int i = 0; i < finalresult.length; i++) {
        for (int j = 0; j < tblist.length; j++) {
          if (int.parse(finalresult[i]["tableid"].toString()) ==
              tblist[j].tableid) {
            break;
          } else if (j == tblist.length - 1) {
            int ftableid = int.parse(finalresult[i]["tableid"].toString());
            print("DELETEDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD$ftableid");
            await db!.execute(
              "delete from tables where tableid=$ftableid and areaid=$areaid",
            );
          }
        }
      }
      // for (var i in tblist) {
      //   int tableidtodelete=-1;
      //   if (i.tableid == 0) {
      //     continue;
      //   } else {
      //     for (int j = 0; j < finalresult.length; j++) {
      //       if(int.parse(finalresult[j]["tableid"].toString()) == int.parse(i.tableid.toString()))
      //       {
      //         break;
      //       }
      //       if (int.parse(finalresult[j]["tableid"].toString()) != int.parse(i.tableid.toString()) && j==finalresult.length-1) {
      //         tableidtodelete=int.parse(finalresult[j]["tableid"].toString());
      //       }
      //     }
      //   }
      //   if (tableidtodelete!=-1) {
      //     await db!.execute(
      //       "delete from tables where tableid=$tableidtodelete and areaid=$areaid",
      //     );
      //     print("DELETED FROM DATABASEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE");
      //   }
      // }
      for (int i = 0; i < tblist.length; i++) {
        if (tblist[i].tableid == 0) {
          await db!.execute(
              "INSERT INTO Tables ('tableid', 'areaid', 'dx', 'dy', 'shape', 'name') values (?, ?, ?, ?, ?, ?)",
              [
                null,
                tblist[i].areaid,
                tblist[i].dx,
                tblist[i].dy,
                tblist[i].shape,
                tblist[i].tablename
              ]);
        } else {
          double dx = tblist[i].dx;
          double dy = tblist[i].dy;
          int tableid = tblist[i].tableid;
          print(
              "Table ID : $tableid UPDATED DX DY----------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> $dx : $dy");
          await db!.execute(
            "update tables set dx='$dx' where tableid=$tableid",
          );
          await db!.execute(
            "update tables set dy='$dy' where tableid=$tableid",
          );
        }
      }
      // var result = await db!.query("tables");
      // for (var i in result) {
      //   if (i["areaid"].toString() == areaid.toString()) {
      //     ft.Fluttertoast.showToast(
      //       msg: "Area Already Exists",
      //       toastLength: ft.Toast.LENGTH_SHORT,
      //     );
      //     return false;
      //   }
      // }
      // await db!.execute("INSERT INTO Areas ('areaid', 'name') values (?, ?)", [null, areaname]);
      // result = await db!.query("areas");
      // int areaid = -1;
      // for (var i in result) {
      //   if (i["name"].toString() == areaname) {
      //     areaid = int.parse(i["areaid"].toString());
      //   }
      // }
      return true;
    } catch (e) {
      print("ROLAAAAAAAAAAAAAAAAAAAAAAAAA$e");
      return false;
    }
  }

  static Future<bool> getAllTables(int areaid, DateTime bookdate,
      BuildContext context) async {
    print("Area Id  : $areaid");
    try {
      var result = await db!.query("tables");
      List<TableObject> list = [];
      for (var i in result) {
        if (i["areaid"].toString() != areaid.toString()) {
          continue;
        }
        print("Table Id : ${i["tableid"]}");
        var bookingresult = await db!.query("Bookings");
        BookingObject? co;
        for (var j in bookingresult) {
          if (j["areaid"] == areaid &&
              j["tableid"] == i["tableid"] &&
              j["bookdate"] ==
                  "${bookdate.year}-${bookdate.month}-${bookdate.day}" &&
              j["deleted"] == null) {
            co = BookingObject(
              int.parse(j["bookid"].toString()),
              j["customername"].toString(),
              j["customerphn"].toString(),
              DateTime(
                int.parse(
                  j["sysdate"].toString().split("-")[0],
                ),
                int.parse(
                  j["sysdate"].toString().split("-")[1],
                ),
                int.parse(
                  j["sysdate"].toString().split("-")[2],
                ),
              ),
              DateTime(
                int.parse(
                  j["bookdate"].toString().split(" ")[0].split("-")[0],
                ),
                int.parse(
                  j["bookdate"].toString().split(" ")[0].split("-")[1],
                ),
                int.parse(
                  j["bookdate"].toString().split(" ")[0].split("-")[2],
                ),
                int.parse(
                  j["bookdate"].toString().split(" ")[1].split(":")[0],
                ),
                int.parse(
                  j["bookdate"].toString().split(" ")[1].split(":")[1],
                ),
              ),
              j["checkin"] == null
                  ? null
                  : DateTime(
                int.parse(
                  j["checkin"].toString().split("-")[0],
                ),
                int.parse(
                  j["checkin"].toString().split("-")[1],
                ),
                int.parse(
                  j["checkin"].toString().split("-")[2].split(" ")[0],
                ),
                int.parse(
                  j["checkin"].toString().split(" ")[1].split(":")[0],
                ),
                int.parse(
                  j["checkin"].toString().split(" ")[1].split(":")[1],
                ),
                int.parse(
                  j["checkin"].toString().split(" ")[1].split(":")[2],
                ),
              ),
              j["checkout"] == null
                  ? null
                  : DateTime(
                int.parse(
                  j["checkout"].toString().split("-")[0],
                ),
                int.parse(
                  j["checkout"].toString().split("-")[1],
                ),
                int.parse(
                  j["checkout"].toString().split("-")[2],
                ),
              ),
              null,
              int.parse(j["totalpersons"].toString()),
              int.parse(j["advance"].toString()),
            );
            break;
          }
        }
        if (co != null) {
          print("Name      : ${co.name}");
          print("phn       : ${co.phn}");
          print("booked_on : ${co.booked_on}");
          print("CheckIn   : ${co.check_in}");
          print("DELETED   : ${co.deleted}");
        }
        // TableObject to = TableObject(int.parse(i["tableid"].toString()), i["name"].toString(), co, double.parse(i["dx"].toString()), double.parse(i["dy"].toString()), i["shape"].toString());
        // list.add(to);
      }

      Provider
          .of<AllTablesPro>(context, listen: false)
          .mytables = list;
      print(result.toString());
      return true;
    } catch (e) {
      print("ROLAAAAAAAAAAAAAAAAAAAAAAAAA$e");
      return false;
    }
  }

  static Future<bool> getWholeArea(int areaid, BuildContext context) async {
    // print("Area Id  : " + areaid.toString());
    try {
      var result = await db!.query("tables");
      List<TableObject> list = [];
      for (var i in result) {
        if (i["areaid"].toString() != areaid.toString()) {
          continue;
        }
        // print("Table Id : " + i["tableid"].toString());
        var bookingresult = await db!.query("Bookings");
        BookingObject? co;
        for (var j in bookingresult) {
          // print("j==========="+j.toString());
          if (j["areaid"] == areaid &&
              j["tableid"] == i["tableid"] &&
              // j["bookdate"] == bookdate.year.toString() + "-" + bookdate.month.toString() + "-" + bookdate.day.toString() &&
              j["deleted"] == null

          //  &&
          // j["checkin"] == null &&
          // j["checkout"] == null &&
          // j["deleted"] == null
          ) {
            // print("AYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
            co = BookingObject(
              int.parse(j["bookid"].toString()),
              j["customername"].toString(),
              j["customerphn"].toString(),
              DateTime(
                int.parse(
                  j["sysdate"].toString().split("-")[0],
                ),
                int.parse(
                  j["sysdate"].toString().split("-")[1],
                ),
                int.parse(
                  j["sysdate"].toString().split("-")[2],
                ),
              ),
              DateTime(
                int.parse(
                  j["bookdate"].toString().split(" ")[0].split("-")[0],
                ),
                int.parse(
                  j["bookdate"].toString().split(" ")[0].split("-")[1],
                ),
                int.parse(
                  j["bookdate"].toString().split(" ")[0].split("-")[2],
                ),
                int.parse(
                  j["bookdate"].toString().split(" ")[1].split(":")[0],
                ),
                int.parse(
                  j["bookdate"].toString().split(" ")[1].split(":")[1],
                ),
              ),
              j["checkin"] == null
                  ? null
                  : DateTime(
                int.parse(
                  j["checkin"].toString().split("-")[0],
                ),
                int.parse(
                  j["checkin"].toString().split("-")[1],
                ),
                int.parse(
                  j["checkin"].toString().split("-")[2].split(" ")[0],
                ),
                int.parse(
                  j["checkin"].toString().split(" ")[1].split(":")[0],
                ),
                int.parse(
                  j["checkin"].toString().split(" ")[1].split(":")[1],
                ),
                int.parse(
                  j["checkin"].toString().split(" ")[1].split(":")[2],
                ),
              ),
              j["checkout"] == null
                  ? null
                  : DateTime(
                int.parse(
                  j["checkout"].toString().split("-")[0],
                ),
                int.parse(
                  j["checkout"].toString().split("-")[1],
                ),
                int.parse(
                  j["checkout"].toString().split("-")[2],
                ),
              ),
              null,
              int.parse(j["totalpersons"].toString()),
              int.parse(j["advance"].toString()),
            );
            break;
          }
        }
        if (co != null) {
          print("Name      : ${co.name}");
          print("phn       : ${co.phn}");
          print("booked_on : ${co.booked_on}");
          print("CheckIn   : ${co.check_in}");
          print("DELETED   : ${co.deleted}");
        }
        TableObject to = TableObject(
            int.parse(i["tableid"].toString()),
            int.parse(i["areaid"].toString()),
            i["name"].toString(),
            co,
            double.parse(i["dx"].toString()),
            double.parse(i["dy"].toString()),
            i["shape"].toString());
        list.add(to);
      }

      Provider
          .of<ManageAreaPro>(context, listen: false)
          .mytables = list;
      print(result.toString());
      return true;
    } catch (e) {
      print("ROLAAAAAAAAAAAAAAAAAAAAAAAAA$e");
      return false;
    }
  }

  static Future<bool> getWholeAreaForBooking(int areaid, DateTime bookdate,
      BuildContext context) async {
    // print("Area Id  : " + areaid.toString());
    try {
      var result = await db!.query("tables");
      List<TableObject> list = [];
      for (var i in result) {
        if (i["areaid"].toString() != areaid.toString()) {
          continue;
        }
        // print("Table Id : " + i["tableid"].toString());
        var bookingresult = await db!.query("Bookings");
        BookingObject? co;
        for (var j in bookingresult) {
          print("BOOKDATE IS:::::::::::::::::${j["bookdate"]}");
          if (j["areaid"] == areaid &&
              j["tableid"] == i["tableid"] &&
              "${j["bookdate"].toString().split(" ")[0].split(
                  "-")[0]}-${j["bookdate"].toString().split(" ")[0].split(
                  "-")[1]}-${j["bookdate"].toString().split(" ")[0].split(
                  "-")[2]}" ==
                  "${bookdate.year}-${bookdate.month}-${bookdate.day}" &&
              j["deleted"] == null &&
              j["checkout"] == null

          //  &&
          // j["checkin"] == null &&
          // j["checkout"] == null &&
          // j["deleted"] == null
          ) {
            co = BookingObject(
              int.parse(j["bookid"].toString()),
              j["customername"].toString(),
              j["customerphn"].toString(),
              DateTime(
                int.parse(
                  j["sysdate"].toString().split("-")[0],
                ),
                int.parse(
                  j["sysdate"].toString().split("-")[1],
                ),
                int.parse(
                  j["sysdate"].toString().split("-")[2],
                ),
              ),
              DateTime(
                int.parse(
                  j["bookdate"].toString().split(" ")[0].split("-")[0],
                ),
                int.parse(
                  j["bookdate"].toString().split(" ")[0].split("-")[1],
                ),
                int.parse(
                  j["bookdate"].toString().split(" ")[0].split("-")[2],
                ),
                int.parse(
                  j["bookdate"].toString().split(" ")[1].split(":")[0],
                ),
                int.parse(
                  j["bookdate"].toString().split(" ")[1].split(":")[1],
                ),
              ),
              j["checkin"] == null
                  ? null
                  : DateTime(
                int.parse(
                  j["checkin"].toString().split("-")[0],
                ),
                int.parse(
                  j["checkin"].toString().split("-")[1],
                ),
                int.parse(
                  j["checkin"].toString().split("-")[2].split(" ")[0],
                ),
                int.parse(
                  j["checkin"].toString().split(" ")[1].split(":")[0],
                ),
                int.parse(
                  j["checkin"].toString().split(" ")[1].split(":")[1],
                ),
                int.parse(
                  j["checkin"].toString().split(" ")[1].split(":")[2],
                ),
              ),
              j["checkout"] == null
                  ? null
                  : DateTime(
                int.parse(
                  j["checkout"].toString().split("-")[0],
                ),
                int.parse(
                  j["checkout"].toString().split("-")[1],
                ),
                int.parse(
                  j["checkout"].toString().split("-")[2],
                ),
              ),
              null,
              int.parse(j["totalpersons"].toString()),
              int.parse(j["advance"].toString()),
            );
            break;
          }
        }
        if (co != null) {
          print("Name      : " + co.name);
          print("phn       : " + co.phn);
          print("booked_on : " + co.booked_on.toString());
          print("CheckIn   : " + co.check_in.toString());
          print("DELETED   : " + co.deleted.toString());
        }
        TableObject to = TableObject(
            int.parse(i["tableid"].toString()),
            int.parse(i["areaid"].toString()),
            i["name"].toString(),
            co,
            double.parse(i["dx"].toString()),
            double.parse(i["dy"].toString()),
            i["shape"].toString());
        list.add(to);
      }

      Provider
          .of<AllTablesPro>(context, listen: false)
          .mytables = list;
      print(result.toString());
      return true;
    } catch (e) {
      print("ROLAAAAAAAAAAAAAAAAAAAAAAAAA$e");
      return false;
    }
  }

  static Future<bool> updateBooking(int bookid, DateTime bookdate,
      String custname, String custphn, int advance, int persons,
      BuildContext context) async {
    String dt = "${bookdate.year}-${bookdate.month}-${bookdate.day}";
    await db!.execute(
      "update bookings set bookdate='$dt' where bookid=$bookid",
    );
    await db!.execute(
      "update bookings set customername='$custname' where bookid=$bookid",
    );
    await db!.execute(
      "update bookings set customerphn='$custphn' where bookid=$bookid",
    );
    await db!.execute(
      "update bookings set advance=$advance where bookid=$bookid",
    );
    await db!.execute(
      "update bookings set totalpersons=$persons where bookid=$bookid",
    );
    return true;
  }

  static Future<bool> searchBooking(String date, String name, AreaObject area,
      BuildContext context) async {
    print("Given Area  ID : ${area.areaid}");
    // print("Given Table ID :" + table.tableid.toString());
    try {
      var result = await db!.query("Bookings");
      print("result : : : : : ${result.length}");
      List<SearchObject> list = [];
      for (var i in result) {
        if (i["deleted"] != null) {
          continue;
        }
        if ("${i["bookdate"].toString().split(" ")[0].split(
            "-")[0]}-${i["bookdate"].toString().split(" ")[0].split(
            "-")[1]}-${i["bookdate"].toString().split(" ")[0].split("-")[2]}" !=
            date) {
          continue;
        }
        if (!i["customername"].toString().contains(name)) {
          continue;
        }
        if (area.areaid != 0) {
          if (area.areaid.toString() != i["areaid"].toString()) {
            continue;
          }
        }

        // if (table.tableid != 0) {
        //   if (table.tableid.toString() != i["tableid"].toString()) {
        //     continue;
        //   }
        // }
        print("----------> Book  Id : ${i["bookid"]}");
        print("----------> Area  Id : ${i["areaid"]}");
        print("----------> Table Id : ${i["tableid"]}");
        var arearesult = await db!.query("Areas");
        String finalareaname = "";
        String finaltablename = "";
        for (var j in arearesult) {
          if (j["areaid"].toString() == i["areaid"].toString()) {
            finalareaname = j["name"].toString();
          }
        }
        var tableresult = await db!.query("Tables");
        for (var j in tableresult) {
          if (j["tableid"].toString() == i["tableid"].toString()) {
            finaltablename = j["name"].toString();
          }
        }
        list.add(
          SearchObject(
            int.parse(i["bookid"].toString()),
            i["customername"].toString(),
            DateTime(
              int.parse(i["sysdate"].toString().split('-')[0]),
              int.parse(i["sysdate"].toString().split('-')[1]),
              int.parse(i["sysdate"].toString().split('-')[2]),
            ),
            DateTime(
              int.parse(i["bookdate"].toString().split(' ')[0].split("-")[0]),
              int.parse(i["bookdate"].toString().split(' ')[0].split("-")[1]),
              int.parse(i["bookdate"].toString().split(' ')[0].split("-")[2]),
              int.parse(i["bookdate"].toString().split(' ')[1].split(":")[0]),
              int.parse(i["bookdate"].toString().split(' ')[1].split(":")[1]),
            ),
            i["customeremail"].toString(),
            i["customerphn"].toString(),
            finalareaname,
            finaltablename,
            int.parse(i["advance"].toString()),
            int.parse(i["totalpersons"].toString()),
            i["checkin"] == null
                ? null
                : DateTime(
              int.parse(
                i["checkin"].toString().split("-")[0],
              ),
              int.parse(
                i["checkin"].toString().split("-")[1],
              ),
              int.parse(
                i["checkin"].toString().split("-")[2].split(" ")[0],
              ),
              int.parse(
                i["checkin"].toString().split(" ")[1].split(":")[0],
              ),
              int.parse(
                i["checkin"].toString().split(" ")[1].split(":")[1],
              ),
              int.parse(
                i["checkin"].toString().split(" ")[1].split(":")[2],
              ),
            ),
            i["checkout"] == null
                ? null
                : DateTime(
              int.parse(
                i["checkout"].toString().split("-")[0],
              ),
              int.parse(
                i["checkout"].toString().split("-")[1],
              ),
              int.parse(
                i["checkout"].toString().split("-")[2].split(" ")[0],
              ),
              int.parse(
                i["checkout"].toString().split(" ")[1].split(":")[0],
              ),
              int.parse(
                i["checkout"].toString().split(" ")[1].split(":")[1],
              ),
              int.parse(
                i["checkout"].toString().split(" ")[1].split(":")[2],
              ),
            ),
          ),
        );
      }
      print("LENGTH OF LIST : : : : ${list.length}");
      Provider
          .of<SearchPro>(context, listen: false)
          .searches = list;
      print(result.toString());
      return true;
    } catch (e) {
      print("ROLAAAAAAAAAAAAAAAAAAAAAAAAA$e");
      return false;
    }
  }

  static Future<bool> checkIn(int bookid, DateTime d) async {
    print("BOOK ID :$bookid");
    print("d :$d");
    String dt = "${d.year}-${d.month}-${d.day} ${d.hour}:${d.minute}:${d
        .second}";
    print("VALUE OF DT ON CHECKIN IS :$dt:");
    await db!.execute(
      "update bookings set checkin='$dt' where bookid=$bookid",
    );
    return true;
  }

  static Future<bool> updateAreaNAme(int areaid, String areaname) async {
    await db!.execute(
      "update Areas set name='$areaname' where areaid=$areaid",
    );
    return true;
  }

  static Future<bool> checkOut(int bookid, DateTime d) async {
    print("BOOK ID :" + bookid.toString());
    print("d :" + d.toString());
    String dt = d.year.toString() + "-" + d.month.toString() + "-" +
        d.day.toString() + " " + d.hour.toString() + ":" + d.minute.toString() +
        ":" + d.second.toString();
    await db!.execute(
      "update bookings set checkout='$dt' where bookid=$bookid",
    );
    // await db!.execute(
    //   "update bookings set deleted='$dt' where bookid=$bookid",
    // );
    return true;
  }

  static Future<bool> cancel(int bookid) async {
    print("BOOK ID :" + bookid.toString());
    DateTime d = DateTime.now();
    String dt = d.year.toString() + "-" + d.month.toString() + "-" +
        d.day.toString();
    await db!.execute(
      "update bookings set deleted='$dt' where bookid=$bookid",
    );
    return true;
  }

  static Future<bool> getEditAllAreas(BuildContext context) async {
    try {
      var result = await db!.query("areas");
      List<AreaObject> list = [];
      for (var i in result) {
        AreaObject ao = AreaObject(
            int.parse(i["areaid"].toString()), i["name"].toString());
        list.add(ao);
      }
      Provider
          .of<EditAreasPro>(context, listen: false)
          .areas = list;
      print(result.toString());
      return true;
    } catch (e) {
      print("ROLAAAAAAAAAAAAAAAAAAAAAAAAA" + e.toString());
      return false;
    }
  }


  static Future<bool> searchAllBooking(BuildContext context, DateTime? fromDate,
      DateTime? toDate) async {
    try {
      var result = await db!.query("Bookings");
      print("result : : : : : ${result.length}");
      List<SearchObject> list = [];
      for (var i in result) {
        if (i["deleted"] != null) {
          continue;
        }
        print("----------> Book  Id : ${i["bookid"]}");
        print("----------> Area  Id : ${i["areaid"]}");
        print("----------> Table Id : ${i["tableid"]}");
        var arearesult = await db!.query("Areas");
        String finalareaname = "";
        String finaltablename = "";
        for (var j in arearesult) {
          if (j["areaid"].toString() == i["areaid"].toString()) {
            finalareaname = j["name"].toString();
          }
        }
        var tableresult = await db!.query("Tables");
        for (var j in tableresult) {
          if (j["tableid"].toString() == i["tableid"].toString()) {
            finaltablename = j["name"].toString();
          }
        }

        DateTime bookDate = DateTime(
          int.parse(i["bookdate"].toString().split(' ')[0].split("-")[0]),
          int.parse(i["bookdate"].toString().split(' ')[0].split("-")[1]),
          int.parse(i["bookdate"].toString().split(' ')[0].split("-")[2]),
          int.parse(i["bookdate"].toString().split(' ')[1].split(":")[0]),
          int.parse(i["bookdate"].toString().split(' ')[1].split(":")[1]),
        );

        // Apply the date filter
        if (fromDate != null && toDate != null) {
          if (bookDate.isBefore(fromDate) || bookDate.isAfter(toDate)) {
            continue; // Skip records that don't fall within the date range
          }
        } else if (fromDate != null) {
          if (bookDate.isBefore(fromDate) || bookDate.isAfter(fromDate)) {
            continue; // Skip records that are before or after the fromDate
          }
        } else if (toDate != null) {
          if (bookDate.isBefore(toDate) || bookDate.isAfter(toDate)) {
            continue; // Skip records that are before or after the toDate
          }
        }

        list.add(
          SearchObject(
            int.parse(i["bookid"].toString()),
            i["customername"].toString(),
            DateTime(
              int.parse(i["sysdate"].toString().split('-')[0]),
              int.parse(i["sysdate"].toString().split('-')[1]),
              int.parse(i["sysdate"].toString().split('-')[2]),
            ),
            bookDate,
            i["customeremail"].toString(),
            i["customerphn"].toString(),
            finalareaname,
            finaltablename,
            int.parse(i["advance"].toString()),
            int.parse(i["totalpersons"].toString()),
            i["checkin"] == null
                ? null
                : DateTime(
              int.parse(i["checkin"].toString().split("-")[0]),
              int.parse(i["checkin"].toString().split("-")[1]),
              int.parse(i["checkin"].toString().split("-")[2].split(" ")[0]),
              int.parse(i["checkin"].toString().split(" ")[1].split(":")[0]),
              int.parse(i["checkin"].toString().split(" ")[1].split(":")[1]),
              int.parse(i["checkin"].toString().split(" ")[1].split(":")[2]),
            ),
            i["checkout"] == null
                ? null
                : DateTime(
              int.parse(i["checkout"].toString().split("-")[0]),
              int.parse(i["checkout"].toString().split("-")[1]),
              int.parse(i["checkout"].toString().split("-")[2].split(" ")[0]),
              int.parse(i["checkout"].toString().split(" ")[1].split(":")[0]),
              int.parse(i["checkout"].toString().split(" ")[1].split(":")[1]),
              int.parse(i["checkout"].toString().split(" ")[1].split(":")[2]),
            ),
          ),
        );
      }
      print("LENGTH OF LIST : : : : ${list.length}");
      Provider
          .of<SearchPro>(context, listen: false)
          .searches = list;
      print(result.toString());
      return true;
    } catch (e) {
      print("ROLAAAAAAAAAAAAAAAAAAAAAAAAA$e");
      return false;
    }
  }
}

//   static Future<bool> searchAllBooking(BuildContext context) async {
//     try {
//       var result = await db!.query("Bookings");
//       print("result : : : : : ${result.length}");
//       List<SearchObject> list = [];
//       for (var i in result) {
//         if (i["deleted"] != null) {
//           continue;
//         }
//         print("----------> Book  Id : ${i["bookid"]}");
//         print("----------> Area  Id : ${i["areaid"]}");
//         print("----------> Table Id : ${i["tableid"]}");
//         var arearesult = await db!.query("Areas");
//         String finalareaname = "";
//         String finaltablename = "";
//         for (var j in arearesult) {
//           if (j["areaid"].toString() == i["areaid"].toString()) {
//             finalareaname = j["name"].toString();
//           }
//         }
//         var tableresult = await db!.query("Tables");
//         for (var j in tableresult) {
//           if (j["tableid"].toString() == i["tableid"].toString()) {
//             finaltablename = j["name"].toString();
//           }
//         }
//         list.add(
//           SearchObject(
//             int.parse(i["bookid"].toString()),
//             i["customername"].toString(),
//             DateTime(
//               int.parse(i["sysdate"].toString().split('-')[0]),
//               int.parse(i["sysdate"].toString().split('-')[1]),
//               int.parse(i["sysdate"].toString().split('-')[2]),
//             ),
//             DateTime(
//               int.parse(i["bookdate"].toString().split(' ')[0].split("-")[0]),
//               int.parse(i["bookdate"].toString().split(' ')[0].split("-")[1]),
//               int.parse(i["bookdate"].toString().split(' ')[0].split("-")[2]),
//               int.parse(i["bookdate"].toString().split(' ')[1].split(":")[0]),
//               int.parse(i["bookdate"].toString().split(' ')[1].split(":")[1]),
//             ),
//             i["customeremail"].toString(),
//             i["customerphn"].toString(),
//             finalareaname,
//             finaltablename,
//             int.parse(i["advance"].toString()),
//             int.parse(i["totalpersons"].toString()),
//             i["checkin"] == null
//                 ? null
//                 : DateTime(
//               int.parse(
//                 i["checkin"].toString().split("-")[0],
//               ),
//               int.parse(
//                 i["checkin"].toString().split("-")[1],
//               ),
//               int.parse(
//                 i["checkin"].toString().split("-")[2].split(" ")[0],
//               ),
//               int.parse(
//                 i["checkin"].toString().split(" ")[1].split(":")[0],
//               ),
//               int.parse(
//                 i["checkin"].toString().split(" ")[1].split(":")[1],
//               ),
//               int.parse(
//                 i["checkin"].toString().split(" ")[1].split(":")[2],
//               ),
//             ),
//             i["checkout"] == null
//                 ? null
//                 : DateTime(
//               int.parse(
//                 i["checkout"].toString().split("-")[0],
//               ),
//               int.parse(
//                 i["checkout"].toString().split("-")[1],
//               ),
//               int.parse(
//                 i["checkout"].toString().split("-")[2].split(" ")[0],
//               ),
//               int.parse(
//                 i["checkout"].toString().split(" ")[1].split(":")[0],
//               ),
//               int.parse(
//                 i["checkout"].toString().split(" ")[1].split(":")[1],
//               ),
//               int.parse(
//                 i["checkout"].toString().split(" ")[1].split(":")[2],
//               ),
//             ),
//           ),
//         );
//       }
//       print("LENGTH OF LIST : : : : ${list.length}");
//       Provider.of<SearchPro>(context, listen: false).searches = list;
//       print(result.toString());
//       return true;
//     } catch (e) {
//       print("ROLAAAAAAAAAAAAAAAAAAAAAAAAA$e");
//       return false;
//     }
//   }
// }




