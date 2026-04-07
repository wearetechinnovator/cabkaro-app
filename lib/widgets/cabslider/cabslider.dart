import 'package:cabkaro/screens/user/booked_cab_screen.dart';
import 'package:flutter/material.dart';
import 'cabdata.dart';
import 'cabcard.dart';
class CabSlider extends StatelessWidget {
  const CabSlider();

  static const List<CabData> _cabs = [
    CabData(driverName: 'Mark', carModel: 'Sedan - A1243XG', fare: '₹ 800 /-', eta: '30 Mins'),
    CabData(driverName: 'Harry', carModel: 'Sedan - B7732AR', fare: '₹ 840 /-', eta: '25 Mins'),
    CabData(driverName: 'Samar', carModel: 'Sedan - D3345TR', fare: '₹ 760 /-', eta: '34 Mins'),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: _cabs.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CabCard(data: _cabs[index], screenWidth: screenWidth, onAccept: (){
              Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookedCabScreen(),
                      ),
                    );
            },
            cardColor: Color(0xFFF8C100),
            ),
          );
        },
      ),
    );
  }
}