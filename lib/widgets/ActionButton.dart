import 'package:flutter/material.dart';
import 'package:dashed_border/dashed_border.dart';

class ActionButton extends StatelessWidget {
	const ActionButton({
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
		final buttonHeight = screenHeight * 0.065;
		final fontSize = (screenHeight * 0.025).clamp(18.0, 24.0);

		return SizedBox(
			width: double.infinity,
			height: 50,
			child: ElevatedButton(
				onPressed: onTap,
				style: ElevatedButton.styleFrom(
					elevation: 0.0,
					backgroundColor: backgroundColor,
					shape: RoundedRectangleBorder(
						borderRadius: BorderRadius.circular(30),
						side: BorderSide(color: borderColor, width: 2),

					),

				),
				child: Text(
					label,
					style: TextStyle(
						color: textColor,
						fontSize: fontSize,
						fontWeight: FontWeight.w500,
						height: 1,
					),
				),
			),
		);
	}
}