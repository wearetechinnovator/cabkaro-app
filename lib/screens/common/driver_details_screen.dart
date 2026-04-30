<<<<<<< HEAD
// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:cabkaro/screens/driver/driver_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/gradient_background.dart';
import '../../widgets/action_button.dart';
import '../../widgets/signup_input.dart';

class DriverData {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  File? driverImage;

  void dispose() {
    nameController.dispose();
    phoneController.dispose();
  }
}
=======
import 'package:cabkaro/controllers/driver_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cabkaro/widgets/gradient_background.dart';
import 'package:cabkaro/widgets/action_button.dart';
import 'package:cabkaro/widgets/signup_input.dart';
>>>>>>> a64f8e0 (Edit vendor and user profile)

class DriverDetailsScreen extends StatefulWidget {
  const DriverDetailsScreen({super.key});

  @override
  State<DriverDetailsScreen> createState() => _DriverDetailsScreenState();
}

class _DriverDetailsScreenState extends State<DriverDetailsScreen> {
<<<<<<< HEAD
  final List<DriverData> _drivers = [DriverData()];

  void _addNewDriver() {
    setState(() {
      _drivers.add(DriverData());
    });
  }

  void _removeDriver(int index) {
    if (_drivers.length > 1) {
      setState(() {
        _drivers[index].dispose();
        _drivers.removeAt(index);
      });
    }
  }

  Future<void> _pickImage(int index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _drivers[index].driverImage = File(pickedFile.path);
      });
    }
  }

  Widget _buildDriverCard(int index) {
    final driver = _drivers[index];
=======
  Widget _buildDriverCard(int index) {
    final driver = Provider.of<DriverDetailsController>(
      context,
      listen: false,
    ).drivers[index];
>>>>>>> a64f8e0 (Edit vendor and user profile)
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            // ignore: duplicate_ignore
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
<<<<<<< HEAD
          )
=======
          ),
>>>>>>> a64f8e0 (Edit vendor and user profile)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Driver ${index + 1}",
                style: GoogleFonts.oswald(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
<<<<<<< HEAD
              if (_drivers.length > 1)
                IconButton(
                  icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
                  onPressed: () => _removeDriver(index),
=======
              if (Provider.of<DriverDetailsController>(
                    context,
                    listen: true,
                  ).drivers.length >
                  1)
                IconButton(
                  icon: const Icon(
                    Icons.delete_forever,
                    color: Colors.redAccent,
                  ),
                  onPressed: () => Provider.of<DriverDetailsController>(
                    context,
                    listen: false,
                  ).removeDriver(index),
>>>>>>> a64f8e0 (Edit vendor and user profile)
                ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 15),
          Center(
            child: GestureDetector(
<<<<<<< HEAD
              onTap: () => _pickImage(index),
=======
              onTap: () => Provider.of<DriverDetailsController>(
                context,
                listen: false,
              ).pickImage(index),
>>>>>>> a64f8e0 (Edit vendor and user profile)
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: const Color.fromARGB(25, 242, 202, 42),
                    backgroundImage: driver.driverImage != null
                        ? FileImage(driver.driverImage!)
                        : null,
                    child: driver.driverImage == null
<<<<<<< HEAD
                        ? const Icon(Icons.person, size: 50, color: Colors.black54)
=======
                        ? const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.black54,
                          )
>>>>>>> a64f8e0 (Edit vendor and user profile)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF2CA2A),
                        shape: BoxShape.circle,
                      ),
<<<<<<< HEAD
                      child: const Icon(Icons.camera_alt, size: 20, color: Colors.black),
=======
                      child: const Icon(
                        Icons.camera_alt,
                        size: 20,
                        color: Colors.black,
                      ),
>>>>>>> a64f8e0 (Edit vendor and user profile)
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 25),
          SignupInput(
            hint: 'Driver Name',
            icon: Icons.person_outline,
            controller: driver.nameController,
          ),
          const SizedBox(height: 15),
          SignupInput(
            hint: 'Phone Number',
            icon: Icons.phone_android,
            controller: driver.phoneController,
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }

  @override
<<<<<<< HEAD
  Widget build(BuildContext context) {
    
=======
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DriverDetailsController>(
        context,
        listen: false,
      ).addNewDriver();
    });
  }

  @override
  Widget build(BuildContext context) {
>>>>>>> a64f8e0 (Edit vendor and user profile)
    return Scaffold(
      body: GradientBackground(
        showGlow: false,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      "Driver Details",
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
<<<<<<< HEAD
                  itemCount: _drivers.length,
=======
                  itemCount: Provider.of<DriverDetailsController>(
                    context,
                    listen: true,
                  ).drivers.length,
>>>>>>> a64f8e0 (Edit vendor and user profile)
                  itemBuilder: (context, index) => _buildDriverCard(index),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(0, 255, 255, 255),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
<<<<<<< HEAD
                    )
=======
                    ),
>>>>>>> a64f8e0 (Edit vendor and user profile)
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ActionButton(
                        label: 'Save All Details',
                        backgroundColor: const Color(0xFF1F1F1F),
                        textColor: Colors.white,
                        borderColor: const Color(0xFF1F1F1F),
                        onTap: () {
<<<<<<< HEAD
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const DriverHomeScreen(),
                                ),
                              );
                            },
=======
                          Provider.of<DriverDetailsController>(
                            context,
                            listen: false,
                          ).saveDriver(context);
                        },
>>>>>>> a64f8e0 (Edit vendor and user profile)
                      ),
                    ),
                    const SizedBox(width: 15),
                    GestureDetector(
<<<<<<< HEAD
                      onTap: _addNewDriver,
=======
                      onTap: Provider.of<DriverDetailsController>(
                        context,
                        listen: false,
                      ).addNewDriver,
>>>>>>> a64f8e0 (Edit vendor and user profile)
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2CA2A),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.black, width: 1.5),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.black,
                          size: 28,
                        ),
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
<<<<<<< HEAD
    for (var driver in _drivers) {
=======
    for (var driver in Provider.of<DriverDetailsController>(
      context,
      listen: false,
    ).drivers) {
>>>>>>> a64f8e0 (Edit vendor and user profile)
      driver.dispose();
    }
    super.dispose();
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> a64f8e0 (Edit vendor and user profile)
