// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import 'package:fluttertoast/fluttertoast.dart' as ft;
// import '../Api & Routes/routes.dart';
// import '../Providers/alltablespro (deleted).dart';
// import '../Providers/homepro.dart';
// import '../myserver.dart';
// import 'package:intl/intl.dart';

// class AllTables extends StatefulWidget {
//   @override
//   State<AllTables> createState() => _AllTablesState();
// }

// class _AllTablesState extends State<AllTables> {
//   TextEditingController custname = TextEditingController();
//   TextEditingController custemail = TextEditingController();
//   TextEditingController custphn = TextEditingController();
//   TextEditingController ttlpersons = TextEditingController();
//   TextEditingController ttladvance = TextEditingController();

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     loadAllTables(this.context);
//   }

//   void loadAllTables(BuildContext context) async {
//     while (true) {
//       var value = await MyServer.getAllTables(Provider.of<AllTablesPro>(context, listen: false).areaid, Provider.of<HomePro>(context, listen: false).d!, context);
//       if (value) {
//         // for(int i=0;i<Provider.of<AllTablesPro>(context, listen: false).tables.length;i++)
//         // {
//         //   print("HERE CUSTOMER IS : : : : : : : : : : : :"+Provider.of<AllTablesPro>(context, listen: false).tables[i].customer.toString());
//         // }
//         Provider.of<AllTablesPro>(context, listen: false).reload = !Provider.of<AllTablesPro>(context, listen: false).reload;
//         Provider.of<AllTablesPro>(context, listen: false).isloaded = true;
//         Provider.of<AllTablesPro>(context, listen: false).notifyListenerz();
//         break;
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: WillPopScope(
//         onWillPop: () {
//           Provider.of<AllTablesPro>(context, listen: false).tables = [];
//           return Future.value(true);
//         },
//         child: Scaffold(
//           appBar: AppBar(
//             backgroundColor: const Color.fromARGB(255, 243, 110, 100),
//             title: Row(
//               children: [
//                 SizedBox(
//                   width: RouteManager.width / 4,
//                 ),
//                 Text("Tables"),
//               ],
//             ),
//           ),
//           body: SingleChildScrollView(
//             child: Container(
//               // color: Colors.red,
//               width: RouteManager.width,
//               height: RouteManager.height / 1.11,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(height: RouteManager.width / 20),
//                   Selector<AllTablesPro, bool>(
//                     selector: (p0, p1) => p1.reload,
//                     builder: (context, reload, child1) {
//                       if (!Provider.of<AllTablesPro>(context, listen: false).isloaded) {
//                         return Center(child: CircularProgressIndicator());
//                       }
//                       print("Length is : " + Provider.of<AllTablesPro>(context, listen: false).tables.length.toString());
//                       if (Provider.of<AllTablesPro>(context, listen: false).tables.isEmpty) {
//                         return Center(
//                           child: Text(
//                             "No Tables Added Yet",
//                             style: TextStyle(fontSize: RouteManager.width / 17, color: Colors.blue),
//                           ),
//                         );
//                       }
//                       return Container(
//                         // color: Colors.blue,
//                         width: RouteManager.width,
//                         height: RouteManager.height / 1.14,
//                         child: ListView.builder(
//                             physics: const BouncingScrollPhysics(),
//                             itemCount: (Provider.of<AllTablesPro>(context, listen: false).tables.length / 2).ceil(),
//                             itemBuilder: (cont, ind) {
//                               ind = ind + ind;
//                               return Column(
//                                 children: [
//                                   Row(
//                                     children: [
//                                       SizedBox(
//                                         width: RouteManager.width / 9,
//                                       ),
//                                       InkWell(
//                                         onTap: () {
//                                           if (Provider.of<AllTablesPro>(cont, listen: false).tables[ind].booking != null) {
//                                             showDialog(
//                                                 context: cont,
//                                                 builder: (cont) {
//                                                   DateTime todaydate = DateTime.now();
//                                                   return AlertDialog(
//                                                     title: Center(
//                                                       child: Text(
//                                                         "Booking Details",
//                                                         style: TextStyle(
//                                                           fontSize: RouteManager.width / 20,
//                                                           color: Colors.red,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     content: Container(
//                                                       width: RouteManager.width,
//                                                       height: RouteManager.height / 1.4,
//                                                       child: Column(
//                                                         children: [
//                                                           SizedBox(height: RouteManager.width / 12),
//                                                           Text(
//                                                             "Customer Name",
//                                                             style: TextStyle(
//                                                               fontSize: RouteManager.width / 23,
//                                                               fontWeight: FontWeight.bold,
//                                                             ),
//                                                           ),
//                                                           SizedBox(height: RouteManager.width / 50),
//                                                           Text(
//                                                             Provider.of<AllTablesPro>(cont, listen: false).tables[ind].booking!.name,
//                                                             style: TextStyle(
//                                                               fontSize: RouteManager.width / 25,
//                                                             ),
//                                                           ),
//                                                           SizedBox(height: RouteManager.width / 20),
//                                                           Text(
//                                                             "Customer Email",
//                                                             style: TextStyle(
//                                                               fontSize: RouteManager.width / 23,
//                                                               fontWeight: FontWeight.bold,
//                                                             ),
//                                                           ),
//                                                           SizedBox(height: RouteManager.width / 50),
//                                                           Text(
//                                                             Provider.of<AllTablesPro>(cont, listen: false).tables[ind].booking!.email,
//                                                             style: TextStyle(
//                                                               fontSize: RouteManager.width / 25,
//                                                             ),
//                                                           ),
//                                                           SizedBox(height: RouteManager.width / 20),
//                                                           Text(
//                                                             "Customer Phn",
//                                                             style: TextStyle(
//                                                               fontSize: RouteManager.width / 23,
//                                                               fontWeight: FontWeight.bold,
//                                                             ),
//                                                           ),
//                                                           SizedBox(height: RouteManager.width / 50),
//                                                           Text(
//                                                             Provider.of<AllTablesPro>(cont, listen: false).tables[ind].booking!.phn,
//                                                             style: TextStyle(
//                                                               fontSize: RouteManager.width / 25,
//                                                             ),
//                                                           ),
//                                                           SizedBox(height: RouteManager.width / 20),
//                                                           Text(
//                                                             "Booked On",
//                                                             style: TextStyle(
//                                                               fontSize: RouteManager.width / 23,
//                                                               fontWeight: FontWeight.bold,
//                                                             ),
//                                                           ),
//                                                           SizedBox(height: RouteManager.width / 50),
//                                                           Text(
//                                                             Provider.of<AllTablesPro>(cont, listen: false).tables[ind].booking!.booked_on.day.toString() +
//                                                                 " " +
//                                                                 MyServer.months[Provider.of<AllTablesPro>(cont, listen: false).tables[ind].booking!.booked_on.month] +
//                                                                 " " +
//                                                                 Provider.of<AllTablesPro>(cont, listen: false).tables[ind].booking!.booked_on.year.toString(),
//                                                             style: TextStyle(
//                                                               fontSize: RouteManager.width / 25,
//                                                             ),
//                                                           ),
//                                                           SizedBox(height: RouteManager.width / 20),
//                                                           Text(
//                                                             "Total Persons",
//                                                             style: TextStyle(
//                                                               fontSize: RouteManager.width / 23,
//                                                               fontWeight: FontWeight.bold,
//                                                             ),
//                                                           ),
//                                                           SizedBox(height: RouteManager.width / 50),
//                                                           Text(
//                                                             Provider.of<AllTablesPro>(cont, listen: false).tables[ind].booking!.ttlpersons.toString(),
//                                                             style: TextStyle(
//                                                               fontSize: RouteManager.width / 25,
//                                                             ),
//                                                           ),
//                                                           SizedBox(height: RouteManager.width / 20),
//                                                           Text(
//                                                             "Advance",
//                                                             style: TextStyle(
//                                                               fontSize: RouteManager.width / 23,
//                                                               fontWeight: FontWeight.bold,
//                                                             ),
//                                                           ),
//                                                           SizedBox(height: RouteManager.width / 50),
//                                                           Text(
//                                                             Provider.of<AllTablesPro>(cont, listen: false).tables[ind].booking!.advance.toString(),
//                                                             style: TextStyle(
//                                                               fontSize: RouteManager.width / 25,
//                                                             ),
//                                                           ),
//                                                           SizedBox(height: RouteManager.width / 20),
//                                                           Provider.of<AllTablesPro>(cont, listen: false).tables[ind].booking!.check_in != null
//                                                               ? Column(
//                                                                   children: [
//                                                                     Text(
//                                                                       "Check In Time",
//                                                                       style: TextStyle(
//                                                                         fontSize: RouteManager.width / 23,
//                                                                         fontWeight: FontWeight.bold,
//                                                                       ),
//                                                                     ),
//                                                                     SizedBox(height: RouteManager.width / 50),
//                                                                     Text(
//                                                                       Provider.of<AllTablesPro>(cont, listen: false).tables[ind].booking!.check_in!.year.toString() +
//                                                                           " " +
//                                                                           MyServer.months[Provider.of<AllTablesPro>(cont, listen: false).tables[ind].booking!.check_in!.month] +
//                                                                           " " +
//                                                                           Provider.of<AllTablesPro>(cont, listen: false).tables[ind].booking!.check_in!.day.toString() +
//                                                                           "     " +
//                                                                           Provider.of<AllTablesPro>(cont, listen: false).tables[ind].booking!.check_in!.hour.toString() +
//                                                                           ":" +
//                                                                           Provider.of<AllTablesPro>(cont, listen: false).tables[ind].booking!.check_in!.minute.toString(),
//                                                                       style: TextStyle(
//                                                                         fontSize: RouteManager.width / 25,
//                                                                       ),
//                                                                     ),
//                                                                     SizedBox(height: RouteManager.width / 20),
//                                                                   ],
//                                                                 )
//                                                               : SizedBox(),
//                                                           Row(
//                                                             mainAxisAlignment: MainAxisAlignment.center,
//                                                             children: [
//                                                               Provider.of<AllTablesPro>(cont, listen: false).tables[ind].booking!.check_in == null
//                                                                   ? ElevatedButton(
//                                                                       style: ElevatedButton.styleFrom(
//                                                                         backgroundColor: Colors.red,
//                                                                       ),
//                                                                       onPressed: () {
//                                                                         MyServer.cancel(
//                                                                           Provider.of<AllTablesPro>(cont, listen: false).tables[ind].booking!.bookid,
//                                                                         ).then((value) {
//                                                                           if (value) {
//                                                                             ft.Fluttertoast.showToast(
//                                                                               msg: "Cancelled",
//                                                                               toastLength: ft.Toast.LENGTH_SHORT,
//                                                                             );
//                                                                             Provider.of<AllTablesPro>(cont, listen: false).tables[ind].booking = null;
//                                                                             setState(() {});
//                                                                           }
//                                                                         });
//                                                                         Navigator.of(context, rootNavigator: true).pop();
//                                                                       },
//                                                                       child: Text(
//                                                                         "Cancel Booking",
//                                                                         style: TextStyle(fontSize: RouteManager.width / 23),
//                                                                       ),
//                                                                     )
//                                                                   : ElevatedButton(
//                                                                       style: ElevatedButton.styleFrom(
//                                                                         backgroundColor: Colors.red,
//                                                                       ),
//                                                                       onPressed: () {
//                                                                         MyServer.checkOut(Provider.of<AllTablesPro>(cont, listen: false).tables[ind].booking!.bookid,
//                                                                                 Provider.of<HomePro>(context, listen: false).d!)
//                                                                             .then((value) {
//                                                                           if (value) {
//                                                                             ft.Fluttertoast.showToast(
//                                                                               msg: "Checked Out",
//                                                                               toastLength: ft.Toast.LENGTH_SHORT,
//                                                                             );
//                                                                           }
//                                                                           Navigator.of(context, rootNavigator: true).pop();
//                                                                           Provider.of<AllTablesPro>(cont, listen: false).tables[ind].booking = null;
//                                                                           setState(() {});
//                                                                         });
//                                                                         print("VALUE IS : : : : :" + Provider.of<AllTablesPro>(cont, listen: false).tables[ind].booking!.check_in.toString());
//                                                                       },
//                                                                       child: Text(
//                                                                         "Check Out",
//                                                                         style: TextStyle(fontSize: RouteManager.width / 23),
//                                                                       ),
//                                                                     ),
//                                                               Provider.of<AllTablesPro>(cont, listen: false).tables[ind].booking!.check_in == null &&
//                                                                       Provider.of<HomePro>(context).d!.year.toString() +
//                                                                               "-" +
//                                                                               Provider.of<HomePro>(context).d!.month.toString() +
//                                                                               "-" +
//                                                                               Provider.of<HomePro>(context).d!.day.toString() ==
//                                                                           todaydate.year.toString() + "-" + todaydate.month.toString() + "-" + todaydate.day.toString()
//                                                                   ? Row(
//                                                                       children: [
//                                                                         SizedBox(
//                                                                           width: RouteManager.width / 50,
//                                                                         ),
//                                                                         ElevatedButton(
//                                                                           style: ElevatedButton.styleFrom(
//                                                                             backgroundColor: Colors.green,
//                                                                           ),
//                                                                           onPressed: () {
//                                                                             MyServer.checkIn(Provider.of<AllTablesPro>(cont, listen: false).tables[ind].booking!.bookid, todaydate).then((value) {
//                                                                               if (value) {
//                                                                                 ft.Fluttertoast.showToast(
//                                                                                   msg: "Checked In",
//                                                                                   toastLength: ft.Toast.LENGTH_SHORT,
//                                                                                 );
//                                                                               }
//                                                                               Navigator.of(context, rootNavigator: true).pop();
//                                                                               Provider.of<AllTablesPro>(cont, listen: false).tables[ind].booking!.check_in = todaydate;
//                                                                               setState(() {});
//                                                                             });
//                                                                             print("VALUE IS : : : : :" + Provider.of<AllTablesPro>(cont, listen: false).tables[ind].booking!.check_in.toString());
//                                                                           },
//                                                                           child: Text(
//                                                                             "Check In",
//                                                                             style: TextStyle(fontSize: RouteManager.width / 23),
//                                                                           ),
//                                                                         ),
//                                                                       ],
//                                                                     )
//                                                                   : SizedBox(),
//                                                             ],
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   );
//                                                 });
//                                             return;
//                                           }
//                                           if (Provider.of<AllTablesPro>(cont, listen: false).isbooking) {
//                                             showDialog(
//                                                 context: cont,
//                                                 builder: (cont) {
//                                                   return AlertDialog(
//                                                     title: Center(
//                                                       child: Text(
//                                                         "New Booking",
//                                                         style: TextStyle(
//                                                           fontSize: RouteManager.width / 20,
//                                                           color: const Color.fromARGB(255, 243, 110, 100),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     content: SingleChildScrollView(
//                                                       child: Container(
//                                                         width: RouteManager.width,
//                                                         // height: RouteManager.height / 1.675,
//                                                         child: Column(children: [
//                                                           Row(
//                                                             mainAxisAlignment: MainAxisAlignment.center,
//                                                             children: [
//                                                               Text(
//                                                                 "Area : ",
//                                                                 style: TextStyle(
//                                                                   fontSize: RouteManager.width / 20,
//                                                                   fontWeight: FontWeight.bold,
//                                                                 ),
//                                                               ),
//                                                               Text(
//                                                                 Provider.of<AllTablesPro>(cont, listen: false).areaname,
//                                                                 style: TextStyle(
//                                                                   fontSize: RouteManager.width / 20,
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                           SizedBox(
//                                                             height: RouteManager.width / 32,
//                                                           ),
//                                                           Row(
//                                                             mainAxisAlignment: MainAxisAlignment.center,
//                                                             children: [
//                                                               Text(
//                                                                 "Table : ",
//                                                                 style: TextStyle(
//                                                                   fontSize: RouteManager.width / 20,
//                                                                   fontWeight: FontWeight.bold,
//                                                                 ),
//                                                               ),
//                                                               Text(
//                                                                 Provider.of<AllTablesPro>(cont, listen: false).tables[ind].tablename,
//                                                                 style: TextStyle(
//                                                                   fontSize: RouteManager.width / 20,
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                           SizedBox(
//                                                             height: RouteManager.width / 32,
//                                                           ),
//                                                           Row(
//                                                             mainAxisAlignment: MainAxisAlignment.center,
//                                                             children: [
//                                                               Text(
//                                                                 "Date : ",
//                                                                 style: TextStyle(
//                                                                   fontSize: RouteManager.width / 20,
//                                                                   fontWeight: FontWeight.bold,
//                                                                 ),
//                                                               ),
//                                                               Text(
//                                                                 Provider.of<HomePro>(cont, listen: false).d!.day.toString() +
//                                                                     " " +
//                                                                     MyServer.months[Provider.of<HomePro>(cont, listen: false).d!.month].toString() +
//                                                                     " " +
//                                                                     Provider.of<HomePro>(cont, listen: false).d!.year.toString(),
//                                                                 style: TextStyle(
//                                                                   fontSize: RouteManager.width / 20,
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                           SizedBox(
//                                                             height: RouteManager.width / 32,
//                                                           ),
//                                                           Row(
//                                                             mainAxisAlignment: MainAxisAlignment.center,
//                                                             children: [
//                                                               Text(
//                                                                 "Day : ",
//                                                                 style: TextStyle(
//                                                                   fontSize: RouteManager.width / 20,
//                                                                   fontWeight: FontWeight.bold,
//                                                                 ),
//                                                               ),
//                                                               Text(
//                                                                 DateFormat('EEEE').format(Provider.of<HomePro>(cont, listen: false).d!),
//                                                                 // Provider.of<HomePro>(context, listen: false).d!.year.toString() +
//                                                                 //     "-" +
//                                                                 //     Provider.of<HomePro>(context, listen: false).d!.month.toString() +
//                                                                 //     "-" +
//                                                                 //     Provider.of<HomePro>(context, listen: false).d!.day.toString(),
//                                                                 style: TextStyle(
//                                                                   fontSize: RouteManager.width / 20,
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                           SizedBox(
//                                                             height: RouteManager.width / 32,
//                                                           ),
//                                                           TextField(
//                                                             controller: custname,
//                                                             decoration: InputDecoration(
//                                                               enabledBorder: const OutlineInputBorder(
//                                                                 borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                                                                 borderSide: BorderSide(
//                                                                   color: Color.fromARGB(255, 243, 110, 100),
//                                                                 ),
//                                                               ),
//                                                               focusedBorder: const OutlineInputBorder(
//                                                                 borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                                                                 borderSide: BorderSide(
//                                                                   color: Color.fromARGB(255, 243, 110, 100),
//                                                                 ),
//                                                               ),
//                                                               disabledBorder: const OutlineInputBorder(
//                                                                 borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                                                                 borderSide: BorderSide(
//                                                                   color: Color.fromARGB(255, 243, 110, 100),
//                                                                 ),
//                                                               ),
//                                                               fillColor: Colors.white,
//                                                               filled: true,
//                                                               floatingLabelBehavior: FloatingLabelBehavior.auto,
//                                                               labelText: "Name",
//                                                               labelStyle: TextStyle(
//                                                                 fontWeight: FontWeight.bold,
//                                                                 fontSize: RouteManager.width / 23,
//                                                                 color: const Color.fromARGB(255, 243, 110, 100),
//                                                               ),
//                                                               hintText: "Enter Customer's Name",
//                                                               hintStyle: TextStyle(
//                                                                 fontSize: RouteManager.width / 24,
//                                                               ),
//                                                             ),
//                                                           ),
//                                                           SizedBox(height: RouteManager.width / 23),
//                                                           TextField(
//                                                             controller: custemail,
//                                                             decoration: InputDecoration(
//                                                               enabledBorder: const OutlineInputBorder(
//                                                                 borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                                                                 borderSide: BorderSide(
//                                                                   color: Color.fromARGB(255, 243, 110, 100),
//                                                                 ),
//                                                               ),
//                                                               focusedBorder: const OutlineInputBorder(
//                                                                 borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                                                                 borderSide: BorderSide(
//                                                                   color: Color.fromARGB(255, 243, 110, 100),
//                                                                 ),
//                                                               ),
//                                                               disabledBorder: const OutlineInputBorder(
//                                                                 borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                                                                 borderSide: BorderSide(
//                                                                   color: Color.fromARGB(255, 243, 110, 100),
//                                                                 ),
//                                                               ),
//                                                               fillColor: Colors.white,
//                                                               filled: true,
//                                                               floatingLabelBehavior: FloatingLabelBehavior.auto,
//                                                               labelText: "Email",
//                                                               labelStyle: TextStyle(
//                                                                 fontWeight: FontWeight.bold,
//                                                                 fontSize: RouteManager.width / 23,
//                                                                 color: const Color.fromARGB(255, 243, 110, 100),
//                                                               ),
//                                                               hintText: "Enter Customer's Email",
//                                                               hintStyle: TextStyle(
//                                                                 fontSize: RouteManager.width / 24,
//                                                               ),
//                                                             ),
//                                                           ),
//                                                           SizedBox(height: RouteManager.width / 23),
//                                                           TextField(
//                                                             controller: custphn,
//                                                             keyboardType: TextInputType.phone,
//                                                             decoration: InputDecoration(
//                                                               enabledBorder: const OutlineInputBorder(
//                                                                 borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                                                                 borderSide: BorderSide(
//                                                                   color: Color.fromARGB(255, 243, 110, 100),
//                                                                 ),
//                                                               ),
//                                                               focusedBorder: const OutlineInputBorder(
//                                                                 borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                                                                 borderSide: BorderSide(
//                                                                   color: Color.fromARGB(255, 243, 110, 100),
//                                                                 ),
//                                                               ),
//                                                               disabledBorder: const OutlineInputBorder(
//                                                                 borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                                                                 borderSide: BorderSide(
//                                                                   color: Color.fromARGB(255, 243, 110, 100),
//                                                                 ),
//                                                               ),
//                                                               fillColor: Colors.white,
//                                                               filled: true,
//                                                               floatingLabelBehavior: FloatingLabelBehavior.auto,
//                                                               labelText: "Phn No.",
//                                                               labelStyle: TextStyle(
//                                                                 fontWeight: FontWeight.bold,
//                                                                 fontSize: RouteManager.width / 23,
//                                                                 color: const Color.fromARGB(255, 243, 110, 100),
//                                                               ),
//                                                               hintText: "Enter Customer's Phn.No",
//                                                               hintStyle: TextStyle(
//                                                                 fontSize: RouteManager.width / 24,
//                                                               ),
//                                                             ),
//                                                           ),
//                                                           SizedBox(height: RouteManager.width / 23),
//                                                           TextField(
//                                                             controller: ttlpersons,
//                                                             keyboardType: TextInputType.phone,
//                                                             decoration: InputDecoration(
//                                                               enabledBorder: const OutlineInputBorder(
//                                                                 borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                                                                 borderSide: BorderSide(
//                                                                   color: Color.fromARGB(255, 243, 110, 100),
//                                                                 ),
//                                                               ),
//                                                               focusedBorder: const OutlineInputBorder(
//                                                                 borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                                                                 borderSide: BorderSide(
//                                                                   color: Color.fromARGB(255, 243, 110, 100),
//                                                                 ),
//                                                               ),
//                                                               disabledBorder: const OutlineInputBorder(
//                                                                 borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                                                                 borderSide: BorderSide(
//                                                                   color: Color.fromARGB(255, 243, 110, 100),
//                                                                 ),
//                                                               ),
//                                                               fillColor: Colors.white,
//                                                               filled: true,
//                                                               floatingLabelBehavior: FloatingLabelBehavior.auto,
//                                                               labelText: "Persons",
//                                                               labelStyle: TextStyle(
//                                                                 fontWeight: FontWeight.bold,
//                                                                 fontSize: RouteManager.width / 23,
//                                                                 color: const Color.fromARGB(255, 243, 110, 100),
//                                                               ),
//                                                               hintText: "Enter Total Persons",
//                                                               hintStyle: TextStyle(
//                                                                 fontSize: RouteManager.width / 24,
//                                                               ),
//                                                             ),
//                                                           ),
//                                                           SizedBox(height: RouteManager.width / 23),
//                                                           TextField(
//                                                             controller: ttladvance,
//                                                             keyboardType: TextInputType.phone,
//                                                             decoration: InputDecoration(
//                                                               enabledBorder: const OutlineInputBorder(
//                                                                 borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                                                                 borderSide: BorderSide(
//                                                                   color: Color.fromARGB(255, 243, 110, 100),
//                                                                 ),
//                                                               ),
//                                                               focusedBorder: const OutlineInputBorder(
//                                                                 borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                                                                 borderSide: BorderSide(
//                                                                   color: Color.fromARGB(255, 243, 110, 100),
//                                                                 ),
//                                                               ),
//                                                               disabledBorder: const OutlineInputBorder(
//                                                                 borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                                                                 borderSide: BorderSide(
//                                                                   color: Color.fromARGB(255, 243, 110, 100),
//                                                                 ),
//                                                               ),
//                                                               floatingLabelBehavior: FloatingLabelBehavior.auto,
//                                                               labelText: "Advance",
//                                                               labelStyle: TextStyle(
//                                                                 fontWeight: FontWeight.bold,
//                                                                 fontSize: RouteManager.width / 23,
//                                                                 color: const Color.fromARGB(255, 243, 110, 100),
//                                                               ),
//                                                               fillColor: Colors.white,
//                                                               filled: true,
//                                                               hintText: "Enter Total Advance",
//                                                               hintStyle: TextStyle(
//                                                                 fontSize: RouteManager.width / 24,
//                                                               ),
//                                                             ),
//                                                           ),
//                                                           SizedBox(height: RouteManager.width / 23),
//                                                           ElevatedButton(
//                                                               style: ElevatedButton.styleFrom(
//                                                                 backgroundColor: const Color.fromARGB(255, 243, 110, 100),
//                                                               ),
//                                                               onPressed: () {
//                                                                 if (custname.text.isEmpty || custemail.text.isEmpty || custphn.text.isEmpty || ttlpersons.text.isEmpty || ttladvance.text.isEmpty) {
//                                                                   ft.Fluttertoast.showToast(
//                                                                     msg: "Please fill all fields",
//                                                                     toastLength: ft.Toast.LENGTH_SHORT,
//                                                                   );
//                                                                   return;
//                                                                 }
//                                                                 MyServer.addBooking(
//                                                                   Provider.of<AllTablesPro>(cont, listen: false).areaid,
//                                                                   Provider.of<AllTablesPro>(cont, listen: false).tables[ind].tableid,
//                                                                   Provider.of<HomePro>(cont, listen: false).d!,
//                                                                   custname.text,
//                                                                   custemail.text,
//                                                                   custphn.text,
//                                                                   int.parse(ttlpersons.text),
//                                                                   int.parse(ttladvance.text),
//                                                                   context,
//                                                                 ).then((value) {
//                                                                   setState(() {});
//                                                                   if (value) {
//                                                                     ft.Fluttertoast.showToast(
//                                                                       msg: "Table Booked",
//                                                                       toastLength: ft.Toast.LENGTH_SHORT,
//                                                                     );
//                                                                     Provider.of<AllTablesPro>(context, listen: false).notifyListenerz();
//                                                                     Navigator.of(context, rootNavigator: true).pop();
//                                                                   } else {
//                                                                     ft.Fluttertoast.showToast(
//                                                                       msg: "Failed",
//                                                                       toastLength: ft.Toast.LENGTH_SHORT,
//                                                                     );
//                                                                   }
//                                                                 });
//                                                               },
//                                                               child: Text(
//                                                                 "Confirm",
//                                                                 style: TextStyle(fontSize: RouteManager.width / 20),
//                                                               ))
//                                                         ]),
//                                                       ),
//                                                     ),
//                                                   );
//                                                 }).then((value) {
//                                               custname.text = "";
//                                               custemail.text = "";
//                                               custphn.text = "";
//                                               ttlpersons.text = "";
//                                               ttladvance.text = "";
//                                             });
//                                           }
//                                         },
//                                         child: Container(
//                                           color: const Color.fromARGB(255, 228, 228, 228),
//                                           width: RouteManager.width / 2.8,
//                                           height: RouteManager.width / 2.8,
//                                           child: Stack(
//                                             fit: StackFit.expand,
//                                             children: [
//                                               Center(
//                                                 child: Column(
//                                                   mainAxisAlignment: MainAxisAlignment.center,
//                                                   children: [
//                                                     SizedBox(
//                                                       // width:RouteManager.width/,
//                                                       height: RouteManager.width / 4.5,
//                                                       child: Image.asset("images/table.png"),
//                                                     ),
//                                                     Text(
//                                                       // "BOOKED",
//                                                       Provider.of<AllTablesPro>(context, listen: false).tables[ind].tablename,
//                                                       maxLines: 2,
//                                                       style: TextStyle(
//                                                         // fontFamily: "MyFonts",
//                                                         fontWeight: FontWeight.bold,
//                                                         fontSize: RouteManager.width / 20,
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                               Provider.of<AllTablesPro>(context, listen: false).tables[ind].booking != null
//                                                   ? Container(
//                                                       child: Column(
//                                                         children: [
//                                                           SizedBox(
//                                                             height: RouteManager.width / 12,
//                                                           ),
//                                                           Transform.rotate(
//                                                             angle: 18.2,
//                                                             child: Container(
//                                                               padding: EdgeInsets.all(
//                                                                 RouteManager.width / 80,
//                                                               ),
//                                                               color: Provider.of<AllTablesPro>(context, listen: false).tables[ind].booking!.check_in == null ? Colors.red : Colors.green,
//                                                               child: Text(
//                                                                 Provider.of<AllTablesPro>(context, listen: false).tables[ind].booking!.check_in == null ? "Booked" : "Checked In",
//                                                                 style: TextStyle(
//                                                                     color: Colors.white,
//                                                                     fontSize: Provider.of<AllTablesPro>(context, listen: false).tables[ind].booking!.check_in == null
//                                                                         ? RouteManager.width / 15
//                                                                         : RouteManager.width / 17),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     )
//                                                   : const SizedBox(),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: RouteManager.width / 15,
//                                       ),
//                                       ind + 1 != Provider.of<AllTablesPro>(context, listen: false).tables.length
//                                           ? InkWell(
//                                               onTap: () {
//                                                 if (Provider.of<AllTablesPro>(cont, listen: false).tables[ind + 1].booking != null) {
//                                                   showDialog(
//                                                       context: cont,
//                                                       builder: (cont) {
//                                                         DateTime todaydate = DateTime.now();
//                                                         return AlertDialog(
//                                                           title: Center(
//                                                             child: Text(
//                                                               "Booking Details",
//                                                               style: TextStyle(
//                                                                 fontSize: RouteManager.width / 20,
//                                                                 color: Colors.red,
//                                                               ),
//                                                             ),
//                                                           ),
//                                                           content: Container(
//                                                             width: RouteManager.width,
//                                                             height: RouteManager.height / 1.5,
//                                                             child: Column(
//                                                               children: [
//                                                                 SizedBox(height: RouteManager.width / 12),
//                                                                 Text(
//                                                                   "Customer Name",
//                                                                   style: TextStyle(
//                                                                     fontSize: RouteManager.width / 23,
//                                                                     fontWeight: FontWeight.bold,
//                                                                   ),
//                                                                 ),
//                                                                 SizedBox(height: RouteManager.width / 50),
//                                                                 Text(
//                                                                   Provider.of<AllTablesPro>(cont, listen: false).tables[ind + 1].booking!.name,
//                                                                   style: TextStyle(
//                                                                     fontSize: RouteManager.width / 25,
//                                                                   ),
//                                                                 ),
//                                                                 SizedBox(height: RouteManager.width / 20),
//                                                                 Text(
//                                                                   "Customer Email",
//                                                                   style: TextStyle(
//                                                                     fontSize: RouteManager.width / 23,
//                                                                     fontWeight: FontWeight.bold,
//                                                                   ),
//                                                                 ),
//                                                                 SizedBox(height: RouteManager.width / 50),
//                                                                 Text(
//                                                                   Provider.of<AllTablesPro>(cont, listen: false).tables[ind + 1].booking!.email,
//                                                                   style: TextStyle(
//                                                                     fontSize: RouteManager.width / 25,
//                                                                   ),
//                                                                 ),
//                                                                 SizedBox(height: RouteManager.width / 20),
//                                                                 Text(
//                                                                   "Customer Phn",
//                                                                   style: TextStyle(
//                                                                     fontSize: RouteManager.width / 23,
//                                                                     fontWeight: FontWeight.bold,
//                                                                   ),
//                                                                 ),
//                                                                 SizedBox(height: RouteManager.width / 50),
//                                                                 Text(
//                                                                   Provider.of<AllTablesPro>(cont, listen: false).tables[ind + 1].booking!.phn,
//                                                                   style: TextStyle(
//                                                                     fontSize: RouteManager.width / 25,
//                                                                   ),
//                                                                 ),
//                                                                 SizedBox(height: RouteManager.width / 20),
//                                                                 Text(
//                                                                   "Booked On",
//                                                                   style: TextStyle(
//                                                                     fontSize: RouteManager.width / 23,
//                                                                     fontWeight: FontWeight.bold,
//                                                                   ),
//                                                                 ),
//                                                                 SizedBox(height: RouteManager.width / 50),
//                                                                 Text(
//                                                                   Provider.of<AllTablesPro>(cont, listen: false).tables[ind + 1].booking!.booked_on.day.toString() +
//                                                                       " " +
//                                                                       MyServer.months[Provider.of<AllTablesPro>(cont, listen: false).tables[ind + 1].booking!.booked_on.month] +
//                                                                       " " +
//                                                                       Provider.of<AllTablesPro>(cont, listen: false).tables[ind + 1].booking!.booked_on.year.toString(),
//                                                                   style: TextStyle(
//                                                                     fontSize: RouteManager.width / 25,
//                                                                   ),
//                                                                 ),
//                                                                 SizedBox(height: RouteManager.width / 20),
//                                                                 Text(
//                                                                   "Total Persons",
//                                                                   style: TextStyle(
//                                                                     fontSize: RouteManager.width / 23,
//                                                                     fontWeight: FontWeight.bold,
//                                                                   ),
//                                                                 ),
//                                                                 SizedBox(height: RouteManager.width / 50),
//                                                                 Text(
//                                                                   Provider.of<AllTablesPro>(cont, listen: false).tables[ind + 1].booking!.ttlpersons.toString(),
//                                                                   style: TextStyle(
//                                                                     fontSize: RouteManager.width / 25,
//                                                                   ),
//                                                                 ),
//                                                                 SizedBox(height: RouteManager.width / 20),
//                                                                 Text(
//                                                                   "Advance",
//                                                                   style: TextStyle(
//                                                                     fontSize: RouteManager.width / 23,
//                                                                     fontWeight: FontWeight.bold,
//                                                                   ),
//                                                                 ),
//                                                                 SizedBox(height: RouteManager.width / 50),
//                                                                 Text(
//                                                                   Provider.of<AllTablesPro>(cont, listen: false).tables[ind + 1].booking!.advance.toString(),
//                                                                   style: TextStyle(
//                                                                     fontSize: RouteManager.width / 25,
//                                                                   ),
//                                                                 ),
//                                                                 SizedBox(height: RouteManager.width / 20),
//                                                                 Provider.of<AllTablesPro>(cont, listen: false).tables[ind + 1].booking!.check_in != null
//                                                                     ? Column(
//                                                                         children: [
//                                                                           Text(
//                                                                             "Check In Time",
//                                                                             style: TextStyle(
//                                                                               fontSize: RouteManager.width / 23,
//                                                                               fontWeight: FontWeight.bold,
//                                                                             ),
//                                                                           ),
//                                                                           SizedBox(height: RouteManager.width / 50),
//                                                                           Text(
//                                                                             Provider.of<AllTablesPro>(cont, listen: false).tables[ind + 1].booking!.check_in!.year.toString() +
//                                                                                 " " +
//                                                                                 MyServer.months[Provider.of<AllTablesPro>(cont, listen: false).tables[ind].booking!.check_in!.month] +
//                                                                                 " " +
//                                                                                 Provider.of<AllTablesPro>(cont, listen: false).tables[ind].booking!.check_in!.day.toString() +
//                                                                                 "     " +
//                                                                                 Provider.of<AllTablesPro>(cont, listen: false).tables[ind].booking!.check_in!.hour.toString() +
//                                                                                 ":" +
//                                                                                 Provider.of<AllTablesPro>(cont, listen: false).tables[ind].booking!.check_in!.minute.toString(),
//                                                                             style: TextStyle(
//                                                                               fontSize: RouteManager.width / 25,
//                                                                             ),
//                                                                           ),
//                                                                           SizedBox(height: RouteManager.width / 20),
//                                                                         ],
//                                                                       )
//                                                                     : SizedBox(),
//                                                                 Row(
//                                                                   mainAxisAlignment: MainAxisAlignment.center,
//                                                                   children: [
//                                                                     Provider.of<AllTablesPro>(cont, listen: false).tables[ind + 1].booking!.check_in == null
//                                                                         ? ElevatedButton(
//                                                                             style: ElevatedButton.styleFrom(
//                                                                               backgroundColor: Colors.red,
//                                                                             ),
//                                                                             onPressed: () {
//                                                                               MyServer.cancel(
//                                                                                 Provider.of<AllTablesPro>(cont, listen: false).tables[ind + 1].booking!.bookid,
//                                                                               ).then((value) {
//                                                                                 if (value) {
//                                                                                   ft.Fluttertoast.showToast(
//                                                                                     msg: "Cancelled",
//                                                                                     toastLength: ft.Toast.LENGTH_SHORT,
//                                                                                   );
//                                                                                   Provider.of<AllTablesPro>(cont, listen: false).tables[ind + 1].booking = null;
//                                                                                   setState(() {});
//                                                                                 }
//                                                                               });
//                                                                               Navigator.of(context, rootNavigator: true).pop();
//                                                                             },
//                                                                             child: Text(
//                                                                               "Cancel Booking",
//                                                                               style: TextStyle(fontSize: RouteManager.width / 23),
//                                                                             ),
//                                                                           )
//                                                                         : ElevatedButton(
//                                                                             style: ElevatedButton.styleFrom(
//                                                                               backgroundColor: Colors.red,
//                                                                             ),
//                                                                             onPressed: () {
//                                                                               MyServer.checkOut(Provider.of<AllTablesPro>(cont, listen: false).tables[ind + 1].booking!.bookid,
//                                                                                       Provider.of<HomePro>(context, listen: false).d!)
//                                                                                   .then((value) {
//                                                                                 if (value) {
//                                                                                   ft.Fluttertoast.showToast(
//                                                                                     msg: "Checked Out",
//                                                                                     toastLength: ft.Toast.LENGTH_SHORT,
//                                                                                   );
//                                                                                 }
//                                                                                 Navigator.of(context, rootNavigator: true).pop();
//                                                                                 Provider.of<AllTablesPro>(cont, listen: false).tables[ind + 1].booking = null;
//                                                                                 setState(() {});
//                                                                               });
//                                                                               print("VALUE IS : : : : :" + Provider.of<AllTablesPro>(cont, listen: false).tables[ind + 1].booking!.check_in.toString());
//                                                                             },
//                                                                             child: Text(
//                                                                               "Check Out",
//                                                                               style: TextStyle(fontSize: RouteManager.width / 23),
//                                                                             ),
//                                                                           ),
//                                                                     Provider.of<AllTablesPro>(cont, listen: false).tables[ind + 1].booking!.check_in == null &&
//                                                                             Provider.of<HomePro>(context).d!.year.toString() +
//                                                                                     "-" +
//                                                                                     Provider.of<HomePro>(context).d!.month.toString() +
//                                                                                     "-" +
//                                                                                     Provider.of<HomePro>(context).d!.day.toString() ==
//                                                                                 todaydate.year.toString() + "-" + todaydate.month.toString() + "-" + todaydate.day.toString()
//                                                                         ? Row(
//                                                                             children: [
//                                                                               SizedBox(
//                                                                                 width: RouteManager.width / 50,
//                                                                               ),
//                                                                               ElevatedButton(
//                                                                                 style: ElevatedButton.styleFrom(
//                                                                                   backgroundColor: Colors.green,
//                                                                                 ),
//                                                                                 onPressed: () {
//                                                                                   MyServer.checkIn(Provider.of<AllTablesPro>(cont, listen: false).tables[ind + 1].booking!.bookid,
//                                                                                           Provider.of<HomePro>(context, listen: false).d!)
//                                                                                       .then((value) {
//                                                                                     if (value) {
//                                                                                       ft.Fluttertoast.showToast(
//                                                                                         msg: "Checked In",
//                                                                                         toastLength: ft.Toast.LENGTH_SHORT,
//                                                                                       );
//                                                                                     }
//                                                                                     Navigator.of(context, rootNavigator: true).pop();
//                                                                                     Provider.of<AllTablesPro>(cont, listen: false).tables[ind + 1].booking!.check_in = todaydate;
//                                                                                     setState(() {});
//                                                                                   });
//                                                                                   print("VALUE IS : : : : :" +
//                                                                                       Provider.of<AllTablesPro>(cont, listen: false).tables[ind + 1].booking!.check_in.toString());
//                                                                                 },
//                                                                                 child: Text(
//                                                                                   "Check In",
//                                                                                   style: TextStyle(fontSize: RouteManager.width / 23),
//                                                                                 ),
//                                                                               ),
//                                                                             ],
//                                                                           )
//                                                                         : SizedBox(),
//                                                                   ],
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                           ),
//                                                         );
//                                                       });
//                                                   return;
//                                                 }
//                                                 if (Provider.of<AllTablesPro>(cont, listen: false).isbooking) {
//                                                   showDialog(
//                                                       context: cont,
//                                                       builder: (cont) {
//                                                         return AlertDialog(
//                                                           title: Center(
//                                                             child: Text(
//                                                               "New Booking",
//                                                               style: TextStyle(
//                                                                 fontSize: RouteManager.width / 20,
//                                                                 color: const Color.fromARGB(255, 243, 110, 100),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                           content: SingleChildScrollView(
//                                                             child: Container(
//                                                               width: RouteManager.width,
//                                                               // height: RouteManager.height / 1.675,
//                                                               child: Column(children: [
//                                                                 Row(
//                                                                   mainAxisAlignment: MainAxisAlignment.center,
//                                                                   children: [
//                                                                     Text(
//                                                                       "Area : ",
//                                                                       style: TextStyle(
//                                                                         fontSize: RouteManager.width / 20,
//                                                                         fontWeight: FontWeight.bold,
//                                                                       ),
//                                                                     ),
//                                                                     Text(
//                                                                       Provider.of<AllTablesPro>(cont, listen: false).areaname,
//                                                                       style: TextStyle(
//                                                                         fontSize: RouteManager.width / 20,
//                                                                       ),
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                                 SizedBox(
//                                                                   height: RouteManager.width / 32,
//                                                                 ),
//                                                                 Row(
//                                                                   mainAxisAlignment: MainAxisAlignment.center,
//                                                                   children: [
//                                                                     Text(
//                                                                       "Table : ",
//                                                                       style: TextStyle(
//                                                                         fontSize: RouteManager.width / 20,
//                                                                         fontWeight: FontWeight.bold,
//                                                                       ),
//                                                                     ),
//                                                                     Text(
//                                                                       Provider.of<AllTablesPro>(cont, listen: false).tables[ind + 1].tablename,
//                                                                       style: TextStyle(
//                                                                         fontSize: RouteManager.width / 20,
//                                                                       ),
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                                 SizedBox(
//                                                                   height: RouteManager.width / 32,
//                                                                 ),
//                                                                 Row(
//                                                                   mainAxisAlignment: MainAxisAlignment.center,
//                                                                   children: [
//                                                                     Text(
//                                                                       "Date : ",
//                                                                       style: TextStyle(
//                                                                         fontSize: RouteManager.width / 20,
//                                                                         fontWeight: FontWeight.bold,
//                                                                       ),
//                                                                     ),
//                                                                     Text(
//                                                                       Provider.of<HomePro>(cont, listen: false).d!.day.toString() +
//                                                                           " " +
//                                                                           MyServer.months[Provider.of<HomePro>(cont, listen: false).d!.month].toString() +
//                                                                           " " +
//                                                                           Provider.of<HomePro>(cont, listen: false).d!.year.toString(),
//                                                                       style: TextStyle(
//                                                                         fontSize: RouteManager.width / 20,
//                                                                       ),
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                                 SizedBox(
//                                                                   height: RouteManager.width / 32,
//                                                                 ),
//                                                                 Row(
//                                                                   mainAxisAlignment: MainAxisAlignment.center,
//                                                                   children: [
//                                                                     Text(
//                                                                       "Day : ",
//                                                                       style: TextStyle(
//                                                                         fontSize: RouteManager.width / 20,
//                                                                         fontWeight: FontWeight.bold,
//                                                                       ),
//                                                                     ),
//                                                                     Text(
//                                                                       DateFormat('EEEE').format(Provider.of<HomePro>(cont, listen: false).d!),
//                                                                       // Provider.of<HomePro>(context, listen: false).d!.year.toString() +
//                                                                       //     "-" +
//                                                                       //     Provider.of<HomePro>(context, listen: false).d!.month.toString() +
//                                                                       //     "-" +
//                                                                       //     Provider.of<HomePro>(context, listen: false).d!.day.toString(),
//                                                                       style: TextStyle(
//                                                                         fontSize: RouteManager.width / 20,
//                                                                       ),
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                                 SizedBox(
//                                                                   height: RouteManager.width / 32,
//                                                                 ),
//                                                                 TextField(
//                                                                   controller: custname,
//                                                                   decoration: InputDecoration(
//                                                                     enabledBorder: const OutlineInputBorder(
//                                                                       borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                                                                       borderSide: BorderSide(
//                                                                         color: Color.fromARGB(255, 243, 110, 100),
//                                                                       ),
//                                                                     ),
//                                                                     focusedBorder: const OutlineInputBorder(
//                                                                       borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                                                                       borderSide: BorderSide(
//                                                                         color: Color.fromARGB(255, 243, 110, 100),
//                                                                       ),
//                                                                     ),
//                                                                     disabledBorder: const OutlineInputBorder(
//                                                                       borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                                                                       borderSide: BorderSide(
//                                                                         color: Color.fromARGB(255, 243, 110, 100),
//                                                                       ),
//                                                                     ),
//                                                                     fillColor: Colors.white,
//                                                                     filled: true,
//                                                                     floatingLabelBehavior: FloatingLabelBehavior.auto,
//                                                                     labelText: "Name",
//                                                                     labelStyle: TextStyle(
//                                                                       fontWeight: FontWeight.bold,
//                                                                       fontSize: RouteManager.width / 23,
//                                                                       color: const Color.fromARGB(255, 243, 110, 100),
//                                                                     ),
//                                                                     hintText: "Enter Customer's Name",
//                                                                     hintStyle: TextStyle(
//                                                                       fontSize: RouteManager.width / 24,
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                                 SizedBox(height: RouteManager.width / 23),
//                                                                 TextField(
//                                                                   controller: custemail,
//                                                                   decoration: InputDecoration(
//                                                                     enabledBorder: const OutlineInputBorder(
//                                                                       borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                                                                       borderSide: BorderSide(
//                                                                         color: Color.fromARGB(255, 243, 110, 100),
//                                                                       ),
//                                                                     ),
//                                                                     focusedBorder: const OutlineInputBorder(
//                                                                       borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                                                                       borderSide: BorderSide(
//                                                                         color: Color.fromARGB(255, 243, 110, 100),
//                                                                       ),
//                                                                     ),
//                                                                     disabledBorder: const OutlineInputBorder(
//                                                                       borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                                                                       borderSide: BorderSide(
//                                                                         color: Color.fromARGB(255, 243, 110, 100),
//                                                                       ),
//                                                                     ),
//                                                                     fillColor: Colors.white,
//                                                                     filled: true,
//                                                                     floatingLabelBehavior: FloatingLabelBehavior.auto,
//                                                                     labelText: "Email",
//                                                                     labelStyle: TextStyle(
//                                                                       fontWeight: FontWeight.bold,
//                                                                       fontSize: RouteManager.width / 23,
//                                                                       color: const Color.fromARGB(255, 243, 110, 100),
//                                                                     ),
//                                                                     hintText: "Enter Customer's Email",
//                                                                     hintStyle: TextStyle(
//                                                                       fontSize: RouteManager.width / 24,
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                                 SizedBox(height: RouteManager.width / 23),
//                                                                 TextField(
//                                                                   controller: custphn,
//                                                                   keyboardType: TextInputType.phone,
//                                                                   decoration: InputDecoration(
//                                                                     enabledBorder: const OutlineInputBorder(
//                                                                       borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                                                                       borderSide: BorderSide(
//                                                                         color: Color.fromARGB(255, 243, 110, 100),
//                                                                       ),
//                                                                     ),
//                                                                     focusedBorder: const OutlineInputBorder(
//                                                                       borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                                                                       borderSide: BorderSide(
//                                                                         color: Color.fromARGB(255, 243, 110, 100),
//                                                                       ),
//                                                                     ),
//                                                                     disabledBorder: const OutlineInputBorder(
//                                                                       borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                                                                       borderSide: BorderSide(
//                                                                         color: Color.fromARGB(255, 243, 110, 100),
//                                                                       ),
//                                                                     ),
//                                                                     fillColor: Colors.white,
//                                                                     filled: true,
//                                                                     floatingLabelBehavior: FloatingLabelBehavior.auto,
//                                                                     labelText: "Phn No.",
//                                                                     labelStyle: TextStyle(
//                                                                       fontWeight: FontWeight.bold,
//                                                                       fontSize: RouteManager.width / 23,
//                                                                       color: const Color.fromARGB(255, 243, 110, 100),
//                                                                     ),
//                                                                     hintText: "Enter Customer's Phn.No",
//                                                                     hintStyle: TextStyle(
//                                                                       fontSize: RouteManager.width / 24,
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                                 SizedBox(height: RouteManager.width / 23),
//                                                                 TextField(
//                                                                   controller: ttlpersons,
//                                                                   keyboardType: TextInputType.phone,
//                                                                   decoration: InputDecoration(
//                                                                     enabledBorder: const OutlineInputBorder(
//                                                                       borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                                                                       borderSide: BorderSide(
//                                                                         color: Color.fromARGB(255, 243, 110, 100),
//                                                                       ),
//                                                                     ),
//                                                                     focusedBorder: const OutlineInputBorder(
//                                                                       borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                                                                       borderSide: BorderSide(
//                                                                         color: Color.fromARGB(255, 243, 110, 100),
//                                                                       ),
//                                                                     ),
//                                                                     disabledBorder: const OutlineInputBorder(
//                                                                       borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                                                                       borderSide: BorderSide(
//                                                                         color: Color.fromARGB(255, 243, 110, 100),
//                                                                       ),
//                                                                     ),
//                                                                     fillColor: Colors.white,
//                                                                     filled: true,
//                                                                     floatingLabelBehavior: FloatingLabelBehavior.auto,
//                                                                     labelText: "Persons",
//                                                                     labelStyle: TextStyle(
//                                                                       fontWeight: FontWeight.bold,
//                                                                       fontSize: RouteManager.width / 23,
//                                                                       color: const Color.fromARGB(255, 243, 110, 100),
//                                                                     ),
//                                                                     hintText: "Enter Total Persons",
//                                                                     hintStyle: TextStyle(
//                                                                       fontSize: RouteManager.width / 24,
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                                 SizedBox(height: RouteManager.width / 23),
//                                                                 TextField(
//                                                                   controller: ttladvance,
//                                                                   keyboardType: TextInputType.phone,
//                                                                   decoration: InputDecoration(
//                                                                     enabledBorder: const OutlineInputBorder(
//                                                                       borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                                                                       borderSide: BorderSide(
//                                                                         color: Color.fromARGB(255, 243, 110, 100),
//                                                                       ),
//                                                                     ),
//                                                                     focusedBorder: const OutlineInputBorder(
//                                                                       borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                                                                       borderSide: BorderSide(
//                                                                         color: Color.fromARGB(255, 243, 110, 100),
//                                                                       ),
//                                                                     ),
//                                                                     disabledBorder: const OutlineInputBorder(
//                                                                       borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                                                                       borderSide: BorderSide(
//                                                                         color: Color.fromARGB(255, 243, 110, 100),
//                                                                       ),
//                                                                     ),
//                                                                     floatingLabelBehavior: FloatingLabelBehavior.auto,
//                                                                     labelText: "Advance",
//                                                                     labelStyle: TextStyle(
//                                                                       fontWeight: FontWeight.bold,
//                                                                       fontSize: RouteManager.width / 23,
//                                                                       color: const Color.fromARGB(255, 243, 110, 100),
//                                                                     ),
//                                                                     fillColor: Colors.white,
//                                                                     filled: true,
//                                                                     hintText: "Enter Total Advance",
//                                                                     hintStyle: TextStyle(
//                                                                       fontSize: RouteManager.width / 24,
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                                 SizedBox(height: RouteManager.width / 23),
//                                                                 ElevatedButton(
//                                                                     style: ElevatedButton.styleFrom(
//                                                                       backgroundColor: const Color.fromARGB(255, 243, 110, 100),
//                                                                     ),
//                                                                     onPressed: () {
//                                                                       if (custname.text.isEmpty ||
//                                                                           custemail.text.isEmpty ||
//                                                                           custphn.text.isEmpty ||
//                                                                           ttlpersons.text.isEmpty ||
//                                                                           ttladvance.text.isEmpty) {
//                                                                         ft.Fluttertoast.showToast(
//                                                                           msg: "Please fill all fields",
//                                                                           toastLength: ft.Toast.LENGTH_SHORT,
//                                                                         );
//                                                                         return;
//                                                                       }
//                                                                       MyServer.addBooking(
//                                                                         Provider.of<AllTablesPro>(cont, listen: false).areaid,
//                                                                         Provider.of<AllTablesPro>(cont, listen: false).tables[ind + 1].tableid,
//                                                                         Provider.of<HomePro>(cont, listen: false).d!,
//                                                                         custname.text,
//                                                                         custemail.text,
//                                                                         custphn.text,
//                                                                         int.parse(ttlpersons.text),
//                                                                         int.parse(ttladvance.text),
//                                                                         context,
//                                                                       ).then((value) {
//                                                                         setState(() {});
//                                                                         if (value) {
//                                                                           ft.Fluttertoast.showToast(
//                                                                             msg: "Table Booked",
//                                                                             toastLength: ft.Toast.LENGTH_SHORT,
//                                                                           );
//                                                                           Provider.of<AllTablesPro>(context, listen: false).notifyListenerz();
//                                                                           Navigator.of(context, rootNavigator: true).pop();
//                                                                         } else {
//                                                                           ft.Fluttertoast.showToast(
//                                                                             msg: "Failed",
//                                                                             toastLength: ft.Toast.LENGTH_SHORT,
//                                                                           );
//                                                                         }
//                                                                       });
//                                                                     },
//                                                                     child: Text(
//                                                                       "Confirm",
//                                                                       style: TextStyle(fontSize: RouteManager.width / 20),
//                                                                     ))
//                                                               ]),
//                                                             ),
//                                                           ),
//                                                         );
//                                                       }).then((value) {
//                                                     custname.text = "";
//                                                     custemail.text = "";
//                                                     custphn.text = "";
//                                                     ttlpersons.text = "";
//                                                     ttladvance.text = "";
//                                                   });
//                                                 }
//                                               },
//                                               child: Container(
//                                                 color: const Color.fromARGB(255, 228, 228, 228),
//                                                 // color: Provider.of<AllTablesPro>(context, listen: false).tables[ind + 1].customer == null ? const Color.fromARGB(255, 228, 228, 228) : Colors.red,
//                                                 width: RouteManager.width / 2.8,
//                                                 height: RouteManager.width / 2.8,
//                                                 child: Stack(
//                                                   fit: StackFit.expand,
//                                                   children: [
//                                                     Center(
//                                                       child: Column(
//                                                         mainAxisAlignment: MainAxisAlignment.center,
//                                                         children: [
//                                                           SizedBox(
//                                                             // width:RouteManager.width/,
//                                                             height: RouteManager.width / 4.5,
//                                                             child: Image.asset("images/table.png"),
//                                                           ),
//                                                           Text(
//                                                             // "BOOKED",
//                                                             Provider.of<AllTablesPro>(context, listen: false).tables[ind + 1].tablename,
//                                                             maxLines: 2,
//                                                             style: TextStyle(
//                                                               // fontFamily: "MyFonts",
//                                                               fontWeight: FontWeight.bold,
//                                                               fontSize: RouteManager.width / 20,
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                     Provider.of<AllTablesPro>(context, listen: false).tables[ind + 1].booking != null
//                                                         ? Container(
//                                                             child: Column(
//                                                               children: [
//                                                                 SizedBox(
//                                                                   height: RouteManager.width / 12,
//                                                                 ),
//                                                                 Transform.rotate(
//                                                                   angle: 18.2,
//                                                                   child: Container(
//                                                                     padding: EdgeInsets.all(
//                                                                       RouteManager.width / 80,
//                                                                     ),
//                                                                     color: Provider.of<AllTablesPro>(context, listen: false).tables[ind + 1].booking!.check_in == null ? Colors.red : Colors.green,
//                                                                     child: Text(
//                                                                       Provider.of<AllTablesPro>(context, listen: false).tables[ind + 1].booking!.check_in == null ? "Booked" : "Checked In",
//                                                                       style: TextStyle(
//                                                                           color: Colors.white,
//                                                                           fontSize: Provider.of<AllTablesPro>(context, listen: false).tables[ind + 1].booking!.check_in == null
//                                                                               ? RouteManager.width / 15
//                                                                               : RouteManager.width / 17),
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                           )
//                                                         : SizedBox()
//                                                   ],
//                                                 ),
//                                               ),
//                                             )
//                                           : SizedBox(),
//                                     ],
//                                   ),
//                                   Container(
//                                     // color: Colors.red,
//                                     height: RouteManager.width / 15,
//                                   ),
//                                 ],
//                               );
//                             }),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
