import 'package:flutter/material.dart';

class DashboardActionCard extends StatelessWidget {
  const DashboardActionCard({
    super.key,
    required this.userName,
    this.onEditProfileTap,
  });

  final String userName;
  final VoidCallback? onEditProfileTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8C100),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.person, color: Color(0xFF2D2F35)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2D2F35),
                  ),
                ),
              ),
              GestureDetector(
                onTap: onEditProfileTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D2F35),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Edit Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(color: Color(0x66FFFFFF), thickness: 1),
          const _ActionRow(
            icon: Icons.history,
            label: 'Last Ride',
            trailing: Icon(Icons.arrow_forward, color: Color(0xFF2D2F35)),
          ),
          const Divider(color: Color(0x66FFFFFF), thickness: 1),
          const _ActionRow(
            icon: Icons.location_city,
            label: 'Nearby Hotel',
            trailing: Text(
              'Coming Soon',
              style: TextStyle(fontSize: 14, color: Color(0xFF6A6A6A)),
            ),
          ),
          const Divider(color: Color(0x66FFFFFF), thickness: 1),
          const _ActionRow(
            icon: Icons.map_outlined,
            label: 'Offline Map',
            trailing: Text(
              'Coming Soon',
              style: TextStyle(fontSize: 14, color: Color(0xFF6A6A6A)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.label,
    required this.trailing,
  });

  final IconData icon;
  final String label;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF2D2F35), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2D2F35),
              ),
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}
