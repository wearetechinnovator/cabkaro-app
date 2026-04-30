import 'dart:io';
import 'dart:convert';
import 'package:cabkaro/controllers/car_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cabkaro/widgets/gradient_background.dart';
import 'package:cabkaro/widgets/action_button.dart';
import 'package:cabkaro/widgets/signup_input.dart';

class AddCarDetails extends StatefulWidget {
  const AddCarDetails({super.key});

  @override
  State<AddCarDetails> createState() => _AddCarDetailsState();
}

class _AddCarDetailsState extends State<AddCarDetails> {
  final _seaterOptions = ['2', '4', '5', '6', '7', '8', '10', '12+'];

  // Only kept for image handling (base64 + local preview)
  String? _base64Image;
  String? _networkImageUrl;
  File? _localImageFile;
  bool _isConvertingImage = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<CarDetailsController>(
        context,
        listen: false,
      );

      // If no car exists yet for editing, add a blank one
      if (controller.cars.isEmpty) {
        controller.addNewCar();
      }

      // If the existing car already has a network image, show it
      final car = controller.cars.first;
      if (car.base64Img != null && car.base64Img!.startsWith('http')) {
        setState(() => _networkImageUrl = car.base64Img);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

  }

  /// Returns the single car being edited from the controller
  CarDetails get _car =>
      Provider.of<CarDetailsController>(context, listen: false).cars.first;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (picked != null) {
      setState(() => _isConvertingImage = true);

      try {
        final file = File(picked.path);
        final bytes = await file.readAsBytes();
        final base64String = base64Encode(bytes);

        setState(() {
          _localImageFile = file;
          _base64Image = "data:image/jpeg;base64,$base64String";
          _networkImageUrl = null;
          _isConvertingImage = false;

          // Also keep the File reference in the model (mirrors CarDetailsScreen)
          _car.carImage = file;
          _car.base64Img = _base64Image;
        });
      } catch (e) {
        setState(() => _isConvertingImage = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to process image: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Widget _buildRadio(
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

  Widget _buildSeaterSelector() {
    // Read directly from model — mirrors CarDetailsScreenScreen
    final car = Provider.of<CarDetailsController>(
      context,
      listen: false,
    ).cars.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Number of Seats",
          style: GoogleFonts.nunitoSans(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _seaterOptions.map((seat) {
            final isSelected = car.seaterCount == seat;
            return GestureDetector(
              onTap: () => setState(() => car.seaterCount = seat),
              child: Container(
                width: 52,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFF2CA2A)
                      : const Color.fromARGB(25, 242, 202, 42),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.grey[300]!,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    seat,
                    style: GoogleFonts.oswald(
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildImageDisplay() {
    if (_isConvertingImage) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFF2CA2A)),
      );
    }

    // New image picked locally — mirrors how CarDetailsScreenScreen shows car.carImage
    if (_localImageFile != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(_localImageFile!, fit: BoxFit.cover),
          ),
          Positioned(top: 8, right: 8, child: _buildChangeBadge()),
        ],
      );
    }

    // Existing network image from server
    if (_networkImageUrl != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              _networkImageUrl!,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFFF2CA2A)),
                );
              },
              errorBuilder: (context, error, stackTrace) =>
                  _buildUploadPlaceholder(),
            ),
          ),
          Positioned(top: 8, right: 8, child: _buildChangeBadge()),
        ],
      );
    }

    return _buildUploadPlaceholder();
  }

  Widget _buildChangeBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "Tap to change",
        style: GoogleFonts.nunitoSans(color: Colors.white, fontSize: 11),
      ),
    );
  }

  Widget _buildUploadPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.cloud_upload_outlined, size: 40, color: Colors.black54),
        const SizedBox(height: 8),
        Text(
          "Upload Photo",
          style: GoogleFonts.nunitoSans(color: Colors.black54),
        ),
      ],
    );
  }

  void _onSave() {
    final car = _car;

    // Validation — reads directly from model controllers (same pattern)
    if (car.carNumberController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter car number')),
      );
      return;
    }
    if (car.carModel.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter car model')),
      );
      return;
    }
    if (car.seaterCount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select number of seats')),
      );
      return;
    }

    // If no new image was picked but old network image exists, preserve it
    if (_base64Image == null && _networkImageUrl != null) {
      car.base64Img = _networkImageUrl;
    }

    final controller = Provider.of<CarDetailsController>(
      context,
      listen: false,
    );

    controller.saveVehicle(context, isEdit: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        showGlow: false,
        child: SafeArea(
          child: Consumer<CarDetailsController>(
            builder: (context, controller, _) {
              // Guard: show loader until car is available
              if (controller.cars.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFFF2CA2A)),
                );
              }

              final car = controller.cars.first;

              return Column(
                children: [
                  // App bar
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Text(
                          "Add Vehicle",
                          style: GoogleFonts.oswald(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Form
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.black12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Reads directly from car.carNumberController
                            SignupInput(
                              hint: 'Car Number',
                              icon: Icons.directions_car,
                              controller: car.carNumberController,
                            ),
                            const SizedBox(height: 16),
                            // Reads directly from car.carModel
                            SignupInput(
                              hint: 'Car Model',
                              icon: Icons.car_repair,
                              controller: car.carModel,
                            ),
                            const SizedBox(height: 20),

                            _buildSeaterSelector(),
                            const SizedBox(height: 20),

                            // Car image
                            Text(
                              "Car Image",
                              style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: _isConvertingImage ? null : _pickImage,
                              child: Container(
                                height: 160,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(
                                      25, 242, 202, 42),
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: Colors.grey[300]!),
                                ),
                                child: _buildImageDisplay(),
                              ),
                            ),

                            if (_base64Image != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Row(
                                  children: [
                                    const Icon(Icons.check_circle,
                                        color: Colors.green, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      "Image ready to upload",
                                      style: GoogleFonts.nunitoSans(
                                        color: Colors.green,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            const SizedBox(height: 20),

                            // All radio buttons read/write directly from car model
                            _buildRadio(
                              "Is AC Available?",
                              car.isAc,
                              (v) => setState(() => car.isAc = v!),
                            ),
                            _buildRadio(
                              "Is SOS Facility?",
                              car.isSos,
                              (v) => setState(() => car.isSos = v!),
                            ),
                            _buildRadio(
                              "Is First Aid Kit?",
                              car.isFirstAid,
                              (v) => setState(() => car.isFirstAid = v!),
                            ),
                            const SizedBox(height: 15),

                            Text(
                              "Other Facilities",
                              style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Reads directly from car.facilitiesController
                            TextFormField(
                              controller: car.facilitiesController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText:
                                    "E.g. WiFi, Water Bottles, Phone Charger",
                                fillColor:
                                    const Color.fromARGB(46, 242, 202, 42),
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Save button
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: ActionButton(
                      label: 'Save Changes',
                      backgroundColor: const Color(0xFF1F1F1F),
                      textColor: Colors.white,
                      borderColor: const Color(0xFF1F1F1F),
                      onTap: () {
                        if (!_isConvertingImage) _onSave();
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}