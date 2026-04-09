import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cabkaro/providers/location_provider.dart';
import 'package:cabkaro/screens/user/MapPickerScreen.dart';

class LocationPickerModal extends StatefulWidget {
  const LocationPickerModal({super.key});

  @override
  State<LocationPickerModal> createState() => _LocationPickerModalState();
}

class _LocationPickerModalState extends State<LocationPickerModal> {
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _dropController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = context.read<LocationProvider>();
    _pickupController.text = provider.pickupLocation ?? '';
    _dropController.text = provider.dropLocation ?? '';
  }

  @override
  void dispose() {
    _pickupController.dispose();
    _dropController.dispose();
    super.dispose();
  }

  void _confirmLocations() {
    final pickup = _pickupController.text.trim();
    final drop = _dropController.text.trim();

    if (pickup.isEmpty && drop.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter at least one location')),
      );
      return;
    }

    final provider = context.read<LocationProvider>();
    if (pickup.isNotEmpty) provider.setPickupLocation(pickup);
    if (drop.isNotEmpty) provider.setDropLocation(drop);

    Navigator.pop(context);
  }

  Future<void> _openMapPicker(bool isPickup) async {
    final pickup = _pickupController.text.trim();
    final drop = _dropController.text.trim();
    final provider = context.read<LocationProvider>();
    if (pickup.isNotEmpty) provider.setPickupLocation(pickup);
    if (drop.isNotEmpty) provider.setDropLocation(drop);

    Navigator.pop(context);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MapPickerScreen(isPickup: isPickup),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
        left: 16,
        right: 16,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Set Locations',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),

          // Pickup field
          TextField(
            controller: _pickupController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: 'Pickup Location',
              prefixIcon: const Icon(Icons.my_location, color: Colors.blue),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_pickupController.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () =>
                          setState(() => _pickupController.clear()),
                    ),
                  IconButton(
                    icon: const Icon(Icons.map_outlined,
                        size: 18, color: Colors.amber),
                    onPressed: () => _openMapPicker(true),
                  ),
                ],
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.grey[100],
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),

          // Drop field
          TextField(
            controller: _dropController,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: 'Where to?',
              prefixIcon: const Icon(Icons.location_on, color: Colors.red),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_dropController.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () =>
                          setState(() => _dropController.clear()),
                    ),
                  IconButton(
                    icon: const Icon(Icons.map_outlined,
                        size: 18, color: Colors.amber),
                    onPressed: () => _openMapPicker(false),
                  ),
                ],
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.grey[100],
            ),
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) => _confirmLocations(),
          ),
          const SizedBox(height: 16),

          ElevatedButton.icon(
            onPressed: () {
              final pickupEmpty = _pickupController.text.trim().isEmpty;
              _openMapPicker(pickupEmpty);
            },
            icon: const Icon(Icons.map, color: Colors.black),
            label: const Text('Pick from Map',
                style: TextStyle(color: Colors.black)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: _confirmLocations,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Confirm Locations',
                style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}