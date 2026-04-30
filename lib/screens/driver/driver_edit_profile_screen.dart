// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:cabkaro/controllers/driver/driver_edit_profile_controller.dart';
import 'package:cabkaro/controllers/vendor_controller.dart';
import 'package:cabkaro/services/image_picker_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/driver/driver_bottom_dock.dart';
import 'package:cabkaro/utils/constants.dart' as constant;

class DriverEditProfileScreen extends StatefulWidget {
  const DriverEditProfileScreen({super.key});

  @override
  State<DriverEditProfileScreen> createState() =>
      _DriverEditProfileScreenState();
}

class _DriverEditProfileScreenState extends State<DriverEditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ChangeNotifierProvider(
      create: (_) => DriverEditProfileController()..getvendorData(),
      child: Consumer<VendorController>(
        builder: (context, controller, _) {
          return Scaffold(
            backgroundColor: const Color(0xFFE8E8E8),
            body: SafeArea(
              child: Form(
                key: Provider.of<VendorController>(
                  context,
                  listen: false,
                ).vendorDetailsformKey,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
                  children: [
                    // ── Back Button ────────────────────────
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
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Title ──────────────────────────────
                    const Center(
                      child: Text(
                        'Edit Driver Profile',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D2F35),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Profile Avatar ─────────────────────
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
                              : NetworkImage('${constant.imgUrl}/${Provider.of<VendorController>(
                                    context,
                                    listen: false,
                                  ).vendorImg}'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Center(
                      child: Text(
                        'Tap photo to change',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF999999),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Form Fields ────────────────────────
                    _EditProfileInput(
                      icon: Icons.person,
                      hintText: 'Name',
                      controller: controller.nameController,
                    ),
                    const SizedBox(height: 14),

                    _EditProfileInput(
                      icon: Icons.call,
                      hintText: 'Phone',
                      controller: controller.phoneController,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 32),

                    // ── Update Button ──────────────────────
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: controller.isLoading
                            ? null
                            : () => controller.updateVendorDetails(context, isEdit: true),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2D2F35),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          alignment: Alignment.center,
                          child: controller.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Color(0xFFF8C100),
                                  ),
                                )
                              : const Text(
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
                    SizedBox(height: MediaQuery.of(context).size.height * 0.3,),
                     const DriverBottomDock(),
  
                  ],
                ),

                // ── Driver Bottom Dock ─────────────────────
              ),
            ),
          );
        },
      ),
    );
  }

  /// Shows: newly picked file > existing base64 from server > fallback icon
  Widget _buildProfileImage(DriverEditProfileController controller) {
    // 1. Newly picked local file
    if (controller.profileImageFile != null) {
      return Image.file(
        controller.profileImageFile!,
        fit: BoxFit.cover,
        width: 140,
        height: 140,
      );
    }

    // 2. Existing image from server (base64 string)
    if (controller.profileImageBase64.isNotEmpty) {
      try {
        final bytes = base64Decode(controller.profileImageBase64);
        return Image.memory(bytes, fit: BoxFit.cover, width: 140, height: 140);
      } catch (_) {
        // fall through to default
      }
    }

    // 3. Fallback — default avatar asset or icon
    return Image.asset(
      'assets/images/avatar.png',
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: const Color(0xFFF0F0F0),
        child: const Icon(Icons.person, size: 80, color: Color(0xFF2D2F35)),
      ),
    );
  }
}

// ── Reusable Input Widget ──────────────────────────────────────

class _EditProfileInput extends StatelessWidget {
  const _EditProfileInput({
    required this.icon,
    required this.hintText,
    required this.controller,
    this.keyboardType,
  });

  final IconData icon;
  final String hintText;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFCCCCCC), width: 1.5),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFF999999), fontSize: 14),
          prefixIcon: Icon(icon, color: const Color(0xFF2D2F35), size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
        style: const TextStyle(fontSize: 14, color: Color(0xFF2D2F35)),
      ),
    );
  }
}

// ── Image Source Bottom Sheet ──────────────────────────────────

class _ImageSourceBottomSheet extends StatelessWidget {
  const _ImageSourceBottomSheet({
    required this.onCameraTap,
    required this.onGalleryTap,
  });

  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFDDDDDD),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Update Profile Photo',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D2F35),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Choose how you\'d like to add your photo',
            style: TextStyle(fontSize: 13, color: Color(0xFF999999)),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _SourceOption(
                  icon: Icons.camera_alt_rounded,
                  label: 'Camera',
                  onTap: onCameraTap,
                ),
                _SourceOption(
                  icon: Icons.photo_library_rounded,
                  label: 'Gallery',
                  onTap: onGalleryTap,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2D2F35),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _SourceOption extends StatelessWidget {
  const _SourceOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFF8C100).withOpacity(0.4),
                width: 1.5,
              ),
            ),
            child: Icon(icon, size: 32, color: const Color(0xFFF8C100)),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF2D2F35),
            ),
          ),
        ],
      ),
    );
  }
}
