import 'dart:convert';
import 'package:cabkaro/screens/driver/driver_booked_cab_screen.dart';
import 'package:cabkaro/widgets/Toastwidget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:cabkaro/utils/constants.dart' as constant;

class DriverRideController extends ChangeNotifier {
  TextEditingController rideNegoPrice = TextEditingController();
  List<dynamic> availableRides = [];
  late bool isLoading;
  bool hasMoreRides = true;
  TimeOfDay? rideNegoTime;

  void setRideNegoTime(TimeOfDay? time) {
    rideNegoTime = time;
    notifyListeners();
  }

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
      final double latitude = 22.591610311340272;
      final double longitude = 88.36023587733507;

      Uri url = Uri.parse(
        "${constant.apiUrl}/ride/nearest-rides?lat=$latitude&lng=$longitude",
      );
      var req = await http.get(
        url,
        headers: {"Content-Type": "application/json", "x-cab-token": token!},
      );
      var res = jsonDecode(req.body);
      if (req.statusCode != 200) {
        if (!ctx.mounted) return;
        ToastWidget.show(ctx, message: res['err'], type: ToastType.error);
        return;
      }

      availableRides = res['rides'];
      notifyListeners();
    } catch (err) {
      if (!ctx.mounted) return;
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

  Future<void> acceptRide(BuildContext ctx, dynamic rideData) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString(constant.cabToken);

      Uri url = Uri.parse("${constant.apiUrl}/ride/create-ride-nego");
      Map<String, String> data = {
        "rideId": rideData['_id'],
        "proposed_price": rideNegoPrice.text != ""
            ? rideNegoPrice.text
            : rideData['price'].toString(),
        "proposed_pickup_time": rideNegoTime != null
            ? "${rideNegoTime!.hour}:${rideNegoTime!.minute}"
            : rideData['pickup_time'].toString(),
        "token": token!,
      };
      var req = await http.post(
        url,
        body: jsonEncode(data),
        headers: {"Content-Type": "application/json"},
      );
      var res = jsonDecode(req.body);
      if (req.statusCode != 200) {
        if (!ctx.mounted) return;
        ToastWidget.show(ctx, message: res['err'], type: ToastType.error);
        return;
      }

      if (!ctx.mounted) return;
      ToastWidget.show(ctx, message: res['msg'], type: ToastType.success);
      Navigator.push(
        ctx,
        MaterialPageRoute(builder: (context) => const DriverBookedCabScreen()),
      );
    } catch (err) {
      if (!ctx.mounted) return;
      ToastWidget.show(
        ctx,
        message: 'An error occurred while accepting the ride: $err',
        type: ToastType.error,
      );
    }
  }
}
