import 'package:cabkaro/screens/user/OTPScreen.dart';
import 'package:cabkaro/widgets/ToastWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'SigninScreen.dart';
import '../../widgets/ActionButton.dart';
import '../../widgets/GradientBackground.dart';
import '../../widgets/SignupInput.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
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
                  'Sign Up',
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
                        hint: 'Name',
                        icon: Icons.person,
                        controller: _nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            ToastWidget.show(
                              context,
                              message: 'Name is required',
                              type: ToastType.error,
                            );
                            return '';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.015),
                      SignupInput(
                        hint: 'Email',
                        icon: Icons.email,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            ToastWidget.show(
                              context,
                              message: 'Email is required',
                              type: ToastType.error,
                            );
                            return '';
                          }
                          final emailRegex = RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                          );
                          if (!emailRegex.hasMatch(value)) {
                            ToastWidget.show(
                              context,
                              message: 'Enter a valid email address',
                              type: ToastType.error,
                            );
                            return '';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.015),
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
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.1),
                ActionButton(
                  label: 'Submit',
                  backgroundColor: const Color.fromARGB(255, 242, 202, 42),
                  textColor: Colors.black,
                  borderColor: const Color(0xFF1F1F1F),
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      ToastWidget.show(
                        context,
                        message:'Account created! OTP sent to ${_phoneController.text}',
                        type: ToastType.success,
                      );
                      Future.delayed(const Duration(milliseconds: 500), () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                OTPScreen(email: _emailController.text),
                          ),
                        );
                      });
                    } else {
                      // ToastWidget.show(
                      //   context,
                      //   message: 'Please fill all fields correctly.',
                      //   type: ToastType.error,
                      // );
                    }
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
                SizedBox(height: screenHeight * 0.03),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
