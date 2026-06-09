import 'package:flutter/material.dart';
import '../Pages/splashscreen.dart';
import '../pages/AllAreas.dart';
import '../pages/AllTables.dart';
import '../pages/managearea.dart';
import '../pages/editareas.dart';
import '../pages/edittables.dart';
import '../pages/home.dart';
import '../pages/search.dart';

class RouteManager {
  static var width;
  static var height;
  static var newwidth;
  static var newheight;
  static const String splashscreen = "/";
  static const String homepage = "/home";
  static const String allareaspage = "/allareaspage";
  static const String alltablespage = "/alltablespage";
  static const String searchpage = "/searchpage";
  static const String editareaspage = "/editareaspage";
  static const String edittablespage = "/edittablespage";
  static const String manageareapage = "/manageareapage";
  // static const String privacypolicy = "/privacypolicy";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashscreen:
        return MaterialPageRoute(builder: (context) => SplashScreen());
      case homepage:
        return MaterialPageRoute(builder: (context) => const Home());
      case allareaspage:
        return MaterialPageRoute(builder: (context) => const AllAreas());
      case alltablespage:
        return MaterialPageRoute(builder: (context) => const AllTables());
      case searchpage:
        return MaterialPageRoute(builder: (context) => const Search());
      case editareaspage:
        return MaterialPageRoute(builder: (context) => const EditAreas());
      case edittablespage:
        return MaterialPageRoute(builder: (context) => const EditTables());
      case manageareapage:
        return MaterialPageRoute(builder: (context) => const ManageArea());
      // case privacypolicy:
      //   return MaterialPageRoute(builder: (context) => PrivacyPolicy());
      default:
        throw const FormatException("Route no Found!");
    }
  }
}
