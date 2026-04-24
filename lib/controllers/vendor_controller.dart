import 'dart:convert';
import 'package:cabkaro/screens/common/otp_screen.dart';
import 'package:cabkaro/screens/driver/driver_home_screen.dart';
import 'package:cabkaro/widgets/Toastwidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/constants.dart' as constant;


class VendorController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  bool _isLoading = false;
  String otp = '';
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;

  bool get isLoading => _isLoading;

  // =======================================
  //Login Screen code
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
        print(res);
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

      print("==================");
      print(res);
      if (req.statusCode == 200) {
        pref.setString(constant.cabToken, res['token']);
        pref.setString("user-data", jsonEncode(res['data']));
        Navigator.pushReplacement(
          ctx,
          MaterialPageRoute(builder: (context) => const DriverHomeScreen()),
        );
      } else {
        ToastWidget.show(ctx, message: res['err'], type: ToastType.error);
      }
    } catch (e) {
      if (!ctx.mounted) return;
      ToastWidget.show(
        ctx,
        message: 'Something went wrong.',
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
}
