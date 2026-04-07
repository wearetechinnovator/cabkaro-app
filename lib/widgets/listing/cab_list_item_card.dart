import 'package:flutter/material.dart';

class CabListItemCard extends StatelessWidget {
  const CabListItemCard({
    super.key,
    required this.driverName,
    required this.carModel,
    required this.fare,
    required this.eta,
    this.width = 334,
    this.margin = const EdgeInsets.only(right: 12),
    this.onAccept,
    this.acceptLabel = 'Accept',
    this.isAcceptEnabled = true,
  });

  final String driverName;
  final String carModel;
  final String fare;
  final String eta;
  final double width;
  final EdgeInsetsGeometry margin;
  final VoidCallback? onAccept;
  final String acceptLabel;
  final bool isAcceptEnabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: margin,
      // height: 1000,

      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF4E5B0),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF2D2F35), width: 1),
        boxShadow: const [
          BoxShadow(color: Color(0xFF4D4D4D), offset: Offset(3, 4)),
        ],
        
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DriverRow(driverName: driverName, carModel: carModel, eta: eta),
          const SizedBox(height: 8),
          const _BenefitList(),
          const SizedBox(height: 8),
          _FareRow(
            fare: fare,
            onAccept: onAccept,
            acceptLabel: acceptLabel,
            isAcceptEnabled: isAcceptEnabled,
          ),
        ],
      ),
    );
  }
}

class _DriverRow extends StatelessWidget {
  const _DriverRow({
    required this.driverName,
    required this.carModel,
    required this.eta,
  });

  final String driverName;
  final String carModel;
  final String eta;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFEA5A5A),
          ),
          alignment: Alignment.center,
          child: const Text(
            'M',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                driverName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                carModel,
                style: const TextStyle(fontSize: 14, color: Color(0xFF3E3E3E)),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            color: const Color(0xFFF8C100),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.access_time_rounded, size: 15),
              const SizedBox(width: 6),
              Text(
                eta,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BenefitList extends StatelessWidget {
  const _BenefitList();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Benefits',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 4),
        _BenefitItem(text: '4 Seat Available'),
        _BenefitItem(text: 'Air Conditioner'),
        _BenefitItem(text: 'WiFi'),
      ],
    );
  }
}

class _BenefitItem extends StatelessWidget {
  const _BenefitItem({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        children: [
          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(text, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}

class _FareRow extends StatelessWidget {
  const _FareRow({
    required this.fare,
    this.onAccept,
    required this.acceptLabel,
    required this.isAcceptEnabled,
  });

  final String fare;
  final VoidCallback? onAccept;
  final String acceptLabel;
  final bool isAcceptEnabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: isAcceptEnabled ? onAccept : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isAcceptEnabled
                  ? const Color(0xFFF8C100)
                  : const Color(0xFFE1C96A),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              acceptLabel,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF2D2F35),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Fair - $fare',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
