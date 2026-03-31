import 'package:flutter/material.dart';

import '../../widgets/dashboard/dashboard_bottom_dock.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: 'User1257');
    emailController = TextEditingController(text: 'user@example.com');
    phoneController = TextEditingController(text: '+1 234 567 8900');
    addressController = TextEditingController(text: '123 Main Street');
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFE8E8E8),
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
              children: [
                // Back Button
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8C100),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color.fromARGB(255, 255, 255, 255),
                        size: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                const Center(
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D2F35),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Profile Avatar
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFF8C100),
                            width: 1,
                          ),
                          color: Colors.white,
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/avatar.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: const Color(0xFFF0F0F0),
                                child: const Icon(
                                  Icons.person,
                                  size: 80,
                                  color: Color(0xFF2D2F35),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8C100),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Color(0xFF2D2F35),
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Name Input
                _EditProfileInput(
                  icon: Icons.person,
                  hintText: 'Name',
                  controller: nameController,
                ),
                const SizedBox(height: 14),

                // Email Input
                _EditProfileInput(
                  icon: Icons.mail,
                  hintText: 'Email',
                  controller: emailController,
                ),
                const SizedBox(height: 14),

                // Phone Input
                _EditProfileInput(
                  icon: Icons.call,
                  hintText: 'Phone',
                  controller: phoneController,
                ),
                const SizedBox(height: 14),

                // Address Input
                _EditProfileInput(
                  icon: Icons.location_on,
                  hintText: 'Address',
                  controller: addressController,
                ),
                const SizedBox(height: 32),

                // Update Profile Button
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Profile Updated')),
                      );
                    },
                    child: Container(
                      width: 150,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D2F35),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Update Profile',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Bottom Dock
            Positioned(
              left: screenWidth * 0.07,
              right: screenWidth * 0.07,
              bottom: 14,
              child: const DashboardBottomDock(),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditProfileInput extends StatelessWidget {
  const _EditProfileInput({
    required this.icon,
    required this.hintText,
    required this.controller,
  });

  final IconData icon;
  final String hintText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFCCCCCC),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFF999999),
            fontSize: 14,
          ),
          prefixIcon: Icon(
            icon,
            color: const Color(0xFF2D2F35),
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF2D2F35),
        ),
      ),
    );
  }
}
