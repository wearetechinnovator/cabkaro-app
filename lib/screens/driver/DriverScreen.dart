import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'GOVDetailsScreen.dart';
import '../../widgets/ActionButton.dart';
import '../../widgets/GradientBackground.dart';
import '../../widgets/SignupInput.dart';

class DriverScreen extends StatelessWidget {
  const DriverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SvgPicture.asset(
                    'assets/icons/cabkaroLogo.svg',
                    width: 90,
                    height: 90,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Text(
                  'Driver Registration',
                  style: TextStyle(
                    fontSize: screenHeight * 0.04,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2F2F2F),
                    height: 1.0,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                const SignupInput(hint: 'Name', icon: Icons.person),
                SizedBox(height: screenHeight * 0.014),
                const SignupInput(hint: 'Email', icon: Icons.email),
                SizedBox(height: screenHeight * 0.014),
                const SignupInput(
                  hint: 'Phone',
                  icon: Icons.call,
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: screenHeight * 0.014),
                const SignupInput(hint: 'Gender', icon: Icons.transgender),
                SizedBox(height: screenHeight * 0.014),
                const SignupInput(
                  hint: 'Driving License',
                  icon: Icons.description,
                ),
                SizedBox(height: screenHeight * 0.014),
                const SignupInput(
                  hint: 'Aadhar Number',
                  icon: Icons.credit_card,
                ),
                SizedBox(height: screenHeight * 0.12),
                ActionButton(
                  label: 'Submit',
                  backgroundColor: const Color.fromARGB(0, 255, 255, 255),
                  textColor: Colors.black,
                  borderColor: const Color(0xFF1F1F1F),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GOVDetailsScreen(),
                      ),
                    );
                  },
                ),
                SizedBox(height: screenHeight * 0.139),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
