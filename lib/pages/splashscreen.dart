import 'dart:async';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../Api & Routes/routes.dart';
import '../Providers/homepro.dart';
import '../myserver.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool navvalue = true;

  @override
  Widget build(BuildContext context) {
    RouteManager.width = MediaQuery.of(context).size.width;
    RouteManager.height = MediaQuery.of(context).size.height;
    print("Width : " + RouteManager.width.toString());
    print("Height: " + RouteManager.height.toString());
    // CheckPreferences();
    return AnimatedSplashScreen.withScreenRouteFunction(
      screenRouteFunction: () async {
        await checkDb(context);
        var val = await checkVerification(context);
        if (val) {
          return Future.value("/home");
        } else {
          return Future.value("/authenticationpage");
        }
      },
      disableNavigation: navvalue,
      splashTransition: SplashTransition.rotationTransition,
      splash: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset(
          "images/logo.png",
        ),
      ),
      curve: Curves.easeInOutCubic,
      splashIconSize: 100,
      centered: true,
      animationDuration: const Duration(seconds: 2),
      backgroundColor: Colors.black,
    );
  }

  Future<bool> checkVerification(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('verified') == null || prefs.getString('expiredate') == null) {
      return false;
    }
    Provider.of<HomePro>(context, listen: false).expiredate = DateTime(
      int.parse(
        prefs.getString('expiredate').toString().split('-')[0],
      ),
      int.parse(
        prefs.getString('expiredate').toString().split('-')[1],
      ),
      int.parse(
        prefs.getString('expiredate').toString().split('-')[2],
      ),
    );
    return true;
  }

  checkDb(BuildContext context) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'Table_Booking');
    await openDatabase(path, version: 1, onOpen: (db) async {
      // var version = await db.getVersion();
      var result = await db.query("Areas");

      Provider.of<HomePro>(context, listen: false).totalareas = result.length;

      print("Areas : : : : : : : : : : : : : : : : : : : : : : : : :  : : " + result.toString());
      result = await db.query("Tables");
      print("Tables : : : : : : : : : : : : : : : : : : : : : : : : :  : : " + result.toString());
      result = await db.query("Bookings");
      print("Bookings : : : : : : : : : : : : : : : : : : : : : : : : :  : : " + result.toString());
      MyServer.db = db;
      print("------------------------------------------------------------------ >> DB is Opened :" + db.path);
      // print("------------------------------------------------------------------ >> DB VERSION   :" + version.toString());
    }, onCreate: (db, version) async {
      await db.execute("CREATE TABLE Areas ("
          "areaid INTEGER PRIMARY KEY,"
          "name TEXT"
          ")");
      await db.execute("CREATE TABLE Tables ("
          "tableid INTEGER PRIMARY KEY,"
          "areaid Integer,"
          "dx float,"
          "dy float,"
          "shape TEXT,"
          "name TEXT"
          ")");
      await db.execute("CREATE TABLE Bookings ("
          "bookid INTEGER PRIMARY KEY,"
          "areaid INTEGER,"
          "tableid INTEGER,"
          "bookdate DATETIME,"
          "customername TEXT,"
          "customerphn TEXT,"
          "totalpersons INTEGER,"
          "advance INTEGER,"
          "checkin DATETIME,"
          "checkout DATETIME,"
          "deleted DATE,"
          // "status TEXT,"
          "sysdate DATE"
          ")");
      // for (int i = 1; i <= 10; i++) {
      //   await db.execute("INSERT INTO Areas ('areaid', 'name') values (?, ?)", [null, "This is Area $i"]);
      // }
      print("------------------------------------------------------------------ > DB is CREATED :" + db.path);
      // print("------------------------------------------------------------------ > DB VERSION   :" + version.toString());
    });
    print("Database Path is :" + path + ":");
  }
}
