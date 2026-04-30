<<<<<<< HEAD
// ignore_for_file: duplicate_ignore, deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/gradient_background.dart';
import '../../widgets/action_button.dart';
import '../../widgets/signup_input.dart';

// ── Data model ───────────────────────────────────────────────────────────────

=======
import 'dart:convert';
import 'dart:io';
import 'package:cabkaro/controllers/driver_details_controller.dart';
import 'package:cabkaro/widgets/shimmer/driver_list_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:cabkaro/widgets/gradient_background.dart';
import 'package:cabkaro/widgets/action_button.dart';
import 'package:cabkaro/widgets/signup_input.dart';
import 'package:cabkaro/utils/constants.dart' as constant;

// ── Data model ───────────────────────────────────────────────────────────────
>>>>>>> a64f8e0 (Edit vendor and user profile)
class DriverListData {
  String id;
  String name;
  String phone;
  bool isActive;
  File? driverImage;

  DriverListData({
    required this.id,
    required this.name,
    required this.phone,
    this.isActive = false,
    this.driverImage,
  });
}

// ── Listed Drivers Screen ────────────────────────────────────────────────────
<<<<<<< HEAD

=======
>>>>>>> a64f8e0 (Edit vendor and user profile)
class ListedDriverDetailsScreen extends StatefulWidget {
  const ListedDriverDetailsScreen({super.key});

  @override
  State<ListedDriverDetailsScreen> createState() =>
      _ListedDriverDetailsScreenState();
}

class _ListedDriverDetailsScreenState extends State<ListedDriverDetailsScreen> {
<<<<<<< HEAD
  final List<DriverListData> _drivers = [
    DriverListData(
      id: '1',
      name: 'Rajesh Kumar',
      phone: '+91 98765 43210',
      isActive: true,
    ),
    DriverListData(id: '2', name: 'Amit Sharma', phone: '+91 91234 56789'),
  ];

  // ── Add / Edit modal ─────────────────────────────────────────────────────

  void _showDriverFormModal({DriverListData? existingDriver, int? editIndex}) {
    final isNew = existingDriver == null;

    // Local controllers for the modal
    final nameCtrl =
        TextEditingController(text: isNew ? '' : existingDriver.name);
    final phoneCtrl =
        TextEditingController(text: isNew ? '' : existingDriver.phone);

    // Mutable local state inside modal
    File? driverImage = existingDriver?.driverImage;
=======
  // ── Add / Edit modal ─────────────────────────────────────────────────────
  void _showDriverFormModal({Map<String, dynamic>? existingDriver}) {
    final isNew = existingDriver == null;
    // if null -> Add;
    // if not null -> Edit;
    final driverData = DriverData();

    if (!isNew) {
      driverData.id = existingDriver['_id'] ?? '';
      driverData.nameController.text = existingDriver['driver_name'] ?? '';
      driverData.phoneController.text =
          existingDriver['driver_phone']?.toString() ?? '';

      Provider.of<DriverDetailsController>(
        context,
        listen: false,
      ).drivers.add(driverData);
    }

    // Separate variable for existing network image string
    String? existingNetworkImage = isNew ? null : existingDriver['driver_img'];
>>>>>>> a64f8e0 (Edit vendor and user profile)

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
<<<<<<< HEAD
=======
            // Build the avatar widget based on what image state we have
            Widget buildAvatar() {
              if (driverData.driverImage != null) {
                // Newly picked local file
                return CircleAvatar(
                  radius: 52,
                  backgroundImage: FileImage(driverData.driverImage!),
                );
              } else if (existingNetworkImage != null) {
                // Existing driver's network image
                return CircleAvatar(
                  radius: 52,
                  backgroundImage: NetworkImage(
                    "${constant.imgUrl}/$existingNetworkImage",
                  ),
                );
              } else {
                // No image yet
                return CircleAvatar(
                  radius: 52,
                  backgroundColor: const Color.fromARGB(25, 242, 202, 42),
                  child: const Icon(
                    Icons.person,
                    size: 52,
                    color: Colors.black54,
                  ),
                );
              }
            }

>>>>>>> a64f8e0 (Edit vendor and user profile)
            return DraggableScrollableSheet(
              initialChildSize: 0.75,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              expand: false,
              builder: (context, scrollController) {
                return Column(
                  children: [
                    // Handle bar
                    Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 8),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    // Title row
                    Padding(
                      padding: const EdgeInsets.symmetric(
<<<<<<< HEAD
                          horizontal: 20, vertical: 8),
=======
                        horizontal: 20,
                        vertical: 8,
                      ),
>>>>>>> a64f8e0 (Edit vendor and user profile)
                      child: Row(
                        children: [
                          Text(
                            isNew ? "Add New Driver" : "Edit Driver",
                            style: GoogleFonts.oswald(
<<<<<<< HEAD
                                fontSize: 22, fontWeight: FontWeight.bold),
=======
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
>>>>>>> a64f8e0 (Edit vendor and user profile)
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.close),
<<<<<<< HEAD
                            onPressed: () => Navigator.pop(context),
=======
                            onPressed: () {
                              driverData.dispose();
                              Navigator.pop(context);
                            },
>>>>>>> a64f8e0 (Edit vendor and user profile)
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),

                    // Scrollable form
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Avatar picker
                            Center(
                              child: GestureDetector(
                                onTap: () async {
                                  final picker = ImagePicker();
                                  final picked = await picker.pickImage(
<<<<<<< HEAD
                                      source: ImageSource.gallery);
                                  if (picked != null) {
                                    setModalState(() =>
                                        driverImage = File(picked.path));
=======
                                    source: ImageSource.gallery,
                                    imageQuality:
                                        70, // compress a bit for base64
                                  );
                                  if (picked != null) {
                                    final file = File(picked.path);
                                    final bytes = await file.readAsBytes();
                                    final base64Str = base64Encode(bytes);
                                    setModalState(() {
                                      driverData.driverImage = file;
                                      driverData.base64Img =
                                          "data:image/jpeg;base64,$base64Str";
                                      existingNetworkImage =
                                          null; // clear old image
                                    });
>>>>>>> a64f8e0 (Edit vendor and user profile)
                                  }
                                },
                                child: Stack(
                                  children: [
<<<<<<< HEAD
                                    CircleAvatar(
                                      radius: 52,
                                      backgroundColor: const Color.fromARGB(
                                          25, 242, 202, 42),
                                      backgroundImage: driverImage != null
                                          ? FileImage(driverImage!)
                                          : null,
                                      child: driverImage == null
                                          ? const Icon(Icons.person,
                                              size: 52, color: Colors.black54)
                                          : null,
                                    ),
=======
                                    buildAvatar(),
>>>>>>> a64f8e0 (Edit vendor and user profile)
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFF2CA2A),
                                          shape: BoxShape.circle,
                                        ),
<<<<<<< HEAD
                                        child: const Icon(Icons.camera_alt,
                                            size: 18, color: Colors.black),
=======
                                        child: const Icon(
                                          Icons.camera_alt,
                                          size: 18,
                                          color: Colors.black,
                                        ),
>>>>>>> a64f8e0 (Edit vendor and user profile)
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 28),

                            // Name
                            SignupInput(
                              hint: 'Driver Name',
                              icon: Icons.person_outline,
<<<<<<< HEAD
                              controller: nameCtrl,
=======
                              controller: driverData.nameController,
>>>>>>> a64f8e0 (Edit vendor and user profile)
                            ),
                            const SizedBox(height: 16),

                            // Phone
                            SignupInput(
                              hint: 'Phone Number',
                              icon: Icons.phone_android,
<<<<<<< HEAD
                              controller: phoneCtrl,
=======
                              controller: driverData.phoneController,
>>>>>>> a64f8e0 (Edit vendor and user profile)
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),

                    // Save button
                    Container(
<<<<<<< HEAD
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            top: BorderSide(
                                color: Colors.grey[200]!, width: 1)),
=======
                      padding: EdgeInsets.fromLTRB(
                        20,
                        12,
                        20,
                        24 + MediaQuery.of(context).padding.bottom,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(color: Colors.grey[200]!, width: 1),
                        ),
>>>>>>> a64f8e0 (Edit vendor and user profile)
                      ),
                      child: ActionButton(
                        label: isNew ? 'Add Driver' : 'Save Changes',
                        backgroundColor: const Color(0xFFF2CA2A),
                        textColor: Colors.black,
                        borderColor: Colors.transparent,
<<<<<<< HEAD
                        onTap: () {
                          if (nameCtrl.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please enter a driver name')),
                            );
                            return;
                          }
                          if (phoneCtrl.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Please enter a phone number')),
                            );
                            return;
                          }
                          setState(() {
                            if (isNew) {
                              _drivers.add(DriverListData(
                                id: DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                                name: nameCtrl.text.trim(),
                                phone: phoneCtrl.text.trim(),
                                driverImage: driverImage,
                              ));
                            } else if (editIndex != null) {
                              _drivers[editIndex]
                                ..name = nameCtrl.text.trim()
                                ..phone = phoneCtrl.text.trim()
                                ..driverImage = driverImage;
                            }
                          });
                          Navigator.pop(context);
=======
                        onTap: () async {
                          // Validate
                          if (driverData.nameController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter a driver name'),
                              ),
                            );
                            return;
                          }
                          if (driverData.phoneController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter a phone number'),
                              ),
                            );
                            return;
                          }

                          // Get the controller that holds the drivers list
                          final ctrl = Provider.of<DriverDetailsController>(
                            context,
                            listen: false,
                          );

                          if (isNew) {
                            ctrl.addDriver(driverData);
                          } else {
                            // Pass existing image path if no new image was picked
                            if (driverData.driverImage == null &&
                                existingNetworkImage != null) {
                              driverData.base64Img = existingNetworkImage;
                            }

                            ctrl.updateDriver(
                              existingDriver['_id'],
                              driverData,
                            );
                          }

                          // Call the API
                          await ctrl.saveDriver(context, isNew: true);

                          if (context.mounted) Navigator.pop(context);
                          driverData.dispose();
>>>>>>> a64f8e0 (Edit vendor and user profile)
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  // ── Detail bottom sheet ──────────────────────────────────────────────────
<<<<<<< HEAD

  void _showDriverDetail(int index) {
    final driver = _drivers[index];
=======
  void _showDriverDetail(Map<String, dynamic> driverData) {
    final driver = driverData;
>>>>>>> a64f8e0 (Edit vendor and user profile)
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
<<<<<<< HEAD
          initialChildSize: 0.55,
          minChildSize: 0.4,
          maxChildSize: 0.85,
=======
          initialChildSize: 0.30,
          minChildSize: 0.20,
          maxChildSize: 0.30,
>>>>>>> a64f8e0 (Edit vendor and user profile)
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Scrollable body
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
<<<<<<< HEAD
=======
                        const SizedBox(height: 8),
>>>>>>> a64f8e0 (Edit vendor and user profile)
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 32,
<<<<<<< HEAD
                              backgroundColor:
                                  const Color(0xFFF2CA2A).withOpacity(0.2),
                              backgroundImage: driver.driverImage != null
                                  ? FileImage(driver.driverImage!)
                                  : null,
                              child: driver.driverImage == null
                                  ? const Icon(Icons.person,
                                      size: 36, color: Color(0xFFDDA200))
                                  : null,
=======
                              backgroundColor: const Color(
                                0xFFF2CA2A,
                              ).withOpacity(0.2),
                              child: const Icon(
                                Icons.person,
                                size: 36,
                                color: Color(0xFFDDA200),
                              ),
>>>>>>> a64f8e0 (Edit vendor and user profile)
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
<<<<<<< HEAD
                                  driver.name,
                                  style: GoogleFonts.oswald(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(driver.phone,
                                    style:
                                        TextStyle(color: Colors.grey[600])),
                              ],
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: driver.isActive
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                driver.isActive ? 'Active' : 'Inactive',
                                style: TextStyle(
                                  color: driver.isActive
                                      ? Colors.green
                                      : Colors.grey[600],
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 16),
                        _detailRow('Name', driver.name, Icons.person_outline),
                        _detailRow(
                            'Phone', driver.phone, Icons.phone_android),
                        _detailRow(
                          'Status',
                          driver.isActive ? 'Online' : 'Offline',
                          Icons.circle,
                          valueColor:
                              driver.isActive ? Colors.green : Colors.grey,
                        ),
                        const SizedBox(height: 8),
=======
                                  driver['driver_name'],
                                  style: GoogleFonts.oswald(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  driver['driver_phone'].toString(),
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Add more scrollable content here if needed
>>>>>>> a64f8e0 (Edit vendor and user profile)
                      ],
                    ),
                  ),
                ),

<<<<<<< HEAD
                // Bottom action buttons
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        top: BorderSide(color: Colors.grey[200]!, width: 1)),
=======
                // Bottom action buttons — pinned, respects nav bar
                Container(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    12,
                    20,
                    24 + MediaQuery.of(context).padding.bottom,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: Colors.grey[200]!, width: 1),
                    ),
>>>>>>> a64f8e0 (Edit vendor and user profile)
                  ),
                  child: Row(
                    children: [
                      // Delete
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
<<<<<<< HEAD
                            _showDeleteConfirm(index);
=======
                            _showDeleteConfirm(driver);
>>>>>>> a64f8e0 (Edit vendor and user profile)
                          },
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
<<<<<<< HEAD
                                  color: Colors.red.withOpacity(0.4)),
=======
                                color: Colors.red.withOpacity(0.4),
                              ),
>>>>>>> a64f8e0 (Edit vendor and user profile)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
<<<<<<< HEAD
                                const Icon(Icons.delete_outline,
                                    color: Colors.red, size: 18),
                                const SizedBox(width: 6),
                                Text('Delete',
                                    style: GoogleFonts.oswald(
                                        color: Colors.red, fontSize: 15)),
=======
                                const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Delete',
                                  style: GoogleFonts.oswald(
                                    color: Colors.red,
                                    fontSize: 15,
                                  ),
                                ),
>>>>>>> a64f8e0 (Edit vendor and user profile)
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Edit
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
<<<<<<< HEAD
                            Navigator.pop(context);
                            _showDriverFormModal(
                                existingDriver: _drivers[index],
                                editIndex: index);
=======
                            // Navigator.pop(context);
                            _showDriverFormModal(existingDriver: driver);
>>>>>>> a64f8e0 (Edit vendor and user profile)
                          },
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1F1F1F),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
<<<<<<< HEAD
                                const Icon(Icons.edit_outlined,
                                    color: Colors.white, size: 18),
                                const SizedBox(width: 6),
                                Text('Edit',
                                    style: GoogleFonts.oswald(
                                        color: Colors.white, fontSize: 15)),
=======
                                const Icon(
                                  Icons.edit_outlined,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Edit',
                                  style: GoogleFonts.oswald(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
>>>>>>> a64f8e0 (Edit vendor and user profile)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

<<<<<<< HEAD
  Widget _detailRow(String label, String value, IconData icon,
      {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF2CA2A).withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: const Color(0xFFDDA200)),
          ),
          const SizedBox(width: 14),
          Text(label,
              style: GoogleFonts.nunitoSans(
                  fontSize: 14, color: Colors.grey[600])),
          const Spacer(),
          Text(value,
              style: GoogleFonts.nunitoSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? Colors.black)),
        ],
      ),
    );
  }

  // ── Delete confirm ─────────────────────────────────────────────────────────

  void _showDeleteConfirm(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Delete Driver?", style: GoogleFonts.oswald()),
        content: Text(
          "Remove ${_drivers[index].name} from your listed drivers? This cannot be undone.",
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              setState(() => _drivers.removeAt(index));
=======
  // ── Delete confirm ─────────────────────────────────────────────────────────
  void _showDeleteConfirm(Map<String, dynamic> driver) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Delete Driver?", style: GoogleFonts.oswald()),
        content: Text(
          "Remove ${driver["driver_name"]} from your listed drivers? This cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Provider.of<DriverDetailsController>(
                context,
                listen: false,
              ).deleteDriver(context, driver['_id']);
>>>>>>> a64f8e0 (Edit vendor and user profile)
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

<<<<<<< HEAD
  // ── Toggle active ──────────────────────────────────────────────────────────

  void _handleToggle(int index, bool value) {
    setState(() => _drivers[index].isActive = value);
  }

  // ── Build ──────────────────────────────────────────────────────────────────

=======
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DriverDetailsController>(
        context,
        listen: false,
      ).getVendorDrivers(context);
    });
  }

>>>>>>> a64f8e0 (Edit vendor and user profile)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        showGlow: false,
<<<<<<< HEAD
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      "My Listed Drivers",
                      style: GoogleFonts.oswald(
                          fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _drivers.isEmpty
                    ? Center(
                        child: Text(
                          "No drivers listed yet.",
                          style: GoogleFonts.nunitoSans(
                              color: Colors.grey, fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: _drivers.length,
                        itemBuilder: (context, index) {
                          final driver = _drivers[index];
                          return GestureDetector(
                            onTap: () => _showDriverDetail(index),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: driver.isActive
                                      ? const Color(0xFFF2CA2A)
                                      : Colors.black12,
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor: const Color(0xFFF2CA2A)
                                        .withOpacity(0.2),
                                    backgroundImage: driver.driverImage != null
                                        ? FileImage(driver.driverImage!)
                                        : null,
                                    child: driver.driverImage == null
                                        ? const Icon(Icons.person,
                                            color: Color(0xFFDDA200), size: 26)
                                        : null,
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(driver.name,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                        Text(driver.phone,
                                            style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 13)),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    behavior: HitTestBehavior.opaque,
                                    child: Switch(
                                      value: driver.isActive,
                                      activeColor: const Color(0xFFF2CA2A),
                                      onChanged: (val) =>
                                          _handleToggle(index, val),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    GestureDetector(
                      // Opens the add modal
                      onTap: () => _showDriverFormModal(),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2CA2A),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.black, width: 1.5),
                        ),
                        child: const Icon(Icons.add,
                            color: Colors.black, size: 28),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: ActionButton(
                        label: 'Refresh',
                        backgroundColor: const Color(0xFF1F1F1F),
                        textColor: Colors.white,
                        borderColor: const Color(0xFF1F1F1F),
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
=======
        child: RefreshIndicator(
          onRefresh: () async {
            Provider.of<DriverDetailsController>(
              context,
              listen: false,
            ).getVendorDrivers(context);
          },
          child: SafeArea(
            child:
                Provider.of<DriverDetailsController>(
                      context,
                      listen: true,
                    ).loading ==
                    true
                ? DriverListShimmer()
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () => Navigator.pop(context),
                            ),
                            Text(
                              "My Listed Drivers",
                              style: GoogleFonts.oswald(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child:
                            Provider.of<DriverDetailsController>(
                              context,
                              listen: true,
                            ).listedDrivers.isEmpty
                            ? Center(
                                child: Text(
                                  "No drivers listed yet.",
                                  style: GoogleFonts.nunitoSans(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                itemCount: Provider.of<DriverDetailsController>(
                                  context,
                                  listen: true,
                                ).listedDrivers.length,
                                itemBuilder: (context, index) {
                                  final driver =
                                      Provider.of<DriverDetailsController>(
                                        context,
                                        listen: true,
                                      ).listedDrivers[index];
                                  return GestureDetector(
                                    onTap: () => _showDriverDetail(driver),
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: Colors.black12,
                                          width: 1.5,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.05,
                                            ),
                                            blurRadius: 10,
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 24,
                                            backgroundColor: const Color(
                                              0xFFF2CA2A,
                                            ).withOpacity(0.2),
                                            backgroundImage:
                                                driver['driver_img'] != null
                                                ? NetworkImage(
                                                    "${constant.imgUrl}/${driver['driver_img']}",
                                                  )
                                                : null,
                                            child: driver['driver_img'] == null
                                                ? const Icon(
                                                    Icons.person,
                                                    color: Color(0xFFDDA200),
                                                    size: 26,
                                                  )
                                                : null,
                                          ),
                                          const SizedBox(width: 14),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  driver['driver_name'],
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Text(
                                                  driver['driver_phone']
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDriverFormModal();
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          child: const Icon(Icons.add, color: Colors.black, size: 28),
        ),
      ),
    );
  }
}
>>>>>>> a64f8e0 (Edit vendor and user profile)
