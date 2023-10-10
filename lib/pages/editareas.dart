import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:fluttertoast/fluttertoast.dart' as ft;
import 'package:table_booking/Providers/manageareapro.dart';
import '../Api & Routes/routes.dart';
// import '../Providers/alltablespro (deleted).dart';
import '../Providers/editareaspro.dart';
import '../Providers/homepro.dart';
import '../myserver.dart';

class EditAreas extends StatefulWidget {
  @override
  State<EditAreas> createState() => _EditAreasState();
}

class _EditAreasState extends State<EditAreas> {
  TextEditingController areaname = TextEditingController();
  // TextEditingController tablename = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAllAreas(this.context);
  }

  void loadAllAreas(BuildContext context) async {
    while (true) {
      var value = await MyServer.getEditAllAreas(context);
      if (value) {
        // Provider.of<EditAreasPro>(context, listen: false).reload = !Provider.of<AllAreasPro>(context, listen: false).reload;
        Provider.of<EditAreasPro>(context, listen: false).isloaded = true;
        Provider.of<EditAreasPro>(context, listen: false).notifyListenerz();
        print("AYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaaa");
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          Provider.of<EditAreasPro>(context, listen: false).areas = [];
          Provider.of<EditAreasPro>(context, listen: false).isloaded = false;
          return Future.value(true);
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(
                255, 55, 253, 18),
            title: Row(
              children: [
                SizedBox(width: RouteManager.width / 4.2),
                Text("Areas", style: TextStyle(fontSize: RouteManager.width / 17)),
              ],
            ),
          ),
          body: !Provider.of<EditAreasPro>(context).isloaded
              ? Center(
                  child: CircularProgressIndicator(
                    color: const Color.fromARGB(
                        255, 55, 253, 18),
                  ),
                )
              : Provider.of<EditAreasPro>(context).areas.isEmpty
                  ? Center(
                      child: Text(
                        "No Areas Added",
                        style: TextStyle(
                          fontSize: RouteManager.width / 17,
                          color: const Color.fromARGB(
                              255, 55, 253, 18),
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Container(
                        height: RouteManager.height / 1.114,
                        // color: Colors.blue,
                        child: ListView.builder(
                          itemCount: Provider.of<EditAreasPro>(context).areas.length,
                          itemBuilder: (cont, index) {
                            return Column(
                              children: [
                                SizedBox(
                                  height: RouteManager.width / 40,
                                ),
                                Container(
                                  width: RouteManager.width,
                                  child: Card(
                                    color: Color.fromARGB(255, 236, 219, 219),
                                    child: Stack(
                                      children: [
                                        Column(
                                          children: [
                                            SizedBox(
                                              height: RouteManager.width / 39,
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: RouteManager.width / 39,
                                                ),
                                                Container(
                                                  decoration: const BoxDecoration(
                                                    color: const Color.fromARGB(
                                                        255, 55, 253, 18),
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(20),
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.all(RouteManager.width / 30),
                                                  width: RouteManager.width / 1.3,
                                                  child: Text(
                                                    Provider.of<EditAreasPro>(context).areas[index].areaname, // +
                                                    // "asdsadasdadkajdalsdlakjdaldjalkdjaskjdaldlasjdajdlksajdasjdlajddjlasjdksajdlsadjsalkddlasdlkjsadkajdksajdksajdsakjdsadjsadsadsad",
                                                    style: TextStyle(
                                                      fontSize: RouteManager.width / 18,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                                  onPressed: () {
                                                    Provider.of<ManageAreaPro>(context, listen: false).areaid = Provider.of<EditAreasPro>(context, listen: false).areas[index].areaid;
                                                    Provider.of<ManageAreaPro>(context, listen: false).areaname = Provider.of<EditAreasPro>(context, listen: false).areas[index].areaname;
                                                    SystemChrome.setPreferredOrientations(
                                                      [
                                                        DeviceOrientation.landscapeRight,
                                                        DeviceOrientation.landscapeLeft,
                                                      ],
                                                    ).then((value) {
                                                      Navigator.of(context).pushNamed(
                                                        RouteManager.manageareapage,
                                                      );
                                                    });
                                                  },
                                                  child: Text(
                                                    "Manage",
                                                    style: TextStyle(fontSize: RouteManager.width / 19),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: RouteManager.width / 39,
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            SizedBox(
                                              height: RouteManager.width / 100,
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(width: RouteManager.width / 1.16),
                                                InkWell(
                                                  onTap: () {
                                                    // areaname.text=Provider.of<EditAreasPro>(context,listen:false).areas[index].areaname;
                                                    showDialog(
                                                      context: context,
                                                      builder: (cont) {
                                                        return Dialog(
                                                          child: Container(
                                                            width: RouteManager.width,
                                                            padding: EdgeInsets.all(10),
                                                            decoration: const BoxDecoration(
                                                              // color: Color.fromRGBO(101, 106, 121, 1),
                                                              borderRadius: BorderRadius.all(
                                                                Radius.circular(20),
                                                              ),
                                                            ),
                                                            child: SingleChildScrollView(
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                    padding: EdgeInsets.all(RouteManager.width / 70),
                                                                    width: RouteManager.width,
                                                                    decoration: BoxDecoration(
                                                                      color: const Color.fromARGB(
                                                                          255, 55, 253, 18),
                                                                      borderRadius: BorderRadius.all(
                                                                        Radius.circular(RouteManager.width / 23),
                                                                      ),
                                                                    ),
                                                                    child: Row(
                                                                      children: [
                                                                        InkWell(
                                                                          onTap: () {
                                                                            Navigator.of(context, rootNavigator: true).pop();
                                                                          },
                                                                          child: Icon(
                                                                            Icons.close,
                                                                            color: Colors.black,
                                                                            size: RouteManager.width / 13,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width: RouteManager.width / 13,
                                                                        ),
                                                                        Text(
                                                                          "Update Area",
                                                                          style: TextStyle(
                                                                            color: Colors.white,
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: RouteManager.width / 15,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: RouteManager.width / 10),
                                                                  TextField(
                                                                    controller: areaname,
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
                                                                      labelText: "Area Name",
                                                                      labelStyle: TextStyle(
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: RouteManager.width / 23,
                                                                        color: const Color.fromARGB(
                                                                            255, 55, 253, 18),
                                                                      ),
                                                                      hintText: "Enter Area's Name",
                                                                      hintStyle: TextStyle(
                                                                        fontSize: RouteManager.width / 24,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: RouteManager.width / 20),
                                                                  ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(
                                                                      backgroundColor: const Color.fromARGB(
                                                                          255, 55, 253, 18),
                                                                    ),
                                                                    onPressed: () {
                                                                      if (areaname.text == "") {
                                                                        ft.Fluttertoast.showToast(
                                                                          msg: "Please Enter Area Name",
                                                                          toastLength: ft.Toast.LENGTH_SHORT,
                                                                        );
                                                                        return;
                                                                      }
                                                                      MyServer.updateAreaNAme(Provider.of<EditAreasPro>(context, listen: false).areas[index].areaid, areaname.text).then((value) {
                                                                        if (value) {
                                                                          ft.Fluttertoast.showToast(
                                                                            msg: "Updated Successfully",
                                                                            toastLength: ft.Toast.LENGTH_SHORT,
                                                                          );
                                                                          Provider.of<EditAreasPro>(context, listen: false).areas[index].areaname = areaname.text;
                                                                          Provider.of<EditAreasPro>(context, listen: false).notifyListenerz();
                                                                          areaname.text = "";
                                                                        }
                                                                        Navigator.of(context, rootNavigator: true).pop();
                                                                      });
                                                                    },
                                                                    child: Text(
                                                                      "Confirm",
                                                                      style: TextStyle(fontSize: RouteManager.width / 21),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ).then((value) {
                                                      areaname.text = "";
                                                    });
                                                  },
                                                  child: Icon(
                                                    Icons.edit,
                                                    size: RouteManager.width / 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: RouteManager.width / 18),
                                            Row(
                                              children: [
                                                SizedBox(width: RouteManager.width / 1.16),
                                                InkWell(
                                                  onTap: () async {
                                                    var value = await MyServer.checkTablesCount(Provider.of<EditAreasPro>(context, listen: false).areas[index].areaid);
                                                    if (!value) {
                                                      value = await MyServer.deleteArea(Provider.of<EditAreasPro>(context, listen: false).areas[index].areaid);
                                                      if (value) {
                                                        Provider.of<EditAreasPro>(context, listen: false).areas.removeAt(index);

                                                        setState(() {});
                                                      }
                                                    } else {
                                                      ft.Fluttertoast.showToast(
                                                        msg: "has Tables",
                                                        toastLength: ft.Toast.LENGTH_SHORT,
                                                      );
                                                    }
                                                  },
                                                  child: Icon(
                                                    Icons.delete,
                                                    color: const Color.fromARGB(
                                                        255, 55, 253, 18),
                                                    size: RouteManager.width / 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: RouteManager.width / 100,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
        ),
      ),
    );
  }
}
