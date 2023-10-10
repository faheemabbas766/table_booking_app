import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
class HomePro with ChangeNotifier {
  DateTime? expiredate;
  Timer? timer;
  DateTime? d;
  int? totalareas;
  notifyListenerz(){
    notifyListeners();
  }
  clearAll(){
    timer=null;
    expiredate=null;
    d=null;
  }
}