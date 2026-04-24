// ignore_for_file: duplicate_ignore, deprecated_member_use

import 'dart:io';
import 'package:cabkaro/screens/driver/edit_driver_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/gradient_background.dart';
import '../../widgets/action_button.dart';

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
  final List<DriverListData> _drivers = [
    DriverListData(
      id: '1',
      name: 'Rajesh Kumar',
      phone: '+91 98765 43210',
      isActive: true,
    ),
    DriverListData(id: '2', name: 'Amit Sharma', phone: '+91 91234 56789'),
  ];

  // ── Detail bottom sheet ────────────────────────────────────────────────────

  void _showDriverDetail(int index) {
    final driver = _drivers[index];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.55,
          minChildSize: 0.4,
          maxChildSize: 0.85,
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
                        // Avatar + name header
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 32,
                              backgroundColor: const Color(
                                0xFFF2CA2A,
                              ).withOpacity(0.2),
                              backgroundImage: driver.driverImage != null
                                  ? FileImage(driver.driverImage!)
                                  : null,
                              child: driver.driverImage == null
                                  ? const Icon(
                                      Icons.person,
                                      size: 36,
                                      color: Color(0xFFDDA200),
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  driver.name,
                                  style: GoogleFonts.oswald(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  driver.phone,
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
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

                        // Detail rows
                        _detailRow('Name', driver.name, Icons.person_outline),
                        _detailRow('Phone', driver.phone, Icons.phone_android),
                        _detailRow(
                          'Status',
                          driver.isActive ? 'Online' : 'Offline',
                          Icons.circle,
                          valueColor: driver.isActive
                              ? Colors.green
                              : Colors.grey,
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),

                // Bottom action buttons
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
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
                            _showDeleteConfirm(index);
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
                            Navigator.pop(context);
                            _openEditPage(index);
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

  Widget _detailRow(
    String label,
    String value,
    IconData icon, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: const Color(0xFFF2CA2A).withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: const Color(0xFFDDA200)),
          ),
          const SizedBox(width: 14),
          Text(
            label,
            style: GoogleFonts.nunitoSans(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.nunitoSans(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: valueColor ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // ── Delete confirm ─────────────────────────────────────────────────────────

  void _showDeleteConfirm(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Delete Driver?", style: GoogleFonts.oswald()),
        content: Text(
          "Remove ${_drivers[index].name} from your listed drivers? This cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(() => _drivers.removeAt(index));
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // ── Edit page ──────────────────────────────────────────────────────────────

  void _openEditPage(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditDriverScreen(
          driver: _drivers[index],
          onSave: (updated) {
            setState(() => _drivers[index] = updated);
          },
        ),
      ),
    );
  }

  // ── Toggle active ──────────────────────────────────────────────────────────

  void _handleToggle(int index, bool value) {
    setState(() => _drivers[index].isActive = value);
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        showGlow: false,
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
                child: _drivers.isEmpty
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
                                    backgroundColor: const Color(
                                      0xFFF2CA2A,
                                    ).withOpacity(0.2),
                                    backgroundImage: driver.driverImage != null
                                        ? FileImage(driver.driverImage!)
                                        : null,
                                    child: driver.driverImage == null
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
                                          driver.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          driver.phone,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Isolate switch tap from card tap
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
                      onTap: () => Navigator.pushNamed(context, '/add-driver'),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2CA2A),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.black, width: 1.5),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.black,
                          size: 28,
                        ),
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
