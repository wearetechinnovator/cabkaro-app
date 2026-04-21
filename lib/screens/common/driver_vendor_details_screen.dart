import 'dart:io';
import 'package:cabkaro/screens/common/car_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/gradient_background.dart';
import '../../widgets/action_button.dart';
import '../../widgets/signup_input.dart';

class DriverVendorDetailsScreen extends StatefulWidget {
  const DriverVendorDetailsScreen({super.key});

  @override
  State<DriverVendorDetailsScreen> createState() =>
      _DriverVendorDetailsScreenState();
}

class _DriverVendorDetailsScreenState extends State<DriverVendorDetailsScreen> {
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

  Widget _buildRadioButton(
    String title,
    String currentVal,
    Function(String?) onChange,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.nunitoSans(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text("Yes"),
                value: "Yes",
                groupValue: currentVal,
                activeColor: const Color(0xFFF2CA2A),
                onChanged: onChange,
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text("No"),
                value: "No",
                groupValue: currentVal,
                activeColor: const Color(0xFFF2CA2A),
                onChanged: onChange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.06;



    return Scaffold(
      body: GradientBackground(
        showGlow: false,
        child: SafeArea(
          child: Form(
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
            ),
          ),
        ),
      ),
    );
  }
}
