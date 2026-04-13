import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActionButton extends StatelessWidget {
	const ActionButton({super.key, 
		required this.label,
		required this.backgroundColor,
		required this.textColor,
		required this.borderColor,
		required this.onTap,
	});

	final String label;
	final Color backgroundColor;
	final Color textColor;
	final Color borderColor;
	final VoidCallback onTap;

	@override
	Widget build(BuildContext context) {
		final screenHeight = MediaQuery.of(context).size.height;
		// final buttonHeight = screenHeight * 0.065;
		final fontSize = (screenHeight * 0.025).clamp(18.0, 24.0);

		return SizedBox(
			width: double.infinity,
			height: 50,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.black, width: 1.5)
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
						borderRadius: BorderRadius.circular(30),
						side: BorderSide(color: borderColor, width: 2),
					),
          ),
          child: Text(
            label,
            style: GoogleFonts.oswald(
              color: textColor,
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              height: 1,
            ),
          ),
          ),
      ),
		);
	}
}