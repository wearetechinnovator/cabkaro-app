import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/gradient_background.dart';

// Shared ride status notifier — import this wherever BookingDetailsScreen needs it
class RideStatusNotifier extends ChangeNotifier {
  String _status = 'Booked';

  String get status => _status;

  void updateStatus(String newStatus) {
    _status = newStatus;
    notifyListeners();
  }
}

// Simple singleton so both screens share the same instance without full Provider setup
final globalRideStatus = RideStatusNotifier();

// Status config
const _statusSteps = [
  'Booked',
  'Driver on the way',
  'Picked up',
  'In Transit',
  'Completed',
];

const _statusColors = {
  'Booked': Color(0xFF1DA20B),
  'Driver on the way': Color(0xFF1976D2),
  'Picked up': Color(0xFFF8C100),
  'In Transit': Color(0xFFFF6F00),
  'Completed': Color(0xFF4CAF50),
};

const _statusIcons = {
  'Booked': Icons.check_circle_outline,
  'Driver on the way': Icons.directions_car_outlined,
  'Picked up': Icons.person_pin_circle_outlined,
  'In Transit': Icons.route_outlined,
  'Completed': Icons.flag_outlined,
};

class UserOngoingRidesScreen extends StatefulWidget {
  const UserOngoingRidesScreen({super.key});

  @override
  State<UserOngoingRidesScreen> createState() => _UserOngoingRidesScreenState();
}

class _UserOngoingRidesScreenState extends State<UserOngoingRidesScreen> {
  // Mock bookings — in production replace with real data from your controller
  final List<Map<String, dynamic>> _bookings = [
    {
      'id': 'BK001',
      'passenger': 'Rahul Das',
      'phone': '98765 43210',
      'from': 'Contai',
      'to': 'Digha',
      'fare': '₹800',
      'date': '30 Dec',
      'time': '9:30 AM',
      'status': globalRideStatus, // shared notifier
    },
    {
      'id': 'BK002',
      'passenger': 'Priya Sen',
      'phone': '91234 56789',
      'from': 'Kolkata',
      'to': 'Haldia',
      'fare': '₹1,200',
      'date': '31 Dec',
      'time': '11:00 AM',
      'status': RideStatusNotifier(), // separate notifier per booking
    },
  ];

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
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      "Ongoing Rides",
                      style: GoogleFonts.oswald(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Booking cards
              Expanded(
                child: _bookings.isEmpty
                    ? Center(
                        child: Text(
                          "No ongoing rides.",
                          style: GoogleFonts.nunitoSans(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: _bookings.length,
                        itemBuilder: (context, index) =>
                            _BookingCard(booking: _bookings[index]),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookingCard extends StatefulWidget {
  final Map<String, dynamic> booking;
  const _BookingCard({required this.booking});

  @override
  State<_BookingCard> createState() => _BookingCardState();
}

class _BookingCardState extends State<_BookingCard> {
  late RideStatusNotifier _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = widget.booking['status'] as RideStatusNotifier;
    _notifier.addListener(_onStatusChanged);
  }

  @override
  void dispose() {
    _notifier.removeListener(_onStatusChanged);
    super.dispose();
  }

  void _onStatusChanged() => setState(() {});

  void _showStatusPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                "Update Ride Status",
                style: GoogleFonts.oswald(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.booking['id'],
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
              const SizedBox(height: 16),
              ..._statusSteps.map((step) {
                final isCurrent = _notifier.status == step;
                final currentIdx = _statusSteps.indexOf(_notifier.status);
                final stepIdx = _statusSteps.indexOf(step);
                final isPast = stepIdx < currentIdx;
                final color = _statusColors[step]!;

                return GestureDetector(
                  onTap: stepIdx <= currentIdx
                      ? null // can't go backward
                      : () {
                          _notifier.updateStatus(step);
                          Navigator.pop(context);
                        },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? color.withOpacity(0.12)
                          : isPast
                          ? Colors.grey.withOpacity(0.06)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isCurrent
                            ? color
                            : isPast
                            ? Colors.grey[300]!
                            : Colors.grey[200]!,
                        width: isCurrent ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _statusIcons[step],
                          size: 20,
                          color: isCurrent
                              ? color
                              : isPast
                              ? Colors.grey[400]
                              : Colors.grey[600],
                        ),
                        const SizedBox(width: 12),
                        Text(
                          step,
                          style: GoogleFonts.nunitoSans(
                            fontSize: 15,
                            fontWeight: isCurrent
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isCurrent
                                ? color
                                : isPast
                                ? Colors.grey[400]
                                : Colors.grey[800],
                          ),
                        ),
                        const Spacer(),
                        if (isCurrent)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "Current",
                              style: GoogleFonts.nunitoSans(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        if (isPast)
                          Icon(
                            Icons.check_circle,
                            size: 18,
                            color: Colors.grey[400],
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final status = _notifier.status;
    final statusColor = _statusColors[status]!;
    final b = widget.booking;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withOpacity(0.5), width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          // Header row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              children: [
                // Passenger avatar
                CircleAvatar(
                  radius: 22,
                  backgroundColor: const Color(0xFFF2CA2A).withOpacity(0.2),
                  child: const Icon(
                    Icons.person,
                    color: Color(0xFFDDA200),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        b['passenger'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        b['phone'],
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                // Booking ID + date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      b['id'],
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${b['date']} · ${b['time']}',
                      style: TextStyle(color: Colors.grey[500], fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Route row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                const Icon(Icons.my_location, size: 14, color: Colors.green),
                const SizedBox(width: 6),
                Text(
                  b['from'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, size: 14, color: Colors.grey),
                const SizedBox(width: 8),
                const Icon(Icons.location_on, size: 14, color: Colors.red),
                const SizedBox(width: 6),
                Text(
                  b['to'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const Spacer(),
                Text(
                  b['fare'],
                  style: GoogleFonts.oswald(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Status bar + update button
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Status pill
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFFF6F00).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Color(0xFFFF6F00).withOpacity(0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.location_disabled_sharp, size: 14, color: Color(0xFFFF6F00)),
                      const SizedBox(width: 5),
                      Text(
                        "Cancel ride",
                        style: GoogleFonts.nunitoSans(
                          color: Color(0xFFFF6F00),
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Update button — disabled when completed
                if (status != 'Completed')
                  GestureDetector(
                    onTap: _showStatusPicker,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1F1F1F),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.edit_location_alt_outlined, color: Colors.white, size: 14),
                          const SizedBox(width: 5),
                          Text(
                            "Edit ride",
                            style: GoogleFonts.oswald(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (status == 'Completed')
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.green.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 14,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "Ride Done",
                          style: GoogleFonts.oswald(
                            color: Colors.green,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
