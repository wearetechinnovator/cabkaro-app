<<<<<<< HEAD
import 'dart:io';
import 'package:cabkaro/controllers/edit_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cabkaro/widgets/ToastWidget.dart';
import 'package:provider/provider.dart';
import '../../widgets/dashboard/dashboard_bottom_dock.dart';


=======
import 'dart:convert';
import 'package:cabkaro/controllers/edit_profile_controller.dart';
import 'package:cabkaro/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:cabkaro/widgets/ToastWidget.dart';
import 'package:provider/provider.dart';
import '../../widgets/dashboard/dashboard_bottom_dock.dart';
import 'package:cabkaro/utils/constants.dart' as constant;
>>>>>>> a64f8e0 (Edit vendor and user profile)

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
<<<<<<< HEAD

  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }



  // ──────────────────────────────────────────────
  // Permission helpers
  // ──────────────────────────────────────────────

  Future<bool> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isPermanentlyDenied) {
      if (!mounted) return false;
      _showPermissionDeniedDialog('Camera');
      return false;
    }
    return status.isGranted;
  }

  Future<bool> _requestGalleryPermission() async {

    final Permission permission = Platform.isAndroid
        ? Permission.photos
        : Permission.photos;

    final status = await permission.request();
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

  // ──────────────────────────────────────────────
  // Pick image
  // ──────────────────────────────────────────────

  Future<void> _pickFromCamera() async {
  try {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
    );

    if (photo != null) {
      setState(() => _profileImage = File(photo.path));
    }
  } catch (e) {
    ToastWidget.show(context,
        message: 'Could not open camera.',
        type: ToastType.error);
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
      if (image != null) {
        setState(() => _profileImage = File(image.path));
      }
    } catch (e) {
      if (!mounted) return;
      ToastWidget.show(context,
          message: 'Could not pick image. Try again.',
          type: ToastType.error);
    }
  }

  // ──────────────────────────────────────────────
  // Bottom sheet modal
  // ──────────────────────────────────────────────

  void _showImageSourceModal() {
=======
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
>>>>>>> a64f8e0 (Edit vendor and user profile)
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _ImageSourceBottomSheet(
        onCameraTap: () {
          Navigator.pop(ctx);
<<<<<<< HEAD
          _pickFromCamera();
        },
        onGalleryTap: () {
          Navigator.pop(ctx);
          _pickFromGallery();
=======
          controller.pickFromCamera(context);
        },
        onGalleryTap: () {
          Navigator.pop(ctx);
          controller.pickFromGallery(context);
>>>>>>> a64f8e0 (Edit vendor and user profile)
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
<<<<<<< HEAD
    var provider = Provider.of<EditProfileController>(context, listen: false);
=======
>>>>>>> a64f8e0 (Edit vendor and user profile)

    return Scaffold(
      backgroundColor: const Color(0xFFE8E8E8),
      body: SafeArea(
        child: Stack(
          children: [
<<<<<<< HEAD
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
                        color: Colors.white,
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

                // Profile Avatar — now triggers the modal
                Center(
                  child: GestureDetector(
                    onTap: _showImageSourceModal, // ← changed
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
                          child: ClipOval(
                            child: _profileImage != null
                                ? Image.file(
                                    _profileImage!,
                                    fit: BoxFit.cover,
                                    width: 140,
                                    height: 140,
                                  )
                                : Image.asset(
                                    'assets/images/avatar.png',
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) {
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
=======
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
>>>>>>> a64f8e0 (Edit vendor and user profile)
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8C100),
<<<<<<< HEAD
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
                ),

                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    'Tap photo to change',
                    style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                  ),
                ),
                const SizedBox(height: 24),

                _EditProfileInput(
                  icon: Icons.person,
                  hintText: 'Name',
                  controller: provider.nameController,
                ),
                const SizedBox(height: 14),
                _EditProfileInput(
                  icon: Icons.call,
                  hintText: 'Phone',
                  controller: provider.phoneController,
                ),
                const SizedBox(height: 32),
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      provider.update(context);
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

=======
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
>>>>>>> a64f8e0 (Edit vendor and user profile)
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
<<<<<<< HEAD
}

// ──────────────────────────────────────────────────────────────
// Bottom Sheet Widget
=======

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
>>>>>>> a64f8e0 (Edit vendor and user profile)
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
<<<<<<< HEAD
          // Drag handle
=======
>>>>>>> a64f8e0 (Edit vendor and user profile)
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
<<<<<<< HEAD

          // Title
=======
>>>>>>> a64f8e0 (Edit vendor and user profile)
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
<<<<<<< HEAD
            'Choose how you\'d like to add your photo',
            style: TextStyle(fontSize: 13, color: Color(0xFF999999)),
          ),
          const SizedBox(height: 24),

          // Options row
=======
            "Choose how you'd like to add your photo",
            style: TextStyle(fontSize: 13, color: Color(0xFF999999)),
          ),
          const SizedBox(height: 24),
>>>>>>> a64f8e0 (Edit vendor and user profile)
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
<<<<<<< HEAD

          // Cancel
=======
>>>>>>> a64f8e0 (Edit vendor and user profile)
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
<<<<<<< HEAD
            child: Icon(
              icon,
              size: 32,
              color: const Color(0xFFF8C100),
            ),
=======
            child: Icon(icon, size: 32, color: const Color(0xFFF8C100)),
>>>>>>> a64f8e0 (Edit vendor and user profile)
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
<<<<<<< HEAD
// Input Widget (unchanged)
=======
// Input Widget
>>>>>>> a64f8e0 (Edit vendor and user profile)
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
<<<<<<< HEAD
}
=======
}
>>>>>>> a64f8e0 (Edit vendor and user profile)
