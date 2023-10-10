import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:table_booking/Entities/tableobject.dart';

import '../Entities/areaobject.dart';
import '../Entities/searchobject.dart';
class SearchPro with ChangeNotifier {
  String datetext="Select Date";
  DateTime? d;
  List<AreaObject> areas=[];
  // List<TableObject> tables=[];
  List<SearchObject> searches=[];
  AreaObject? selectedarea;
  // TableObject? selectedtable;
  bool? loaded1;
  bool loaded2=false;
  bool nothingsearched=true;

  notifyListenerz(){
    notifyListeners();
  }
  clearAll(){
    nothingsearched=true;
    d=null;
    areas=[];
    // tables=[];
    loaded1=null;
    loaded2=false;
    datetext="Select Date";
    selectedarea=null;
    // selectedtable=null;
  }
}