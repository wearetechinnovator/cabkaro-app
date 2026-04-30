import 'dart:io';
<<<<<<< HEAD

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'listed_car_deatils_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/gradient_background.dart';
import '../../widgets/action_button.dart';
import '../../widgets/signup_input.dart';

class EditCarScreen extends StatefulWidget {
  final CarData car;
  final void Function(CarData updated) onSave;

  const EditCarScreen({super.key, required this.car, required this.onSave});
=======
import 'dart:convert';
import 'package:cabkaro/controllers/car_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cabkaro/widgets/gradient_background.dart';
import 'package:cabkaro/widgets/action_button.dart';
import 'package:cabkaro/widgets/signup_input.dart';
import 'package:cabkaro/utils/constants.dart' as constant;

class EditCarScreen extends StatefulWidget {
  final Map<String, dynamic>? car;

  const EditCarScreen({super.key, this.car});
>>>>>>> a64f8e0 (Edit vendor and user profile)

  @override
  State<EditCarScreen> createState() => _EditCarScreenState();
}

class _EditCarScreenState extends State<EditCarScreen> {
  late TextEditingController _carNumberController;
  late TextEditingController _modelController;
  late TextEditingController _facilitiesController;
  late String _isAc;
  late String _isSos;
  late String _isFirstAid;
  late String? _seaterCount;
<<<<<<< HEAD
  File? _carImage;
=======

  // Base64 string of the newly picked image (null if no new image picked)
  String? _base64Image;

  // Store the original network image URL
  late String? _networkImageUrl;

  // Store newly picked local image file (for preview only)
  File? _localImageFile;

  // Loading state for image conversion
  bool _isConvertingImage = false;
>>>>>>> a64f8e0 (Edit vendor and user profile)

  final _seaterOptions = ['2', '4', '5', '6', '7', '8', '10', '12+'];

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    _carNumberController =
        TextEditingController(text: widget.car.carNumber);
    _modelController = TextEditingController(text: widget.car.model);
    _facilitiesController =
        TextEditingController(text: widget.car.otherFacilities ?? '');
    _isAc = widget.car.isAc;
    _isSos = widget.car.isSos;
    _isFirstAid = widget.car.isFirstAid;
    _seaterCount = widget.car.seaterCount;
    _carImage = widget.car.carImage;
=======
    _carNumberController = TextEditingController(
      text: widget.car?['vehicle_number'],
    );
    _modelController = TextEditingController(text: widget.car?['vehicle_model']);
    _facilitiesController = TextEditingController(
      text: widget.car?['facilities'] ?? '',
    );
    _isAc = widget.car?['is_ac'];
    _isSos = widget.car?['is_sos'];
    _isFirstAid = widget.car?['is_first_aid_kid'];
    _seaterCount = widget.car?['number_of_seats'].toString();
    _networkImageUrl = widget.car?['vehicle_img'] != null
        ? "${constant.imgUrl}/${widget.car?['vehicle_img']}"
        : null;
>>>>>>> a64f8e0 (Edit vendor and user profile)
  }

  @override
  void dispose() {
    _carNumberController.dispose();
    _modelController.dispose();
    _facilitiesController.dispose();
    super.dispose();
  }

<<<<<<< HEAD
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _carImage = File(picked.path));
=======
  /// Picks an image from the gallery, stores the File for preview,
  /// and converts it to a base64 string for upload.
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80, // Compress to reduce base64 size
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
          _networkImageUrl = null; // Clear old network image
          _isConvertingImage = false;
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
>>>>>>> a64f8e0 (Edit vendor and user profile)
  }

  Widget _buildRadio(String title, String current, Function(String?) onChange) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
<<<<<<< HEAD
        Text(title,
            style: GoogleFonts.nunitoSans(
                fontWeight: FontWeight.w600, fontSize: 16)),
=======
        Text(
          title,
          style: GoogleFonts.nunitoSans(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
>>>>>>> a64f8e0 (Edit vendor and user profile)
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text("Yes"),
                value: "Yes",
                groupValue: current,
                activeColor: const Color(0xFFF2CA2A),
                onChanged: onChange,
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text("No"),
                value: "No",
                groupValue: current,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
<<<<<<< HEAD
        Text("Number of Seats",
            style: GoogleFonts.nunitoSans(
                fontWeight: FontWeight.w600, fontSize: 16)),
=======
        Text(
          "Number of Seats",
          style: GoogleFonts.nunitoSans(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
>>>>>>> a64f8e0 (Edit vendor and user profile)
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _seaterOptions.map((seat) {
            final isSelected = _seaterCount == seat;
            return GestureDetector(
              onTap: () => setState(() => _seaterCount = seat),
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
<<<<<<< HEAD
                  child: Text(seat,
                      style: GoogleFonts.oswald(
                          fontSize: 14,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: Colors.black)),
=======
                  child: Text(
                    seat,
                    style: GoogleFonts.oswald(
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
>>>>>>> a64f8e0 (Edit vendor and user profile)
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

<<<<<<< HEAD
=======
  Widget _buildImageDisplay() {
    // Show loading spinner while converting image to base64
    if (_isConvertingImage) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFF2CA2A)),
      );
    }

    // Show local preview if a new image was picked
    if (_localImageFile != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(_localImageFile!, fit: BoxFit.cover),
          ),
          // Show a small "change" badge in the top-right corner
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Tap to change",
                style: GoogleFonts.nunitoSans(
                  color: Colors.white,
                  fontSize: 11,
                ),
              ),
            ),
          ),
        ],
      );
    }

    // Show existing network image from server
    if (_networkImageUrl != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              _networkImageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  _buildUploadPlaceholder(),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Tap to change",
                style: GoogleFonts.nunitoSans(
                  color: Colors.white,
                  fontSize: 11,
                ),
              ),
            ),
          ),
        ],
      );
    }

    // No image available — show upload placeholder
    return _buildUploadPlaceholder();
  }

  Widget _buildUploadPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.cloud_upload_outlined,
          size: 40,
          color: Colors.black54,
        ),
        const SizedBox(height: 8),
        Text(
          "Upload Photo",
          style: GoogleFonts.nunitoSans(color: Colors.black54),
        ),
      ],
    );
  }

  void _onSave() {
    // Basic validation
    if (_carNumberController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter car number')));
      return;
    }
    if (_modelController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter car model')));
      return;
    }

    final carDetails = CarDetails();
    carDetails.id = widget.car?['_id'];
    carDetails.carNumberController.text = _carNumberController.text.trim();
    carDetails.carModel.text = _modelController.text.trim();
    carDetails.facilitiesController.text = _facilitiesController.text.trim();
    carDetails.isAc = _isAc;
    carDetails.isSos = _isSos;
    carDetails.isFirstAid = _isFirstAid;
    carDetails.seaterCount = _seaterCount;

    // Pass base64 string if a new image was picked,
    // otherwise pass the existing image path so backend keeps the old image.
    if (_base64Image != null) {
      // New image picked → send base64
      carDetails.base64Img = _base64Image;
      carDetails.carImage =
          _localImageFile; // keep File ref if controller needs it
    } else {
      // No new image → preserve existing server image path
      carDetails.base64Img = widget.car?['vehicle_img'];
    }

    final controller = Provider.of<CarDetailsController>(
      context,
      listen: false,
    );

    // Clear old data and add updated car
    controller.cars.clear();
    controller.cars.add(carDetails);

    controller.saveVehicle(context, isEdit: true);
    Navigator.pop(context);
  }

>>>>>>> a64f8e0 (Edit vendor and user profile)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        showGlow: false,
        child: SafeArea(
          child: Column(
            children: [
              // App bar
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
<<<<<<< HEAD
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context)),
                    Text("Edit Vehicle",
                        style: GoogleFonts.oswald(
                            fontSize: 26, fontWeight: FontWeight.bold)),
=======
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      "Edit Vehicle",
                      style: GoogleFonts.oswald(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
>>>>>>> a64f8e0 (Edit vendor and user profile)
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
<<<<<<< HEAD
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4))
=======
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
>>>>>>> a64f8e0 (Edit vendor and user profile)
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SignupInput(
                          hint: 'Car Number',
                          icon: Icons.directions_car,
                          controller: _carNumberController,
                        ),
                        const SizedBox(height: 16),
                        SignupInput(
                          hint: 'Car Model',
                          icon: Icons.car_repair,
                          controller: _modelController,
                        ),
                        const SizedBox(height: 20),
                        _buildSeaterSelector(),
                        const SizedBox(height: 20),

<<<<<<< HEAD
                        // Car image
                        Text("Car Image",
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.w600, fontSize: 16)),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: _pickImage,
=======
                        // Car image picker
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
>>>>>>> a64f8e0 (Edit vendor and user profile)
                          child: Container(
                            height: 160,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(25, 242, 202, 42),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
<<<<<<< HEAD
                            child: _carImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(_carImage!,
                                        fit: BoxFit.cover),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.cloud_upload_outlined,
                                          size: 40, color: Colors.black54),
                                      const SizedBox(height: 8),
                                      Text("Upload Photo",
                                          style: GoogleFonts.nunitoSans(
                                              color: Colors.black54)),
                                    ],
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildRadio("Is AC Available?", _isAc,
                            (v) => setState(() => _isAc = v!)),
                        _buildRadio("Is SOS Facility?", _isSos,
                            (v) => setState(() => _isSos = v!)),
                        _buildRadio("Is First Aid Kit?", _isFirstAid,
                            (v) => setState(() => _isFirstAid = v!)),
                        const SizedBox(height: 15),
                        Text("Other Facilities",
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.w600, fontSize: 16)),
=======
                            child: _buildImageDisplay(),
                          ),
                        ),

                        // Show base64 ready indicator
                        if (_base64Image != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 16,
                                ),
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
                        _buildRadio(
                          "Is AC Available?",
                          _isAc,
                          (v) => setState(() => _isAc = v!),
                        ),
                        _buildRadio(
                          "Is SOS Facility?",
                          _isSos,
                          (v) => setState(() => _isSos = v!),
                        ),
                        _buildRadio(
                          "Is First Aid Kit?",
                          _isFirstAid,
                          (v) => setState(() => _isFirstAid = v!),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "Other Facilities",
                          style: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
>>>>>>> a64f8e0 (Edit vendor and user profile)
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _facilitiesController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: "E.g. WiFi, Water Bottles, Phone Charger",
                            fillColor: const Color.fromARGB(46, 242, 202, 42),
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
<<<<<<< HEAD
                    final updated = CarData(
                      id: widget.car.id,
                      carNumber: _carNumberController.text.trim(),
                      model: _modelController.text.trim(),
                      isActive: widget.car.isActive,
                      location: widget.car.location,
                      radius: widget.car.radius,
                      seaterCount: _seaterCount,
                      isAc: _isAc,
                      isSos: _isSos,
                      isFirstAid: _isFirstAid,
                      otherFacilities: _facilitiesController.text.trim(),
                      carImage: _carImage,
                    );
                    widget.onSave(updated);
                    Navigator.pop(context);
=======
                    if (!_isConvertingImage) _onSave();
>>>>>>> a64f8e0 (Edit vendor and user profile)
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> a64f8e0 (Edit vendor and user profile)
