import 'dart:convert';
import 'package:cabkaro/providers/location_provider.dart';
import 'package:cabkaro/providers/socket_provider.dart';
import 'package:cabkaro/widgets/Toastwidget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:cabkaro/utils/constants.dart' as constant;
import 'package:shared_preferences/shared_preferences.dart';

class RideController extends ChangeNotifier {
  TextEditingController price = TextEditingController();
  DateTime? date;
  TimeOfDay? time;

  // Create New Ride.......
  Future<void> postRide(BuildContext context) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final locationProvider = Provider.of<LocationProvider>(
      context,
      listen: false,
    );
    final socket = Provider.of<SocketProvider>(context, listen: false);

    String ridePrice = price.text.trim();
    DateTime? rideDate = date;
    TimeOfDay? rideTime = time;
    LatLng pickupPosition = locationProvider.pickupLatLng;
    LatLng dropPosition = locationProvider.dropLatLng;
    String token = pref.getString(constant.cabToken)!;

    print(ridePrice);
    print(rideDate);
    print(rideTime);
    print(pickupPosition);
    print(dropPosition);

    if (ridePrice.isEmpty || rideTime == null || rideDate == null) {
      ToastWidget.show(
        context,
        message: "Enter all ride details",
        type: ToastType.error,
      );
      return;
    }

    try {
      Map<String, dynamic> data = {
        "pickup_location": {
          "lat": pickupPosition.latitude,
          "lng": pickupPosition.longitude,
        },
        "drop_location": {
          "lat": dropPosition.latitude,
          "lng": dropPosition.longitude,
        },
        "price": ridePrice,
        "pickup_date": rideDate.toIso8601String(),
        "pickup_time": "${rideTime.hour}:${rideTime.minute}",
        "token": token,
      };
      Uri url = Uri.parse("${constant.apiUrl}/ride/create-ride");
      var req = await http.post(
        url,
        body: jsonEncode(data),
        headers: {"Content-Type": "application/json"},
      );

      var res = jsonDecode(req.body);

      print(res);
      if (req.statusCode != 201) {
        if (!context.mounted) return;
        ToastWidget.show(context, message: res['err'], type: ToastType.error);
      }

      if (!context.mounted) return;
      ToastWidget.show(
        context,
        message: "Ride create success",
        type: ToastType.success,
      );

      // Socket emit send
      socket.emit("ride-create-request", data);

      // Clear fields;
      locationProvider.setPickupLocation("");
      locationProvider.setDropLocation("");
      price.clear();
      date = null;
      time;
    } catch (err) {
      print("========================Error======================");
      print(err);
      if (!context.mounted) return;
      ToastWidget.show(
        context,
        message: "Something went wrong",
        type: ToastType.error,
      );
    }
  }
}
