import 'package:flutter/material.dart';

class LocationSearchRequest {
  const LocationSearchRequest({
    required this.pickup,
    required this.drop,
    required this.price,
    required this.date,
    required this.time,
  });

  final String pickup;
  final String drop;
  final String price;
  final String date;
  final String time;

  double? get maxPrice {
    final cleaned = price.replaceAll(RegExp(r'[^0-9.]'), '');
    if (cleaned.isEmpty) {
      return null;
    }
    return double.tryParse(cleaned);
  }
}

class LocationSearchCard extends StatefulWidget {
  const LocationSearchCard({
    super.key,
    this.submitLabel = 'Submit',
    this.onSubmit,
    this.onSubmitWithValues,
    this.initialPickup,
    this.initialDrop,
    this.initialPrice,
    this.initialDate,
    this.initialTime,
  });

  final String submitLabel;
  final VoidCallback? onSubmit;
  final ValueChanged<LocationSearchRequest>? onSubmitWithValues;
  final String? initialPickup;
  final String? initialDrop;
  final String? initialPrice;
  final String? initialDate;
  final String? initialTime;

  @override
  State<LocationSearchCard> createState() => _LocationSearchCardState();
}

class _LocationSearchCardState extends State<LocationSearchCard> {
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _dropController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pickupController.text = widget.initialPickup ?? '';
    _dropController.text = widget.initialDrop ?? '';
    _priceController.text = widget.initialPrice ?? '';
    _dateController.text = widget.initialDate ?? '';
    _timeController.text = widget.initialTime ?? '';
  }

  void _handleSubmit() {
    final request = LocationSearchRequest(
      pickup: _pickupController.text.trim(),
      drop: _dropController.text.trim(),
      price: _priceController.text.trim(),
      date: _dateController.text.trim(),
      time: _timeController.text.trim(),
    );

    widget.onSubmitWithValues?.call(request);
    widget.onSubmit?.call();
  }

  Future<void> _pickDate() async {
    final DateTime now = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFF8C100),
              onPrimary: Color(0xFF1F1F1F),
              surface: Color(0xFFFFF1C6),
              onSurface: Color(0xFF1F1F1F),
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: Color(0xFFFFF1C6),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF2D2F35),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) {
      return;
    }

    setState(() {
      _dateController.text = _formatDate(picked);
    });
  }

  Future<void> _pickTime() async {
    final TimeOfDay now = TimeOfDay.now();

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFF8C100),
              onPrimary: Color(0xFF1F1F1F),
              surface: Color(0xFFFFF1C6),
              onSurface: Color(0xFF1F1F1F),
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: Color(0xFFFFF1C6),
            ),
            timePickerTheme: const TimePickerThemeData(
              backgroundColor: Color(0xFFFFF1C6),
              hourMinuteTextColor: Color(0xFF1F1F1F),
              dayPeriodTextColor: Color(0xFF1F1F1F),
              dialHandColor: Color(0xFFF8C100),
              dialTextColor: Color(0xFF1F1F1F),
              entryModeIconColor: Color(0xFF2D2F35),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF2D2F35),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) {
      return;
    }

    setState(() {
      _timeController.text = _formatTime(picked);
    });
  }

  String _formatDate(DateTime date) {
    const List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]}';
  }

  String _formatTime(TimeOfDay time) {
    final String hour = time.hour.toString().padLeft(2, '0');
    final String minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  void dispose() {
    _pickupController.dispose();
    _dropController.dispose();
    _priceController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8C100),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2D2F35), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          _InputField(
            hintText: 'Pickup Location',
            icon: Icons.my_location_rounded,
            controller: _pickupController,
          ),
          const SizedBox(height: 10),
          _InputField(
            hintText: 'Drop Location',
            icon: Icons.place_outlined,
            controller: _dropController,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _InputField(
                  hintText: 'Price',
                  icon: Icons.currency_rupee_rounded,
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _InputField(
                  hintText: 'Date',
                  icon: Icons.calendar_month_outlined,
                  controller: _dateController,
                  readOnly: true,
                  onTap: _pickDate,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _InputField(
                  hintText: 'Time',
                  icon: Icons.access_time_rounded,
                  controller: _timeController,
                  readOnly: true,
                  onTap: _pickTime,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _SubmitButton(label: widget.submitLabel, onTap: _handleSubmit),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.hintText,
    required this.icon,
    required this.controller,
    this.keyboardType,
    this.readOnly = false,
    this.onTap,
  });

  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      canRequestFocus: !readOnly,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1F1F1F),
      ),
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0x8A1F1F1F),
        ),
        prefixIcon: Icon(icon, size: 18, color: const Color(0xFF1F1F1F)),
        prefixIconConstraints: const BoxConstraints(minWidth: 36),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        filled: true,
        fillColor: const Color(0xFFF8C100),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(
            color: const Color(0xFF2D2F35),
            width: 1,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(
            color: const Color(0xFF2D2F35),
            width: 1,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: Color(0xFF1F1F1F), width: 1.2),
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xFF2D2F35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
