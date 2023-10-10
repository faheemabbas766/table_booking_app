import 'dart:io';
import 'package:flutter/cupertino.dart';

import '../Entities/areaobject.dart';

class EditAreasPro with ChangeNotifier {
  List<AreaObject> areas = [];
  // bool reload=false;
  bool isloaded = false;
  notifyListenerz() {
    notifyListeners();
  }

  clearAll() {
    isloaded = false;
    areas = [];
  }
}
