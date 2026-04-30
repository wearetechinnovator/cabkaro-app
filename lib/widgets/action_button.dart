import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActionButton extends StatelessWidget {
	const ActionButton({super.key, 
		required this.label,
		required this.backgroundColor,
		required this.textColor,
		required this.borderColor,
		required this.onTap,
		this.isLoading = false,
	});

	final String label;
	final Color backgroundColor;
	final Color textColor;
	final Color borderColor;
	final VoidCallback onTap;
	final bool isLoading;

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
          onPressed: isLoading ? null : onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: isLoading ? Colors.grey[400] : backgroundColor,
            disabledBackgroundColor: Colors.grey[400],
            shape: RoundedRectangleBorder(
						borderRadius: BorderRadius.circular(30),
						side: BorderSide(color: borderColor, width: 2),
					),
          ),
          child: isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      textColor,
                    ),
                  ),
                )
              : Text(
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