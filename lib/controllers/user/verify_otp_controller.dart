import 'dart:convert';
import 'package:cabkaro/screens/user/car_listing_screen.dart';
import 'package:cabkaro/widgets/Toastwidget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../utils/constants.dart' as constant;


class VerifyOtpController extends ChangeNotifier {
  String otp = '';
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;

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
    try {
      Map<String, dynamic> data = {"phone": phone.trim(), "otp": otp.trim()};
      Uri url = Uri.parse("${constant.apiUrl}/user/verify-otp");
      final SharedPreferences pref = await SharedPreferences.getInstance();

      var req = await http.post(
        url,
        body: jsonEncode(data),
        headers: {"Content-Type": "application/json"},
      );

      var res = jsonDecode(req.body);
      if (req.statusCode == 200) {
        pref.setString(constant.cabToken, res['token']);
        pref.setString("user-data", jsonEncode(res['data']));

        Navigator.pushReplacement(
          ctx,
          MaterialPageRoute(builder: (context) => const CarListingScreen()),
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
    }
  }
}
