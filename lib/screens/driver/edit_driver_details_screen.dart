import 'dart:io';
import 'package:cabkaro/screens/driver/listed_driver_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/gradient_background.dart';
import '../../widgets/action_button.dart';
import '../../widgets/signup_input.dart';

class EditDriverScreen extends StatefulWidget {
  final DriverListData driver;
  final void Function(DriverListData updated) onSave;

  const EditDriverScreen(
      {super.key, required this.driver, required this.onSave});

  @override
  State<EditDriverScreen> createState() => _EditDriverScreenState();
}

class _EditDriverScreenState extends State<EditDriverScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  File? _driverImage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.driver.name);
    _phoneController = TextEditingController(text: widget.driver.phone);
    _driverImage = widget.driver.driverImage;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _driverImage = File(picked.path));
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
                    Text("Edit Driver",
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
                        const SizedBox(height: 10),

                        // Avatar picker
                        Center(
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 55,
                                  backgroundColor:
                                      const Color.fromARGB(25, 242, 202, 42),
                                  backgroundImage: _driverImage != null
                                      ? FileImage(_driverImage!)
                                      : null,
                                  child: _driverImage == null
                                      ? const Icon(Icons.person,
                                          size: 55, color: Colors.black54)
                                      : null,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFF2CA2A),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.camera_alt,
                                        size: 20, color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        SignupInput(
                          hint: 'Driver Name',
                          icon: Icons.person_outline,
                          controller: _nameController,
                        ),
                        const SizedBox(height: 16),
                        SignupInput(
                          hint: 'Phone Number',
                          icon: Icons.phone_android,
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
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
                    final updated = DriverListData(
                      id: widget.driver.id,
                      name: _nameController.text.trim(),
                      phone: _phoneController.text.trim(),
                      isActive: widget.driver.isActive,
                      driverImage: _driverImage,
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