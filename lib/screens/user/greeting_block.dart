import 'package:cabkaro/controllers/user/edit_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class GreetingBlock extends StatefulWidget {
  const GreetingBlock({super.key});

  @override
  State<GreetingBlock> createState() => _GreetingBlockState();
}

class _GreetingBlockState extends State<GreetingBlock> {
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<EditProfileController>();
    final name = controller.userData?['name'].split(" ")[0] ?? "";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
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
