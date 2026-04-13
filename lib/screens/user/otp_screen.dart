import 'package:cabkaro/controllers/user/verify_otp_controller.dart';
import 'package:cabkaro/widgets/otp_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../widgets/gradient_background.dart';
import '../../widgets/action_button.dart';



class OTPScreen extends StatefulWidget {
  final String phone;
  const OTPScreen({super.key, required this.phone});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  @override
  void initState() {
    super.initState();

    Provider.of<VerifyOtpController>(context, listen: false).controllers =
        List.generate(5, (_) => TextEditingController());
    Provider.of<VerifyOtpController>(context, listen: false).focusNodes =
        List.generate(5, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in Provider.of<VerifyOtpController>(
      context,
      listen: false,
    ).controllers) {
      controller.dispose();
    }
    for (var node in Provider.of<VerifyOtpController>(
      context,
      listen: false,
    ).focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.06;

    // Mask phone number
    final maskedPhone = widget.phone.length > 4
        ? '${widget.phone.substring(0, 4)}${'*' * (widget.phone.length - 4)}'
        : widget.phone;

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
                      'Enter the 5-digit code we\'ve sent to $maskedPhone',
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
                            controller: Provider.of<VerifyOtpController>(
                              context,
                              listen: false,
                            ).controllers[index],
                            focusNode: Provider.of<VerifyOtpController>(
                              context,
                              listen: false,
                            ).focusNodes[index],
                            screenHeight: screenHeight,
                            onChanged: (value) =>
                                Provider.of<VerifyOtpController>(
                                  context,
                                  listen: false,
                                ).handleInput(value, index),
                            onBackspace: () => Provider.of<VerifyOtpController>(
                              context,
                              listen: false,
                            ).handleBackspace(index),
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
                          Provider.of<VerifyOtpController>(
                            context,
                            listen: false,
                          ).verifyOtp(widget.phone, context);
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
