import 'package:flutter/material.dart';

class LocationProvider extends ChangeNotifier {
  String? _pickupLocation;
  String? _dropLocation;

  String? get pickupLocation => _pickupLocation;
  String? get dropLocation => _dropLocation;

  void setPickupLocation(String location) {
    _pickupLocation = location;
    notifyListeners();
  }

  void setDropLocation(String location) {
    _dropLocation = location;
    notifyListeners();
  }

  void clearLocations() {
    _pickupLocation = null;
    _dropLocation = null;
    notifyListeners();
  }
}