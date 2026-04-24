// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../widgets/gradient_background.dart';
import '../../widgets/action_button.dart';
import '../../widgets/signup_input.dart';

class CarData {
  String id;
  String carNumber;
  String model;
  bool isActive;
  String? location;
  String? radius;
  String? seaterCount;
  String isAc;
  String isSos;
  String isFirstAid;
  String? otherFacilities;
  File? carImage;

  CarData({
    required this.id,
    required this.carNumber,
    required this.model,
    this.isActive = false,
    this.location,
    this.radius,
    this.seaterCount,
    this.isAc = 'No',
    this.isSos = 'No',
    this.isFirstAid = 'No',
    this.otherFacilities,
    this.carImage,
  });
}

class ListedCarDetailsScreen extends StatefulWidget {
  const ListedCarDetailsScreen({super.key});

  @override
  State<ListedCarDetailsScreen> createState() => _ListedCarDetailsScreenState();
}

class _ListedCarDetailsScreenState extends State<ListedCarDetailsScreen> {
  final List<CarData> _listedCars = [
    CarData(
      id: '1',
      carNumber: 'WB-32-A-1234',
      model: 'Swift Dzire',
      isActive: true,
      location: 'Kolkata',
      radius: '15',
      seaterCount: '4',
      isAc: 'Yes',
      isSos: 'Yes',
      isFirstAid: 'No',
      otherFacilities: 'WiFi, Water Bottles',
    ),
  ];

  final TextEditingController _locController = TextEditingController();
  final TextEditingController _radiusController = TextEditingController();

  Future<List<Map<String, String>>> _searchLocations(String query) async {
    if (query.trim().length < 3) return [];
    try {
      final uri = Uri.parse('https://photon.komoot.io/api/?q=${Uri.encodeComponent(query)}&limit=5');
      
      // FIX: Added mandatory User-Agent header and removed double http.get call
      final response = await http.get(uri, headers: {
        'User-Agent': 'cabkaro_flutter_app', 
        'Accept': 'application/json',
      }).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final features = data['features'] as List;
        return features.map<Map<String, String>>((f) {
          final p = f['properties'];
          String name = p['name'] ?? '';
          String city = p['city'] ?? '';
          String state = p['state'] ?? '';
          return {
            'display': "$name${city.isNotEmpty ? ', $city' : ''}${state.isNotEmpty ? ', $state' : ''}",
          };
        }).toList();
      } else {
        debugPrint("API Error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Search Error: $e");
    }
    return [];
  }

  void _showActivationModal(int index) {
    List<Map<String, String>> suggestions = [];
    bool isSearching = false;
    bool hasSearched = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Go Online", style: GoogleFonts.oswald(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),
                    
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(31, 242, 202, 42),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: TextField(
                        controller: _locController,
                        onChanged: (val) async {
                          if (val.length < 3) {
                            setModalState(() {
                              suggestions = [];
                              isSearching = false;
                              hasSearched = false;
                            });
                            return;
                          }
                          setModalState(() {
                            isSearching = true;
                            hasSearched = true;
                          });
                          final results = await _searchLocations(val);
                          setModalState(() {
                            suggestions = results;
                            isSearching = false;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Enter location (e.g. Kolkata)",
                          border: InputBorder.none,
                          icon: isSearching 
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                            : const Icon(Icons.search, size: 20),
                        ),
                      ),
                    ),

                    if (hasSearched && !isSearching) ...[
                      const SizedBox(height: 8),
                      if (suggestions.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("No locations found", style: TextStyle(color: Colors.redAccent, fontSize: 12)),
                        )
                      else
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.black12),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                          ),
                          child: Column(
                            children: suggestions.map((s) => ListTile(
                              dense: true,
                              leading: const Icon(Icons.location_on, size: 18, color: Color(0xFFDDA200)),
                              title: Text(s['display']!, style: const TextStyle(fontSize: 13)),
                              onTap: () {
                                setModalState(() {
                                  _locController.text = s['display']!;
                                  suggestions = [];
                                  hasSearched = false;
                                });
                              },
                            )).toList(),
                          ),
                        ),
                    ],

                    const SizedBox(height: 16),
                    SignupInput(
                      hint: 'Service Radius (km)',
                      icon: Icons.radar,
                      controller: _radiusController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    ActionButton(
                      label: 'Activate Service',
                      backgroundColor: const Color(0xFFF2CA2A),
                      textColor: Colors.black,
                      borderColor: Colors.transparent,
                      onTap: () {
                        if (_locController.text.isNotEmpty && _radiusController.text.isNotEmpty) {
                          setState(() {
                            _listedCars[index].isActive = true;
                            _listedCars[index].location = _locController.text;
                            _listedCars[index].radius = _radiusController.text;
                          });
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        showGlow: false,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
                    Text("My Listed Cars", style: GoogleFonts.oswald(fontSize: 26, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _listedCars.length,
                  itemBuilder: (context, index) {
                    final car = _listedCars[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: car.isActive ? const Color(0xFFF2CA2A) : Colors.black12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.directions_car, color: Color(0xFFDDA200)),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(car.carNumber, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                    Text(car.model, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                                  ],
                                ),
                              ),
                              Switch(
                                value: car.isActive,
                                activeColor: const Color(0xFFF2CA2A),
                                onChanged: (val) {
                                  if (val) _showActivationModal(index);
                                  else setState(() => car.isActive = false);
                                },
                              ),
                            ],
                          ),
                          if (car.isActive && car.location != null) ...[
                            const Divider(height: 20),
                            Row(
                              children: [
                                const Icon(Icons.location_on, size: 14, color: Colors.green),
                                const SizedBox(width: 5),
                                Text("${car.location} (${car.radius} km)", style: const TextStyle(fontSize: 12, color: Colors.green)),
                              ],
                            )
                          ]
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}