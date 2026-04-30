import 'package:cabkaro/controllers/driver/driver_ride_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RequestCard extends StatefulWidget {
  final dynamic rideData;
  const RequestCard({super.key, required this.rideData});

  @override
  State<RequestCard> createState() => RequestCardState();
}

class RequestCardState extends State<RequestCard> {
  Offset acceptButton = Offset(3, 3);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF4E5B0),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF2D2F35), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            offset: Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with user info and date/time
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              _FarePill(
                                fare:
                                    '${widget.rideData['pickup_date'].split("T")[0]} • ${widget.rideData['pickup_time']}',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _FarePill(
                      fare: '${widget.rideData['price'] ?? '---'}',
                      isPrice: true,
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Route Display Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFFFFFFF).withOpacity(0.6),
                    const Color(0xFFFFFFFF).withOpacity(0.3),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF2D2F35).withOpacity(0.15),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    // Route indicator column
                    Column(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF4CAF50),
                            border: Border.all(
                              color: const Color(0xFF2D2F35),
                              width: 2,
                            ),
                          ),
                        ),
                        Container(
                          width: 2,
                          height: 40,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2D2F35),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFF44336),
                            border: Border.all(
                              color: const Color(0xFF2D2F35),
                              width: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 14),

                    // Locations column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Pickup location
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'PICKUP',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF4CAF50),
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 2),
                              ClipRect(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    widget.rideData['pickup_city'] ??
                                        'Unknown Pickup',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1F1F1F),
                                      height: 1.2,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Drop location
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'DROP-OFF',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromARGB(255, 0, 211, 130),
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 2),
                              ClipRect(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    widget.rideData['drop_city'] ??
                                        'Unknown Drop',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1F1F1F),
                                      height: 1.2,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Fare Pill
// ─────────────────────────────────────────────

class _FarePill extends StatefulWidget {
  final bool isPrice;
  final String fare;

  const _FarePill({required this.fare, this.isPrice = false});

  @override
  State<_FarePill> createState() => _FarePillState();
}

class _FarePillState extends State<_FarePill> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2F35),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        widget.isPrice ? 'User Fair - ₹ ${widget.fare}' : widget.fare,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _TimePickerChip extends StatefulWidget {
  const _TimePickerChip();

  @override
  State<_TimePickerChip> createState() => _TimePickerChipState();
}

class _TimePickerChipState extends State<_TimePickerChip> {
  Future<void> _pickTime() async {
    final controller = context.read<DriverRideController>();

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: controller.rideNegoTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFF8C100),
              onPrimary: Color(0xFF2D2F35),
              onSurface: Color(0xFF2D2F35),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.setRideNegoTime(picked);

      // ignore: use_build_context_synchronously
      context.read<DriverRideController>().setRideNegoTime(picked);
    }
  }

  String get _label {
    if (context.watch<DriverRideController>().rideNegoTime == null)
      return 'Estimate Time';
    final hour =
        context.watch<DriverRideController>().rideNegoTime!.hourOfPeriod == 0
        ? 12
        : context.watch<DriverRideController>().rideNegoTime!.hourOfPeriod;
    final minute = context
        .watch<DriverRideController>()
        .rideNegoTime!
        .minute
        .toString()
        .padLeft(2, '0');
    final period =
        context.watch<DriverRideController>().rideNegoTime!.period ==
            DayPeriod.am
        ? 'AM'
        : 'PM';
    return '$hour:$minute $period';
  }

  bool get _hasSelection =>
      context.watch<DriverRideController>().rideNegoTime != null;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickTime,
      child: Container(
        height: 40,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFF66635A), width: 1),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.access_time_rounded,
              size: 18,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  color: _hasSelection
                      ? const Color(0xFF2F2F2F)
                      : const Color.fromARGB(255, 0, 0, 0),
                  fontWeight: _hasSelection ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Price Input
// ─────────────────────────────────────────────

class _PriceInput extends StatefulWidget {
  const _PriceInput();
  @override
  State<_PriceInput> createState() => _PriceInputState();
}

class _PriceInputState extends State<_PriceInput> {
  @override
  void dispose() {
    context.read<DriverRideController>().rideNegoPrice.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF66635A), width: 1),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.currency_rupee_rounded,
            size: 18,
            color: Color(0xFF3F3F3F),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: context.read<DriverRideController>().rideNegoPrice,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF2F2F2F),
                fontWeight: FontWeight.w500,
              ),
              decoration: const InputDecoration(
                hintText: 'Enter price',
                hintStyle: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CarSelectionSheet extends StatefulWidget {
  final List cars;
  final Function(dynamic car) onAssign;
  const _CarSelectionSheet({required this.cars, required this.onAssign});
  @override
  State<_CarSelectionSheet> createState() => _CarSelectionSheetState();
}

class _CarSelectionSheetState extends State<_CarSelectionSheet> {
  dynamic selectedCar;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFE8E8E8),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Drag handle ─────────────────────────────────
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCCCCCC),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 18),

              // ── Header ──────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select Car',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2D2F35),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D2F35),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ── Car List ─────────────────────────────────────
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 320),
                child: widget.cars.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: Text(
                            'No cars available',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF999999),
                            ),
                          ),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: widget.cars.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final car = widget.cars[index];
                          final isSelected = selectedCar == car;

                          return GestureDetector(
                            onTap: () => setState(() => selectedCar = car),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF2D2F35)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFFF8C100)
                                      : Colors.transparent,
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Car icon bubble
                                  Container(
                                    width: 46,
                                    height: 46,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? const Color(
                                              0xFFF8C100,
                                            ).withOpacity(0.15)
                                          : const Color(0xFFF5F5F5),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.directions_car_rounded,
                                      color: isSelected
                                          ? const Color(0xFFF8C100)
                                          : const Color(0xFF2D2F35),
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 14),

                                  // Car details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          car['vehicle_model'] ?? 'Car',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: isSelected
                                                ? Colors.white
                                                : const Color(0xFF2D2F35),
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          car['vehicle_number'] ?? '',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: isSelected
                                                ? const Color(0xFFAAAAAA)
                                                : const Color(0xFF999999),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Check badge
                                  if (isSelected)
                                    Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF8C100),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        color: Color(0xFF2D2F35),
                                        size: 16,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),

              const SizedBox(height: 20),

              // ── Assign Button ────────────────────────────────
              GestureDetector(
                onTap: selectedCar == null
                    ? null
                    : () => widget.onAssign(selectedCar),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: selectedCar == null
                        ? const Color(0xFFCCCCCC)
                        : const Color(0xFF2D2F35),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    selectedCar == null ? 'Select a Car First' : 'Assign Car',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: selectedCar == null
                          ? const Color(0xFF888888)
                          : Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
