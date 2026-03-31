import 'package:flutter/material.dart';

import '../../widgets/listing/cab_list_item_card.dart';
import '../../widgets/listing/listing_bottom_dock.dart';
import '../../widgets/listing/listing_header.dart';
import '../../widgets/listing/location_search_card.dart';
import '../../widgets/listing/section_title.dart';

class AvailableCabsScreen extends StatefulWidget {
  const AvailableCabsScreen({
    super.key,
    this.request = const LocationSearchRequest(
      pickup: '',
      drop: '',
      price: '',
      date: '',
      time: '',
    ),
  });

  final LocationSearchRequest request;

  @override
  State<AvailableCabsScreen> createState() => _AvailableCabsScreenState();
}

class _AvailableCabsScreenState extends State<AvailableCabsScreen> {
  final Set<String> _acceptedCabIds = <String>{};

  String _cabKey(_CabOption cab) => '${cab.driverName}|${cab.carModel}|${cab.eta}';

  static const List<_CabOption> _allCabs = [
    _CabOption(
      driverName: 'Mark',
      carModel: 'Sedan - A1243XY',
      fare: 800,
      eta: '30 Mins',
      pickup: 'Contai',
      drop: 'Digha',
    ),
    _CabOption(
      driverName: 'Harry',
      carModel: 'Sedan - B7732AR',
      fare: 840,
      eta: '25 Mins',
      pickup: 'Contai',
      drop: 'Digha',
    ),
    _CabOption(
      driverName: 'Samar',
      carModel: 'Sedan - D3345TR',
      fare: 760,
      eta: '34 Mins',
      pickup: 'Contai',
      drop: 'Digha',
    ),
    _CabOption(
      driverName: 'Noah',
      carModel: 'Sedan - T4921LM',
      fare: 920,
      eta: '22 Mins',
      pickup: 'Kolkata',
      drop: 'Digha',
    ),
  ];

  List<_CabOption> _filterCabs() {
    final pickupQuery = widget.request.pickup.toLowerCase();
    final dropQuery = widget.request.drop.toLowerCase();
    final maxPrice = widget.request.maxPrice;

    return _allCabs.where((cab) {
      final pickupMatches =
          pickupQuery.isEmpty || cab.pickup.toLowerCase().contains(pickupQuery);
      final dropMatches =
          dropQuery.isEmpty || cab.drop.toLowerCase().contains(dropQuery);
      final priceMatches = maxPrice == null || cab.fare <= maxPrice;
      return pickupMatches && dropMatches && priceMatches;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final filteredCabs = _filterCabs();
    final newlyCabs = filteredCabs
      .where((cab) => _acceptedCabIds.contains(_cabKey(cab)))
        .toList();
    final availableCabs = filteredCabs
      .where((cab) => !_acceptedCabIds.contains(_cabKey(cab)))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFE8E8E8),
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
              children: [
                const ListingHeader(),
                const SizedBox(height: 22),
                LocationSearchCard(
                  submitLabel: 'Resubmit',
                  initialPickup: widget.request.pickup,
                  initialDrop: widget.request.drop,
                  initialPrice: widget.request.price,
                  initialDate: widget.request.date,
                  initialTime: widget.request.time,
                  onSubmitWithValues: (nextRequest) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AvailableCabsScreen(
                          request: nextRequest,
                        ),
                      ),
                    );
                  },
                ),
                if (newlyCabs.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  const SectionTitle(title: 'Newly Cabs'),
                  const SizedBox(height: 12),
                  _AvailableCabList(
                    cabs: newlyCabs,
                    acceptLabel: 'Accepted',
                    isAcceptEnabled: false,
                  ),
                ],
                const SizedBox(height: 24),
                const SectionTitle(title: 'Available Cabs'),
                const SizedBox(height: 12),
                _AvailableCabList(
                  cabs: availableCabs,
                  fadeOut: newlyCabs.isNotEmpty,
                  isAcceptEnabled: newlyCabs.isEmpty,
                  emptyMessage:
                      'No more cabs available. Drivers who accepted are listed in Newly Cabs.',
                  onAccept: (cab) {
                    setState(() {
                      _acceptedCabIds.add(_cabKey(cab));
                    });
                  },
                ),
              ],
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

class _AvailableCabList extends StatelessWidget {
  const _AvailableCabList({
    required this.cabs,
    this.onAccept,
    this.emptyMessage,
    this.acceptLabel = 'Accept',
    this.isAcceptEnabled = true,
    this.fadeOut = false,
  });

  final List<_CabOption> cabs;
  final ValueChanged<_CabOption>? onAccept;
  final String? emptyMessage;
  final String acceptLabel;
  final bool isAcceptEnabled;
  final bool fadeOut;

  @override
  Widget build(BuildContext context) {
    final infoText = emptyMessage ??
        'No cabs found for this route and price. Try increasing your max price or updating destination.';

    if (cabs.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFF4E5B0),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2D2F35), width: 1),
        ),
        child: Text(
          infoText,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF2D2F35),
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return Column(
      children: cabs
          .map(
            (cab) {
              final card = CabListItemCard(
                driverName: cab.driverName,
                carModel: cab.carModel,
                fare: '${cab.fare.toStringAsFixed(0)} /-',
                eta: cab.eta,
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 14),
                acceptLabel: acceptLabel,
                isAcceptEnabled: isAcceptEnabled,
                onAccept: onAccept == null ? null : () => onAccept!(cab),
              );

              if (!fadeOut) {
                return card;
              }

              return ColorFiltered(
                colorFilter: const ColorFilter.matrix([
                  0.2126, 0.7152, 0.0722, 0, 0,
                  0.2126, 0.7152, 0.0722, 0, 0,
                  0.2126, 0.7152, 0.0722, 0, 0,
                  0, 0, 0, 1, 0,
                ]),
                child: card,
              );
            },
          )
          .toList(),
    );
  }
}

class _CabOption {
  const _CabOption({
    required this.driverName,
    required this.carModel,
    required this.fare,
    required this.eta,
    required this.pickup,
    required this.drop,
  });

  final String driverName;
  final String carModel;
  final double fare;
  final String eta;
  final String pickup;
  final String drop;
}
