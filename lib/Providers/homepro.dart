import 'package:flutter/cupertino.dart';

class HomePro with ChangeNotifier {
  DateTime? d;
  int? totalareas;
  notifyListenerz() {
    notifyListeners();
  }

  clearAll() {
    d = null;
  }
}
