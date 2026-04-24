import 'package:cabkaro/controllers/user/ride_controller.dart';
import 'package:cabkaro/screens/user/map_picker_screen.dart';
import 'package:flutter/material.dart';
import 'package:dashed_border/dashed_border.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cabkaro/providers/location_provider.dart';

class Searchcard extends StatefulWidget {
  const Searchcard({super.key, required this.onSubmit});

  final GestureTapCallback onSubmit;

  @override
  State<Searchcard> createState() => _SearchcardState();
}

class _SearchcardState extends State<Searchcard>
    with SingleTickerProviderStateMixin {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  // New field values
  String? _selectedSeater;
  String? _selectedAC;
  String? _selectedSOS;
  String? _selectedFirstAid;
  final TextEditingController _otherFacilitiesController =
      TextEditingController();

  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 12.0)
            .chain(CurveTween(curve: Curves.easeOutQuad)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 12.0, end: 0.0)
            .chain(CurveTween(curve: Curves.bounceOut)),
        weight: 70,
      ),
    ]).animate(_bounceController);
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _otherFacilitiesController.dispose();
    super.dispose();
  }

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

                // Pickup
                _LocationField(
                  hint: "Pickup Location",
                  value: locationProvider.pickupLocation,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => MapPickerScreen(isPickup: true)),
                  ),
                  height: 45,
                ),
                const SizedBox(height: 10),

                // Drop
                _LocationField(
                  hint: "Drop Location",
                  value: locationProvider.dropLocation,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => MapPickerScreen(isPickup: false)),
                  ),
                  height: 40,
                ),
                const SizedBox(height: 10),

                // Price / Date / Time row
                Row(
                  children: [
                    Expanded(
                      child: _InputField(
                        hint: "Price",
                        icon: Icons.currency_rupee_outlined,
                        textController:
                            Provider.of<RideController>(context, listen: false)
                                .price,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: _TappableField(
                        hint: "Date",
                        value: _dateText,
                        icon: Icons.date_range_outlined,
                        onTap: _pickDate,
                      ),
                    ),
                    const SizedBox(width: 5),
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
                const SizedBox(height: 10),

                // Seater / AC row
                Row(
                  children: [
                    Expanded(
                      child: _DropdownField(
                        hint: "Seater",
                        icon: Icons.event_seat_rounded,
                        value: _selectedSeater,
                        items: const ['2', '4', '6', '7', '8', '10', '12+'],
                        onChanged: (v) => setState(() => _selectedSeater = v),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: _DropdownField(
                        hint: "AC",
                        icon: Icons.ac_unit_rounded,
                        value: _selectedAC,
                        items: const ['AC', 'Non-AC'],
                        onChanged: (v) => setState(() => _selectedAC = v),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // SOS / First Aid row
                Row(
                  children: [
                    Expanded(
                      child: _DropdownField(
                        hint: "SOS",
                        icon: Icons.sos_outlined,
                        value: _selectedSOS,
                        items: const ['SOS', 'Non-SOS'],
                        onChanged: (v) => setState(() => _selectedSOS = v),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: _DropdownField(
                        hint: "First Aid",
                        icon: Icons.medical_services_outlined,
                        value: _selectedFirstAid,
                        items: const ['First Aid Box', 'No First Aid Box'],
                        onChanged: (v) => setState(() => _selectedFirstAid = v),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Other Facilities text field
                _InputField(
                  hint: "Other Facilities (e.g. WiFi, USB charging...)",
                  icon: Icons.star_border_outlined,
                  textController: _otherFacilitiesController,
                ),
                const SizedBox(height: 16),

                // Submit
                GestureDetector(
                  onTap: widget.onSubmit,
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

        // Decorative images (unchanged)
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

        // Swap icon
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
              _bounceController.forward(from: 0.0);
            },
            child: AnimatedBuilder(
              animation: _bounceAnimation,
              builder: (context, child) => Transform.translate(
                offset: Offset(0, _bounceAnimation.value),
                child: child,
              ),
              child: Image.asset('assets/icons/upndownicon.png', width: 30),
            ),
          ),
        ),
      ],
    );
  }
}

// ── NEW: Dropdown field ───────────────────────────────────────────────────────

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.hint,
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String hint;
  final IconData icon;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

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
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          isDense: true,
          icon: const Icon(Icons.keyboard_arrow_down, size: 18),
          hint: Row(
            children: [
              Icon(icon, size: 16, color: Colors.black),
              const SizedBox(width: 4),
              Text(
                hint,
                style: GoogleFonts.oswald(fontSize: 11, color: Colors.black),
              ),
            ],
          ),
          items: items
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: GoogleFonts.oswald(fontSize: 11, color: Colors.black),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
          selectedItemBuilder: (context) => items
              .map(
                (item) => Row(
                  children: [
                    Icon(icon, size: 16, color: Colors.black),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        item,
                        style: GoogleFonts.oswald(
                            fontSize: 11, color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

// ── Existing widgets (unchanged) ──────────────────────────────────────────────

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
                  color: const Color.fromARGB(255, 0, 0, 0),
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

class _TappableField extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final hasValue = value.isNotEmpty;
    return GestureDetector(
      onTap: onTap,
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
            Icon(icon, size: 16, color: Colors.black),
            const SizedBox(width: 3),
            Expanded(
              child: Text(
                hasValue ? value : hint,
                style: GoogleFonts.oswald(fontSize: 11, color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.hint,
    required this.icon,
    required this.textController,
  });

  final String hint;
  final IconData icon;
  final TextEditingController textController;

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
        controller: textController,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.oswald(fontSize: 11),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          isDense: true,
          prefixIcon: Icon(icon, size: 16),
          prefixIconConstraints:
              const BoxConstraints(minWidth: 28, minHeight: 0),
        ),
      ),
    );
  }
}