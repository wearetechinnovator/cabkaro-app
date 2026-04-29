import 'dart:convert';
import 'package:cabkaro/providers/location_provider.dart';
import 'package:cabkaro/providers/socket_provider.dart';
import 'package:cabkaro/screens/user/available_cabs_screen.dart';
import 'package:cabkaro/widgets/Toastwidget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:cabkaro/utils/constants.dart' as constant;
import 'package:shared_preferences/shared_preferences.dart';

class RideController extends ChangeNotifier {
  TextEditingController price = TextEditingController();
  TextEditingController otherFacilitiesController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  // New fields from search card
  String? selectedSeater;
  String selectedAC = "Non-AC";
  String selectedSOS = "Non-SOS";
  String selectedFirstAid = "No First Aid Box";

  void setDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  void setTime(TimeOfDay time) {
    selectedTime = time;
    notifyListeners();
  }

  // New setters for additional fields
  void setSeater(String? seater) {
    selectedSeater = seater;
    notifyListeners();
  }

  void setAC(String ac) {
    selectedAC = ac;
    notifyListeners();
  }

  void setSOS(String sos) {
    selectedSOS = sos;
    notifyListeners();
  }

  void setFirstAid(String firstAid) {
    selectedFirstAid = firstAid;
    notifyListeners();
  }

  // Reset all fields
  void resetFields() {
    price.clear();
    selectedDate = null;
    selectedTime = null;
    selectedSeater = null;
    selectedAC = "Non-AC";
    selectedSOS = "Non-SOS";
    selectedFirstAid = "No First Aid Box";
    otherFacilitiesController.clear();
    notifyListeners();
  }

  // Create New Ride.......
  Future<void> postRide(BuildContext context) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    if (!context.mounted) return;
    final locationProvider = Provider.of<LocationProvider>(
      context,
      listen: false,
    );
    final socket = Provider.of<SocketProvider>(context, listen: false);

    String ridePrice = price.text.trim();
    DateTime? rideDate = selectedDate;
    TimeOfDay? rideTime = selectedTime;
    LatLng pickupPosition = locationProvider.pickupLatLng;
    LatLng dropPosition = locationProvider.dropLatLng;
    String token = pref.getString(constant.cabToken)!;
    String pickupString = locationProvider.pickupLocation!;
    String dropString = locationProvider.dropLocation!;

    notifyListeners();

    if (ridePrice.isEmpty || rideTime == null || rideDate == null) {
      if (!context.mounted) return;
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
        "pickup_city": pickupString,
        "drop_city": dropString,
        "other_facilities": otherFacilitiesController.text.trim(),
        "ac_type": selectedAC,
        "sos": selectedSOS,
        "first_aid": selectedFirstAid,
      };

      // Add optional fields if they are set
      if (selectedSeater != null) {
        data["seater"] = selectedSeater;
      }

      Uri url = Uri.parse("${constant.apiUrl}/ride/create-ride");
      var req = await http.post(
        url,
        body: jsonEncode(data),
        headers: {"Content-Type": "application/json"},
      );

      var res = jsonDecode(req.body);
      if (req.statusCode != 201) {
        if (!context.mounted) return;
        ToastWidget.show(context, message: res['err'], type: ToastType.error);
        return;
      }

      if (!context.mounted) return;
      ToastWidget.show(
        context,
        message: "Ride create success",
        type: ToastType.success,
      );

      // Socket emit send
      socket.emit("ride-create-request", data);

      // Clear all form data;
      resetFields();
      locationProvider.clearLocations();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AvailableCabsScreen(rideId: res['data']['_id']),
        ),
      );
    } catch (err) {
      if (!context.mounted) return;
      ToastWidget.show(
        context,
        message: "Something went wrong",
        type: ToastType.error,
      );
    }
  }

  Future<void> editRide(BuildContext context, String rideId) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    if (!context.mounted) return;
    final locationProvider = Provider.of<LocationProvider>(
      context,
      listen: false,
    );
    // final socket = Provider.of<SocketProvider>(context, listen: false);

    String ridePrice = price.text.trim();
    DateTime? rideDate = selectedDate;
    TimeOfDay? rideTime = selectedTime;
    LatLng pickupPosition = locationProvider.pickupLatLng;
    LatLng dropPosition = locationProvider.dropLatLng;
    String token = pref.getString(constant.cabToken)!;

    notifyListeners();

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
        "rideId": rideId,
        "other_facilities": otherFacilitiesController.text.trim(),
        "ac_type": selectedAC,
        "sos": selectedSOS,
        "first_aid": selectedFirstAid,
      };

      // Add optional fields if they are set
      if (selectedSeater != null) {
        data["seater"] = selectedSeater;
      }

      Uri url = Uri.parse("${constant.apiUrl}/ride/edit-ride");
      var req = await http.patch(
        url,
        body: jsonEncode(data),
        headers: {"Content-Type": "application/json"},
      );

      var res = jsonDecode(req.body);
      if (req.statusCode != 200) {
        if (!context.mounted) return;
        ToastWidget.show(context, message: res['err'], type: ToastType.error);
        return;
      }

      if (!context.mounted) return;
      ToastWidget.show(context, message: res['msg'], type: ToastType.success);
    } catch (err) {
      if (!context.mounted) return;
      ToastWidget.show(
        context,
        message: "Something went wrong",
        type: ToastType.error,
      );
    }
  }
}
