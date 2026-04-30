// ignore_for_file: deprecated_member_use
<<<<<<< HEAD

import 'dart:io';
import 'package:cabkaro/screens/common/car_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/gradient_background.dart';
import '../../widgets/action_button.dart';
import '../../widgets/signup_input.dart';
=======
import 'package:cabkaro/controllers/vendor_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cabkaro/widgets/gradient_background.dart';
import 'package:cabkaro/widgets/action_button.dart';
import 'package:cabkaro/widgets/signup_input.dart';
>>>>>>> a64f8e0 (Edit vendor and user profile)

class DriverVendorDetailsScreen extends StatefulWidget {
  const DriverVendorDetailsScreen({super.key});

  @override
  State<DriverVendorDetailsScreen> createState() =>
      _DriverVendorDetailsScreenState();
}

class _DriverVendorDetailsScreenState extends State<DriverVendorDetailsScreen> {
<<<<<<< HEAD
  final _formKey = GlobalKey<FormState>();

  // Selection state
  String userRole = "Driver";

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController carNumberController = TextEditingController();
  final TextEditingController facilitiesController = TextEditingController();

  File? profileImage;
  File? carImage;

  String isAc = "No";
  String isSos = "No";
  String isFirstAid = "No";

  Future<void> _pickImage(bool isProfile) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (isProfile) {
          profileImage = File(pickedFile.path);
        } else {
          carImage = File(pickedFile.path);
        }
      });
    }
  }

  Widget _buildRoleBox(String role, IconData icon) {
    bool isSelected = userRole == role;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => userRole = role),
=======
  Widget _buildRoleBox(String role, IconData icon) {
    bool isSelected =
        Provider.of<VendorController>(context, listen: true).vendorRole == role;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Provider.of<VendorController>(
            context,
            listen: false,
          ).setVendorRole(role);
        },
>>>>>>> a64f8e0 (Edit vendor and user profile)
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFF2CA2A) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.black : Colors.grey.shade300,
              width: 2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? Colors.black : Colors.grey),
              const SizedBox(height: 1),
              Text(
                role,
                style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.black : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

<<<<<<< HEAD

=======
>>>>>>> a64f8e0 (Edit vendor and user profile)
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.06;

<<<<<<< HEAD


=======
>>>>>>> a64f8e0 (Edit vendor and user profile)
    return Scaffold(
      body: GradientBackground(
        showGlow: false,
        child: SafeArea(
          child: Form(
<<<<<<< HEAD
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 20,
              ),
              children: [
                Text(
                  "Drive a Journey - $userRole",
                  style: GoogleFonts.oswald(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    _buildRoleBox("Driver", Icons.person),
                    const SizedBox(width: 16),
                    _buildRoleBox("Agency", Icons.business),
                  ],
                ),

                const SizedBox(height: 30),

                Center(
                  child: GestureDetector(
                    onTap: () => _pickImage(true),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: profileImage != null
                          ? FileImage(profileImage!)
                          : null,
                      child: profileImage == null
                          ? const Icon(
                              Icons.add_a_photo,
                              size: 30,
                              color: Colors.black54,
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    "Upload Profile Image",
                    style: GoogleFonts.nunitoSans(fontSize: 14),
                  ),
                ),

                const SizedBox(height: 20),
                SignupInput(
                  hint: 'Full Name',
                  icon: Icons.person,
                  controller: nameController,
                ),
                const SizedBox(height: 15),
                SignupInput(
                  hint: 'Phone Number',
                  icon: Icons.phone,
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 15),

                const SizedBox(height: 330),
                ActionButton(
                  label: 'Register Journey',
                  backgroundColor: const Color(0xFFF2CA2A),
                  textColor: Colors.black,
                  borderColor: const Color(0xFF1F1F1F),
                  // onTap: () {
                  //   if (_formKey.currentState!.validate()) {}
                  // },
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  CarDetailsScreenScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
=======
            key: Provider.of<VendorController>(
              context,
              listen: false,
            ).vendorDetailsformKey,
            child: Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 20,
                ),
                children: [
                  Text(
                    "Drive a Journey - ${Provider.of<VendorController>(context, listen: true).vendorRole}",
                    style: GoogleFonts.oswald(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
              
                  Row(
                    children: [
                      _buildRoleBox("Individual", Icons.person),
                      const SizedBox(width: 16),
                      _buildRoleBox("Agency", Icons.business),
                    ],
                  ),
              
                  const SizedBox(height: 30),
                  Center(
                    child: GestureDetector(
                      onTap: () => Provider.of<VendorController>(
                        context,
                        listen: false,
                      ).pickImage(true),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[300],
                        backgroundImage:
                            Provider.of<VendorController>(
                                  context,
                                  listen: false,
                                ).profileImage !=
                                null
                            ? FileImage(
                                Provider.of<VendorController>(
                                  context,
                                  listen: false,
                                ).profileImage!,
                              )
                            : null,
                        child:
                            Provider.of<VendorController>(
                                  context,
                                  listen: false,
                                ).profileImage ==
                                null
                            ? const Icon(
                                Icons.add_a_photo,
                                size: 30,
                                color: Colors.black54,
                              )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      "Upload Profile Image",
                      style: GoogleFonts.nunitoSans(fontSize: 14),
                    ),
                  ),
              
                  const SizedBox(height: 20),
                  SignupInput(
                    hint: 'Full Name',
                    icon: Icons.person,
                    controller: Provider.of<VendorController>(
                      context,
                      listen: false,
                    ).nameController,
                  ),
                  const SizedBox(height: 15),
                  SignupInput(
                    hint: 'Phone Number',
                    icon: Icons.phone,
                    controller: Provider.of<VendorController>(
                      context,
                      listen: false,
                    ).phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 15),
                  ActionButton(
                    label: 'Register Journey',
                    backgroundColor: const Color(0xFFF2CA2A),
                    textColor: Colors.black,
                    borderColor: const Color(0xFF1F1F1F),
                    onTap: () {
                      Provider.of<VendorController>(
                        context,
                        listen: false,
                      ).updateVendorDetails(context);
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
>>>>>>> a64f8e0 (Edit vendor and user profile)
            ),
          ),
        ),
      ),
    );
  }
}
