import 'package:cabkaro/controllers/vendor_controller.dart';
import 'package:cabkaro/screens/common/otp_screen.dart';
import 'package:cabkaro/widgets/ToastWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:cabkaro/widgets/action_button.dart';
import 'package:cabkaro/widgets/gradient_background.dart';
import 'package:cabkaro/widgets/signup_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void dispose() {
    Provider.of<VendorController>(
      context,
      listen: false,
    ).phoneController.dispose();

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
                Builder(
                  builder: (context) =>
                      Lottie.asset("assets/animations/car_animation.json"),
                ),

                SizedBox(height: screenHeight * 0.01),
                Text(
                  'Enter your number',
                  style: TextStyle(
                    fontSize: screenHeight * 0.027,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2F2F2F),
                    height: 1.0,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Form(
                  key: Provider.of<VendorController>(
                    context,
                    listen: false,
                  ).formKey,
                  child: Column(
                    children: [
                      SignupInput(
                        hint: 'Phone',
                        icon: Icons.call,
                        controller: Provider.of<VendorController>(
                          context,
                          listen: false,
                        ).phoneController,
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
                      SizedBox(height: screenHeight * 0.01),
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.17),
                Consumer<VendorController>(
                  builder: (context, controller, _) {
                    return ActionButton(
                      label: 'Submit',
                      backgroundColor: const Color.fromARGB(255, 242, 202, 42),
                      textColor: const Color.fromARGB(255, 105, 76, 76),
                      borderColor: const Color(0xFF1F1F1F),
                      isLoading: controller.isLoading,
                      onTap: () {
                        controller.login(context);
                      },
                    );
                  },
                ),
                SizedBox(height: screenHeight * 0.015),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
