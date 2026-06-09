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
  static double _rawWidth = 390;
  static double _rawHeight = 844;
  static double newwidth = 0;
  static double newheight = 0;

  static double get rawWidth => _rawWidth;
  static double get rawHeight => _rawHeight;

  static double get width {
    final isLandscape = _rawWidth > _rawHeight;
    final maxWidth = isLandscape ? 980.0 : 430.0;
    return _rawWidth.clamp(320.0, maxWidth).toDouble();
  }

  static set width(dynamic value) {
    _rawWidth = _toDouble(value, fallback: _rawWidth);
  }

  static double get height {
    final isLandscape = _rawWidth > _rawHeight;
    final maxHeight = isLandscape ? 560.0 : 900.0;
    return _rawHeight.clamp(560.0, maxHeight).toDouble();
  }

  static set height(dynamic value) {
    _rawHeight = _toDouble(value, fallback: _rawHeight);
  }

  static bool get isLandscape => _rawWidth > _rawHeight;

  static void sync(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;
  }

  static double sp(double value) {
    return value.clamp(11.0, 28.0).toDouble();
  }

  static double _toDouble(dynamic value, {required double fallback}) {
    if (value is num) {
      return value.toDouble();
    }
    return fallback;
  }

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
        return MaterialPageRoute(
            builder: (context) =>
                const ResponsiveRoutePage(child: SplashScreen()));
      case homepage:
        return MaterialPageRoute(
            builder: (context) => const ResponsiveRoutePage(child: Home()));
      case allareaspage:
        return MaterialPageRoute(
            builder: (context) => const ResponsiveRoutePage(child: AllAreas()));
      case alltablespage:
        return MaterialPageRoute(
            builder: (context) =>
                const ResponsiveRoutePage(child: AllTables()));
      case searchpage:
        return MaterialPageRoute(
            builder: (context) => const ResponsiveRoutePage(child: Search()));
      case editareaspage:
        return MaterialPageRoute(
            builder: (context) =>
                const ResponsiveRoutePage(child: EditAreas()));
      case edittablespage:
        return MaterialPageRoute(
            builder: (context) =>
                const ResponsiveRoutePage(child: EditTables()));
      case manageareapage:
        return MaterialPageRoute(
            builder: (context) =>
                const ResponsiveRoutePage(child: ManageArea()));
      // case privacypolicy:
      //   return MaterialPageRoute(builder: (context) => PrivacyPolicy());
      default:
        throw const FormatException("Route no Found!");
    }
  }
}

class ResponsiveRoutePage extends StatelessWidget {
  const ResponsiveRoutePage({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    RouteManager.sync(context);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: MediaQuery.textScalerOf(context).clamp(
          minScaleFactor: 0.9,
          maxScaleFactor: 1.15,
        ),
      ),
      child: child,
    );
  }
}
