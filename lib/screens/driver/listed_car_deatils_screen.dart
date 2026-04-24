// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:cabkaro/screens/driver/edit_car_details.dart';
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
    CarData(
      id: '2',
      carNumber: 'WB-32-B-5678',
      model: 'Toyota Innova',
      seaterCount: '7',
      isAc: 'Yes',
      isSos: 'No',
      isFirstAid: 'Yes',
    ),
  ];

  final TextEditingController _locController = TextEditingController();
  final TextEditingController _radiusController = TextEditingController();

  // ── Detail bottom sheet ──────────────────────────────────────────────────

  void _showCarDetail(int index) {
    final car = _listedCars[index];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.65,
          minChildSize: 0.4,
          maxChildSize: 0.92,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                // Handle
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF2CA2A).withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.directions_car,
                                  color: Color(0xFFDDA200), size: 28),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  car.carNumber,
                                  style: GoogleFonts.oswald(
                                      fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                Text(car.model,
                                    style: TextStyle(color: Colors.grey[600])),
                              ],
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: car.isActive
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                car.isActive ? 'Active' : 'Inactive',
                                style: TextStyle(
                                  color: car.isActive
                                      ? Colors.green
                                      : Colors.grey[600],
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 16),

                        // Car image
                        if (car.carImage != null) ...[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(car.carImage!,
                                height: 160,
                                width: double.infinity,
                                fit: BoxFit.cover),
                          ),
                          const SizedBox(height: 20),
                        ],

                        // Details grid
                        _detailRow('Seats', car.seaterCount ?? '—', Icons.airline_seat_recline_normal_outlined),
                        _detailRow('AC', car.isAc, Icons.ac_unit_outlined),
                        _detailRow('SOS', car.isSos, Icons.sos_outlined),
                        _detailRow('First Aid', car.isFirstAid, Icons.medical_services_outlined),
                        if (car.isActive && car.location != null)
                          _detailRow(
                              'Service Area',
                              '${car.location} · ${car.radius} km',
                              Icons.location_on_outlined),
                        if (car.otherFacilities != null &&
                            car.otherFacilities!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text('Other Facilities',
                              style: GoogleFonts.nunitoSans(
                                  fontWeight: FontWeight.w600, fontSize: 14,
                                  color: Colors.grey[600])),
                          const SizedBox(height: 4),
                          Text(car.otherFacilities!,
                              style: GoogleFonts.nunitoSans(fontSize: 15)),
                        ],
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),

                // Bottom action buttons
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        top: BorderSide(color: Colors.grey[200]!, width: 1)),
                  ),
                  child: Row(
                    children: [
                      // Delete
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            _showDeleteConfirm(index);
                          },
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                  color: Colors.red.withOpacity(0.4)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.delete_outline,
                                    color: Colors.red, size: 18),
                                const SizedBox(width: 6),
                                Text('Delete',
                                    style: GoogleFonts.oswald(
                                        color: Colors.red, fontSize: 15)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Edit
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            _openEditPage(index);
                          },
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1F1F1F),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.edit_outlined,
                                    color: Colors.white, size: 18),
                                const SizedBox(width: 6),
                                Text('Edit',
                                    style: GoogleFonts.oswald(
                                        color: Colors.white, fontSize: 15)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _detailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF2CA2A).withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: const Color(0xFFDDA200)),
          ),
          const SizedBox(width: 14),
          Text(label,
              style: GoogleFonts.nunitoSans(
                  fontSize: 14, color: Colors.grey[600])),
          const Spacer(),
          Text(value,
              style: GoogleFonts.nunitoSans(
                  fontSize: 15, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // ── Delete confirm ───────────────────────────────────────────────────────

  void _showDeleteConfirm(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Delete Car?", style: GoogleFonts.oswald()),
        content: Text(
            "Remove ${_listedCars[index].carNumber} from your listed vehicles? This cannot be undone."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              setState(() => _listedCars.removeAt(index));
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // ── Edit page ────────────────────────────────────────────────────────────

  void _openEditPage(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditCarScreen(
          car: _listedCars[index],
          onSave: (updated) {
            setState(() => _listedCars[index] = updated);
          },
        ),
      ),
    );
  }

  // ── Activation / Deactivation (unchanged) ───────────────────────────────

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
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          left: 20, right: 20, top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Go Online",
                style: GoogleFonts.oswald(
                    fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Set your service area for ${_listedCars[index].carNumber}",
                style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            SignupInput(
                hint: 'Current Location',
                icon: Icons.my_location,
                controller: _locController),
            const SizedBox(height: 15),
            SignupInput(
                hint: 'Service Radius (km)',
                icon: Icons.radar,
                controller: _radiusController,
                keyboardType: TextInputType.number),
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
        content: const Text(
            "This car will no longer be visible to customers for new bookings."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              setState(() => _listedCars[index].isActive = false);
              Navigator.pop(context);
            },
            child:
                const Text("Confirm Off", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // ── Build ────────────────────────────────────────────────────────────────

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
                    IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context)),
                    Text("My Listed Cars",
                        style: GoogleFonts.oswald(
                            fontSize: 26, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _listedCars.length,
                  itemBuilder: (context, index) {
                    final car = _listedCars[index];
                    return GestureDetector(
                      // ← tap card to open detail sheet
                      onTap: () => _showCarDetail(index),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: car.isActive
                                  ? const Color(0xFFF2CA2A)
                                  : Colors.black12,
                              width: 1.5),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10)
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: const Color(0xFFF2CA2A)
                                          .withOpacity(0.2),
                                      shape: BoxShape.circle),
                                  child: const Icon(Icons.directions_car,
                                      color: Color(0xFFDDA200)),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(car.carNumber,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18)),
                                      Text(car.model,
                                          style: TextStyle(
                                              color: Colors.grey[600])),
                                    ],
                                  ),
                                ),
                                // Stop tap propagation on the switch
                                GestureDetector(
                                  onTap: () {},
                                  behavior: HitTestBehavior.opaque,
                                  child: Switch(
                                    value: car.isActive,
                                    activeColor: const Color(0xFFF2CA2A),
                                    onChanged: (val) =>
                                        _handleToggle(index, val),
                                  ),
                                ),
                              ],
                            ),
                            if (car.isActive) ...[
                              const Divider(height: 24),
                              Row(
                                children: [
                                  const Icon(Icons.location_on,
                                      size: 16, color: Colors.green),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${car.location} (${car.radius} km range)",
                                    style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600),
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
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.black, width: 1.5),
                        ),
                        child:
                            const Icon(Icons.add, color: Colors.black, size: 28),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: ActionButton(
                        label: 'Refresh',
                        backgroundColor: const Color(0xFF1F1F1F),
                        textColor: Colors.white,
                        borderColor: const Color(0xFF1F1F1F),
                        onTap: () {},
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

  @override
  void dispose() {
    _locController.dispose();
    _radiusController.dispose();
    super.dispose();
  }
}

