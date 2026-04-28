import 'dart:convert';
import 'dart:io';
import 'package:cabkaro/controllers/driver_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:cabkaro/widgets/gradient_background.dart';
import 'package:cabkaro/widgets/action_button.dart';
import 'package:cabkaro/widgets/signup_input.dart';
import 'package:cabkaro/utils/constants.dart' as constant;

// ── Data model ───────────────────────────────────────────────────────────────
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
class ListedDriverDetailsScreen extends StatefulWidget {
  const ListedDriverDetailsScreen({super.key});

  @override
  State<ListedDriverDetailsScreen> createState() =>
      _ListedDriverDetailsScreenState();
}

class _ListedDriverDetailsScreenState extends State<ListedDriverDetailsScreen> {
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
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          Text(
                            isNew ? "Add New Driver" : "Edit Driver",
                            style: GoogleFonts.oswald(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              driverData.dispose();
                              Navigator.pop(context);
                            },
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
                                  }
                                },
                                child: Stack(
                                  children: [
                                    buildAvatar(),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFF2CA2A),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.camera_alt,
                                          size: 18,
                                          color: Colors.black,
                                        ),
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
                              controller: driverData.nameController,
                            ),
                            const SizedBox(height: 16),

                            // Phone
                            SignupInput(
                              hint: 'Phone Number',
                              icon: Icons.phone_android,
                              controller: driverData.phoneController,
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),

                    // Save button
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
                      ),
                      child: ActionButton(
                        label: isNew ? 'Add Driver' : 'Save Changes',
                        backgroundColor: const Color(0xFFF2CA2A),
                        textColor: Colors.black,
                        borderColor: Colors.transparent,
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
  void _showDriverDetail(Map<String, dynamic> driverData) {
    final driver = driverData;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.30,
          minChildSize: 0.20,
          maxChildSize: 0.30,
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
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 32,
                              backgroundColor: const Color(
                                0xFFF2CA2A,
                              ).withOpacity(0.2),
                              child: const Icon(
                                Icons.person,
                                size: 36,
                                color: Color(0xFFDDA200),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
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
                      ],
                    ),
                  ),
                ),

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
                  ),
                  child: Row(
                    children: [
                      // Delete
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            _showDeleteConfirm(driver);
                          },
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.red.withOpacity(0.4),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
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
                            // Navigator.pop(context);
                            _showDriverFormModal(existingDriver: driver);
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
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        showGlow: false,
        child: RefreshIndicator(
          onRefresh: () async {
            Provider.of<DriverDetailsController>(
              context,
              listen: false,
            ).getVendorDrivers(context);
          },
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
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: Provider.of<DriverDetailsController>(
                            context,
                            listen: true,
                          ).listedDrivers.length,
                          itemBuilder: (context, index) {
                            final driver = Provider.of<DriverDetailsController>(
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
                                      color: Colors.black.withOpacity(0.05),
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
                                            driver['driver_phone'].toString(),
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
