import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class GreetingBlock extends StatefulWidget {
  const GreetingBlock();

  @override
  State<GreetingBlock> createState() => _GreetingBlockState();
}

class _GreetingBlockState extends State<GreetingBlock> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hii Jeena,',
          style: GoogleFonts.oswald(
            fontSize: 38,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D2F35),
          ),
        ),
        Text(
          'How About Todays Destination ?',
          style: GoogleFonts.notoSans(fontSize: 18, color: Color(0xFF2D2F35)),
        ),
      ],
    );
  }
}