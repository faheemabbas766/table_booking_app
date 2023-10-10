import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart' as ft;
import '../Api & Routes/routes.dart';
import '../Entities/tableobject.dart';
import '../Providers/manageareapro.dart';
import '../myserver.dart';

class ManageArea extends StatefulWidget {
  @override
  State<ManageArea> createState() => _ManageAreaState();
}

class _ManageAreaState extends State<ManageArea> {
  // TextEditingController areaname = TextEditingController();
  TextEditingController tablename = TextEditingController();

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
        RouteManager.width = MediaQuery.of(context).size.width;
        RouteManager.height = MediaQuery.of(context).size.height;
        print("WIDTH=====================-----------------------" + RouteManager.width.toString());
        print("Height=====================-----------------------" + RouteManager.height.toString());
        while (true) {
          var value = await MyServer.getWholeArea(Provider.of<ManageAreaPro>(context, listen: false).areaid, context);
          if (value) {
            print("LOADED TABLES===========================================================----------------------" + Provider.of<ManageAreaPro>(context, listen: false).mytables.toString());
            List<Widget> mywlist = [];
            for (int i = 0; i < Provider.of<ManageAreaPro>(context, listen: false).mytables.length; i++) {
              mywlist.add(
                Column(
                  children: [
                    SizedBox(
                      height: Provider.of<ManageAreaPro>(context, listen: false).mytables[i].dy,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: Provider.of<ManageAreaPro>(context, listen: false).mytables[i].dx,
                        ),
                        InkWell(
                          onTap: () {
                            ft.Fluttertoast.showToast(
                              msg: Provider.of<ManageAreaPro>(context, listen: false).mytables[i].tablename,
                              toastLength: ft.Toast.LENGTH_SHORT,
                            );
                          },
                          child: Draggable<String>(
                            data: "${Provider.of<ManageAreaPro>(context, listen: false).mytables[i].shape}-$i",
                            // onDragUpdate: (c) {
                            //   print("DRAG UPDATE DETAILS ::::::::::::::::" + c.toString());
                            // },
                            childWhenDragging: const SizedBox(),
                            feedback: SizedBox(
                              width: RouteManager.height / 5.5,
                              height: RouteManager.height / 5.5,
                              child: Stack(
                                children: [
                                  Container(
                                    width: RouteManager.height / 5.5,
                                    height: RouteManager.height / 5.5,
                                    decoration: BoxDecoration(
                                      // color: Colors.red,
                                      shape: Provider.of<ManageAreaPro>(context, listen: false).mytables[i].shape == "circle" ? BoxShape.circle : BoxShape.rectangle,
                                      image: Provider.of<ManageAreaPro>(context, listen: false).mytables[i].shape == "circle"
                                          ? const DecorationImage(image: AssetImage("images/circle.png"), fit: BoxFit.fill)
                                          : Provider.of<ManageAreaPro>(context, listen: false).mytables[i].shape == "square"
                                          ? const DecorationImage(image: AssetImage("images/square.png"), fit: BoxFit.fill)
                                          : Provider.of<ManageAreaPro>(context, listen: false).mytables[i].shape == "bed_beach"
                                          ? const DecorationImage(image: AssetImage("images/bed_beach.png"), fit: BoxFit.fill)
                                          : Provider.of<ManageAreaPro>(context, listen: false).mytables[i].shape == "table"
                                          ? const DecorationImage(image: AssetImage("images/table.png"), fit: BoxFit.fill)
                                          : Provider.of<ManageAreaPro>(context, listen: false).mytables[i].shape == "big_table"
                                          ? const DecorationImage(image: AssetImage("images/big_table.png"), fit: BoxFit.fill)
                                          : const DecorationImage(image: AssetImage("images/round_bed.png"), fit: BoxFit.fill),


                                      // borderRadius: BorderRadius.all(Radius.circular(20)),
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
                                              constraints: BoxConstraints(
                                                maxWidth: RouteManager.height / 5.511,
                                                maxHeight: RouteManager.height / 17,
                                              ),
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
                                                        Provider.of<ManageAreaPro>(context, listen: false).mytables[i].tablename,
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
                                ],
                              ),
                            ),
                            child: SizedBox(
                              width: RouteManager.height / 5.5,
                              height: RouteManager.height / 5.5,
                              child: Stack(
                                children: [
                                  Container(
                                    width: RouteManager.height / 5.5,
                                    height: RouteManager.height / 5.5,
                                    decoration: BoxDecoration(
                                      shape: Provider.of<ManageAreaPro>(context, listen: false).mytables[i].shape == "circle" ? BoxShape.circle : BoxShape.rectangle,
                                      image: Provider.of<ManageAreaPro>(context, listen: false).mytables[i].shape == "circle"
                                          ? const DecorationImage(image: AssetImage("images/circle.png"), fit: BoxFit.fill)
                                          : Provider.of<ManageAreaPro>(context, listen: false).mytables[i].shape == "square"
                                          ? const DecorationImage(image: AssetImage("images/square.png"), fit: BoxFit.fill)
                                          : Provider.of<ManageAreaPro>(context, listen: false).mytables[i].shape == "bed_beach"
                                          ? const DecorationImage(image: AssetImage("images/bed_beach.png"), fit: BoxFit.fill)
                                          : Provider.of<ManageAreaPro>(context, listen: false).mytables[i].shape == "table"
                                          ? const DecorationImage(image: AssetImage("images/table.png"), fit: BoxFit.fill)
                                          : Provider.of<ManageAreaPro>(context, listen: false).mytables[i].shape == "big_table"
                                          ? const DecorationImage(image: AssetImage("images/big_table.png"), fit: BoxFit.fill)
                                          : const DecorationImage(image: AssetImage("images/round_bed.png"), fit: BoxFit.fill),

                                    ),
                                  ),
                                  SizedBox(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          constraints: BoxConstraints(
                                            maxWidth: RouteManager.height / 5.511,
                                            maxHeight: RouteManager.height / 5.250,
                                          ),
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
                                                    Provider.of<ManageAreaPro>(context, listen: false).mytables[i].tablename,
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
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
              print("ADDED TO MYWLIST----------------$i");
            }
            Provider.of<ManageAreaPro>(context, listen: false).tables = Stack(children: [...mywlist]);
            if (Provider.of<ManageAreaPro>(context, listen: false).mytables.isNotEmpty) {
              Provider.of<ManageAreaPro>(context, listen: false).isdonable = true;
            }
            Provider.of<ManageAreaPro>(context, listen: false).isloaded = true;
            print("LOADEDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDd");
            // Provider.of<ManageAreaPro>(context, listen: false).reload = !Provider.of<ManageAreaPro>(context, listen: false).reload;
            // Provider.of<ManageAreaPro>(context, listen: false).isloaded = true;
            Provider.of<ManageAreaPro>(context, listen: false).notifyListenerz();
            break;
          }
        }
      });
    });
  }

  // void loadAllAreas(BuildContext context) async {
  //   while (true) {
  //     var value = await MyServer.getEditAllAreas(context);
  //     if (value) {
  //       // Provider.of<EditAreasPro>(context, listen: false).reload = !Provider.of<AllAreasPro>(context, listen: false).reload;
  //       Provider.of<EditAreasPro>(context, listen: false).isloaded = true;
  //       Provider.of<EditAreasPro>(context, listen: false).notifyListenerz();
  //       print("AYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaaa");
  //       break;
  //     }
  //   }
  // }
  // final verticalScrollController = ScrollController();
  // final horizontalScrollController = ScrollController();
  // final mykey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    print("BUILD WIDTH=====================-----------------------${RouteManager.width}");
    print("BUILD Height=====================-----------------------${RouteManager.height}");
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          // print("CLEAREDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDd 111111111111111111111111111111111111111111111111111111111111111111111111111111111111111");
          Provider.of<ManageAreaPro>(context, listen: false).clearAll();
          setState(() {});
          // Provider.of<EditAreasPro>(context, listen: false).isloaded = false;
          return Future.value(true);
        },
        child: Scaffold(
          // appBar: AppBar(
          //   title: Text(""),
          // ),
          body: Container(
            padding: EdgeInsets.all(RouteManager.width / 150),
            // width: RouteManager.width/1.1,
            // height: RouteManager.height,
            child: Row(
              children: [
                Container(
                  width: RouteManager.width / 1.13,
                  height: RouteManager.height / 1.1,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                    color: const Color.fromARGB(255, 243, 216, 234),
                  ),
                  padding: EdgeInsets.all(RouteManager.height / 90),
                  child: !Provider.of<ManageAreaPro>(context).isloaded
                      ? const SizedBox()
                      : DragTarget<String>(
                          onWillAccept: (value) {
                            print("AYA 1");
                            return true;
                          },
                          onAccept: (value) {
                            // setState(() {});
                            print("Aya 2");
                          },
                          onAcceptWithDetails: (data) async {
                            // print("RouteManager.height/1.275=================================================="+(RouteManager.height/1.275).toString());
                            print("Length of STACK::::::::::::::::::::::::::::::::::::::::::::::::::::::${Provider.of<ManageAreaPro>(context, listen: false).tables.children.length}");
                            print("Length of MyTables:::::::::::::::::::::::::::::::::::::::::::::::::::${Provider.of<ManageAreaPro>(context, listen: false).mytables.length}");

                            if (data.offset.dy > RouteManager.height / 1.275) {
                              return;
                            }
                            if (data.offset.dx > RouteManager.width / 1.23) {
                              return;
                            }
                            // Provider.of<CreateAreaPro>(context, listen: false).accepted = true;
                            // if(data.offset.dx>RouteManager.w)
                            // Provider.of<CreateAreaPro>(context, listen: false).dx = data.offset.dx - (RouteManager.height / 40) < 0 ? 0 : data.offset.dx - (RouteManager.height / 40);
                            // Provider.of<CreateAreaPro>(context, listen: false).dy = data.offset.dy - (RouteManager.height / 10) < 0 ? 0 : data.offset.dy - (RouteManager.height / 10);
                            // int indextoremove = -1;

                            if (int.parse(data.data.split('-')[1]) != Provider.of<ManageAreaPro>(context, listen: false).tables.children.length) {
                              print("DELETEDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD :::::: ${data.data.split('-')[1]}");
                              Provider.of<ManageAreaPro>(context, listen: false).tables.children.removeAt(int.parse(data.data.split('-')[1]));
                              Provider.of<ManageAreaPro>(context, listen: false).mytables.add(Provider.of<ManageAreaPro>(context, listen: false).mytables[int.parse(data.data.split('-')[1])]);

                              Provider.of<ManageAreaPro>(context, listen: false).mytables[Provider.of<ManageAreaPro>(context, listen: false).mytables.length - 1].dx =
                                  data.offset.dx - (RouteManager.height / 40) < 0 ? 0 : data.offset.dx - (RouteManager.height / 40);
                              Provider.of<ManageAreaPro>(context, listen: false).mytables[Provider.of<ManageAreaPro>(context, listen: false).mytables.length - 1].dy =
                                  data.offset.dy - (RouteManager.height / 10) < 0 ? 0 : data.offset.dy - (RouteManager.height / 10);
                              Provider.of<ManageAreaPro>(context, listen: false).mytables.removeAt(int.parse(data.data.split('-')[1]));

                              // Provider.of<ManageAreaPro>(context, listen: false).mytables[int.parse(data.data.split('-')[1])].dx =
                              //     data.offset.dx - (RouteManager.height / 40) < 0 ? 0 : data.offset.dx - (RouteManager.height / 40);
                              // Provider.of<ManageAreaPro>(context, listen: false).mytables[int.parse(data.data.split('-')[1])].dy =
                              //     data.offset.dy - (RouteManager.height / 10) < 0 ? 0 : data.offset.dy - (RouteManager.height / 10);
                              // Provider.of<ManageAreaPro>(context, listen: false).mytables.removeAt(int.parse(data.data.split('-')[1]));
                            } else {
                              await showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (cont) {
                                    return WillPopScope(
                                      onWillPop: () {
                                        return Future.value(false);
                                      },
                                      child: AlertDialog(
                                        // title: const Text("New Table"),
                                        content: SingleChildScrollView(
                                          child: SizedBox(
                                            width: RouteManager.width / 2.5,
                                            // height: RouteManager.height / 2.2,
                                            child: Column(children: [
                                              TextField(
                                                style: TextStyle(
                                                  // fontWeight: FontWeight.bold,
                                                  fontSize: RouteManager.width / 60,
                                                ),
                                                controller: tablename,
                                                decoration: InputDecoration(
                                                  fillColor: Colors.white,
                                                  filled: true,
                                                  // labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: RouteManager.width / 16),
                                                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                                                  // labelText: "New Area",
                                                  hintText: "Enter Table Name",
                                                  hintStyle: TextStyle(
                                                    // fontWeight: FontWeight.bold,
                                                    fontSize: RouteManager.width / 60,
                                                  ),
                                                ),
                                              ),
                                              // SizedBox(height: RouteManager.width / 23),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    if (tablename.text != "") {
                                                      for (int i = 0; i < Provider.of<ManageAreaPro>(context, listen: false).mytables.length; i++) {
                                                        if (Provider.of<ManageAreaPro>(context, listen: false).mytables[i].tablename == tablename.text) {
                                                          ft.Fluttertoast.showToast(
                                                            msg: "${Provider.of<ManageAreaPro>(context, listen: false).mytables[i].tablename} already Exists",
                                                            toastLength: ft.Toast.LENGTH_SHORT,
                                                          );

                                                          return;
                                                        }
                                                      }
                                                      Provider.of<ManageAreaPro>(context, listen: false).mytables.add(
                                                            TableObject(
                                                              0,
                                                              Provider.of<ManageAreaPro>(context, listen: false).areaid,
                                                              tablename.text,
                                                              null,
                                                              // Provider.of<CreateAreaPro>(context, listen: false).dx = data.offset.dx - (RouteManager.height / 40) < 0 ? 0 : data.offset.dx - (RouteManager.height / 40);
                                                              // Provider.of<CreateAreaPro>(context, listen: false).dy = data.offset.dy - (RouteManager.height / 10) < 0 ? 0 : data.offset.dy - (RouteManager.height / 10);
                                                              data.offset.dx - (RouteManager.height / 40) < 0 ? 0 : data.offset.dx - (RouteManager.height / 40),
                                                              data.offset.dy - (RouteManager.height / 10) < 0 ? 0 : data.offset.dy - (RouteManager.height / 10),
                                                              data.data.split('-')[0],
                                                            ),
                                                          );
                                                      Provider.of<ManageAreaPro>(context, listen: false).isdonable = true;
                                                      Provider.of<ManageAreaPro>(context, listen: false).notifyListenerz();
                                                      print("TABLE ADDED STACK::::::::::::::::::::::::::::::::::::::::::::::::::::::${Provider.of<ManageAreaPro>(context, listen: false).tables.children.length}");
                                                      print("TABLE ADDED MyTables:::::::::::::::::::::::::::::::::::::::::::::::::::${Provider.of<ManageAreaPro>(context, listen: false).mytables.length}");
                                                      // print("DX=======================================" + Provider.of<CreateAreaPro>(context, listen: false).dx.toString());
                                                      // print("Dy=======================================" + Provider.of<CreateAreaPro>(context, listen: false).dy.toString());
                                                      Navigator.of(context, rootNavigator: true).pop();
                                                      print("Length of MY TABLEs============================${Provider.of<ManageAreaPro>(context, listen: false).mytables.length}");
                                                    }
                                                  },
                                                  child: Text(
                                                    "Confirm",
                                                    style: TextStyle(fontSize: RouteManager.width / 60),
                                                  ))
                                            ]),
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            }
                            // int indexofwidget = Provider.of<CreateAreaPro>(context, listen: false).tables.children.length;
                            tablename.text = "";
                            List<Widget> mywlist = [];
                            // print("LIST:::::::"+Provider.of<ManageAreaPro>(context, listen: false).mytables.toString());
                            for (int i = 0; i < Provider.of<ManageAreaPro>(context, listen: false).mytables.length; i++) {
                              print("SHAPE :::::::::::${Provider.of<ManageAreaPro>(context, listen: false).mytables[i].shape}");
                              print("LENGTH :::::::::::${Provider.of<ManageAreaPro>(context, listen: false).mytables.length}");
                              mywlist.add(
                                Column(
                                  children: [
                                    Container(
                                      height: Provider.of<ManageAreaPro>(context, listen: false).mytables[i].dy,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: Provider.of<ManageAreaPro>(context, listen: false).mytables[i].dx,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            ft.Fluttertoast.showToast(
                                              msg: Provider.of<ManageAreaPro>(context, listen: false).mytables[i].tablename,
                                              toastLength: ft.Toast.LENGTH_SHORT,
                                            );
                                          },
                                          child: Draggable<String>(
                                            data: Provider.of<ManageAreaPro>(context, listen: false).mytables[i].shape + "-" + i.toString(),

                                            // onDragUpdate: (c) {
                                            //   print("DRAG UPDATE DETAILS ::::::::::::::::" + c.toString());
                                            // },
                                            childWhenDragging: const SizedBox(),
                                            feedback: SizedBox(
                                              width: RouteManager.height / 5.5,
                                              height: RouteManager.height / 5.5,
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    width: RouteManager.height / 5.5,
                                                    height: RouteManager.height / 5.5,

                                                    decoration: BoxDecoration(
                                                      // color: Colors.red,
                                                      shape: Provider.of<ManageAreaPro>(context, listen: false).mytables[i].shape == "circle" ? BoxShape.circle : BoxShape.rectangle,
                                                      image: Provider.of<ManageAreaPro>(context, listen: false).mytables[i].shape == "circle"
                                                          ? const DecorationImage(image: AssetImage("images/circle.png"), fit: BoxFit.fill)
                                                          : Provider.of<ManageAreaPro>(context, listen: false).mytables[i].shape == "square"
                                                          ? const DecorationImage(image: AssetImage("images/square.png"), fit: BoxFit.fill)
                                                          : Provider.of<ManageAreaPro>(context, listen: false).mytables[i].shape == "bed_beach"
                                                          ? const DecorationImage(image: AssetImage("images/bed_beach.png"), fit: BoxFit.fill)
                                                          : Provider.of<ManageAreaPro>(context, listen: false).mytables[i].shape == "table"
                                                          ? const DecorationImage(image: AssetImage("images/table.png"), fit: BoxFit.fill)
                                                          : Provider.of<ManageAreaPro>(context, listen: false).mytables[i].shape == "big_table"
                                                          ? const DecorationImage(image: AssetImage("images/big_table.png"), fit: BoxFit.fill)
                                                          : const DecorationImage(image: AssetImage("images/round_bed.png"), fit: BoxFit.fill),



                                                      // borderRadius: BorderRadius.all(Radius.circular(20)),
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
                                                              constraints: BoxConstraints(
                                                                maxWidth: RouteManager.height / 5.511,
                                                                maxHeight: RouteManager.height / 11.250,
                                                              ),
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
                                                                        Provider.of<ManageAreaPro>(context, listen: false).mytables[i].tablename,
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
                                                ],
                                              ),
                                            ),
                                            child: SizedBox(
                                              width: RouteManager.height / 5.5,
                                              height: RouteManager.height / 5.5,
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    width: RouteManager.height / 5.5,
                                                    height: RouteManager.height / 5.5,
                                                    decoration: BoxDecoration(
                                                      // color: Colors.red,
                                                      shape: Provider.of<ManageAreaPro>(context, listen: false).mytables[i].shape == "circle" ? BoxShape.circle : BoxShape.rectangle,
                                                      image: Provider.of<ManageAreaPro>(context, listen: false).mytables[i].shape == "circle"
                                                          ? const DecorationImage(image: AssetImage("images/circle.png"), fit: BoxFit.fill)
                                                          : Provider.of<ManageAreaPro>(context, listen: false).mytables[i].shape == "square"
                                                          ? const DecorationImage(image: AssetImage("images/square.png"), fit: BoxFit.fill)
                                                          : Provider.of<ManageAreaPro>(context, listen: false).mytables[i].shape == "bed_beach"
                                                          ? const DecorationImage(image: AssetImage("images/bed_beach.png"), fit: BoxFit.fill)
                                                          : Provider.of<ManageAreaPro>(context, listen: false).mytables[i].shape == "table"
                                                          ? const DecorationImage(image: AssetImage("images/table.png"), fit: BoxFit.fill)
                                                          : Provider.of<ManageAreaPro>(context, listen: false).mytables[i].shape == "big_table"
                                                          ? const DecorationImage(image: AssetImage("images/big_table.png"), fit: BoxFit.fill)
                                                          : const DecorationImage(image: AssetImage("images/round_bed.png"), fit: BoxFit.fill),

                                                      // borderRadius: BorderRadius.all(Radius.circular(20)),
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
                                                                        Provider.of<ManageAreaPro>(context, listen: false).mytables[i].tablename,
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
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                              print("ADDED TO MYWLIST----------------" + i.toString());
                            }
                            Provider.of<ManageAreaPro>(context, listen: false).tables = Stack(children: mywlist);
                            print("Length of STACK::::::::::::::::::::::::::::::::::::::::::::::::::::::${Provider.of<ManageAreaPro>(context, listen: false).tables.children.length}");
                            print("Length of MyTables:::::::::::::::::::::::::::::::::::::::::::::::::::${Provider.of<ManageAreaPro>(context, listen: false).mytables.length}");
                            print("ONACCEPTWITHDETAILS DATA::::${data.data}");
                            // print("RouteManager.width/1.23==================================================" + (RouteManager.height / 1.23).toString());
                            // print("DX DY :::::::::::::::::::::::::::::::::::::::::::::::::        " + data.offset.dx.toString() + "  :  " + data.offset.dy.toString());
                            Provider.of<ManageAreaPro>(context, listen: false).notifyListenerz();
                            setState(() {});
                            print("AYA 3");

                            // Provider.of<CreateAreaPro>(context, listen: false).tables = Stack(
                            //   children: [
                            //     ...Provider.of<CreateAreaPro>(context, listen: false).tables.children,
                            //     Column(
                            //       children: [
                            //         SizedBox(
                            //           height: data.offset.dy - (RouteManager.height / 10) < 0 ? 0 : data.offset.dy - (RouteManager.height / 10),
                            //         ),
                            //         Row(
                            //           children: [
                            //             SizedBox(
                            //               width: data.offset.dx - (RouteManager.height / 40) < 0 ? 0 : data.offset.dx - (RouteManager.height / 40),
                            //             ),
                            //             Draggable<String>(
                            //               data: data.data.split('-')[0] + "-" + indexofwidget.toString(),
                            //               child: Container(
                            //                 width: RouteManager.height / 5.5,
                            //                 height: RouteManager.height / 5.5,
                            //                 decoration: BoxDecoration(
                            //                   // color: Colors.red,
                            //                   shape: data.data.split('-')[0] == "circle" ? BoxShape.circle : BoxShape.rectangle,
                            //                   image: DecorationImage(image: AssetImage("images/wood.jpg"), fit: BoxFit.fill),
                            //                   // borderRadius: BorderRadius.all(Radius.circular(20)),
                            //                 ),
                            //               ),
                            //               // onDragUpdate: (c) {
                            //               //   print("DRAG UPDATE DETTAILS ::::::::::::::::" + c.toString());
                            //               // },
                            //               childWhenDragging: SizedBox(),
                            //               feedback: Container(
                            //                 // key: mykey,
                            //                 width: RouteManager.height / 5.5,
                            //                 height: RouteManager.height / 5.5,
                            //                 decoration: BoxDecoration(
                            //                   shape: data.data.split('-')[0] == "circle" ? BoxShape.circle : BoxShape.rectangle,
                            //                   image: DecorationImage(image: AssetImage("images/wood.jpg"), fit: BoxFit.fill),
                            //                   // borderRadius: BorderRadius.all(Radius.circular(20)),
                            //                 ),
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       ],
                            //     ),
                            //   ],
                            // );
                          },
                          builder: (context, candidates, rejects) {
                            print("CANDIDATES : $candidates");
                            print("REJECTS : $rejects");
                            // print("AYA 4");
                            return Provider.of<ManageAreaPro>(context, listen: false).tables;
                          },
                        ),
                ),
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(fontSize: RouteManager.height / 33),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        onPressed: Provider.of<ManageAreaPro>(context).isdonable
                            ? () {
                          MyServer.addTablesInArea(Provider.of<ManageAreaPro>(context, listen: false).areaid, Provider.of<ManageAreaPro>(context, listen: false).mytables).then((value) {
                            // Provider.of<HomePro>(context, listen: false).totalareas = Provider.of<HomePro>(context, listen: false).totalareas! + 1;
                            // Provider.of<HomePro>(context, listen: false).notifyListenerz();
                            // ft.Fluttertoast.showToast(
                            //   msg: "Area '" + areaname.text + "' Added",
                            //   toastLength: ft.Toast.LENGTH_SHORT,
                            // );
                            print("AALAWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW");
                          });
                          // Navigator.of(context, rootNavigator: true).pop();
                          Navigator.of(context, rootNavigator: true).pop();
                          print("Length of MYTABLEs============================${Provider.of<ManageAreaPro>(context, listen: false).mytables.length}");
                        }
                            : null,
                        child: Text(
                          "Done",
                          style: TextStyle(fontSize: RouteManager.height / 25),
                        ),
                      ),
                      Container(
                        width: RouteManager.height / 6.77,
                        height: RouteManager.height / 6.77,
                        padding: EdgeInsets.all(RouteManager.height / 300),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 219, 216, 216),
                          shape: BoxShape.circle,
                          // image: DecorationImage(image: AssetImage("images/wood.jpg"), fit: BoxFit.fill),
                          // borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Icon(
                              Icons.delete_forever,
                              color: Colors.red,
                              size: RouteManager.height / 12,
                            ),
                            DragTarget(
                              onWillAccept: (data) => true,
                              onAcceptWithDetails: (data) {
                                if (int.parse(data.data.toString().split('-')[1]) == Provider.of<ManageAreaPro>(context, listen: false).mytables.length) {
                                  return;
                                }
                                if (Provider.of<ManageAreaPro>(context, listen: false).mytables[int.parse(data.data.toString().split('-')[1])].booking != null) {
                                  ft.Fluttertoast.showToast(
                                    msg: "Table has Bookings",
                                    toastLength: ft.Toast.LENGTH_SHORT,
                                  );
                                  return;
                                }
                                Provider.of<ManageAreaPro>(context, listen: false).mytables.removeAt(int.parse(data.data.toString().split('-')[1]));
                                List<Widget> mywlist = [];
                                for (int i = 0; i < Provider.of<ManageAreaPro>(context, listen: false).mytables.length; i++) {
                                  mywlist.add(
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: Provider.of<ManageAreaPro>(context, listen: false).mytables[i].dy,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: Provider.of<ManageAreaPro>(context, listen: false).mytables[i].dx,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                ft.Fluttertoast.showToast(
                                                  msg: Provider.of<ManageAreaPro>(context, listen: false).mytables[i].tablename,
                                                  toastLength: ft.Toast.LENGTH_SHORT,
                                                );
                                              },
                                              child: Draggable<String>(
                                                data: "${Provider.of<ManageAreaPro>(context, listen: false).mytables[i].shape}-$i",

                                                // onDragUpdate: (c) {
                                                //   print("DRAG UPDATE DETTAILS ::::::::::::::::" + c.toString());
                                                // },
                                                childWhenDragging: SizedBox(),
                                                feedback: Container(
                                                  width: RouteManager.height / 5.5,
                                                  height: RouteManager.height / 5.5,
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        width: RouteManager.height / 5.5,
                                                        height: RouteManager.height / 5.5,
                                                        decoration: BoxDecoration(
                                                          // color: Colors.red,
                                                          shape: Provider.of<ManageAreaPro>(context, listen: false).mytables[i].shape == "circle" ? BoxShape.circle : BoxShape.rectangle,
                                                          image: Provider.of<ManageAreaPro>(context, listen: false).mytables[i].shape == "circle"
                                                              ? const DecorationImage(image: AssetImage("images/circle.png"), fit: BoxFit.fill)
                                                              : Provider.of<ManageAreaPro>(context, listen: false).mytables[i].shape == "square"
                                                              ? const DecorationImage(image: AssetImage("images/square.png"), fit: BoxFit.fill)
                                                              : Provider.of<ManageAreaPro>(context, listen: false).mytables[i].shape == "bed_beach"
                                                              ? const DecorationImage(image: AssetImage("images/bed_beach.png"), fit: BoxFit.fill)
                                                              : Provider.of<ManageAreaPro>(context, listen: false).mytables[i].shape == "table"
                                                              ? const DecorationImage(image: AssetImage("images/table.png"), fit: BoxFit.fill)
                                                              : Provider.of<ManageAreaPro>(context, listen: false).mytables[i].shape == "big_table"
                                                              ? const DecorationImage(image: AssetImage("images/big_table.png"), fit: BoxFit.fill)
                                                              : const DecorationImage(image: AssetImage("images/round_bed.png"), fit: BoxFit.fill),

                                                          // borderRadius: BorderRadius.all(Radius.circular(20)),
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
                                                                  constraints: BoxConstraints(
                                                                    maxWidth: RouteManager.height / 5.511,
                                                                    maxHeight: RouteManager.height / 11.250,
                                                                  ),
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
                                                                          child: SizedBox(
                                                                            child: Text(
                                                                              Provider.of<ManageAreaPro>(context, listen: false).mytables[i].tablename,
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: TextStyle(
                                                                                fontSize: RouteManager.height / 30,
                                                                                color: Colors.white,
                                                                              ),
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
                                                    ],
                                                  ),
                                                ),
                                                child: Container(
                                                  width: RouteManager.height / 5.5,
                                                  height: RouteManager.height / 5.5,
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        width: RouteManager.height / 5.5,
                                                        height: RouteManager.height / 5.5,
                                                        decoration: BoxDecoration(
                                                          // color: Colors.red,
                                                          image: Provider.of<ManageAreaPro>(context, listen: false).mytables[i].shape == "circle"
                                                              ? const DecorationImage(image: AssetImage("images/circle.png"), fit: BoxFit.fill)
                                                              : Provider.of<ManageAreaPro>(context, listen: false).mytables[i].shape == "square"
                                                              ? const DecorationImage(image: AssetImage("images/square.png"), fit: BoxFit.fill)
                                                              : Provider.of<ManageAreaPro>(context, listen: false).mytables[i].shape == "bed_beach"
                                                              ? const DecorationImage(image: AssetImage("images/bed_beach.png"), fit: BoxFit.fill)
                                                              : Provider.of<ManageAreaPro>(context, listen: false).mytables[i].shape == "table"
                                                              ? const DecorationImage(image: AssetImage("images/table.png"), fit: BoxFit.fill)
                                                              : Provider.of<ManageAreaPro>(context, listen: false).mytables[i].shape == "big_table"
                                                              ? const DecorationImage(image: AssetImage("images/big_table.png"), fit: BoxFit.fill)
                                                              : const DecorationImage(image: AssetImage("images/round_bed.png"), fit: BoxFit.fill),
                                                          //borderRadius: BorderRadius.all(Radius.circular(20)),
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
                                                                            Provider.of<ManageAreaPro>(context, listen: false).mytables[i].tablename,
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
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                  print("ADDED TO MYWLIST----------------$i");
                                }
                                Provider.of<ManageAreaPro>(context, listen: false).tables = Stack(children: mywlist);
                                setState(() {});
                                print("DATA HERE IS ::::::::::::::::::::${data.data}");
                              },
                              builder: (a, b, c) {
                                return const SizedBox();
                              },
                            ),
                          ],
                        ),
                      ),






                      Row(
                        children: [
                          SizedBox(width: RouteManager.height / 90),
                          Draggable<String>(
                            data: "table-${Provider.of<ManageAreaPro>(context).tables.children.length}",
                            childWhenDragging: Container(
                              width: RouteManager.height / 5.5,
                              height: RouteManager.height / 5.5,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle, border: Border.all(color: Colors.brown),
                                // image: DecorationImage(image: AssetImage("images/wood.jpg"), fit: BoxFit.fill),
                                // borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                            ),
                            feedback: Container(
                              // key: mykey,
                              width: RouteManager.height / 5.5,
                              height: RouteManager.height / 5.5,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(image: AssetImage("images/table.png"), fit: BoxFit.fill),
                                // borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                            ),
                            onDragStarted: () {
                              // Provider.of<CreateAreaPro>(context, listen: false).tableslength = Provider.of<CreateAreaPro>(context, listen: false).tables.children.length;
                            },
                            onDragCompleted: () {
                              // if (Provider.of<CreateAreaPro>(context, listen: false).tableslength == Provider.of<CreateAreaPro>(context, listen: false).tables.children.length) {
                              //   return;
                              // }

                              print("COMPLETED");
                            },
                            onDragEnd: (DraggableDetails c) {
                              // cc.offset
                              print("ENDEDDDD: " + c.offset.toString());
                            },
                            onDraggableCanceled: (v, o) {
                              print("CANCELEDDDDDDDD:$v:$o");
                            },
                            child: Container(
                              width: RouteManager.height / 5.5,
                              height: RouteManager.height / 5.5,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(image: AssetImage("images/table.png"), fit: BoxFit.fill),
                                // borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                              // child:Image.asset("images/circle.png"),
                            ),
                          ),
                        ],
                      ),




                      Row(
                        children: [
                          SizedBox(width: RouteManager.height / 90),
                          Draggable<String>(
                            data: "big_table-${Provider.of<ManageAreaPro>(context).tables.children.length}",
                            childWhenDragging: Container(
                              width: RouteManager.height / 5.5,
                              height: RouteManager.height / 5.5,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle, border: Border.all(color: Colors.brown),
                                // image: DecorationImage(image: AssetImage("images/wood.jpg"), fit: BoxFit.fill),
                                // borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                            ),
                            feedback: Container(
                              // key: mykey,
                              width: RouteManager.height / 5.5,
                              height: RouteManager.height / 5.5,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(image: AssetImage("images/big_table.png"), fit: BoxFit.fill),
                                // borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                            ),
                            onDragStarted: () {
                              // Provider.of<CreateAreaPro>(context, listen: false).tableslength = Provider.of<CreateAreaPro>(context, listen: false).tables.children.length;
                            },
                            onDragCompleted: () {
                              // if (Provider.of<CreateAreaPro>(context, listen: false).tableslength == Provider.of<CreateAreaPro>(context, listen: false).tables.children.length) {
                              //   return;
                              // }

                              print("COMPLETED");
                            },
                            onDragEnd: (DraggableDetails c) {
                              // cc.offset
                              print("ENDEDDDD: " + c.offset.toString());
                            },
                            onDraggableCanceled: (v, o) {
                              print("CANCELEDDDDDDDD:" + v.toString() + ":" + o.toString());
                            },
                            child: Container(
                              width: RouteManager.height / 5.5,
                              height: RouteManager.height / 5.5,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(image: AssetImage("images/big_table.png"), fit: BoxFit.fill),
                                // borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                              // child:Image.asset("images/circle.png"),
                            ),
                          ),
                        ],
                      ),








                      Row(
                        children: [
                          SizedBox(width: RouteManager.height / 90),
                          Draggable<String>(
                            data: "bed_beach-${Provider.of<ManageAreaPro>(context).tables.children.length}",
                            childWhenDragging: Container(
                              width: RouteManager.height / 5.5,
                              height: RouteManager.height / 5.5,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle, border: Border.all(color: Colors.brown),
                                // image: DecorationImage(image: AssetImage("images/wood.jpg"), fit: BoxFit.fill),
                                // borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                            ),
                            feedback: Container(
                              // key: mykey,
                              width: RouteManager.height / 5.5,
                              height: RouteManager.height / 5.5,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(image: AssetImage("images/bed_beach.png"), fit: BoxFit.fill),
                                // borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                            ),
                            onDragStarted: () {
                              // Provider.of<CreateAreaPro>(context, listen: false).tableslength = Provider.of<CreateAreaPro>(context, listen: false).tables.children.length;
                            },
                            onDragCompleted: () {
                              // if (Provider.of<CreateAreaPro>(context, listen: false).tableslength == Provider.of<CreateAreaPro>(context, listen: false).tables.children.length) {
                              //   return;
                              // }

                              print("COMPLETED");
                            },
                            onDragEnd: (DraggableDetails c) {
                              // cc.offset
                              print("ENDEDDDD: " + c.offset.toString());
                            },
                            onDraggableCanceled: (v, o) {
                              print("CANCELEDDDDDDDD:" + v.toString() + ":" + o.toString());
                            },
                            child: Container(
                              width: RouteManager.height / 5.5,
                              height: RouteManager.height / 5.5,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(image: AssetImage("images/bed_beach.png"), fit: BoxFit.fill),
                                // borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                              // child:Image.asset("images/circle.png"),
                            ),
                          ),
                        ],
                      ),









                      Row(
                        children: [
                          SizedBox(width: RouteManager.height / 90),
                          Draggable<String>(
                            data: "round_bed-${Provider.of<ManageAreaPro>(context).tables.children.length}",
                            childWhenDragging: Container(
                              width: RouteManager.height / 5.5,
                              height: RouteManager.height / 5.5,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle, border: Border.all(color: Colors.brown),
                                // image: DecorationImage(image: AssetImage("images/wood.jpg"), fit: BoxFit.fill),
                                // borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                            ),
                            feedback: Container(
                              // key: mykey,
                              width: RouteManager.height / 5.5,
                              height: RouteManager.height / 5.5,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(image: AssetImage("images/round_bed.png"), fit: BoxFit.fill),
                                // borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                            ),
                            onDragStarted: () {
                              // Provider.of<CreateAreaPro>(context, listen: false).tableslength = Provider.of<CreateAreaPro>(context, listen: false).tables.children.length;
                            },
                            onDragCompleted: () {
                              // if (Provider.of<CreateAreaPro>(context, listen: false).tableslength == Provider.of<CreateAreaPro>(context, listen: false).tables.children.length) {
                              //   return;
                              // }

                              print("COMPLETED");
                            },
                            onDragEnd: (DraggableDetails c) {
                              // cc.offset
                              print("ENDEDDDD: " + c.offset.toString());
                            },
                            onDraggableCanceled: (v, o) {
                              print("CANCELEDDDDDDDD:" + v.toString() + ":" + o.toString());
                            },
                            child: Container(
                              width: RouteManager.height / 5.5,
                              height: RouteManager.height / 5.5,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(image: AssetImage("images/round_bed.png"), fit: BoxFit.fill),
                                // borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                              // child:Image.asset("images/circle.png"),
                            ),
                          ),
                        ],
                      ),











                      Row(
                        children: [
                          SizedBox(width: RouteManager.height / 90),
                          Draggable<String>(
                            data: "circle-${Provider.of<ManageAreaPro>(context).tables.children.length}",
                            childWhenDragging: Container(
                              width: RouteManager.height / 5.5,
                              height: RouteManager.height / 5.5,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle, border: Border.all(color: Colors.brown),
                                // image: DecorationImage(image: AssetImage("images/wood.jpg"), fit: BoxFit.fill),
                                // borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                            ),
                            feedback: Container(
                              // key: mykey,
                              width: RouteManager.height / 5.5,
                              height: RouteManager.height / 5.5,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(image: AssetImage("images/circle.png"), fit: BoxFit.fill),
                                // borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                            ),
                            onDragStarted: () {
                              // Provider.of<CreateAreaPro>(context, listen: false).tableslength = Provider.of<CreateAreaPro>(context, listen: false).tables.children.length;
                            },
                            onDragCompleted: () {
                              // if (Provider.of<CreateAreaPro>(context, listen: false).tableslength == Provider.of<CreateAreaPro>(context, listen: false).tables.children.length) {
                              //   return;
                              // }

                              print("COMPLETED");
                            },
                            onDragEnd: (DraggableDetails c) {
                              // cc.offset
                              print("ENDEDDDD: " + c.offset.toString());
                            },
                            onDraggableCanceled: (v, o) {
                              print("CANCELEDDDDDDDD:" + v.toString() + ":" + o.toString());
                            },
                            child: Container(
                              width: RouteManager.height / 5.5,
                              height: RouteManager.height / 5.5,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(image: AssetImage("images/circle.png"), fit: BoxFit.fill),
                                // borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                              // child:Image.asset("images/circle.png"),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: RouteManager.height / 33,
                      ),
                      Row(
                        children: [
                          SizedBox(width: RouteManager.height / 90),
                          Draggable(
                            data: "square-${Provider.of<ManageAreaPro>(context).tables.children.length}",
                            feedback: Container(
                              width: RouteManager.height / 5.5,
                              height: RouteManager.height / 5.5,
                              decoration: const BoxDecoration(
                                // shape: BoxShape.circle,
                                image: DecorationImage(image: AssetImage("images/square.png"), fit: BoxFit.fill),
                                // borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                            ),
                            childWhenDragging: Container(
                              width: RouteManager.height / 5.5,
                              height: RouteManager.height / 5.5,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.brown),
                                // shape: BoxShape.circle,
                                // image: DecorationImage(image: AssetImage("images/wood.jpg"), fit: BoxFit.fill),
                                // borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                            ),
                            onDragStarted: () {
                              // Provider.of<CreateAreaPro>(context, listen: false).tableslength = Provider.of<CreateAreaPro>(context, listen: false).tables.children.length;
                            },
                            onDragCompleted: () {
                              // if (Provider.of<CreateAreaPro>(context, listen: false).tableslength == Provider.of<CreateAreaPro>(context, listen: false).tables.children.length) {
                              //   return;
                              // }
                              print("COMPLETED");
                            },
                            onDragEnd: (DraggableDetails c) {
                              // cc.offset
                              print("ENDEDDDD: ${c.offset}");
                            },
                            onDraggableCanceled: (v, o) {
                              print("CANCELEDDDDDDDD:$v:$o");
                            },
                            child: Container(
                              width: RouteManager.height / 5.5,
                              height: RouteManager.height / 5.5,
                              decoration: const BoxDecoration(
                                // shape: BoxShape.circle,
                                image: DecorationImage(image: AssetImage("images/square.png"), fit: BoxFit.fill),
                                // borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
