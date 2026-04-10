import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cabkaro/widgets/ToastWidget.dart';
import 'package:dashed_border/dashed_border.dart';
import 'package:provider/provider.dart';
import 'package:cabkaro/providers/location_provider.dart';
import 'package:cabkaro/screens/user/MapPickerScreen.dart';
import 'package:file_picker/file_picker.dart';
import 'GOVDetailsScreen.dart';
import '../../widgets/ActionButton.dart';
import '../../widgets/SignupInput.dart';

class DriverScreen extends StatefulWidget {
  const DriverScreen({super.key});

  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();
  final TextEditingController _aadharController = TextEditingController();
  final TextEditingController _radiusController = TextEditingController();

  String? _selectedGender;
  String? _selectedLocation;
  File? _profileImage;

  final List<String> _genderOptions = ['Male', 'Female', 'Others'];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _licenseController.dispose();
    _aadharController.dispose();
    _radiusController.dispose();
    super.dispose();
  }

  Future<void> _pickProfileImage() async {
    final result = await FilePicker.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _profileImage = File(result.files.single.path!);
      });
    }
  }

  Widget _dashedContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        border: DashedBorder(
          color: const Color(0xFF5E5951),
          width: 1.1,
          dashLength: 4.0,
          dashGap: 4.0,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final fontSize = screenHeight * 0.015;
    final iconSize = screenHeight * 0.025;
    const inputHeight = 35.0;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 10),

            // Logo
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    border: const Border(
                      bottom: BorderSide(color: Colors.black, width: 3),
                    ),
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/cabkaroLogoNormal.svg',
                    width: 10,
                    height: 90,
                  ),
                ),
              ),
            ),

            Image.asset(
              "assets/images/Pattern.png",
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),

            SizedBox(height: screenHeight * 0.03),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Text(
                'Driver Registration',
                style: TextStyle(
                  fontSize: screenHeight * 0.04,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF2F2F2F),
                  height: 1.0,
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.01),

            // ── Profile Photo Picker ──────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: _pickProfileImage,
                    child: Center(
                      child: _profileImage == null
                          // Empty state — circular
                          ? Container(
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                color: const Color(0x10000000),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0x8F2D2F35),
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: Container(
                                  width: 42,
                                  height: 42,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF2D2F35),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Color(0xFFF2F2F2),
                                    size: 26,
                                  ),
                                ),
                              ),
                            )
                          // Preview state — circular with overlay
                          : Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 110,
                                  height: 110,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.amber,
                                      width: 2.5,
                                    ),
                                    image: DecorationImage(
                                      image: FileImage(_profileImage!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                // Dark overlay + edit icon
                                Container(
                                  width: 110,
                                  height: 110,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black.withOpacity(0.35),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Change',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: fontSize * 0.9,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: screenHeight * 0.02),

            // ── Form fields ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Name
                    SignupInput(
                      hint: 'Name',
                      icon: Icons.person,
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          ToastWidget.show(
                            context,
                            message: 'Name is required',
                            type: ToastType.error,
                          );
                          return '';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.014),

                    // Email
                    SignupInput(
                      hint: 'Email',
                      icon: Icons.email,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          ToastWidget.show(
                            context,
                            message: 'Email is required',
                            type: ToastType.error,
                          );
                          return '';
                        }
                        final emailRegex = RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                        );
                        if (!emailRegex.hasMatch(value)) {
                          ToastWidget.show(
                            context,
                            message: 'Enter a valid email address',
                            type: ToastType.error,
                          );
                          return '';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.014),

                    // Phone
                    SignupInput(
                      hint: 'Phone',
                      icon: Icons.call,
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          ToastWidget.show(
                            context,
                            message: 'Phone is required',
                            type: ToastType.error,
                          );
                          return '';
                        }
                        if (value.length != 10) {
                          ToastWidget.show(
                            context,
                            message: 'Enter a valid 10-digit number',
                            type: ToastType.error,
                          );
                          return '';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.014),

                    // Gender dropdown
                    FormField<String>(
                      validator: (_) {
                        if (_selectedGender == null) {
                          ToastWidget.show(
                            context,
                            message: 'Please select a gender',
                            type: ToastType.error,
                          );
                          return '';
                        }
                        return null;
                      },
                      builder: (field) {
                        return _dashedContainer(
                          child: SizedBox(
                            height: inputHeight,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedGender,
                                isExpanded: true,
                                isDense: true,
                                hint: Row(
                                  children: [
                                    const SizedBox(width: 10),
                                    Icon(
                                      Icons.transgender,
                                      color: const Color(0xFF4C473F),
                                      size: iconSize,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Gender',
                                      style: TextStyle(
                                        fontSize: fontSize,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF9E9E9E),
                                      ),
                                    ),
                                  ],
                                ),
                                selectedItemBuilder: (_) => _genderOptions
                                    .map(
                                      (g) => Row(
                                        children: [
                                          const SizedBox(width: 10),
                                          Icon(
                                            Icons.transgender,
                                            color: const Color(0xFF4C473F),
                                            size: iconSize,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            g,
                                            style: TextStyle(
                                              fontSize: fontSize * 1.1,
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xFF2D2D2D),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                    .toList(),
                                items: _genderOptions
                                    .map(
                                      (g) => DropdownMenuItem(
                                        value: g,
                                        child: Text(
                                          g,
                                          style: TextStyle(
                                            fontSize: fontSize * 1.1,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF2D2D2D),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  setState(() => _selectedGender = value);
                                  field.didChange(value);
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: screenHeight * 0.014),

                    // Driving License
                    SignupInput(
                      hint: 'Driving License',
                      icon: Icons.description,
                      controller: _licenseController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          ToastWidget.show(
                            context,
                            message: 'Driving license is required',
                            type: ToastType.error,
                          );
                          return '';
                        }
                        final dlRegex = RegExp(r'^[A-Z]{2}[0-9]{2}[0-9]{11}$');
                        if (!dlRegex.hasMatch(value.replaceAll(' ', ''))) {
                          ToastWidget.show(
                            context,
                            message: 'Enter a valid driving license number',
                            type: ToastType.error,
                          );
                          return '';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.014),

                    // Aadhar
                    SignupInput(
                      hint: 'Aadhar Number',
                      icon: Icons.credit_card,
                      controller: _aadharController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          ToastWidget.show(
                            context,
                            message: 'Aadhar number is required',
                            type: ToastType.error,
                          );
                          return '';
                        }
                        if (value.replaceAll(' ', '').length != 12) {
                          ToastWidget.show(
                            context,
                            message: 'Enter a valid 12-digit Aadhar number',
                            type: ToastType.error,
                          );
                          return '';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.014),

                    // Service Radius + Location button
                    FormField<String>(
                      validator: (_) {
                        if (_radiusController.text.trim().isEmpty) {
                          ToastWidget.show(
                            context,
                            message: 'Service radius is required',
                            type: ToastType.error,
                          );
                          return '';
                        }
                        if (_selectedLocation == null) {
                          ToastWidget.show(
                            context,
                            message: 'Please select your base location',
                            type: ToastType.error,
                          );
                          return '';
                        }
                        return null;
                      },
                      builder: (field) {
                        return Row(
                          children: [
                            Expanded(
                              child: _dashedContainer(
                                child: SizedBox(
                                  height: inputHeight,
                                  child: TextFormField(
                                    controller: _radiusController,
                                    keyboardType: TextInputType.number,
                                    textAlignVertical: TextAlignVertical.center,
                                    decoration: InputDecoration(
                                      errorStyle: const TextStyle(
                                        fontSize: 0,
                                        height: 0,
                                      ),
                                      errorBorder: InputBorder.none,
                                      hintText: 'Enter distance in km',
                                      hintStyle: TextStyle(
                                        fontSize: fontSize,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF9E9E9E),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.social_distance_outlined,
                                        color: const Color(0xFF4C473F),
                                        size: iconSize,
                                      ),
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      isDense: true,
                                    ),
                                    style: TextStyle(
                                      fontSize: fontSize * 1.1,
                                      color: const Color(0xFF2D2D2D),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
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
                                    setState(() => _selectedLocation = loc);
                                    field.didChange(loc);
                                  }
                                }
                              },
                              child: _dashedContainer(
                                child: SizedBox(
                                  height: inputHeight,
                                  width: inputHeight,
                                  child: Center(
                                    child: Icon(
                                      _selectedLocation != null
                                          ? Icons.location_on
                                          : Icons.location_on_outlined,
                                      color: _selectedLocation != null
                                          ? Colors.amber
                                          : const Color(0xFF4C473F),
                                      size: iconSize,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    if (_selectedLocation != null) ...[
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                size: 13,
                                color: Colors.green,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  _selectedLocation!,
                                  style: TextStyle(
                                    fontSize: fontSize * 0.9,
                                    color: const Color(0xFF4C473F),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: ActionButton(
                label: 'Submit',
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                textColor: Colors.black,
                borderColor: const Color(0xFF1F1F1F),
                onTap: () {
                  // Also validate profile photo
                  if (_profileImage == null) {
                    ToastWidget.show(
                      context,
                      message: 'Please upload a profile photo',
                      type: ToastType.error,
                    );
                    return;
                  }
                  if (_formKey.currentState!.validate()) {
                    ToastWidget.show(
                      context,
                      message: 'Registration submitted successfully!',
                      type: ToastType.success,
                    );
                    Future.delayed(const Duration(milliseconds: 500), () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GOVDetailsScreen(),
                        ),
                      );
                    });
                  }
                },
              ),
            ),

            SizedBox(height: screenHeight * 0.05),
          ],
        ),
      ),
    );
  }
}
