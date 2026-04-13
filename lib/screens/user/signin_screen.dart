import 'package:cabkaro/screens/user/otp_screen.dart';
import 'package:cabkaro/widgets/ToastWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../widgets/action_button.dart';
import '../../widgets/gradient_background.dart';
import '../../widgets/signup_input.dart';
import 'signup_screen.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

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
                    padding: const EdgeInsets.only(left: 1),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.black, width: 3),
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
                  'Sign In',
                  style: TextStyle(
                    fontSize: screenHeight * 0.027,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2F2F2F),
                    height: 1.0,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SignupInput(
                        hint: 'Phone',
                        icon: Icons.call,
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            ToastWidget.show(
                              context,
                              message: 'Phone is required',
                              type: ToastType.error,
                            );
                            return '';
                          }
                          if (value.length != 10) {
                            ToastWidget.show(
                              context,
                              message: 'Enter a valid 10-digit number',
                              type: ToastType.error,
                            );
                            return '';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16,),
                      SignupInput(
                        hint: 'Password',
                        icon: Icons.password_rounded,
                        controller: _passwordController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            ToastWidget.show(
                              context,
                              message: 'Password is required',
                              type: ToastType.error,
                            );
                            return '';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: screenHeight * 0.18),
                ActionButton(
                  label: 'Submit',
                  backgroundColor: const Color.fromARGB(255, 242, 202, 42),
                  textColor: Colors.black,
                  borderColor: const Color(0xFF1F1F1F),
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      ToastWidget.show(
                        context,
                        message: 'OTP sent to ${_phoneController.text}',
                        type: ToastType.success,
                      );
                      Future.delayed(const Duration(milliseconds: 500), () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const OTPScreen(email: "sayan@gmail.com"),
                          ),
                        );
                      });
                    } else {
                      // ToastWidget.show(
                      //   context,
                      //   message: 'Please fix the errors before continuing.',
                      //   type: ToastType.error,
                      // );
                    }
                  },
                ),
                SizedBox(height: screenHeight * 0.015),
                ActionButton(
                  label: 'Sign up',
                  backgroundColor: const Color(0xFF2D2F35),
                  textColor: Colors.white,
                  borderColor: const Color(0xFF2D2F35),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupScreen(),
                      ),
                    );
                  },
                ),
                SizedBox(height: screenHeight * 0.03),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
