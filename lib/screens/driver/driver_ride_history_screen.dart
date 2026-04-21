import 'package:flutter/material.dart';
import '../../widgets/driver/driver_bottom_dock.dart';

// ─── Data model ───────────────────────────────────────────────
class RideHistory {
  final String id;
  final String passengerName;
  final String pickupAddress;
  final String dropAddress;
  final String date;
  final String time;
  final String duration;
  final double fare;
  final double distanceKm;
  final int rating;

  const RideHistory({
    required this.id,
    required this.passengerName,
    required this.pickupAddress,
    required this.dropAddress,
    required this.date,
    required this.time,
    required this.duration,
    required this.fare,
    required this.distanceKm,
    required this.rating,
  });
}

// ─── Dummy data ────────────────────────────────────────────────
final List<RideHistory> _dummyRides = [
  RideHistory(
    id: 'RD-00123',
    passengerName: 'Priya Sharma',
    pickupAddress: '12 Park Street, Kolkata',
    dropAddress: 'Salt Lake Sector V, Kolkata',
    date: 'Today',
    time: '10:24 AM',
    duration: '28 min',
    fare: 185.50,
    distanceKm: 9.4,
    rating: 5,
  ),
  RideHistory(
    id: 'RD-00122',
    passengerName: 'Rahul Das',
    pickupAddress: 'Howrah Station, Howrah',
    dropAddress: 'New Town Action Area 1',
    date: 'Today',
    time: '8:05 AM',
    duration: '42 min',
    fare: 310.00,
    distanceKm: 18.2,
    rating: 4,
  ),
  RideHistory(
    id: 'RD-00121',
    passengerName: 'Anjali Roy',
    pickupAddress: 'Jadavpur University, Kolkata',
    dropAddress: 'Ballygunge Place, Kolkata',
    date: 'Yesterday',
    time: '6:45 PM',
    duration: '19 min',
    fare: 132.00,
    distanceKm: 5.8,
    rating: 5,
  ),
  RideHistory(
    id: 'RD-00120',
    passengerName: 'Suresh Kumar',
    pickupAddress: 'Airport Gate 2, Dum Dum',
    dropAddress: 'Rajarhat Township',
    date: 'Yesterday',
    time: '2:10 PM',
    duration: '35 min',
    fare: 260.00,
    distanceKm: 14.1,
    rating: 4,
  ),
  RideHistory(
    id: 'RD-00119',
    passengerName: 'Meera Ghosh',
    pickupAddress: 'Gariahat Market, Kolkata',
    dropAddress: 'Tollygunge Metro, Kolkata',
    date: '18 Apr',
    time: '11:30 AM',
    duration: '14 min',
    fare: 98.00,
    distanceKm: 3.9,
    rating: 5,
  ),
  RideHistory(
    id: 'RD-00118',
    passengerName: 'Amit Banerjee',
    pickupAddress: 'Sealdah Station, Kolkata',
    dropAddress: 'EM Bypass, Ruby Hospital',
    date: '17 Apr',
    time: '9:00 AM',
    duration: '31 min',
    fare: 220.00,
    distanceKm: 11.6,
    rating: 3,
  ),
];

// ─── Screen ────────────────────────────────────────────────────
class RideHistoryScreen extends StatelessWidget {
  const RideHistoryScreen({super.key});

  double get _totalEarnings =>
      _dummyRides.fold(0, (sum, r) => sum + r.fare);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFE8E8E8),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // ── Header ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8C100),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(Icons.arrow_back,
                              color: Colors.white, size: 20),
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        'Ride History',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2D2F35),
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 44), // balance
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ── Summary card ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D2F35),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _SummaryTile(
                          label: 'Total Rides',
                          value: '${_dummyRides.length}',
                          icon: Icons.directions_car_rounded,
                        ),
                        _divider(),
                        _SummaryTile(
                          label: 'Total Earned',
                          value:
                              '₹${_totalEarnings.toStringAsFixed(0)}',
                          icon: Icons.currency_rupee_rounded,
                        ),
                        _divider(),
                        _SummaryTile(
                          label: 'Avg Rating',
                          value: _avgRating,
                          icon: Icons.star_rounded,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ── List ──
                Expanded(
                  child: ListView.separated(
                    padding:
                        const EdgeInsets.fromLTRB(20, 4, 20, 120),
                    itemCount: _dummyRides.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) => _RideTile(
                      ride: _dummyRides[index],
                    ),
                  ),
                ),
              ],
            ),

            // ── Bottom Dock ──
            Positioned(
              left: screenWidth * 0.07,
              right: screenWidth * 0.07,
              bottom: 14,
              child: const DriverBottomDock(),
            ),
          ],
        ),
      ),
    );
  }

  String get _avgRating {
    final avg =
        _dummyRides.fold(0, (sum, r) => sum + r.rating) /
            _dummyRides.length;
    return avg.toStringAsFixed(1);
  }

  Widget _divider() => Container(
        width: 1,
        height: 36,
        color: Colors.white24,
      );
}

// ─── Summary tile ──────────────────────────────────────────────
class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.label,
    required this.value,
    required this.icon,
  });
  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFFF8C100), size: 22),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white54,
          ),
        ),
      ],
    );
  }
}

// ─── Ride tile ─────────────────────────────────────────────────
class _RideTile extends StatelessWidget {
  const _RideTile({required this.ride});
  final RideHistory ride;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showRideDetail(context, ride),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row — passenger + fare
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.person_rounded,
                      color: Color(0xFFF8C100), size: 22),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ride.passengerName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D2F35),
                        ),
                      ),
                      Text(
                        '${ride.date}  •  ${ride.time}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF999999),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '₹${ride.fare.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D2F35),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFFF0F0F0)),
            const SizedBox(height: 12),

            // Route
            _RouteRow(
              pickup: ride.pickupAddress,
              drop: ride.dropAddress,
            ),

            const SizedBox(height: 12),

            // Bottom chips
            Row(
              children: [
                _Chip(
                    icon: Icons.timer_outlined,
                    label: ride.duration),
                const SizedBox(width: 8),
                _Chip(
                    icon: Icons.route_outlined,
                    label: '${ride.distanceKm} km'),
                const Spacer(),
                Row(
                  children: List.generate(
                    5,
                    (i) => Icon(
                      i < ride.rating
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      size: 16,
                      color: const Color(0xFFF8C100),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Route row ─────────────────────────────────────────────────
class _RouteRow extends StatelessWidget {
  const _RouteRow({required this.pickup, required this.drop});
  final String pickup;
  final String drop;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            Container(
                width: 1.5,
                height: 24,
                color: const Color(0xFFCCCCCC)),
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: const Color(0xFFF8C100),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(pickup,
                  style: const TextStyle(
                      fontSize: 13, color: Color(0xFF2D2F35))),
              const SizedBox(height: 18),
              Text(drop,
                  style: const TextStyle(
                      fontSize: 13, color: Color(0xFF2D2F35))),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Chip ──────────────────────────────────────────────────────
class _Chip extends StatelessWidget {
  const _Chip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: const Color(0xFF888888)),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(
                  fontSize: 12, color: Color(0xFF555555))),
        ],
      ),
    );
  }
}

// ─── Detail bottom sheet ───────────────────────────────────────
void _showRideDetail(BuildContext context, RideHistory ride) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (ctx) => _RideDetailSheet(ride: ride),
  );
}

class _RideDetailSheet extends StatelessWidget {
  const _RideDetailSheet({required this.ride});
  final RideHistory ride;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFDDDDDD),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    ride.id,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFF8C100),
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Completed',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Passenger
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.person_rounded,
                      color: Color(0xFFF8C100), size: 26),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ride.passengerName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2D2F35),
                      ),
                    ),
                    Text(
                      '${ride.date}  •  ${ride.time}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF999999),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: List.generate(
                    5,
                    (i) => Icon(
                      i < ride.rating
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      size: 18,
                      color: const Color(0xFFF8C100),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          const Divider(indent: 20, endIndent: 20),
          const SizedBox(height: 16),

          // Route
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _RouteRow(
                pickup: ride.pickupAddress, drop: ride.dropAddress),
          ),

          const SizedBox(height: 16),
          const Divider(indent: 20, endIndent: 20),
          const SizedBox(height: 16),

          // Stats grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _StatBox(
                    label: 'Fare',
                    value: '₹${ride.fare.toStringAsFixed(0)}'),
                const SizedBox(width: 12),
                _StatBox(label: 'Distance', value: '${ride.distanceKm} km'),
                const SizedBox(width: 12),
                _StatBox(label: 'Duration', value: ride.duration),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2D2F35),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF999999),
              ),
            ),
          ],
        ),
      ),
    );
  }
}