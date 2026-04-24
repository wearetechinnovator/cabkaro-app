import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  CarData({
    required this.id,
    required this.carNumber,
    required this.model,
    this.isActive = false,
    this.location,
    this.radius,
  });
}

class ListedCarDetailsScreen extends StatefulWidget {
  const ListedCarDetailsScreen({super.key});

  @override
  State<ListedCarDetailsScreen> createState() => _ListedCarDetailsScreenState();
}

class _ListedCarDetailsScreenState extends State<ListedCarDetailsScreen> {
  // Mock data for listed cars
  final List<CarData> _listedCars = [
    CarData(id: '1', carNumber: 'WB-32-A-1234', model: 'Swift Dzire', isActive: true, location: 'Kolkata', radius: '15'),
    CarData(id: '2', carNumber: 'WB-32-B-5678', model: 'Toyota Innova'),
  ];

  final TextEditingController _locController = TextEditingController();
  final TextEditingController _radiusController = TextEditingController();

  void _handleToggle(int index, bool value) {
    if (value) {
      _showActivationModal(index);
    } else {
      _showDeactivationConfirm(index);
    }
  }

  void _showActivationModal(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          left: 20, right: 20, top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Go Online", style: GoogleFonts.oswald(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Set your service area for ${ _listedCars[index].carNumber}", style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            SignupInput(hint: 'Current Location', icon: Icons.my_location, controller: _locController),
            const SizedBox(height: 15),
            SignupInput(hint: 'Service Radius (km)', icon: Icons.radar, controller: _radiusController, keyboardType: TextInputType.number),
            const SizedBox(height: 25),
            ActionButton(
              label: 'Activate Service',
              backgroundColor: const Color(0xFFF2CA2A),
              textColor: Colors.black,
              borderColor: const Color.fromARGB(0, 0, 0, 0),
              onTap: () {
                setState(() {
                  _listedCars[index].isActive = true;
                  _listedCars[index].location = _locController.text;
                  _listedCars[index].radius = _radiusController.text;
                });
                Navigator.pop(context);
                _locController.clear();
                _radiusController.clear();

              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeactivationConfirm(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Are you sure?", style: GoogleFonts.oswald()),
        content: const Text("This car will no longer be visible to customers for new bookings."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              setState(() => _listedCars[index].isActive = false);
              Navigator.pop(context);
            },
            child: const Text("Confirm Off", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
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
                        border: Border.all(color: car.isActive ? const Color(0xFFF2CA2A) : Colors.black12, width: 1.5),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(color: const Color(0xFFF2CA2A).withOpacity(0.2), shape: BoxShape.circle),
                                child: const Icon(Icons.directions_car, color: Color(0xFFDDA200)),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(car.carNumber, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                    Text(car.model, style: TextStyle(color: Colors.grey[600])),
                                  ],
                                ),
                              ),
                              Switch(
                                value: car.isActive,
                                activeColor: const Color(0xFFF2CA2A),
                                onChanged: (val) => _handleToggle(index, val),
                              ),
                            ],
                          ),
                          if (car.isActive) ...[
                            const Divider(height: 24),
                            Row(
                              children: [
                                const Icon(Icons.location_on, size: 16, color: Colors.green),
                                const SizedBox(width: 4),
                                Text("${car.location} (${car.radius} km range)", style: const TextStyle(fontSize: 13, color: Colors.green, fontWeight: FontWeight.w600)),
                              ],
                            )
                          ]
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/add-car'),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2CA2A),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black, width: 1.5),
                        ),
                        child: const Icon(Icons.add, color: Colors.black, size: 28),
                      ),
                    ),
                    const SizedBox(width: 15),
                     Expanded(
                      child: ActionButton(
                        label: 'Refresh Fleet',
                        backgroundColor: Color(0xFF1F1F1F),
                        textColor: Colors.white,
                        borderColor: Color(0xFF1F1F1F),
                        onTap: () {}, // Add refresh logic
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}