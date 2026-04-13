import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:cabkaro/providers/location_provider.dart';

class MapPickerScreen extends StatefulWidget {
  final bool isPickup;
  const MapPickerScreen({super.key, this.isPickup = true});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  LatLng _centerPosition = const LatLng(22.5726, 88.3639);
  // GoogleMapController? _mapController;
  String _resolvedAddress = 'Move map to select location';
  bool _isResolving = false;

  Future<void> _resolveAddress(LatLng position) async {
    setState(() => _isResolving = true);
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final parts = [
          if (p.name != null && p.name!.isNotEmpty) p.name,
          if (p.locality != null && p.locality!.isNotEmpty) p.locality,
          if (p.administrativeArea != null && p.administrativeArea!.isNotEmpty)
            p.administrativeArea,
        ];
        setState(() => _resolvedAddress = parts.join(', '));
      }
    } catch (e) {
      setState(() {
        _resolvedAddress =
            '${_centerPosition.latitude.toStringAsFixed(4)}, '
            '${_centerPosition.longitude.toStringAsFixed(4)}';
      });
    } finally {
      setState(() => _isResolving = false);
    }
  }

  void _confirmLocation() {
    final provider = context.read<LocationProvider>();
    if (widget.isPickup) {
      provider.setPickupLocation(_resolvedAddress);
    } else {
      provider.setDropLocation(_resolvedAddress);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isPickup ? 'Pick Pickup Location' : 'Pick Drop Location',
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _centerPosition,
              zoom: 15.0,
            ),
            onMapCreated: (controller) {
              // _mapController = controller;
              _resolveAddress(_centerPosition);
            },
            onCameraMove: (position) {
              _centerPosition = position.target;
            },
            onCameraIdle: () {
              _resolveAddress(_centerPosition);
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),

          // Pin icon at center
          const Padding(
            padding: EdgeInsets.only(bottom: 40),
            child: Icon(Icons.location_pin, size: 50, color: Colors.black),
          ),

          // Address chip at top
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    widget.isPickup ? Icons.my_location : Icons.location_on,
                    color: widget.isPickup ? Colors.blue : Colors.red,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _isResolving
                        ? const Text(
                            'Resolving address...',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          )
                        : Text(
                            _resolvedAddress,
                            style: const TextStyle(fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                  ),
                ],
              ),
            ),
          ),

          // Confirm button
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: _isResolving ? null : _confirmLocation,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                disabledBackgroundColor: Colors.amber,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isResolving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.black,
                      ),
                    )
                  : const Text(
                      'Confirm Pin Location',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}