import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationProvider extends ChangeNotifier {
  String? _pickupLocation;
  String? _dropLocation;
  LatLng? _pickupLatLng;
  LatLng? _dropLatLng;

  String? get pickupLocation => _pickupLocation;
  String? get dropLocation => _dropLocation;
  LatLng? get pickupLatLng => _pickupLatLng;
  LatLng? get dropLatLng => _dropLatLng;

  void setPickupLatLng(LatLng position) {
    _pickupLatLng = position;
    notifyListeners();
  }

  void setDropLatLng(LatLng position) {
    _dropLatLng = position;
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
