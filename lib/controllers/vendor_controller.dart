import 'dart:convert';
import 'dart:io';
import 'package:cabkaro/screens/common/car_details_screen.dart';
import 'package:cabkaro/screens/common/driver_vendor_details_screen.dart';
import 'package:cabkaro/screens/common/landing_screen.dart';
import 'package:cabkaro/screens/common/otp_screen.dart';
import 'package:cabkaro/screens/driver/vendor_home_screen.dart';
import 'package:cabkaro/widgets/Toastwidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cabkaro/utils/constants.dart' as constant;
import 'package:image_picker/image_picker.dart';


class VendorController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final vendorDetailsformKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  bool _isLoading = false;
  String otp = '';
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;
  String vendorRole = "Individual"; // Default role
  final TextEditingController nameController = TextEditingController();
  File? profileImage;
  late String profileImageBase64;
  bool get isLoading => _isLoading;

  String vendorPhone = "";
  String vendorName = "";
  String vendorImg = "";
  // =======================================
  // Login Screen code
  // =======================================
  Future<void> login(BuildContext ctx) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      Map<String, dynamic> data = {"vendor_phone": phoneController.text.trim()};
      Uri url = Uri.parse("${constant.apiUrl}/vendor/login");
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
          MaterialPageRoute(builder: (context) => OtpScreen(phone: phone)),
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
      _isLoading = false;
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
    _isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> data = {"phone": phone.trim(), "otp": otp.trim()};
      Uri url = Uri.parse("${constant.apiUrl}/vendor/verify-otp");

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
            MaterialPageRoute(
              builder: (context) => const DriverVendorDetailsScreen(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            ctx,
            MaterialPageRoute(builder: (context) => const VendorHomeScreen()),
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
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  // =====================================
  // Update Vendor Details Screen code
  // =====================================
  void setVendorRole(String role) {
    vendorRole = role;
    notifyListeners();
  }

  Future<void> pickImage(bool isProfile) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      final bytes = await profileImage!.readAsBytes();
      final base64 = base64Encode(bytes);
      profileImageBase64 = "data:image/jpeg;base64,$base64";
      notifyListeners();
    }
  }

  Future<void> updateVendorDetails(BuildContext ctx) async {
    if (!vendorDetailsformKey.currentState!.validate()) {
      return;
    }

    try {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString(constant.cabToken);

      Map<String, String> data = {
        "vendor_name": nameController.text.trim(),
        "vendor_phone": phoneController.text.trim(),
        "vendor_img": profileImageBase64,
        "vendor_type": vendorRole.toLowerCase() == "individual" ? "1" : "2",
        "token": token!,
      };
      Uri url = Uri.parse("${constant.apiUrl}/vendor/update-profile");

      var req = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      var res = jsonDecode(req.body);
      if (req.statusCode != 200) {
        if (!ctx.mounted) return;
        ToastWidget.show(ctx, message: res['err'], type: ToastType.error);
      } else {
        if (!ctx.mounted) return;
        ToastWidget.show(
          ctx,
          message: 'Profile updated successfully',
          type: ToastType.success,
        );
        Navigator.push(
          ctx,
          MaterialPageRoute(builder: (context) => CarDetailsScreenScreen()),
        );
      }
    } catch (e) {
      if (!ctx.mounted) return;
      ToastWidget.show(
        ctx,
        message: 'Something went wrong.',
        type: ToastType.error,
      );
    }
  }

  // ============================
  // Get Vendor Profile Details;
  // ============================
  Future<void> getVendorDetails(BuildContext ctx) async {
    try {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString(constant.cabToken);

      Uri url = Uri.parse("${constant.apiUrl}/vendor/get-profile");
      var req = await http.get(url, headers: {"x-cab-token": token!});

      var res = jsonDecode(req.body);
      if (req.statusCode != 200) {
        if (!ctx.mounted) return;
        ToastWidget.show(ctx, message: res['err'], type: ToastType.error);
      } else {
        nameController.text = res['data']['vendor_name'];
        phoneController.text = res['data']['vendor_phone'];
        profileImageBase64 = res['data']['vendor_img'];

        // Used anywhere in vendor profile;
        vendorName = res['data']['vendor_name'];
        vendorPhone = res['data']['vendor_phone'];
        vendorImg = res['data']['vendor_img'];

        notifyListeners();
      }
    } catch (e) {
      if (!ctx.mounted) return;
      ToastWidget.show(
        ctx,
        message: 'Something went wrong.',
        type: ToastType.error,
      );
    }
  }

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
