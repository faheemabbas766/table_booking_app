import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:fluttertoast/fluttertoast.dart' as ft;
import '../Api & Routes/api.dart';
import '../Api & Routes/routes.dart';
// import '../Providers/alltablespro (deleted).dart';
import '../Providers/alltablespro.dart';
import '../Providers/homepro.dart';
import '../myserver.dart';

class Authentication extends StatefulWidget {
  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  TextEditingController key = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // key.text = "y3wqogs5fvigrj2v7hxn662bpzpjt7c3";
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(
              255, 55, 253, 18),
          title: Row(
            children: [
              SizedBox(width: RouteManager.width / 4),
              Text(
                "Authentication",
                style: TextStyle(
                  fontSize: RouteManager.width / 17,
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: RouteManager.width / 3,
                    ),
                    Container(
                      child: Image.asset("images/logo.png"),
                    ),
                    // SizedBox(height: RouteManager.width / 10),
                    // SizedBox(
                    //   height: RouteManager.width / 4,
                    // ),
                  ],
                ),
              ),
              Opacity(
                opacity: 0.5,
                child: Container(
                  color: Colors.black,
                  width: RouteManager.width,
                  height: RouteManager.height,
                ),
              ),
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: RouteManager.width,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      height: RouteManager.width / 1.8,
                      child: SizedBox(
                        width: RouteManager.width / 1.1,
                        child: Column(
                          children: [
                            Icon(
                              Icons.key,
                              color: Color.fromARGB(
                                  255, 55, 253, 18),
                              size: RouteManager.width / 10,
                            ),
                            Text(
                              "Enter Your Key ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: RouteManager.width / 20,
                              ),
                            ),
                            SizedBox(
                              height: RouteManager.width / 20,
                            ),
                            SizedBox(
                              width: RouteManager.width / 1.2,
                              child: TextField(
                                controller: key,
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
                                  labelText: "Key",
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: RouteManager.width / 20,
                                    color: const Color.fromARGB(
                                        255, 55, 253, 18),
                                  ),
                                  hintText: "Enter Your Key",
                                  hintStyle: TextStyle(
                                    fontSize: RouteManager.width / 20,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: RouteManager.width / 30,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(
                                    255, 55, 253, 18),
                              ),
                              onPressed: () {
                                if (key.text == "") {
                                  ft.Fluttertoast.showToast(
                                    msg: "Please Enter Key",
                                    toastLength: ft.Toast.LENGTH_LONG,
                                  );
                                  return;
                                }
                                MyServer.showLoading("Verifying", context);
                                API.checkAuth(key.text, context).then((value) {
                                  if (value) {
                                    SharedPreferences.getInstance().then((prefs) async {
                                      prefs.clear();
                                      var val1 = await prefs.setString('verified', "0");
                                      if (val1) {
                                        var val2 = await prefs.setString(
                                          'expiredate',
                                          Provider.of<HomePro>(context, listen: false).expiredate!.year.toString() +
                                              "-" +
                                              Provider.of<HomePro>(context, listen: false).expiredate!.month.toString() +
                                              "-" +
                                              Provider.of<HomePro>(context, listen: false).expiredate!.day.toString(),
                                        );
                                        if (val2) {
                                          Navigator.of(context).pushNamedAndRemoveUntil(
                                            RouteManager.homepage,
                                            (route) => false,
                                          );
                                        }
                                      }
                                    });
                                  } else {
                                    Navigator.of(context, rootNavigator: true).pop();
                                  }
                                });
                              },
                              child: Text(
                                "Confirm",
                                style: TextStyle(
                                  fontSize: RouteManager.width / 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
