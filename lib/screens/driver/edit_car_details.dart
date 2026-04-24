import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'listed_car_deatils_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/gradient_background.dart';
import '../../widgets/action_button.dart';
import '../../widgets/signup_input.dart';

class EditCarScreen extends StatefulWidget {
  final CarData car;
  final void Function(CarData updated) onSave;

  const EditCarScreen({super.key, required this.car, required this.onSave});

  @override
  State<EditCarScreen> createState() => _EditCarScreenState();
}

class _EditCarScreenState extends State<EditCarScreen> {
  late TextEditingController _carNumberController;
  late TextEditingController _modelController;
  late TextEditingController _facilitiesController;
  late String _isAc;
  late String _isSos;
  late String _isFirstAid;
  late String? _seaterCount;
  File? _carImage;

  final _seaterOptions = ['2', '4', '5', '6', '7', '8', '10', '12+'];

  @override
  void initState() {
    super.initState();
    _carNumberController =
        TextEditingController(text: widget.car.carNumber);
    _modelController = TextEditingController(text: widget.car.model);
    _facilitiesController =
        TextEditingController(text: widget.car.otherFacilities ?? '');
    _isAc = widget.car.isAc;
    _isSos = widget.car.isSos;
    _isFirstAid = widget.car.isFirstAid;
    _seaterCount = widget.car.seaterCount;
    _carImage = widget.car.carImage;
  }

  @override
  void dispose() {
    _carNumberController.dispose();
    _modelController.dispose();
    _facilitiesController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _carImage = File(picked.path));
  }

  Widget _buildRadio(String title, String current, Function(String?) onChange) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: GoogleFonts.nunitoSans(
                fontWeight: FontWeight.w600, fontSize: 16)),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text("Yes"),
                value: "Yes",
                groupValue: current,
                activeColor: const Color(0xFFF2CA2A),
                onChanged: onChange,
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text("No"),
                value: "No",
                groupValue: current,
                activeColor: const Color(0xFFF2CA2A),
                onChanged: onChange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSeaterSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Number of Seats",
            style: GoogleFonts.nunitoSans(
                fontWeight: FontWeight.w600, fontSize: 16)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _seaterOptions.map((seat) {
            final isSelected = _seaterCount == seat;
            return GestureDetector(
              onTap: () => setState(() => _seaterCount = seat),
              child: Container(
                width: 52,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFF2CA2A)
                      : const Color.fromARGB(25, 242, 202, 42),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.grey[300]!,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Center(
                  child: Text(seat,
                      style: GoogleFonts.oswald(
                          fontSize: 14,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: Colors.black)),
                ),
              ),
            );
          }).toList(),
        ),
      ],
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
              // App bar
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context)),
                    Text("Edit Vehicle",
                        style: GoogleFonts.oswald(
                            fontSize: 26, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),

              // Form
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.black12),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4))
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SignupInput(
                          hint: 'Car Number',
                          icon: Icons.directions_car,
                          controller: _carNumberController,
                        ),
                        const SizedBox(height: 16),
                        SignupInput(
                          hint: 'Car Model',
                          icon: Icons.car_repair,
                          controller: _modelController,
                        ),
                        const SizedBox(height: 20),
                        _buildSeaterSelector(),
                        const SizedBox(height: 20),

                        // Car image
                        Text("Car Image",
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.w600, fontSize: 16)),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            height: 160,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(25, 242, 202, 42),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: _carImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(_carImage!,
                                        fit: BoxFit.cover),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.cloud_upload_outlined,
                                          size: 40, color: Colors.black54),
                                      const SizedBox(height: 8),
                                      Text("Upload Photo",
                                          style: GoogleFonts.nunitoSans(
                                              color: Colors.black54)),
                                    ],
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildRadio("Is AC Available?", _isAc,
                            (v) => setState(() => _isAc = v!)),
                        _buildRadio("Is SOS Facility?", _isSos,
                            (v) => setState(() => _isSos = v!)),
                        _buildRadio("Is First Aid Kit?", _isFirstAid,
                            (v) => setState(() => _isFirstAid = v!)),
                        const SizedBox(height: 15),
                        Text("Other Facilities",
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.w600, fontSize: 16)),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _facilitiesController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: "E.g. WiFi, Water Bottles, Phone Charger",
                            fillColor: const Color.fromARGB(46, 242, 202, 42),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),

              // Save button
              Padding(
                padding: const EdgeInsets.all(20),
                child: ActionButton(
                  label: 'Save Changes',
                  backgroundColor: const Color(0xFF1F1F1F),
                  textColor: Colors.white,
                  borderColor: const Color(0xFF1F1F1F),
                  onTap: () {
                    final updated = CarData(
                      id: widget.car.id,
                      carNumber: _carNumberController.text.trim(),
                      model: _modelController.text.trim(),
                      isActive: widget.car.isActive,
                      location: widget.car.location,
                      radius: widget.car.radius,
                      seaterCount: _seaterCount,
                      isAc: _isAc,
                      isSos: _isSos,
                      isFirstAid: _isFirstAid,
                      otherFacilities: _facilitiesController.text.trim(),
                      carImage: _carImage,
                    );
                    widget.onSave(updated);
                    Navigator.pop(context);
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