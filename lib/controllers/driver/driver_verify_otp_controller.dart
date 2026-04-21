import 'dart:convert';
import 'package:cabkaro/screens/driver/driver_home_screen.dart';
import 'package:cabkaro/widgets/ToastWidget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../utils/constants.dart' as constant;

class DriverVerifyOtpController extends ChangeNotifier {
  String otp = '';
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

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
      Uri url = Uri.parse("${constant.apiUrl}/driver/verify-otp");

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