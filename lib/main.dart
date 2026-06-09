import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:table_booking/Providers/allareaspro.dart';
import 'package:table_booking/theme/app_theme.dart';
import 'Api & Routes/routes.dart';
import 'Providers/alltablespro.dart';
import 'Providers/manageareapro.dart';
import 'Providers/editareaspro.dart';
import 'Providers/homepro.dart';
import 'Providers/searchpro.dart';

void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<HomePro>(
            create: (BuildContext context) => HomePro()),
        ChangeNotifierProvider<AllAreasPro>(
            create: (BuildContext context) => AllAreasPro()),
        ChangeNotifierProvider<AllTablesPro>(
            create: (BuildContext context) => AllTablesPro()),
        ChangeNotifierProvider<SearchPro>(
            create: (BuildContext context) => SearchPro()),
        ChangeNotifierProvider<EditAreasPro>(
            create: (BuildContext context) => EditAreasPro()),
        ChangeNotifierProvider<ManageAreaPro>(
            create: (BuildContext context) => ManageAreaPro()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    RouteManager.sync(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: RouteManager.splashscreen,
      onGenerateRoute: RouteManager.generateRoute,
    );
  }
}
