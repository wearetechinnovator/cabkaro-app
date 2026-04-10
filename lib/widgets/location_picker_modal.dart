import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cabkaro/providers/location_provider.dart';
import 'package:cabkaro/screens/user/MapPickerScreen.dart';
import 'package:cabkaro/services/places_service.dart';

class LocationPickerModal extends StatefulWidget {
  const LocationPickerModal({super.key});

  @override
  State<LocationPickerModal> createState() => _LocationPickerModalState();
}

class _LocationPickerModalState extends State<LocationPickerModal> {
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _dropController = TextEditingController();

  List<String> _pickupSuggestions = [];
  List<String> _dropSuggestions = [];

  bool _showPickupSuggestions = false;
  bool _showDropSuggestions = false;

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

  Future<void> _onPickupChanged(String value) async {
    if (value.length < 2) {
      setState(() {
        _pickupSuggestions = [];
        _showPickupSuggestions = false;
      });
      return;
    }
    final results = await PlacesService.getSuggestions(value);
    setState(() {
      _pickupSuggestions = results;
      _showPickupSuggestions = results.isNotEmpty;
    });
  }

  Future<void> _onDropChanged(String value) async {
    if (value.length < 2) {
      setState(() {
        _dropSuggestions = [];
        _showDropSuggestions = false;
      });
      return;
    }
    final results = await PlacesService.getSuggestions(value);
    setState(() {
      _dropSuggestions = results;
      _showDropSuggestions = results.isNotEmpty;
    });
  }

  void _selectPickup(String place) {
    _pickupController.text = place;
    setState(() {
      _pickupSuggestions = [];
      _showPickupSuggestions = false;
    });
  }

  void _selectDrop(String place) {
    _dropController.text = place;
    setState(() {
      _dropSuggestions = [];
      _showDropSuggestions = false;
    });
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

  // Reusable suggestion list
  Widget _buildSuggestions({
    required List<String> suggestions,
    required void Function(String) onSelect,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.separated(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: suggestions.length > 5 ? 5 : suggestions.length,
        separatorBuilder: (_, __) =>
            Divider(height: 1, color: Colors.grey.shade200),
        itemBuilder: (context, index) {
          final place = suggestions[index];
          return InkWell(
            onTap: () => onSelect(place),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined,
                      size: 18, color: Colors.grey),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      place,
                      style: const TextStyle(fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
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
                style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),

            // Pickup field
            TextField(
              controller: _pickupController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: 'Pickup Location',
                prefixIcon:
                    const Icon(Icons.my_location, color: Colors.blue),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_pickupController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () => setState(() {
                          _pickupController.clear();
                          _pickupSuggestions = [];
                          _showPickupSuggestions = false;
                        }),
                      ),
                    IconButton(
                      icon: const Icon(Icons.map_outlined,
                          size: 18, color: Colors.amber),
                      onPressed: () => _openMapPicker(true),
                    ),
                  ],
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: _onPickupChanged,
            ),

            // Pickup suggestions
            if (_showPickupSuggestions) ...[
              const SizedBox(height: 4),
              _buildSuggestions(
                suggestions: _pickupSuggestions,
                onSelect: _selectPickup,
              ),
            ],

            const SizedBox(height: 12),

            // Drop field
            TextField(
              controller: _dropController,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                hintText: 'Where to?',
                prefixIcon:
                    const Icon(Icons.location_on, color: Colors.red),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_dropController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () => setState(() {
                          _dropController.clear();
                          _dropSuggestions = [];
                          _showDropSuggestions = false;
                        }),
                      ),
                    IconButton(
                      icon: const Icon(Icons.map_outlined,
                          size: 18, color: Colors.amber),
                      onPressed: () => _openMapPicker(false),
                    ),
                  ],
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: _onDropChanged,
              onSubmitted: (_) => _confirmLocations(),
            ),

            // Drop suggestions
            if (_showDropSuggestions) ...[
              const SizedBox(height: 4),
              _buildSuggestions(
                suggestions: _dropSuggestions,
                onSelect: _selectDrop,
              ),
            ],

            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: () {
                final pickupEmpty =
                    _pickupController.text.trim().isEmpty;
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
      ),
    );
  }
}