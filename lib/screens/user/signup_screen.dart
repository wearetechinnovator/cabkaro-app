import 'package:cabkaro/controllers/user/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'signin_screen.dart';
import '../../widgets/action_button.dart';
import '../../widgets/gradient_background.dart';
import '../../widgets/signup_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
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
                // Profile Picture Picker
                Consumer<SignupController>(
                  builder: (context, signupController, _) {
                    return GestureDetector(
                      onTap: signupController.isLoadingImage
                          ? null
                          : () {
                              signupController.pickProfileImage(context);
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
                                  color: const Color.fromARGB(255, 242, 202, 42),
                                  width: 3,
                                ),
                              ),
                              child: signupController.profileImage != null
                                  ? ClipOval(
                                      child: Image.file(
                                        signupController.profileImage!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Center(
                                      child: signupController.isLoadingImage
                                          ? const SizedBox(
                                              width: 40,
                                              height: 40,
                                              child:
                                                  CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                                  Color.fromARGB(
                                                      255, 242, 202, 42),
                                                ),
                                              ),
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
                                                    height:
                                                        screenHeight * 0.005),
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
                            if (signupController.profileImage != null)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    signupController.removeProfileImage();
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
                  key: Provider.of<SignupController>(context).formKey,
                  child: Column(
                    children: [
                      SignupInput(
                        hint: 'Name',
                        icon: Icons.person,
                        controller: Provider.of<SignupController>(
                          context,
                          listen: true,
                        ).nameController,
                        validator: (value) => Provider.of<SignupController>(
                          context,
                          listen: false,
                        ).nameValidate(value, context),
                      ),
                      SizedBox(height: screenHeight * 0.015),
                      SignupInput(
                        hint: 'Phone',
                        icon: Icons.call,
                        controller: Provider.of<SignupController>(
                          context,
                          listen: true,
                        ).phoneController,
                        keyboardType: TextInputType.phone,
                        validator: (value) => Provider.of<SignupController>(
                          context,
                          listen: false,
                        ).phoneValidate(value, context),
                      ),
                      SizedBox(height: screenHeight * 0.015),
                      SignupInput(
                        hint: 'Password',
                        icon: Icons.email,
                        controller: Provider.of<SignupController>(
                          context,
                          listen: true,
                        ).passwordController,
                        validator: (value) => Provider.of<SignupController>(
                          context,
                          listen: false,
                        ).passwordValidate(value, context),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.1),
                Consumer<SignupController>(
                  builder: (context, signupController, _) {
                    return ActionButton(
                      label: 'Submit',
                      backgroundColor: const Color.fromARGB(255, 242, 202, 42),
                      textColor: Colors.black,
                      borderColor: const Color(0xFF1F1F1F),
                      isLoading: signupController.isLoading,
                      onTap: () => Provider.of<SignupController>(
                        context,
                        listen: false,
                      ).signup(context),
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
                SizedBox(height: screenHeight * 0.03),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
