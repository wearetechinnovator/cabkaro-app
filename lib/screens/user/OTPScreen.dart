import 'package:cabkaro/screens/user/CarListingScreen.dart';
import 'package:cabkaro/widgets/OTPField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../widgets/GradientBackground.dart';
import '../../widgets/ActionButton.dart';

class OTPScreen extends StatefulWidget {
  final String email;
  const OTPScreen({super.key, required this.email});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  String otp = '';

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(5, (_) => TextEditingController());
    _focusNodes = List.generate(5, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _handleInput(String value, int index) {
    if (value.isNotEmpty) {
      otp = _controllers.map((c) => c.text).join();
      if (index < 4) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }
  }

  void _handleBackspace(int index) {
    if (_controllers[index].text.isEmpty && index > 0) {
      _controllers[index - 1].clear();
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.06;

    // Mask email
    final parts = widget.email.split('@');
    final emailPrefix = parts[0];
    final maskedEmail = emailPrefix.length > 2
        ? '${emailPrefix.substring(0, 2)}${'*' * (emailPrefix.length - 2)}${parts.isNotEmpty ? '@${parts[1]}' : ''}'
        : widget.email;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GradientBackground(
        child: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: screenHeight * 0.02,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Back button
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.arrow_back,
                          size: screenHeight * 0.04,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // Logo
                    Align(
                      alignment: Alignment.centerRight,
                      child: Transform.translate(
                        offset: const Offset(12, -70),
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
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.04),

                    // OTP Icon
                    SizedBox(
                      width: screenHeight * 0.15,
                      height: screenHeight * 0.15,
                      child: Center(
                        child: Image.asset("assets/icons/inboxIcon.png"),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // Title
                    Text(
                      'Verification Code',
                      style: TextStyle(
                        fontSize: screenHeight * 0.03,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2F2F2F),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.01),

                    // Subtitle
                    Text(
                      'Enter the 5-digit code we\'ve sent to $maskedEmail',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: screenHeight * 0.016,
                        color: const Color(0xFF6F6F6F),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.04),

                    // OTP Input Fields
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          5,
                          (index) => OTPField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            screenHeight: screenHeight,
                            onChanged: (value) => _handleInput(value, index),
                            onBackspace: () => _handleBackspace(index),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // Resend OTP
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Didn\'t receive the OTP?',
                            style: TextStyle(
                              fontSize: screenHeight * 0.016,
                              color: const Color(0xFF6F6F6F),
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.172),
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('OTP resent'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            child: Text(
                              'Resend',
                              style: TextStyle(
                                fontSize: screenHeight * 0.016,
                                color: const Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.14),
                  ],
                ),
              ),
              Positioned(
                left: horizontalPadding,
                right: horizontalPadding,
                bottom: 8,
                child: Row(
                  children: [
                    Expanded(
                      child: ActionButton(
                        label: 'Cancel',
                        backgroundColor: const Color.fromARGB(
                          255,
                          242,
                          202,
                          42,
                        ),
                        textColor: const Color(0xFF2D2F35),
                        borderColor: const Color(0xFF2D2F35),
                        onTap: () => Navigator.pop(context),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.08),
                    Expanded(
                      child: ActionButton(
                        label: 'Verify',
                        backgroundColor: const Color(0xFF2D2F35),
                        textColor: Colors.white,
                        borderColor: const Color(0xFF2D2F35),
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CarListingScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
