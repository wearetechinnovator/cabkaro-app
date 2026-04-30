<<<<<<< HEAD
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
=======
import 'dart:convert';
import 'package:cabkaro/controllers/car_details_controller.dart';
import 'package:cabkaro/screens/driver/add_car_details.dart';
import 'package:cabkaro/screens/driver/edit_car_details.dart';
import 'package:cabkaro/widgets/shimmer/car_list_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:cabkaro/widgets/gradient_background.dart';
import 'package:cabkaro/widgets/action_button.dart';
import 'package:cabkaro/widgets/signup_input.dart';
import 'package:cabkaro/utils/constants.dart' as constant;
>>>>>>> a64f8e0 (Edit vendor and user profile)

class ListedCarDetailsScreen extends StatefulWidget {
  const ListedCarDetailsScreen({super.key});

  @override
  State<ListedCarDetailsScreen> createState() => _ListedCarDetailsScreenState();
}

class _ListedCarDetailsScreenState extends State<ListedCarDetailsScreen> {
<<<<<<< HEAD
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
=======
  final TextEditingController _locController = TextEditingController();

  Future<List<Map<String, dynamic>>> _searchLocations(String query) async {
    if (query.trim().length < 3) return [];

    try {
      final uri = Uri.parse(
        'https://photon.komoot.io/api/?q=${Uri.encodeComponent(query)}&limit=5',
      );

      final response = await http
          .get(
            uri,
            headers: {
              'User-Agent': 'cabkaro_flutter_app',
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 5));
>>>>>>> a64f8e0 (Edit vendor and user profile)

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final features = data['features'] as List;
<<<<<<< HEAD
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
=======

        return features.map<Map<String, dynamic>>((f) {
          final p = f['properties'];

          String name = p['name'] ?? '';
          String city = p['city'] ?? '';
          String state = p['state'] ?? '';

          return {
            'display':
                "$name${city.isNotEmpty ? ', $city' : ''}${state.isNotEmpty ? ', $state' : ''}",
            'geoData': f['geometry'], // ✅ now allowed
          };
        }).toList();
>>>>>>> a64f8e0 (Edit vendor and user profile)
      }
    } catch (e) {
      debugPrint("Search Error: $e");
    }
<<<<<<< HEAD
    return [];
  }

  void _showActivationModal(int index) {
    List<Map<String, String>> suggestions = [];
=======

    return [];
  }

  // ─── NEW: Detail Modal ────────────────────────────────────────────────────

  void _showCarDetailModal(Map<String, dynamic> carData) {
    final car = carData;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Car image (if available)
                if (car['vehicle_img'] != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      "${constant.imgUrl}/${car['vehicle_img']}",
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                ] else ...[
                  Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(25, 242, 202, 42),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.directions_car,
                      size: 48,
                      color: Color(0xFFDDA200),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Car number & model
                Text(
                  car['vehicle_number'],
                  style: GoogleFonts.oswald(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  car['vehicle_model'],
                  style: GoogleFonts.nunitoSans(
                    fontSize: 15,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),

                // Details grid
                _detailRow(
                  Icons.event_seat,
                  'Seats',
                  car['number_of_seats']?.toString() ?? '—',
                ),
                _detailRow(Icons.ac_unit, 'AC', car['is_ac']),
                _detailRow(Icons.sos, 'SOS', car['is_sos']),
                _detailRow(
                  Icons.medical_services,
                  'First Aid',
                  car['is_first_aid_kid'],
                ),
                if (car['facilities'] != null && car['facilities']!.isNotEmpty)
                  _detailRow(Icons.star_outline, 'Other', car['facilities']),
                if (car['is_available'])
                  _detailRow(
                    Icons.location_on,
                    'Location',
                    'test location here..',
                  ),

                const SizedBox(height: 24),

                // Edit & Delete buttons
                Row(
                  children: [
                    // Edit button
                    Expanded(
                      child: ActionButton(
                        label: 'Edit',
                        backgroundColor: const Color(0xFFF2CA2A),
                        textColor: Colors.black,
                        borderColor: Colors.transparent,
                        onTap: () {
                          Navigator.pop(context); // close modal first
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditCarScreen(car: car),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Delete button
                    Expanded(
                      child: ActionButton(
                        label: 'Delete',
                        backgroundColor: Colors.redAccent,
                        textColor: Colors.white,
                        borderColor: Colors.transparent,
                        onTap: () {
                          Navigator.pop(context); // close modal
                          _confirmDelete(car);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFFDDA200)),
          const SizedBox(width: 10),
          Text(
            '$label:',
            style: GoogleFonts.nunitoSans(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.nunitoSans(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(Map<String, dynamic> car) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete Vehicle',
          style: GoogleFonts.oswald(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to remove ${car['vehicle_number']}?',
          style: GoogleFonts.nunitoSans(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black54),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Provider.of<CarDetailsController>(
                context,
                listen: false,
              ).deleteVehicle(context, car['_id']);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Activation Modal (unchanged) When try to active Car ─────────────────────────────────────────
  void _showActivationModal(int index, String id) {
    List<Map<String, dynamic>> suggestions = [];
>>>>>>> a64f8e0 (Edit vendor and user profile)
    bool isSearching = false;
    bool hasSearched = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
<<<<<<< HEAD
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
=======
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
>>>>>>> a64f8e0 (Edit vendor and user profile)
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
<<<<<<< HEAD
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
=======
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
>>>>>>> a64f8e0 (Edit vendor and user profile)
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
<<<<<<< HEAD
                    Text("Go Online", style: GoogleFonts.oswald(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),
                    
=======
                    Text(
                      "Go Online",
                      style: GoogleFonts.oswald(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
>>>>>>> a64f8e0 (Edit vendor and user profile)
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
<<<<<<< HEAD
                          setModalState(() {
                            isSearching = true;
                            hasSearched = true;
                          });
=======
                          setModalState(() => isSearching = hasSearched = true);
>>>>>>> a64f8e0 (Edit vendor and user profile)
                          final results = await _searchLocations(val);
                          setModalState(() {
                            suggestions = results;
                            isSearching = false;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Enter location (e.g. Kolkata)",
                          border: InputBorder.none,
<<<<<<< HEAD
                          icon: isSearching 
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                            : const Icon(Icons.search, size: 20),
                        ),
                      ),
                    ),

=======
                          icon: isSearching
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.black,
                                  ),
                                )
                              : const Icon(Icons.search, size: 20),
                        ),
                      ),
                    ),
>>>>>>> a64f8e0 (Edit vendor and user profile)
                    if (hasSearched && !isSearching) ...[
                      const SizedBox(height: 8),
                      if (suggestions.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(8.0),
<<<<<<< HEAD
                          child: Text("No locations found", style: TextStyle(color: Colors.redAccent, fontSize: 12)),
=======
                          child: Text(
                            "No locations found",
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 12,
                            ),
                          ),
>>>>>>> a64f8e0 (Edit vendor and user profile)
                        )
                      else
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.black12),
<<<<<<< HEAD
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

=======
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Column(
                            children: suggestions
                                .map(
                                  (s) => ListTile(
                                    dense: true,
                                    leading: const Icon(
                                      Icons.location_on,
                                      size: 18,
                                      color: Color(0xFFDDA200),
                                    ),
                                    title: Text(
                                      s['display']!,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                    onTap: () {
                                      setModalState(() {
                                        _locController.text = s['display']!;
                                        suggestions = [];
                                        hasSearched = false;
                                      });

                                      Provider.of<CarDetailsController>(
                                        context,
                                        listen: false,
                                      ).setCoordinates(
                                        s['geoData']['coordinates'][0],
                                        s['geoData']['coordinates'][1],
                                        s['display']!,
                                      );
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                    ],
>>>>>>> a64f8e0 (Edit vendor and user profile)
                    const SizedBox(height: 16),
                    SignupInput(
                      hint: 'Service Radius (km)',
                      icon: Icons.radar,
<<<<<<< HEAD
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
=======
                      controller: Provider.of<CarDetailsController>(
                        context,
                        listen: false,
                      ).serviceRadius,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: ActionButton(
                        label: 'Activate Service',
                        backgroundColor: const Color(0xFFF2CA2A),
                        textColor: Colors.black,
                        borderColor: Colors.transparent,
                        onTap: () {
                          Provider.of<CarDetailsController>(
                            context,
                            listen: false,
                          ).updateAvailablity(context, id);

                          _locController.clear();
                        },
                      ),
>>>>>>> a64f8e0 (Edit vendor and user profile)
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

<<<<<<< HEAD
=======
  // ─── Build ────────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CarDetailsController>(
        context,
        listen: false,
      ).getVendorVehicles(context);
    });
  }

>>>>>>> a64f8e0 (Edit vendor and user profile)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        showGlow: false,
<<<<<<< HEAD
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
=======
        child: RefreshIndicator(
          onRefresh: () async {
            Provider.of<CarDetailsController>(
              context,
              listen: false,
            ).getVendorVehicles(context);
          },
          child: SafeArea(
            child:
                Provider.of<CarDetailsController>(
                      context,
                      listen: true,
                    ).loading ==
                    true
                ? CarListShimmer()
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () => Navigator.pop(context),
                            ),
                            Text(
                              "My Listed Cars",
                              style: GoogleFonts.oswald(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: Provider.of<CarDetailsController>(
                            context,
                            listen: true,
                          ).listedVechiles.length,
                          itemBuilder: (context, index) {
                            final car = Provider.of<CarDetailsController>(
                              context,
                              listen: true,
                            ).listedVechiles[index];
                            return GestureDetector(
                              onTap: () => _showCarDetailModal(car),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: car['is_available']
                                        ? const Color(0xFFF2CA2A)
                                        : Colors.black12,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.directions_car,
                                          color: Color(0xFFDDA200),
                                        ),
                                        const SizedBox(width: 15),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                car['vehicle_number']
                                                    .toString(),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              Text(
                                                car['vehicle_model'],
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Switch(
                                          value: car['is_available'],
                                          activeColor: const Color(0xFFF2CA2A),
                                          onChanged: (val) {
                                            Provider.of<CarDetailsController>(
                                              context,
                                              listen: false,
                                            ).activeStatus = val;

                                            if (val) {
                                              _showActivationModal(
                                                index,
                                                car['_id'],
                                              );
                                            } else {
                                              Provider.of<CarDetailsController>(
                                                context,
                                                listen: false,
                                              ).updateAvailablity(
                                                context,
                                                car['_id'],
                                              );
                                              setState(
                                                () =>
                                                    car['is_available'] = false,
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                    if (car['is_available']) ...[
                                      const Divider(height: 20),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on,
                                            size: 14,
                                            color: Colors.green,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            car['service_location_string'] ??
                                                "",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddCarDetails()),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          child: const Icon(Icons.add, color: Colors.black, size: 28),
        ),
      ),
    );
  }
}
>>>>>>> a64f8e0 (Edit vendor and user profile)
