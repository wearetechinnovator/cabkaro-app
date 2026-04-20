import 'dart:convert';

import 'package:cabkaro/widgets/Toastwidget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:cabkaro/utils/constants.dart' as constant;

class DriverGetRide extends ChangeNotifier {
  List<dynamic> availableRides = [];
  late bool isLoading;
  bool hasMoreRides = true;



  Future<void> refreshRides(BuildContext ctx) async {
    isLoading = true;
    notifyListeners();

    try {
      await getRide(ctx);
    } catch (err) {
      ToastWidget.show(
        ctx,
        message: 'An error occurred while refreshing rides: $err',
        type: ToastType.error,
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  Future<void> getRide(BuildContext ctx) async {
    isLoading = true;
    notifyListeners();

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString(constant.cabToken);
      final double? latitude = 22.591610311340272;
      final double? longitude = 88.36023587733507;

      Uri url = Uri.parse("${constant.apiUrl}/ride/nearest-rides?lat=$latitude&lng=$longitude");
      Map<String, dynamic> data = {"lat": latitude, "lng": longitude};
      var req = await http.get(
        url,
        headers: {"Content-Type": "application/json", "x-cab-token": token!},
      );
      var res = jsonDecode(req.body);
      print(res);
      if (req.statusCode != 200) {
        ToastWidget.show(ctx, message: res['err'], type: ToastType.error);
        return;
      }

      availableRides = res['rides'];
      notifyListeners();
    } catch (err) {
      ToastWidget.show(
        ctx,
        message: 'An error occurred: $err',
        type: ToastType.error,
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
