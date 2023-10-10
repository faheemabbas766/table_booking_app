import 'dart:io';
import 'package:flutter/cupertino.dart';

import '../Entities/areaobject.dart';
import '../Entities/tableobject.dart';

class AllTablesPro with ChangeNotifier {
  int areaid = -1;
  String areaname = "";
  List<TableObject> mytables = [];
  Stack tables = const Stack(
    children: [],
  );
  bool isloaded=false;
  // bool isdonable = false;

  clearAll() {
    areaid = -1;
    areaname = "";
    mytables = [];
    tables = const Stack(
      children: [],
    );
    mytables = [];
    // isdonable = false;
    print("CLEAREDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD");
  }

  notifyListenerz() {
    notifyListeners();
  }
}
