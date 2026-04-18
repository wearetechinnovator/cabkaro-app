import 'package:cabkaro/controllers/user/ride_controller.dart';
import 'package:cabkaro/screens/user/map_picker_screen.dart';
import 'package:flutter/material.dart';
import 'package:dashed_border/dashed_border.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cabkaro/providers/location_provider.dart';
// import 'location_picker_modal.dart';

class Searchcard extends StatefulWidget {
  final GestureTapCallback onSubmit;

  const Searchcard({
    super.key,
    required this.onSubmit,
  });

  @override
  State<Searchcard> createState() => _SearchcardState();
}

class _SearchcardState extends State<Searchcard> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  String get _dateText {
    final d = context.watch<RideController>().selectedDate;
    if (d == null) return '';

    return '${d.day.toString().padLeft(2, '0')}/'
        '${d.month.toString().padLeft(2, '0')}/'
        '${d.year}';
  }

  String get _timeText {
    final t = context.watch<RideController>().selectedTime;
    if (t == null) return '';

    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final minute = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color.fromARGB(255, 248, 182, 0),
              onPrimary: Colors.black,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        Provider.of<RideController>(context, listen: false).setDate(picked);
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color.fromARGB(255, 248, 182, 0),
              onPrimary: Colors.black,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        Provider.of<RideController>(context, listen: false).setTime(picked);
      });
    }
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
                _LocationField(
                  hint: "Pickup Location",
                  value: locationProvider.pickupLocation,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MapPickerScreen(isPickup: true),
                      ),
                    );
                  },
                  height: 45,
                ),
                const SizedBox(height: 10),
                _LocationField(
                  hint: "Drop Location",
                  value: locationProvider.dropLocation,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MapPickerScreen(isPickup: false),
                      ),
                    );
                  },
                  height: 40,
                ),
                const SizedBox(height: 10),

                // Price / Date / Time row
                Row(
                  children: [
                    // Price — still a free text field
                    Expanded(
                      child: _InputField(
                        hint: "Price",
                        icon: Icons.currency_rupee_outlined,
                        textController: Provider.of<RideController>(
                          context,
                          listen: false,
                        ).price,
                      ),
                    ),
                    const SizedBox(width: 5),

                    // Date — tappable picker
                    Expanded(
                      child: _TappableField(
                        hint: "Date",
                        value: _dateText,
                        icon: Icons.date_range_outlined,
                        onTap: _pickDate,
                      ),
                    ),
                    const SizedBox(width: 5),

                    // Time — tappable picker
                    Expanded(
                      child: _TappableField(
                        hint: "Time",
                        value: _timeText,
                        icon: Icons.access_time,
                        onTap: _pickTime,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Submit button
                GestureDetector(
                  onTap: () {
                    widget.onSubmit();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(30),
                    ),
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

class _LocationField extends StatefulWidget {
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
  State<_LocationField> createState() => _LocationFieldState();
}

class _LocationFieldState extends State<_LocationField> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        height: widget.height,
        decoration: BoxDecoration(
          border: const DashedBorder(
            color: Color.fromARGB(255, 0, 0, 0),
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
                widget.value ?? widget.hint,
                style: GoogleFonts.oswald(
                  color: widget.value != null
                      ? const Color.fromARGB(255, 0, 0, 0)
                      : const Color.fromARGB(255, 1, 1, 1),
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

// Tappable date/time display field
class _TappableField extends StatefulWidget {
  const _TappableField({
    required this.hint,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  final String hint;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  @override
  State<_TappableField> createState() => _TappableFieldState();
}

class _TappableFieldState extends State<_TappableField> {
  @override
  Widget build(BuildContext context) {
    final hasValue = widget.value.isNotEmpty;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        height: 40,
        decoration: BoxDecoration(
          border: const DashedBorder(
            color: Color.fromARGB(255, 0, 0, 0),
            width: 1.1,
            dashLength: 4.0,
            dashGap: 4.0,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Icon(
              widget.icon,
              size: 16,
              color: hasValue
                  ? const Color.fromARGB(255, 0, 0, 0)
                  : const Color.fromARGB(255, 0, 0, 0),
            ),
            const SizedBox(width: 3),
            Expanded(
              child: Text(
                hasValue ? widget.value : widget.hint,
                style: GoogleFonts.oswald(
                  color: hasValue
                      ? const Color.fromARGB(255, 0, 0, 0)
                      : const Color.fromARGB(255, 4, 4, 4),
                  fontSize: 11,
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

// Free-text input field (Price only)
class _InputField extends StatefulWidget {
  final String hint;
  final IconData icon;
  final TextEditingController textController;

  const _InputField({
    required this.hint,
    required this.icon,
    required this.textController,
  });
  @override
  State<_InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<_InputField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose(); // important cleanup
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      height: 40,
      decoration: BoxDecoration(
        border: const DashedBorder(
          color: Color.fromARGB(255, 0, 0, 0),
          width: 1.1,
          dashLength: 4.0,
          dashGap: 4.0,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: widget.textController,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintStyle: GoogleFonts.oswald(),
          hintText: widget.hint,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          isDense: true,
          prefixIcon: Icon(widget.icon),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 5,
            minHeight: 0,
          ),
        ),
      ),
    );
  }
}
