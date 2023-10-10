import 'dart:io';
import 'package:flutter/cupertino.dart';

import '../Entities/areaobject.dart';
class AllAreasPro with ChangeNotifier {
  List<AreaObject> areas=[];
  bool reload=false;
  bool isloaded=false;
  notifyListenerz(){
    notifyListeners();
  }
  clearAll(){
    reload=false;
    isloaded=false;
    areas=[];
  }
}