<<<<<<< HEAD
// ignore_for_file: use_build_context_synchronously

=======
>>>>>>> a64f8e0 (Edit vendor and user profile)
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
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
<<<<<<< HEAD
  
  // New fields for ride preferences
  String? selectedSeater;
  String? selectedAC;
  String? selectedSOS;
  String? selectedFirstAid;
  String? otherFacilities;
=======
>>>>>>> a64f8e0 (Edit vendor and user profile)

  void setDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  void setTime(TimeOfDay time) {
    selectedTime = time;
    notifyListeners();
  }

<<<<<<< HEAD
  void setSeater(String? seater) {
    selectedSeater = seater;
    notifyListeners();
  }

  void setAC(String? ac) {
    selectedAC = ac;
    notifyListeners();
  }

  void setSOS(String? sos) {
    selectedSOS = sos;
    notifyListeners();
  }

  void setFirstAid(String? firstAid) {
    selectedFirstAid = firstAid;
    notifyListeners();
  }

  void setOtherFacilities(String? facilities) {
    otherFacilities = facilities;
    notifyListeners();
  }

  void setPrice(String priceValue) {
    price.text = priceValue;
    notifyListeners();
  }

=======
>>>>>>> a64f8e0 (Edit vendor and user profile)
  // Create New Ride.......
  Future<void> postRide(BuildContext context) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final locationProvider = Provider.of<LocationProvider>(
      context,
      listen: false,
    );
    final socket = Provider.of<SocketProvider>(context, listen: false);

    String ridePrice = price.text.trim();
    DateTime? rideDate = selectedDate;
    TimeOfDay? rideTime = selectedTime;
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> a64f8e0 (Edit vendor and user profile)
    LatLng pickupPosition = locationProvider.pickupLatLng;
    LatLng dropPosition = locationProvider.dropLatLng;
    String token = pref.getString(constant.cabToken)!;
    String pickupString = locationProvider.pickupLocation!;
    String dropString = locationProvider.dropLocation!;

    print(pickupString);
    print(dropString);

    notifyListeners();
<<<<<<< HEAD
=======
    LatLng? pickupPosition = locationProvider.pickupLatLng;
    LatLng? dropPosition = locationProvider.dropLatLng;
    String? token = pref.getString(constant.cabToken);
    
    // Debug logging
    print("DEBUG postRide: price='$ridePrice', date=$rideDate, time=$rideTime, pickup=$pickupPosition, drop=$dropPosition, token=$token");
    print("DEBUG: seater=$selectedSeater, ac=$selectedAC, sos=$selectedSOS, firstAid=$selectedFirstAid");
>>>>>>> 5c2a44a (minor changes)

    if (ridePrice.isEmpty || rideTime == null || rideDate == null || pickupPosition == null || dropPosition == null || token == null) {
=======

    if (ridePrice.isEmpty || rideTime == null || rideDate == null) {
>>>>>>> a64f8e0 (Edit vendor and user profile)
      ToastWidget.show(
        context,
        message: "Enter all ride details",
        type: ToastType.error,
      );
<<<<<<< HEAD
      print("DEBUG: Validation failed - missing: price=$ridePrice, time=$rideTime, date=$rideDate, pickup=$pickupPosition, drop=$dropPosition, token=$token");
=======
>>>>>>> a64f8e0 (Edit vendor and user profile)
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
<<<<<<< HEAD
<<<<<<< HEAD
        "pickup_city": pickupString,
        "drop_city": dropString,
=======
        "seater": selectedSeater,
        "ac": selectedAC,
        "sos": selectedSOS,
        "first_aid": selectedFirstAid,
        "other_facilities": otherFacilities,
>>>>>>> 5c2a44a (minor changes)
=======
        "pickup_city": pickupString,
        "drop_city": dropString,
>>>>>>> a64f8e0 (Edit vendor and user profile)
      };
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
      }

      if (!context.mounted) return;
      ToastWidget.show(
        context,
        message: "Ride create success",
        type: ToastType.success,
      );

      // Socket emit send
      socket.emit("ride-create-request", data);

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
    final locationProvider = Provider.of<LocationProvider>(
      context,
      listen: false,
    );
    final socket = Provider.of<SocketProvider>(context, listen: false);

    String ridePrice = price.text.trim();
    DateTime? rideDate = selectedDate;
    TimeOfDay? rideTime = selectedTime;
<<<<<<< HEAD
    LatLng? pickupPosition = locationProvider.pickupLatLng;
    LatLng? dropPosition = locationProvider.dropLatLng;
    String? token = pref.getString(constant.cabToken);
    // Socket emit send
    notifyListeners();

    if (ridePrice.isEmpty || rideTime == null || rideDate == null || pickupPosition == null || dropPosition == null || token == null) {
=======
    LatLng pickupPosition = locationProvider.pickupLatLng;
    LatLng dropPosition = locationProvider.dropLatLng;
    String token = pref.getString(constant.cabToken)!;
    // Socket emit send
    notifyListeners();

    if (ridePrice.isEmpty || rideTime == null || rideDate == null) {
>>>>>>> a64f8e0 (Edit vendor and user profile)
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
<<<<<<< HEAD
        "seater": selectedSeater,
        "ac": selectedAC,
        "sos": selectedSOS,
        "first_aid": selectedFirstAid,
        "other_facilities": otherFacilities,
=======
>>>>>>> a64f8e0 (Edit vendor and user profile)
      };
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
      }

      if (!context.mounted) return;
      ToastWidget.show(context, message: res['msg'], type: ToastType.success);
    } catch (err) {
      print("error:");
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
