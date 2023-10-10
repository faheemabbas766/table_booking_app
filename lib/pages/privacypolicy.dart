// import 'dart:io';
// import 'package:table_booking/Api%20&%20Routes/routes.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class PrivacyPolicy extends StatefulWidget {
//   @override
//   PrivacyPolicyState createState() => PrivacyPolicyState();
// }

// class PrivacyPolicyState extends State<PrivacyPolicy> {
//   @override
//   void initState() {
//     super.initState();
//     // Enable hybrid composition.
//     // if (Platform.isAndroid) WebViewController. WebView.platform = SurfaceAndroidWebView();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(const Color(0x00000000))
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onProgress: (int progress) {
//             print("PROGRESS IS : : : : " + progress.toString());
//             // Update loading bar.
//           },
//           onPageStarted: (String url) {},
//           onPageFinished: (String url) {},
//           onWebResourceError: (WebResourceError error) {},
//           onNavigationRequest: (NavigationRequest request) {
//             if (request.url.startsWith('https://www.youtube.com/')) {
//               return NavigationDecision.prevent;
//             }
//             return NavigationDecision.navigate;
//           },
//         ),
//       )
//       ..loadRequest(Uri.parse('https://demo.app.gatocomits.com/'));

//     return SafeArea(
//       child: Scaffold(
//           body: Stack(
//         children: [
//           Container(
//             color: Colors.red,
//             width: RouteManager.width,
//             height: 200,
//           ),
//           WebViewWidget(
//             controller: controller,
//           ),
//         ],
//       )),
//     );
//   }
// }