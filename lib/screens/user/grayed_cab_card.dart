// helper widget at bottom of file
import 'package:flutter/material.dart';
import '../../widgets/cabslider/cabcard.dart';
import '../../widgets/cabslider/cabdata.dart';

class GreyedCabCard extends StatefulWidget {
  final CabData cab;
  final double screenWidth;

  const GreyedCabCard({required this.cab, required this.screenWidth});

  @override
  State<GreyedCabCard> createState() => _GreyedCabCardState();
}

class _GreyedCabCardState extends State<GreyedCabCard> {
  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: const ColorFilter.matrix([
        0.2126, 0.7152, 0.0722, 0, 0,
        0.2126, 0.7152, 0.0722, 0, 0,
        0.2126, 0.7152, 0.0722, 0, 0,
        0,      0,      0,      1, 0,
      ]),
      child: IgnorePointer( // disables tap on greyed cards
        child: CabCard(
          cardColor: Color(0xFFF8C100),
          data: widget.cab,
          screenWidth: widget.screenWidth,
          onAccept: () {},
        ),
      ),
    );
  }
}