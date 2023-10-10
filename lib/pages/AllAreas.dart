import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:fluttertoast/fluttertoast.dart' as ft;
import 'package:table_booking/Providers/allareaspro.dart';
import '../Api & Routes/routes.dart';
// import '../Providers/alltablespro (deleted).dart';
import '../Providers/alltablespro.dart';
import '../Providers/homepro.dart';
import '../myserver.dart';

class AllAreas extends StatefulWidget {
  @override
  State<AllAreas> createState() => _AllAreasState();
}

class _AllAreasState extends State<AllAreas> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAllAreas(this.context);
  }

  void loadAllAreas(BuildContext context) async {
    while (true) {
      var value = await MyServer.getAllAreas(context);
      if (value) {
        Provider.of<AllAreasPro>(context, listen: false).reload = !Provider.of<AllAreasPro>(context, listen: false).reload;
        Provider.of<AllAreasPro>(context, listen: false).isloaded = true;
        Provider.of<AllAreasPro>(context, listen: false).notifyListenerz();
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(
              255, 55, 253, 18),
          title: Row(
            children: [
              SizedBox(
                width: RouteManager.width / 4,
              ),
              Text("Areas"),
            ],
          ),
        ),
        body: Container(
          // color: Colors.red,
          width: RouteManager.width,
          height: RouteManager.height / 1.11,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: RouteManager.width / 20),
              Selector<AllAreasPro, bool>(
                selector: (p0, p1) => p1.reload,
                builder: (context, reload, child1) {
                  if (!Provider.of<AllAreasPro>(context, listen: false).isloaded) {
                    return Center(child: CircularProgressIndicator());
                  }
                  print("Length is : " + Provider.of<AllAreasPro>(context, listen: false).areas.length.toString());
                  if (Provider.of<AllAreasPro>(context, listen: false).areas.isEmpty) {
                    return Center(
                      child: Text(
                        "No Areas Added Yet",
                        style: TextStyle(fontSize: RouteManager.width / 17, color: Colors.blue),
                      ),
                    );
                  }
                  return Container(
                    // color: Colors.blue,
                    width: RouteManager.width,
                    height: RouteManager.height / 1.14,
                    child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: (Provider.of<AllAreasPro>(context, listen: false).areas.length / 3).ceil(),
                        itemBuilder: (cont, ind) {
                          ind = ind + ind + ind;
                          return Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: RouteManager.width / 35,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      Provider.of<AllTablesPro>(context, listen: false).areaid = Provider.of<AllAreasPro>(context, listen: false).areas[ind].areaid;
                                      Provider.of<AllTablesPro>(context, listen: false).areaname = Provider.of<AllAreasPro>(context, listen: false).areas[ind].areaname;
                                      var value = await MyServer.checkTablesCount(Provider.of<AllAreasPro>(context, listen: false).areas[ind].areaid);
                                      if (value) {
                                        SystemChrome.setPreferredOrientations(
                                          [
                                            DeviceOrientation.landscapeRight,
                                            DeviceOrientation.landscapeLeft,
                                          ],
                                        ).then((value) async {
                                          Navigator.of(context).pushNamed(
                                            RouteManager.alltablespage,
                                          );
                                        });
                                      }
                                    },
                                    child: Container(
                                      width: RouteManager.width / 3.7,
                                      height: RouteManager.width / 3.7,
                                      decoration: const BoxDecoration(color: Color.fromARGB(
                                          255, 55, 253, 18), shape: BoxShape.circle),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          Center(
                                            child: Text(
                                              Provider.of<AllAreasPro>(context, listen: false).areas[ind].areaname,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: RouteManager.width / 25,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: RouteManager.width / 15,
                                  ),
                                  ind + 1 < Provider.of<AllAreasPro>(context, listen: false).areas.length
                                      ? InkWell(
                                          onTap: () async {
                                            Provider.of<AllTablesPro>(context, listen: false).areaid = Provider.of<AllAreasPro>(context, listen: false).areas[ind + 1].areaid;
                                            Provider.of<AllTablesPro>(context, listen: false).areaname = Provider.of<AllAreasPro>(context, listen: false).areas[ind + 1].areaname;
                                            var value = await MyServer.checkTablesCount(Provider.of<AllAreasPro>(context, listen: false).areas[ind + 1].areaid);
                                            if (value) {
                                              SystemChrome.setPreferredOrientations(
                                                [
                                                  DeviceOrientation.landscapeRight,
                                                  DeviceOrientation.landscapeLeft,
                                                ],
                                              ).then((value) async {
                                                Navigator.of(context).pushNamed(
                                                  RouteManager.alltablespage,
                                                );
                                              });
                                            }

                                            // Provider.of<AllTablesPro>(context, listen: false).areaid = Provider.of<AllAreasPro>(context, listen: false).areas[ind + 1].areaid;
                                            // Provider.of<AllTablesPro>(context, listen: false).areaname = Provider.of<AllAreasPro>(context, listen: false).areas[ind + 1].areaname;
                                            // Navigator.of(context).pushNamed(
                                            //   RouteManager.alltablespage,
                                            // );
                                            // SystemChrome.setPreferredOrientations(
                                            //   [
                                            //     DeviceOrientation.landscapeRight,
                                            //     DeviceOrientation.landscapeLeft,
                                            //   ],
                                            // );
                                          },
                                          child: Container(
                                            width: RouteManager.width / 3.7,
                                            height: RouteManager.width / 3.7,
                                            decoration: const BoxDecoration(color: Color.fromARGB(
                                                255, 55, 253, 18), shape: BoxShape.circle),
                                            child: Stack(
                                              fit: StackFit.expand,
                                              children: [
                                                Center(
                                                  child: Text(
                                                    Provider.of<AllAreasPro>(context, listen: false).areas[ind + 1].areaname,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: RouteManager.width / 25,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : SizedBox(),
                                  SizedBox(
                                    width: RouteManager.width / 15,
                                  ),
                                  ind + 2 < Provider.of<AllAreasPro>(context, listen: false).areas.length
                                      ? InkWell(
                                          onTap: () async {
                                            Provider.of<AllTablesPro>(context, listen: false).areaid = Provider.of<AllAreasPro>(context, listen: false).areas[ind + 2].areaid;
                                            Provider.of<AllTablesPro>(context, listen: false).areaname = Provider.of<AllAreasPro>(context, listen: false).areas[ind + 2].areaname;
                                            var value = await MyServer.checkTablesCount(Provider.of<AllAreasPro>(context, listen: false).areas[ind + 2].areaid);
                                            if (value) {
                                              SystemChrome.setPreferredOrientations(
                                                [
                                                  DeviceOrientation.landscapeRight,
                                                  DeviceOrientation.landscapeLeft,
                                                ],
                                              ).then((value) async {
                                                Navigator.of(context).pushNamed(
                                                  RouteManager.alltablespage,
                                                );
                                              });
                                            }

                                            // Provider.of<AllTablesPro>(context, listen: false).areaid = Provider.of<AllAreasPro>(context, listen: false).areas[ind + 2].areaid;
                                            // Provider.of<AllTablesPro>(context, listen: false).areaname = Provider.of<AllAreasPro>(context, listen: false).areas[ind + 2].areaname;
                                            // Navigator.of(context).pushNamed(
                                            //   RouteManager.alltablespage,
                                            // );
                                            // SystemChrome.setPreferredOrientations(
                                            //   [
                                            //     DeviceOrientation.landscapeRight,
                                            //     DeviceOrientation.landscapeLeft,
                                            //   ],
                                            // );
                                          },
                                          child: Container(
                                            width: RouteManager.width / 3.7,
                                            height: RouteManager.width / 3.7,
                                            decoration: const BoxDecoration(color: Color.fromARGB(
                                                255, 55, 253, 18), shape: BoxShape.circle),
                                            child: Stack(
                                              fit: StackFit.expand,
                                              children: [
                                                Center(
                                                  child: Text(
                                                    Provider.of<AllAreasPro>(context, listen: false).areas[ind + 2].areaname,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: RouteManager.width / 25,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                              Container(
                                // color: Colors.red,
                                height: RouteManager.width / 15,
                              ),
                            ],
                          );
                        }),
                  );
                  // return Text("IS LOADED IS : : : " + isloaded.toString());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
