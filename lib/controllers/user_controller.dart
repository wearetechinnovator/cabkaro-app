import 'dart:convert';
import 'dart:io';
import 'package:cabkaro/screens/common/landing_screen.dart';
import 'package:cabkaro/screens/user/user_details_screen.dart';
import 'package:cabkaro/screens/user/user_home_screen.dart';
import 'package:cabkaro/screens/user/user_otp_screen.dart';
import 'package:cabkaro/services/image_picker_service.dart';
import 'package:cabkaro/widgets/Toastwidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cabkaro/utils/constants.dart' as constant;

class UserController extends ChangeNotifier {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>(); //Login form key;
  final TextEditingController phoneController = TextEditingController();
  String otp = '';
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;

  String? userName;
  String? userPhone;
  String? userImg;

  // User details screen;
  final signupFormKey = GlobalKey<FormState>();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController userPasswordController = TextEditingController();
  final TextEditingController userPhoneController = TextEditingController();
  String userProfileBase64 = "";
  File? profileImage;
  bool _isLoadingImage = false;
  bool get isLoadingImage => _isLoadingImage;

  // User Profile Details complete screen;
  String? nameValidate(String? value, BuildContext ctx) {
    if (value == null || value.isEmpty) {
      ToastWidget.show(ctx, message: 'Name is required', type: ToastType.error);
      return '';
    }
    return null;
  }

  String? passwordValidate(String? value, BuildContext ctx) {
    if (value == null || value.isEmpty) {
      ToastWidget.show(
        ctx,
        message: 'Password is required',
        type: ToastType.error,
      );
      return '';
    }

    /*
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      ToastWidget.show(
        ctx,
        message: 'Enter a valid email address',
        type: ToastType.error,
      );
      return '';
    }*/

    return null;
  }

  String? phoneValidate(String? value, BuildContext ctx) {
    if (value == null || value.isEmpty) {
      ToastWidget.show(
        ctx,
        message: 'Phone is required',
        type: ToastType.error,
      );
      return '';
    }
    if (value.length != 10) {
      ToastWidget.show(
        ctx,
        message: 'Enter a valid 10-digit number',
        type: ToastType.error,
      );
      return '';
    }

    return null;
  }

  /// Pick profile image from camera or gallery
  Future<void> pickProfileImage(BuildContext context) async {
    _isLoadingImage = true;
    notifyListeners();

    try {
      final file = await ImagePickerService.showImagePickerDialog(context);

      if (file != null) {
        // Validate file size (max 5MB)
        final sizeMB = await ImagePickerService.getFileSizeInMB(file);
        if (sizeMB > 5) {
          _isLoadingImage = false;
          notifyListeners();
          if (!context.mounted) return;
          ToastWidget.show(
            context,
            message: 'Image size should be less than 5MB',
            type: ToastType.error,
          );
          return;
        }

        // Validate file format
        if (!ImagePickerService.isValidImageFile(file)) {
          _isLoadingImage = false;
          notifyListeners();
          if (!context.mounted) return;
          ToastWidget.show(
            context,
            message: 'Please select a valid image file',
            type: ToastType.error,
          );
          return;
        }

        // Set the profile image
        profileImage = file;
        userProfileBase64 = await ImagePickerService.fileToBase64(file);

        // Important: Set loading to false BEFORE notifying
        _isLoadingImage = false;
        notifyListeners(); // This triggers the UI rebuild

        if (!context.mounted) return;
        ToastWidget.show(
          context,
          message: 'Profile picture selected',
          type: ToastType.success,
        );
      } else {
        _isLoadingImage = false;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      _isLoadingImage = false;
      notifyListeners();
      if (!context.mounted) return;
      ToastWidget.show(
        context,
        message: 'Error picking image',
        type: ToastType.error,
      );
    }
  }

  /// Remove selected profile image
  void removeProfileImage() {
    profileImage = null;
    notifyListeners();
  }

  Future<void> signup(BuildContext ctx) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString(constant.cabToken);

      Map<String, dynamic> data = {
        "name": userNameController.text.trim(),
        "phone": userPhoneController.text.trim(),
        "gender": "male",
        "profile_img": userProfileBase64,
        "token": token,
      };

      // Add profile image if selected
      if (profileImage != null) {
        final base64Image = await ImagePickerService.fileToBase64(
          profileImage!,
        );
        data["profilePicture"] = base64Image;
      }

      Uri url = Uri.parse("${constant.apiUrl}/user/update");
      var req = await http.patch(
        url,
        body: jsonEncode(data),
        headers: {"Content-Type": "application/json"},
      );
      var res = jsonDecode(req.body);
      if (req.statusCode != 200) {
        ToastWidget.show(ctx, message: res['err'], type: ToastType.error);
        return;
      }

      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pushReplacement(
          ctx,
          MaterialPageRoute(builder: (ctx) => UserHomeScreen()),
        );
      });
    } catch (err) {
      if (!ctx.mounted) return;
      ToastWidget.show(
        ctx,
        message: 'Something went wrong. $err',
        type: ToastType.error,
      );
      return;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // =======================================
  // Login Screen code
  // =======================================
  Future<void> login(BuildContext ctx) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      isLoading = true;
      notifyListeners();
      Map<String, dynamic> data = {"phone": phoneController.text.trim()};
      Uri url = Uri.parse("${constant.apiUrl}/user/login");
      var req = await http.post(
        url,
        body: jsonEncode(data),
        headers: {"Content-Type": "application/json"},
      );

      var res = jsonDecode(req.body);
      if (req.statusCode == 200) {
        if (!ctx.mounted) return;
        ToastWidget.show(
          ctx,
          message: 'OTP sent to ${phoneController.text}',
          type: ToastType.success,
        );

        String phone = phoneController.text;
        phoneController.text = "";

        Navigator.pushReplacement(
          ctx,
          MaterialPageRoute(builder: (context) => UserOtpScreen(phone: phone)),
        );
      } else {
        if (!ctx.mounted) return;
        ToastWidget.show(ctx, message: res['err'], type: ToastType.error);
      }
    } catch (e) {
      if (!ctx.mounted) return;
      ToastWidget.show(
        ctx,
        message: 'Something went wrong.',
        type: ToastType.error,
      );
      return;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // =======================================
  // Verified OTP and log in the user Screen
  // =======================================
  void handleInput(String value, int index) {
    if (value.isNotEmpty) {
      otp = controllers.map((c) => c.text).join();
      if (index < 4) {
        focusNodes[index + 1].requestFocus();
      } else {
        focusNodes[index].unfocus();
      }
    }
  }

  void handleBackspace(int index) {
    if (controllers[index].text.isEmpty && index > 0) {
      controllers[index - 1].clear();
      focusNodes[index - 1].requestFocus();
    }
  }

  void verifyOtp(String phone, BuildContext ctx) async {
    isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> data = {"phone": phone.trim(), "otp": otp.trim()};
      Uri url = Uri.parse("${constant.apiUrl}/user/verify-otp");

      final SharedPreferences pref = await SharedPreferences.getInstance();

      // Check if widget is still mounted after the first await
      if (!ctx.mounted) return;

      var req = await http.post(
        url,
        body: jsonEncode(data),
        headers: {"Content-Type": "application/json"},
      );

      // Check again after the network call (the most important one)
      if (!ctx.mounted) return;

      var res = jsonDecode(req.body);

      if (req.statusCode == 200) {
        pref.setString(constant.cabToken, res['token']);
        pref.setString("data", jsonEncode(res['data']));

        if (res['data']['profile_completed'] == false) {
          Navigator.pushReplacement(
            ctx,
            MaterialPageRoute(builder: (context) => const UserDetailsScreen()),
          );
        } else {
          Navigator.pushReplacement(
            ctx,
            MaterialPageRoute(builder: (context) => const UserHomeScreen()),
          );
        }
      } else {
        ToastWidget.show(ctx, message: res['err'], type: ToastType.error);
      }
    } catch (e) {
      if (!ctx.mounted) return;
      ToastWidget.show(
        ctx,
        message: 'Something went wrong. $e',
        type: ToastType.error,
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ========================
  // Get user profile data
  // ========================
  Future<void> getUserDetails(BuildContext ctx) async {
    try {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString(constant.cabToken);

      Uri url = Uri.parse("${constant.apiUrl}/user/get-profile");
      var req = await http.get(url, headers: {"x-cab-token": token!});

      var res = jsonDecode(req.body);

      if (req.statusCode != 200) {
        if (!ctx.mounted) return;
        ToastWidget.show(ctx, message: res['err'], type: ToastType.error);
      } else {
        userNameController.text = res['data']['name'];
        userPhoneController.text = res['data']['phone'].toString();
        userProfileBase64 = res['data']['profile_img'];

        // Used anywhere in vendor profile;
        userName = res['data']['name'];
        userPhone = res['data']['phone'].toString();
        userImg = res['data']['profile_img'];
        notifyListeners();
      }
    } catch (e) {
      if (!ctx.mounted) return;
      ToastWidget.show(
        ctx,
        message: 'Something went wrong.$e',
        type: ToastType.error,
      );
    }
  }

  // ===============
  // Logout
  // ===============
  void logout(BuildContext ctx) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove(constant.cabToken);
    pref.remove("role");
    pref.remove("data");

    if (!ctx.mounted) return;
    Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (context) {
          return LandingScreen();
        },
      ),
    );
  }
}
