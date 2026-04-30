import 'dart:convert';
import 'package:cabkaro/controllers/edit_profile_controller.dart';
import 'package:cabkaro/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:cabkaro/widgets/ToastWidget.dart';
import 'package:provider/provider.dart';
import '../../widgets/dashboard/dashboard_bottom_dock.dart';
import 'package:cabkaro/utils/constants.dart' as constant;

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EditProfileController>(context, listen: false).getUserData();
    });
  }

  // ──────────────────────────────────────────────
  // Bottom sheet — delegates picking to controller
  // ──────────────────────────────────────────────

  void _showImageSourceModal(EditProfileController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _ImageSourceBottomSheet(
        onCameraTap: () {
          Navigator.pop(ctx);
          controller.pickFromCamera(context);
        },
        onGalleryTap: () {
          Navigator.pop(ctx);
          controller.pickFromGallery(context);
        },
      ),
    );
  }

  // ──────────────────────────────────────────────
  // Build
  // ──────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFE8E8E8),
      body: SafeArea(
        child: Stack(
          children: [
            Consumer<EditProfileController>(
              builder: (context, controller, _) {
                return ListView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
                  children: [
                    // ── Back button ──
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

                    // ── Title ──
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

                    // ── Avatar ──
                    // Priority: 1) newly picked file, 2) base64 from server, 3) placeholder
                    Center(
                      child: GestureDetector(
                        onTap: () => _showImageSourceModal(controller),
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
                                  width: 2,
                                ),
                                color: Colors.white,
                              ),
                              child: ClipOval(child: _buildAvatar(controller)),
                            ),
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8C100),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
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

                    // ── Name ──
                    _EditProfileInput(
                      icon: Icons.person,
                      hintText: 'Name',
                      controller: controller.nameController,
                    ),
                    const SizedBox(height: 14),

                    // ── Phone ──
                    _EditProfileInput(
                      icon: Icons.call,
                      hintText: 'Phone',
                      controller: controller.phoneController,
                    ),
                    const SizedBox(height: 14),

                    // ── Gender selector ──
                    _GenderSelector(
                      selected: controller.selectedGender,
                      onChanged: controller.setGender,
                    ),
                    const SizedBox(height: 32),

                    // ── Update button ──
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: controller.isLoading
                            ? null
                            : () => controller.update(context),
                        child: Container(
                          width: 150,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: controller.isLoading
                                ? Colors.grey[400]
                                : const Color(0xFF2D2F35),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          alignment: Alignment.center,
                          child: controller.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
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
                  ],
                );
              },
            ),

            // ── Bottom dock ──
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

  // ── Avatar builder ────────────────────────────────────────────
  // 1. Newly picked file → Image.file
  // 2. Base64 from server → Image.memory
  // 3. Fallback → icon placeholder
  Widget _buildAvatar(EditProfileController controller) {
    if (controller.profileImageFile != null) {
      return Image.file(
        controller.profileImageFile!,
        fit: BoxFit.cover,
        width: 140,
        height: 140,
      );
    } else {
      return Image.network(
        '${constant.imgUrl}/${Provider.of<UserController>(context, listen: true).userImg}',
        fit: BoxFit.cover,
        width: 140,
        height: 140,
      );
    }
  }

  
}

// ──────────────────────────────────────────────────────────────
// Gender Selector Widget
// ──────────────────────────────────────────────────────────────

class _GenderSelector extends StatelessWidget {
  const _GenderSelector({required this.selected, required this.onChanged});

  final String selected;
  final ValueChanged<String> onChanged;

  static const _options = [
    ('male', Icons.male_rounded, 'Male'),
    ('female', Icons.female_rounded, 'Female'),
    ('others', Icons.transgender_rounded, 'Others'),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<EditProfileController>(
      builder: (_, controller, __) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 10),
              child: Text(
                'Gender',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF666666),
                ),
              ),
            ),
            Row(
              children: _options.map((opt) {
                final value = opt.$1;
                final icon = opt.$2;
                final label = opt.$3;
                final isSelected = controller.selectedGender == value;

                return Expanded(
                  child: GestureDetector(
                    onTap: () => onChanged(value),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: EdgeInsets.only(
                        right: value != 'others' ? 10 : 0,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF2D2F35)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF2D2F35)
                              : const Color(0xFFCCCCCC),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            icon,
                            size: 22,
                            color: isSelected
                                ? const Color(0xFFF8C100)
                                : const Color(0xFF999999),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF666666),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Bottom Sheet
// ──────────────────────────────────────────────────────────────

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
            "Choose how you'd like to add your photo",
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

// ──────────────────────────────────────────────────────────────
// Input Widget
// ──────────────────────────────────────────────────────────────

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
        border: Border.all(color: const Color(0xFFCCCCCC), width: 1.5),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
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
