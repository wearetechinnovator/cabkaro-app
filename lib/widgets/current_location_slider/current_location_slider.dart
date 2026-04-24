import 'package:cabkaro/screens/user/booked_cab_screen.dart';
import 'package:flutter/material.dart';
import 'current_location_data.dart';
import 'current_location_card.dart';

const List<CabData> _cabs = [
  CabData(
    driverName: 'Mark',
    carModel: 'Sedan - A1243XG',
    fare: '₹ 800 /-',
    eta: '30 Mins',
  ),
  CabData(
    driverName: 'Harry',
    carModel: 'Sedan - B7732AR',
    fare: '₹ 840 /-',
    eta: '25 Mins',
  ),
  CabData(
    driverName: 'Samar',
    carModel: 'Sedan - D3345TR',
    fare: '₹ 760 /-',
    eta: '34 Mins',
  ),
  CabData(
    driverName: 'Samar',
    carModel: 'Sedan - D3345TR',
    fare: '₹ 760 /-',
    eta: '34 Mins',
  ),
];

class CurrentLocationSlider extends StatefulWidget {
  const CurrentLocationSlider({super.key, required this.onPageChanged});
  final ValueChanged<int> onPageChanged;


  static int get count => _cabs.length;

  @override
  State<CurrentLocationSlider> createState() => _CurrentLocationSliderState();
}

class _CurrentLocationSliderState extends State<CurrentLocationSlider> {
  final _controller = PageController(viewportFraction: 1);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      height: 150,
      width: double.infinity,
      child: PageView.builder(
        controller: _controller,
        padEnds: false,
        clipBehavior: Clip.none,
        itemCount: _cabs.length,
        onPageChanged: widget.onPageChanged,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              double value = 1.0;

              if (_controller.position.haveDimensions) {
                value = _controller.page! - index;
                value = (1 - (value.abs() * 0.2)).clamp(0.85, 1.0);
              }

              return Center(
                child: Transform.scale(scale: value, child: child),
              );
            },
            child: CabCard(
              data: _cabs[index],
              onAccept: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BookedCabScreen()),
                );
              },
              cardColor: const Color(0xFFF8C100),
            ),
          );
        },
      ),
    );
  }
}
