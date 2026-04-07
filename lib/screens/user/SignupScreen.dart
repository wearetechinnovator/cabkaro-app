import 'package:cabkaro/screens/user/OTPScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'SigninScreen.dart';
import '../../widgets/ActionButton.dart';
import '../../widgets/GradientBackground.dart';
import '../../widgets/SignupInput.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final horizontalPadding = screenWidth * 0.06;
    final verticalPadding = screenHeight * 0.02;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: ListView(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 1),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.black, width: 3),
                          right: BorderSide.none,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),

                      child: SvgPicture.asset(
                        'assets/icons/cabkaroLogoNormal.svg',
                        width: 133,
                        height: 40,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),
                Center(
                  child: Image.asset(
                    'assets/images/authImage.png',
                    height: screenHeight * 0.3,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: screenHeight * 0.027,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2F2F2F),
                    height: 1.0,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                SignupInput(hint: 'Name', icon: Icons.person),
                SizedBox(height: screenHeight * 0.015),
                SignupInput(hint: 'Email', icon: Icons.email),
                SizedBox(height: screenHeight * 0.015),
                SignupInput(
                  hint: 'Phone',
                  icon: Icons.call,
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: screenHeight * 0.149),
                ActionButton(
                  label: 'Submit',
                  backgroundColor: const Color.fromARGB(255, 242, 202, 42),
                  textColor: Colors.black,
                  borderColor: const Color(0xFF1F1F1F),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const OTPScreen(email: "sayan@gmail.com"),
                      ),
                    );
                  },
                ),
                SizedBox(height: screenHeight * 0.019),
                ActionButton(
                  label: 'Sign in',
                  backgroundColor: const Color(0xFF2D2F35),
                  textColor: Colors.white,
                  borderColor: const Color(0xFF2D2F35),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SigninScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
