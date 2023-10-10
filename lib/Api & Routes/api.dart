import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart' as ft;
import 'package:provider/provider.dart';

import '../Providers/homepro.dart';

class API {
  static String ip = "https://manageapp.wd4webdemo.com/api/";

  static Future<bool> checkAuth(String key, BuildContext context) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(ip + "checkauth"),
    );
    request.headers.addAll({'Content-type': 'multipart/form-data'});
    request.fields.addAll({
      'auth_key': key.toString(),
    });
    var response;
    try {
      response = await request.send().timeout(const Duration(seconds: 20), onTimeout: () {
        throw "TimeOut";
      });
      var responsed = await http.Response.fromStream(response);
      if (response.statusCode == 200) {
        var res = jsonDecode(responsed.body);
        print("RESPONSE OF CHECK AUTH:::::::::::::::::::${responsed.body}");
        if (res["message"] == "Success") {
          Provider.of<HomePro>(context, listen: false).expiredate = DateTime(
            int.parse(
              res["data"]["End Date"].toString().split(' ')[0].split('-')[0],
            ),
            int.parse(
              res["data"]["End Date"].toString().split(' ')[0].split('-')[1],
            ),
            int.parse(
              res["data"]["End Date"].toString().split(' ')[0].split('-')[2],
            ),
          );

          ft.Fluttertoast.showToast(
            msg: "Verification Successful",
            toastLength: ft.Toast.LENGTH_LONG,
          );
          return true;
        }
        ft.Fluttertoast.showToast(
          msg: "Invalid Key",
          toastLength: ft.Toast.LENGTH_LONG,
        );
        return false;
      } else {
        return false;
      }
    } catch (e) {
      ft.Fluttertoast.showToast(
        msg: "Check your Internet Connection!",
        toastLength: ft.Toast.LENGTH_LONG,
      );
      return false;
    }
  }
}
