import 'package:cabkaro/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cabkaro/widgets/action_button.dart';
import 'package:cabkaro/widgets/gradient_background.dart';
import 'package:cabkaro/widgets/signup_input.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
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
                  'Enter your details',
                  style: GoogleFonts.oswald(
                    fontSize: screenHeight * 0.027,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2F2F2F),
                    height: 1.0,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                // Profile Picture Picker
                Consumer<UserController>(
                  builder: (context, controller, _) {
                    return GestureDetector(
                      onTap: controller.isLoadingImage
                          ? null
                          : () async {
                              await controller.pickProfileImage(context);
                            },
                      child: Center(
                        child: Stack(
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[200],
                                border: Border.all(
                                  color: const Color.fromARGB(
                                    255,
                                    242,
                                    202,
                                    42,
                                  ),
                                  width: 3,
                                ),
                              ),
                              child: ClipOval(
                                child: controller.isLoadingImage
                                    ? Center(
                                        child: SizedBox(
                                          width: 40,
                                          height: 40,
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Color.fromARGB(
                                                    255,
                                                    242,
                                                    202,
                                                    42,
                                                  ),
                                                ),
                                          ),
                                        ),
                                      )
                                    : controller.profileImage != null
                                    ? Image.file(
                                        controller.profileImage!,
                                        fit: BoxFit.cover,
                                        width: 120,
                                        height: 120,
                                        cacheHeight: 120,
                                        cacheWidth: 120,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              // Fallback if image fails to load
                                              return Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.error_outline,
                                                      size: 40,
                                                      color: Colors.red[400],
                                                    ),
                                                    SizedBox(height: 4),
                                                    Text(
                                                      'Failed to load',
                                                      style: TextStyle(
                                                        color: Colors.red[400],
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                      )
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.camera_alt,
                                            size: 40,
                                            color: Colors.grey[600],
                                          ),
                                          SizedBox(
                                            height: screenHeight * 0.005,
                                          ),
                                          Text(
                                            'Add Photo',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                            if (controller.profileImage != null &&
                                !controller.isLoadingImage)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    controller.removeProfileImage();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.all(6),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: screenHeight * 0.02),
                Form(
                  key: Provider.of<UserController>(context).formKey,
                  child: Column(
                    children: [
                      SignupInput(
                        hint: 'Name',
                        icon: Icons.person,
                        controller: Provider.of<UserController>(
                          context,
                          listen: true,
                        ).userNameController,
                        validator: (value) => Provider.of<UserController>(
                          context,
                          listen: false,
                        ).nameValidate(value, context),
                      ),
                      SizedBox(height: screenHeight * 0.015),
                      SignupInput(
                        hint: 'Phone',
                        icon: Icons.call,
                        controller: Provider.of<UserController>(
                          context,
                          listen: true,
                        ).userPhoneController,
                        keyboardType: TextInputType.phone,
                        validator: (value) => Provider.of<UserController>(
                          context,
                          listen: false,
                        ).phoneValidate(value, context),
                      ),
                      SizedBox(height: screenHeight * 0.015),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.1),
                Consumer<UserController>(
                  builder: (context, UserController, _) {
                    return ActionButton(
                      label: 'Save',
                      backgroundColor: const Color.fromARGB(255, 242, 202, 42),
                      textColor: Colors.black,
                      borderColor: const Color(0xFF1F1F1F),
                      isLoading: UserController.isLoading,
                      onTap: () => UserController.signup(context),
                    );
                  },
                ),
                SizedBox(height: screenHeight * 0.019),
              ],
            ),
          ),
        ),
      ),
    );
  }
}