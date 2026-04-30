import 'dart:io';
import 'package:cabkaro/screens/driver/vendor_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cabkaro/widgets/ToastWidget.dart';

import '../../widgets/action_button.dart';
import '../../widgets/gradient_background.dart';

class GOVDetailsScreen extends StatefulWidget {
  const GOVDetailsScreen({super.key});

  @override
  State<GOVDetailsScreen> createState() => _GOVDetailsScreenState();
}

class _GOVDetailsScreenState extends State<GOVDetailsScreen> {
  String? aadharFile;
  String? licenseFile;
  String? carProofFile;
  File? _carPhoto;
  String? _selectedSeats;
  bool _hasAC = false;
  bool _hasWiFi = false;

  final List<String> _seatOptions = ['2', '4', '5', '7', '8'];

  Future<void> _pickCarPhoto() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if (result != null && result.files.single.path != null) {
        setState(() {
          _carPhoto = File(result.files.single.path!);
        });
      }
    } catch (e) {
      if (!mounted) return;
      ToastWidget.show(context,
          message: 'Error uploading photo. Try again.',
          type: ToastType.error);
    }
  }

  Future<void> _pickFile(String documentType) async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        if (!mounted) return;
        setState(() {
          switch (documentType) {
            case 'Aadhar Card':
              aadharFile = file.name;
              break;
            case 'Driving License':
              licenseFile = file.name;
              break;
            case 'Commercial Car Proof':
              carProofFile = file.name;
              break;
          }
        });
        if (!mounted) return;
        ToastWidget.show(context,
            message: '$documentType uploaded successfully',
            type: ToastType.success);
      }
    } catch (e) {
      if (!mounted) return;
      ToastWidget.show(context,
          message: 'Error uploading file. Please try again.',
          type: ToastType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GradientBackground(
        child: SafeArea(
          child: ListView(
            children: [
              const SizedBox(height: 10),

              // Logo
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
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
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  'Document Upload',
                  style: TextStyle(
                    fontSize: screenHeight * 0.04,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2D2F35),
                    height: 1.0,
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.01),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  'Attach the following details',
                  style: TextStyle(
                    fontSize: screenHeight * 0.02,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF3C3D42),
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.025),

              // ── Car Photo Picker (square) ──────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Car Photo',
                      style: TextStyle(
                        fontSize: screenHeight * 0.018,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF3C3D42),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: _pickCarPhoto,
                      child: _carPhoto == null
                          // Empty state
                          ? Container(
                              width: double.infinity,
                              height: 160,
                              decoration: BoxDecoration(
                                color: const Color(0x102D2F35),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0x8F2D2F35),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF2D2F35),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.directions_car_outlined,
                                      color: Color(0xFFF2F2F2),
                                      size: 26,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Tap to add car photo',
                                    style: TextStyle(
                                      fontSize: screenHeight * 0.015,
                                      color: const Color(0xFF3C3D42),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          // Filled state — square preview
                          : Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 160,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.amber,
                                      width: 2,
                                    ),
                                    image: DecorationImage(
                                      image: FileImage(_carPhoto!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                // Overlay
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      // ignore: deprecated_member_use
                                      color: Colors.black.withOpacity(0.3),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.edit,
                                            color: Colors.white, size: 16),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Change Photo',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: screenHeight * 0.015,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.025),

              // ── Car Features Section ────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Car Features',
                      style: TextStyle(
                        fontSize: screenHeight * 0.02,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2D2F35),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Seats Dropdown
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Number of Seats',
                          style: TextStyle(
                            fontSize: screenHeight * 0.016,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF3C3D42),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0x8F2D2F35),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButton<String>(
                            value: _selectedSeats,
                            hint: const Text('Select seats'),
                            isExpanded: true,
                            underline: const SizedBox(),
                            items: _seatOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedSeats = newValue;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // AC Toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'AC Available',
                          style: TextStyle(
                            fontSize: screenHeight * 0.016,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF3C3D42),
                          ),
                        ),
                        Switch(
                          value: _hasAC,
                          onChanged: (bool value) {
                            setState(() {
                              _hasAC = value;
                            });
                          },
                          activeColor: const Color(0xFFF8C100),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // WiFi Toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'WiFi Available',
                          style: TextStyle(
                            fontSize: screenHeight * 0.016,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF3C3D42),
                          ),
                        ),
                        Switch(
                          value: _hasWiFi,
                          onChanged: (bool value) {
                            setState(() {
                              _hasWiFi = value;
                            });
                          },
                          activeColor: const Color(0xFFF8C100),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.025),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: _DocumentTile(
                  title: 'Aadhar Card',
                  isUploaded: aadharFile != null,
                  onTap: () => _pickFile('Aadhar Card'),
                ),
              ),
              SizedBox(height: screenHeight * 0.014),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: _DocumentTile(
                  title: 'Driving License',
                  isUploaded: licenseFile != null,
                  onTap: () => _pickFile('Driving License'),
                ),
              ),
              SizedBox(height: screenHeight * 0.014),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: _DocumentTile(
                  title: 'Commercial Car Proof',
                  isUploaded: carProofFile != null,
                  onTap: () => _pickFile('Commercial Car Proof'),
                ),
              ),

              SizedBox(height: screenHeight * 0.12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: ActionButton(
                  label: 'Submit',
                  backgroundColor: const Color.fromARGB(255, 242, 202, 42),
                  textColor: Colors.black,
                  borderColor: const Color(0xFF1F1F1F),
                  onTap: () {
                    // Validate car photo
                    if (_carPhoto == null) {
                      ToastWidget.show(context,
                          message: 'Please upload a car photo',
                          type: ToastType.error);
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VendorHomeScreen(),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: screenHeight * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}

class _DocumentTile extends StatelessWidget {
  const _DocumentTile({
    required this.title,
    required this.onTap,
    required this.isUploaded,
  });

  final String title;
  final VoidCallback onTap;
  final bool isUploaded;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF2D2F35),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isUploaded ? Colors.green : const Color(0xFFF0EFE9),
              ),
              alignment: Alignment.center,
              child: Icon(
                isUploaded ? Icons.check : Icons.add,
                size: 17,
                color: isUploaded ? Colors.white : const Color(0xFF2D2F35),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: const Color(0xFFF8F7F3),
                  fontSize: screenHeight * 0.025,
                  fontWeight: FontWeight.w500,
                  height: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}