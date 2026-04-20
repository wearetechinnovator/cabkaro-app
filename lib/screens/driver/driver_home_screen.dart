import 'package:cabkaro/controllers/driver/driver_ride_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cabkaro/widgets/listing/listing_bottom_dock.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  @override
  initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DriverRideController>().getRide(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    List<dynamic> availableRides = context
        .watch<DriverRideController>()
        .availableRides;

    return Scaffold(
      backgroundColor: const Color(0xFFE8E8E8),
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () =>
                  context.read<DriverRideController>().refreshRides(context),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
                children: [
                  _DriverHeader(),
                  SizedBox(height: 24),
                  Text(
                    'Driver Dashboard',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F1F1F),
                      height: 1,
                    ),
                  ),
                  SizedBox(height: 16),
                  ...List.generate(
                    availableRides.length,
                    (index) => Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: _RequestCard(rideData: availableRides[index]),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: screenWidth * 0.07,
              right: screenWidth * 0.07,
              bottom: 16,
              child: const ListingBottomDock(),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Header
// ─────────────────────────────────────────────

class _DriverHeader extends StatefulWidget {
  const _DriverHeader();

  @override
  State<_DriverHeader> createState() => _DriverHeaderState();
}

class _DriverHeaderState extends State<_DriverHeader> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _HeaderCircle(icon: Icons.grid_view_rounded),
        const Spacer(),
        _HeaderCircle(
          icon: Icons.notifications_none_rounded,
          onTap: () => Navigator.pushNamed(context, '/notifications'),
        ),
        const SizedBox(width: 12),
        const CircleAvatar(
          radius: 20,
          backgroundColor: Color(0xFFD24A61),
          child: Text(
            'M',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

class _HeaderCircle extends StatefulWidget {
  const _HeaderCircle({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  State<_HeaderCircle> createState() => _HeaderCircleState();
}

class _HeaderCircleState extends State<_HeaderCircle> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: widget.onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF2D2F35), width: 1.2),
        ),
        child: Icon(widget.icon, size: 20, color: const Color(0xFF2D2F35)),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Request Card
// ─────────────────────────────────────────────

class _RequestCard extends StatefulWidget {
  final dynamic rideData;
  const _RequestCard({required this.rideData});

  @override
  State<_RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<_RequestCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF4E5B0),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2D2F35), width: 1.2),
        boxShadow: const [
          BoxShadow(color: Color(0xFF4D4D4D), offset: Offset(2, 3)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 8, 8),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFE6A64E),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          widget.rideData['user']['name'] != null
                              ? widget.rideData['user']['name'][0].toUpperCase()
                              : 'U',
                          style: TextStyle(
                            color: Color(0xFF2D2F35),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          widget.rideData['user']['name'] ?? 'Unknown User',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1F1F1F),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 126,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFFF8C100),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(22),
                  ),
                ),
                transform: Matrix4.translationValues(0, -9, 0),
                child: Row(
                  children: [
                    Icon(Icons.access_time_rounded, size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${widget.rideData['pickup_date'].split("T")[0] ?? 'Unknown Date'}\n${widget.rideData['pickup_time'] ?? 'Unknown Time'}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          height: 1.1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _PriceInput(),
                      SizedBox(height: 8),
                      _TimePickerChip(),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            context.read<DriverRideController>().acceptRide(
                              context,
                              widget.rideData,
                            );
                          },
                          child: Container(
                            height: 36,
                            width: 86,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8C100),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'Accept',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _FarePill(
                      fare: '${widget.rideData['price'] ?? 'Unknown Fare'} /-',
                    ),
                    SizedBox(height: 20),
                    _RouteLine(),
                  ],
                ),
              ],
            ),
          ),
        ],
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

// ─────────────────────────────────────────────
// Time Picker Chip  (replaces the old _ChipInput for time)
// ─────────────────────────────────────────────

class _TimePickerChip extends StatefulWidget {
  const _TimePickerChip();

  @override
  State<_TimePickerChip> createState() => _TimePickerChipState();
}

class _TimePickerChipState extends State<_TimePickerChip> {
  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime:
          context.watch<DriverRideController>().rideNegoTime ?? TimeOfDay.now(),
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
// Fare Pill
// ─────────────────────────────────────────────

class _FarePill extends StatefulWidget {
  const _FarePill({required this.fare});

  final String fare;

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
        'Fair - ₹ ${widget.fare}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Route Line
// ─────────────────────────────────────────────

class _RouteLine extends StatefulWidget {
  const _RouteLine();

  @override
  State<_RouteLine> createState() => _RouteLineState();
}

class _RouteLineState extends State<_RouteLine> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _Dot(),
              SizedBox(width: 8),
              Expanded(
                child: Divider(
                  color: Color(0xFF3D3D3D),
                  thickness: 2,
                  height: 2,
                ),
              ),
              SizedBox(width: 8),
              _Dot(),
            ],
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Contai',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              Text(
                'Digha',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Dot
// ─────────────────────────────────────────────

class _Dot extends StatefulWidget {
  const _Dot();

  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 11,
      height: 11,
      decoration: const BoxDecoration(
        color: Color(0xFFF8C100),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: 4,
          height: 4,
          decoration: const BoxDecoration(
            color: Color(0xFF2D2F35),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
