import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationProvider extends ChangeNotifier {
  String? _pickupLocation;
  String? _dropLocation;
<<<<<<< HEAD
  LatLng? _pickupLatLng;
  LatLng? _dropLatLng;

  String? get pickupLocation => _pickupLocation;
  String? get dropLocation => _dropLocation;
  LatLng? get pickupLatLng => _pickupLatLng;
  LatLng? get dropLatLng => _dropLatLng;

  void setPickupLatLng(LatLng position) {
    _pickupLatLng = position;
=======
  late LatLng pickupLatLng;
  late LatLng dropLatLng;

  String? get pickupLocation => _pickupLocation;
  String? get dropLocation => _dropLocation;

  void setPickupLatLng(LatLng position) {
    pickupLatLng = position;
>>>>>>> a64f8e0 (Edit vendor and user profile)
    notifyListeners();
  }

  void setDropLatLng(LatLng position) {
<<<<<<< HEAD
    _dropLatLng = position;
=======
    dropLatLng = position;
>>>>>>> a64f8e0 (Edit vendor and user profile)
    notifyListeners();
  }

  void setPickupLocation(String location) {
    _pickupLocation = location.isEmpty ? null : location;
    notifyListeners();
  }

  void setDropLocation(String location) {
    _dropLocation = location.isEmpty ? null : location;
    notifyListeners();
  }

  void clearLocations() {
    _pickupLocation = null;
    _dropLocation = null;
    notifyListeners();
  }
}
