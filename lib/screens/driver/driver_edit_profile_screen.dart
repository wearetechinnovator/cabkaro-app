// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:cabkaro/controllers/driver/driver_signup_controller.dart';
import 'package:cabkaro/providers/location_provider.dart';
import 'package:cabkaro/screens/user/map_picker_screen.dart';
import 'package:cabkaro/widgets/ToastWidget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../widgets/driver/driver_bottom_dock.dart';

class DriverEditProfileScreen extends StatefulWidget {
  const DriverEditProfileScreen({super.key});

  @override
  State<DriverEditProfileScreen> createState() =>
      _DriverEditProfileScreenState();
}

class _DriverEditProfileScreenState extends State<DriverEditProfileScreen> {
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  // ── Permission helpers ─────────────────────────────────────
  Future<bool> _requestGalleryPermission() async {
    final status = await Permission.photos.request();
    if (status.isPermanentlyDenied) {
      if (!mounted) return false;
      _showPermissionDeniedDialog('Photo Library');
      return false;
    }
    return status.isGranted;
  }

  void _showPermissionDeniedDialog(String permissionName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('$permissionName Permission Required'),
        content: Text(
          '$permissionName access was permanently denied. '
          'Please enable it in your device Settings to continue.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              openAppSettings();
            },
            child: const Text(
              'Open Settings',
              style: TextStyle(color: Color(0xFFF8C100)),
            ),
          ),
        ],
      ),
    );
  }

  // ── Image Pickers ──────────────────────────────────────────
  Future<void> _pickFromCamera() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) setState(() => _profileImage = File(photo.path));
    } catch (e) {
      ToastWidget.show(context,
          message: 'Could not open camera.', type: ToastType.error);
    }
  }

  Future<void> _pickFromGallery() async {
    final granted = await _requestGalleryPermission();
    if (!granted) return;
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 800,
      );
      if (image != null) setState(() => _profileImage = File(image.path));
    } catch (e) {
      if (!mounted) return;
      ToastWidget.show(context,
          message: 'Could not pick image. Try again.', type: ToastType.error);
    }
  }

  void _showImageSourceModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _ImageSourceBottomSheet(
        onCameraTap: () {
          Navigator.pop(ctx);
          _pickFromCamera();
        },
        onGalleryTap: () {
          Navigator.pop(ctx);
          _pickFromGallery();
        },
      ),
    );
  }

  // ── Dashed container (matches signup screen style) ─────────

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final provider =
        Provider.of<DriverSignupController>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFFE8E8E8),
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
              children: [
                // ── Back Button ──────────────────────────────
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
                      child: const Icon(Icons.arrow_back,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ── Title ────────────────────────────────────
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

                // ── Profile Avatar ───────────────────────────
                Center(
                  child: GestureDetector(
                    onTap: _showImageSourceModal,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: const Color(0xFFF8C100), width: 2),
                            color: Colors.white,
                          ),
                          child: ClipOval(
                            child: _profileImage != null
                                ? Image.file(_profileImage!,
                                    fit: BoxFit.cover,
                                    width: 140,
                                    height: 140)
                                : Image.asset(
                                    'assets/images/avatar.png',
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) => Container(
                                      color: const Color(0xFFF0F0F0),
                                      child: const Icon(Icons.person,
                                          size: 80, color: Color(0xFF2D2F35)),
                                    ),
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
                          child: const Icon(Icons.camera_alt,
                              color: Color(0xFF2D2F35), size: 20),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    'Tap photo to change',
                    style:
                        TextStyle(fontSize: 12, color: Color(0xFF999999)),
                  ),
                ),
                const SizedBox(height: 24),

                // ── Form Fields ──────────────────────────────
                _EditProfileInput(
                  icon: Icons.person,
                  hintText: 'Name',
                  controller: provider.nameController,
                ),
                const SizedBox(height: 14),
                _EditProfileInput(
                  icon: Icons.email,
                  hintText: 'Email',
                  controller: provider.emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 14),
                _EditProfileInput(
                  icon: Icons.call,
                  hintText: 'Phone',
                  controller: provider.phoneController,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 14),
                _EditProfileInput(
                  icon: Icons.description,
                  hintText: 'Driving License',
                  controller: provider.licenseController,
                ),
                const SizedBox(height: 14),
                _EditProfileInput(
                  icon: Icons.credit_card,
                  hintText: 'Aadhar Number',
                  controller: provider.aadharController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 14),
                _EditProfileInput(
                  icon: Icons.car_repair,
                  hintText: 'Vehicle Number',
                  controller: provider.vehicleNumberController,
                ),
                const SizedBox(height: 14),

                // ── Gender Dropdown ──────────────────────────
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color(0xFFCCCCCC), width: 1.5),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: provider.selectedGender,
                      isExpanded: true,
                      hint: const Row(
                        children: [
                          SizedBox(width: 8),
                          Icon(Icons.transgender,
                              color: Color(0xFF2D2F35), size: 20),
                          SizedBox(width: 8),
                          Text('Gender',
                              style: TextStyle(
                                  color: Color(0xFF999999), fontSize: 14)),
                        ],
                      ),
                      items: provider.genderOptions
                          .map((g) => DropdownMenuItem(
                                value: g,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Text(g,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF2D2F35))),
                                ),
                              ))
                          .toList(),
                      onChanged: (value) =>
                          setState(() => provider.selectedGender = value),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // ── Service Radius + Location ────────────────
                Row(
                  children: [
                    Expanded(
                      child: _EditProfileInput(
                        icon: Icons.social_distance_outlined,
                        hintText: 'Service radius (km)',
                        controller: provider.radiusController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const MapPickerScreen(isPickup: true),
                          ),
                        );
                        if (mounted) {
                          final loc = context
                              .read<LocationProvider>()
                              .pickupLocation;
                          if (loc != null) {
                            setState(() => provider.selectedLocation = loc);
                          }
                        }
                      },
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: const Color(0xFFCCCCCC), width: 1.5),
                          color: Colors.white,
                        ),
                        child: Icon(
                          provider.selectedLocation != null
                              ? Icons.location_on
                              : Icons.location_on_outlined,
                          color: provider.selectedLocation != null
                              ? const Color(0xFFF8C100)
                              : const Color(0xFF2D2F35),
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),

                if (provider.selectedLocation != null) ...[
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle,
                            size: 13, color: Colors.green),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            provider.selectedLocation!,
                            style: const TextStyle(
                                fontSize: 12, color: Color(0xFF4C473F)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 32),

                // ── Update Button ────────────────────────────
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      // call your driver update method here
                      // e.g. provider.updateDriverProfile(context);
                    },
                    child: Container(
                      width: 160,
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

            // ── Driver Bottom Dock ───────────────────────────
            Positioned(
              left: screenWidth * 0.07,
              right: screenWidth * 0.07,
              bottom: 14,
              child: const DriverBottomDock(),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Reusable Input Widget (same as user edit profile) ──────────

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
          hintStyle:
              const TextStyle(color: Color(0xFF999999), fontSize: 14),
          prefixIcon: Icon(icon, color: const Color(0xFF2D2F35), size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
        style:
            const TextStyle(fontSize: 14, color: Color(0xFF2D2F35)),
      ),
    );
  }
}

// ── Bottom Sheet (reused from user edit profile) ───────────────

class _ImageSourceBottomSheet extends StatelessWidget {
  const _ImageSourceBottomSheet(
      {required this.onCameraTap, required this.onGalleryTap});

  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
                color: const Color(0xFFDDDDDD),
                borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 20),
          const Text('Update Profile Photo',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D2F35))),
          const SizedBox(height: 6),
          const Text('Choose how you\'d like to add your photo',
              style: TextStyle(fontSize: 13, color: Color(0xFF999999))),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _SourceOption(
                    icon: Icons.camera_alt_rounded,
                    label: 'Camera',
                    onTap: onCameraTap),
                _SourceOption(
                    icon: Icons.photo_library_rounded,
                    label: 'Gallery',
                    onTap: onGalleryTap),
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
                  borderRadius: BorderRadius.circular(16)),
              alignment: Alignment.center,
              child: const Text('Cancel',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2D2F35))),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _SourceOption extends StatelessWidget {
  const _SourceOption(
      {required this.icon, required this.label, required this.onTap});

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
                  // ignore: deprecated_member_use
                  color: const Color(0xFFF8C100).withOpacity(0.4), width: 1.5),
            ),
            child: Icon(icon, size: 32, color: const Color(0xFFF8C100)),
          ),
          const SizedBox(height: 8),
          Text(label,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2D2F35))),
        ],
      ),
    );
  }
}