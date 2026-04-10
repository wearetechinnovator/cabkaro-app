import 'package:flutter/material.dart';
import 'package:dashed_border/dashed_border.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cabkaro/providers/location_provider.dart';
import 'location_picker_modal.dart';

class Searchcard extends StatelessWidget {
  const Searchcard({super.key, required this.onSubmit});

  final GestureTapCallback onSubmit;

  void _openModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const LocationPickerModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = context.watch<LocationProvider>();

    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 248, 182, 0),
            borderRadius: BorderRadius.all(Radius.circular(25)),
            border: Border(
              bottom: BorderSide(color: Color(0xFF4D4D4D), width: 4),
              right: BorderSide(color: Color(0xFF4D4D4D), width: 4),
              top: BorderSide(color: Color(0xFF4D4D4D), width: 2),
              left: BorderSide(color: Color(0xFF4D4D4D), width: 2),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              children: [
                const SizedBox(height: 35),

                // Pickup field
                _LocationField(
                  hint: "Pickup Location",
                  value: locationProvider.pickupLocation,
                  onTap: () => _openModal(context),
                  height: 45,
                ),
                const SizedBox(height: 10),

                // Drop field
                _LocationField(
                  hint: "Drop Location",
                  value: locationProvider.dropLocation,
                  onTap: () => _openModal(context),
                  height: 40,
                ),

                const SizedBox(height: 10),

                // Price / Date / Time row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _InputField(
                        hint: "Price",
                        icon: Icons.currency_rupee_outlined,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: _InputField(
                        hint: "Date",
                        icon: Icons.date_range_outlined,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: _InputField(hint: "Time", icon: Icons.access_time),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Submit button
                Container(
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: GestureDetector(
                    onTap: onSubmit,
                    child: Center(
                      child: Text(
                        "Submit",
                        style: GoogleFonts.oswald(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
        Positioned(
          left: -3,
          child: Image.asset('assets/images/Rectangle8.png', width: 74),
        ),
        Positioned(
          left: -10.9,
          child: Image.asset('assets/images/Rectangle9.png', width: 74),
        ),
        Positioned(
          left: -3,
          child: Image.asset('assets/images/Rectangle10.png', width: 74),
        ),
        Positioned(
          right: 45,
          top: 72,
          child: GestureDetector(
            onTap: () {
              final provider = context.read<LocationProvider>();
              final pickup = provider.pickupLocation;
              final drop = provider.dropLocation;
              // Only swap if at least one has a value
              if (pickup != null || drop != null) {
                provider.setPickupLocation(drop ?? '');
                provider.setDropLocation(pickup ?? '');
              }
            },
            child: Image.asset('assets/icons/upndownicon.png', width: 30),
          ),
        ),
      ],
    );
  }
}

// Tappable location display field (reads from provider)
class _LocationField extends StatelessWidget {
  const _LocationField({
    required this.hint,
    required this.value,
    required this.onTap,
    required this.height,
  });

  final String hint;
  final String? value;
  final VoidCallback onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        height: height,
        decoration: BoxDecoration(
          border: const DashedBorder(
            color: Color(0xFF5E5951),
            width: 1.1,
            dashLength: 4.0,
            dashGap: 4.0,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            const Icon(Icons.my_location_outlined, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                value ?? hint,
                style: GoogleFonts.oswald(
                  color: value != null
                      ? const Color(0xFF2C2C2A)
                      : const Color(0xFF888780),
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Non-tappable input field (Price / Date / Time)
class _InputField extends StatelessWidget {
  const _InputField({required this.hint, required this.icon});

  final String hint;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      height: 40,
      decoration: BoxDecoration(
        border: const DashedBorder(
          color: Color(0xFF5E5951),
          width: 1.1,
          dashLength: 4.0,
          dashGap: 4.0,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintStyle: GoogleFonts.oswald(),
          hintText: hint,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          isDense: true,
          prefixIcon: Icon(icon),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 5,
            minHeight: 0,
          ),
        ),
      ),
    );
  }
}
