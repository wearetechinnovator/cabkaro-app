import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:cabkaro/providers/location_provider.dart';

// ─── OpenStreetMap Suggestion Model ──────────────────────────────────────────
class _PlaceSuggestion {
  final String title;
  final String subtitle;
  final double lat;
  final double lng;

  const _PlaceSuggestion({
    required this.title,
    required this.subtitle,
    required this.lat,
    required this.lng,
  });
}

class MapPickerScreen extends StatefulWidget {
  final bool isPickup;
  const MapPickerScreen({super.key, this.isPickup = true});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  GoogleMapController? _mapController;
  LatLng _centerPosition = const LatLng(22.5726, 88.3639);
  String _resolvedAddress = 'Move map to select location';
  bool _isResolving = false;

  final TextEditingController _searchCtrl = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  List<_PlaceSuggestion> _suggestions = [];
  bool _showSuggestions = false;
  bool _isSearching = false;
  Timer? _debounce;

  // ── OpenStreetMap (Photon) Autocomplete ────────────────────────────────────
  // 100% free, no API key needed
  Future<void> _fetchSuggestions(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _suggestions = [];
        _showSuggestions = false;
      });
      return;
    }
    
    // We append the country filter if needed, e.g. '&lat=22.5&lon=88.3' to bias
    final uri = Uri.parse('https://photon.komoot.io/api/?q=${Uri.encodeComponent(query)}&limit=5');
    
    setState(() => _isSearching = true);
    
    try {
      final res = await http.get(uri, headers: {
        'User-Agent': 'cabkaro_flutter_app', // Photon blocks default Dart User-Agent
        'Accept': 'application/json',
      });
      if (res.statusCode == 200 && mounted) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final features = (data['features'] as List<dynamic>?) ?? [];
        
        setState(() {
          _suggestions = features.map((f) {
            final props = f['properties'] as Map<String, dynamic>? ?? {};
            final geom = f['geometry'] as Map<String, dynamic>? ?? {};
            final coords = geom['coordinates'] as List<dynamic>? ?? [0.0, 0.0];
            
            // Photon returns coordinates as [longitude, latitude]
            final lng = (coords[0] as num).toDouble();
            final lat = (coords[1] as num).toDouble();
            
            // Build address parts
            final name = props['name'] as String? ?? '';
            final street = props['street'] as String?;
            final city = props['city'] as String? ?? props['town'] as String?;
            final state = props['state'] as String?;
            
            final title = name.isNotEmpty ? name : (street ?? city ?? 'Unknown Location');
            
            final subParts = [
              if (city != null && city != name) city,
              if (state != null && state != name) state,
              if (props['country'] != null) props['country'],
            ];
            
            return _PlaceSuggestion(
              title: title,
              subtitle: subParts.join(', '),
              lat: lat,
              lng: lng,
            );
          }).toList();
          
          _showSuggestions = _suggestions.isNotEmpty;
        });
      } else {
        debugPrint('[OSM API] failed with status: ${res.statusCode}');
      }
    } catch (e) {
      debugPrint('[OSM API] error: $e');
    } finally {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  // ── Handle Tap (Coordinates already included) ──────────────────────────────
  void _onSuggestionTap(_PlaceSuggestion suggestion) {
    _searchFocus.unfocus();
    final fullAddr = suggestion.subtitle.isEmpty 
        ? suggestion.title 
        : '${suggestion.title}, ${suggestion.subtitle}';
        
    setState(() {
      _showSuggestions = false;
      _searchCtrl.text = suggestion.title;
      _resolvedAddress = fullAddr;
      _centerPosition = LatLng(suggestion.lat, suggestion.lng);
    });

    _mapController?.animateCamera(CameraUpdate.newLatLng(_centerPosition));
  }

  // ── Reverse Geocode on map drag (Using Google Geocoding plugin) ────────────
  Future<void> _resolveAddress(LatLng pos) async {
    setState(() => _isResolving = true);
    try {
      // Note: placemarkFromCoordinates uses the native iOS/Android geocoder,
      // which is usually free on device level.
      final marks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
      if (marks.isNotEmpty) {
        final p = marks.first;
        final parts = [
          if (p.name != null && p.name!.isNotEmpty) p.name,
          if (p.subLocality != null && p.subLocality!.isNotEmpty) p.subLocality,
          if (p.locality != null && p.locality!.isNotEmpty) p.locality,
          if (p.administrativeArea != null && p.administrativeArea!.isNotEmpty)
            p.administrativeArea,
        ];
        final addr = parts.join(', ');
        setState(() {
          _resolvedAddress = addr;
          if (!_searchFocus.hasFocus) _searchCtrl.text = addr;
        });
      }
    } catch (_) {
      final fallback = '${pos.latitude.toStringAsFixed(4)}, ${pos.longitude.toStringAsFixed(4)}';
      setState(() {
        _resolvedAddress = fallback;
        if (!_searchFocus.hasFocus) _searchCtrl.text = fallback;
      });
    } finally {
      setState(() => _isResolving = false);
    }
  }

  void _confirmLocation() {
    final provider = context.read<LocationProvider>();
    if (widget.isPickup) {
      provider.setPickupLocation(_resolvedAddress);
      provider.setPickupLatLng(_centerPosition);
    } else {
      provider.setDropLocation(_resolvedAddress);
      provider.setDropLatLng(_centerPosition);
    }
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    _searchFocus.dispose();
    _mapController?.dispose();
    super.dispose();
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
            initialCameraPosition: CameraPosition(target: _centerPosition, zoom: 15.0),
            onMapCreated: (c) {
              _mapController = c;
              _resolveAddress(_centerPosition);
            },
            onCameraMove: (pos) => _centerPosition = pos.target,
            onCameraIdle: () {
              if (!_showSuggestions) _resolveAddress(_centerPosition);
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),

          const Padding(
            padding: EdgeInsets.only(bottom: 40),
            child: Icon(Icons.location_pin, size: 50, color: Colors.black),
          ),

          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2)),
                    ],
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      Icon(
                        widget.isPickup ? Icons.my_location : Icons.location_on,
                        color: widget.isPickup ? Colors.blue : Colors.red,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchCtrl,
                          focusNode: _searchFocus,
                          onChanged: (v) {
                            _debounce?.cancel();
                            _debounce = Timer(
                              const Duration(milliseconds: 500), // Slightly longer debounce so we don't spam free API
                              () => _fetchSuggestions(v),
                            );
                          },
                          onTap: () {
                            if (_searchCtrl.text.isNotEmpty) {
                              _fetchSuggestions(_searchCtrl.text);
                            }
                          },
                          decoration: const InputDecoration(
                            hintText: 'Search location…',
                            hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      if (_isResolving || _isSearching)
                        const Padding(
                          padding: EdgeInsets.only(right: 12),
                          child: SizedBox(
                            width: 16, height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.grey),
                          ),
                        )
                      else if (_searchCtrl.text.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            _searchCtrl.clear();
                            setState(() {
                              _suggestions = [];
                              _showSuggestions = false;
                            });
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: Icon(Icons.close, size: 18, color: Colors.grey),
                          ),
                        ),
                    ],
                  ),
                ),

                if (_showSuggestions)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2)),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _suggestions.length,
                        separatorBuilder: (_, __) => const Divider(
                          height: 1, indent: 44, color: Color(0xFFEEEEEE),
                        ),
                        itemBuilder: (_, i) {
                          final s = _suggestions[i];
                          return ListTile(
                            dense: true,
                            leading: const Icon(
                              Icons.location_on_outlined,
                              color: Color(0xFFF8C100),
                              size: 20,
                            ),
                            title: Text(
                              s.title,
                              style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF2D2F35),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: s.subtitle.isNotEmpty
                                ? Text(
                                    s.subtitle,
                                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                                    overflow: TextOverflow.ellipsis,
                                  )
                                : null,
                            onTap: () => _onSuggestionTap(s),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),

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
                      height: 20, width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
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
