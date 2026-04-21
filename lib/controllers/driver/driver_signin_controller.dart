import 'dart:convert';
import 'package:cabkaro/screens/driver/driver_otp_screen.dart';
import 'package:cabkaro/widgets/Toastwidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../utils/constants.dart' as constant;

class DriverSigninController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login(BuildContext ctx) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      Map<String, dynamic> data = {
        "phone": phoneController.text.trim(),
        "password": passwordController.text.trim(),
      };
      Uri url = Uri.parse("${constant.apiUrl}/driver/login");
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
        passwordController.text = "";

        Navigator.pushReplacement(
          ctx,
          MaterialPageRoute(
            builder: (context) => DriverOtpScreen(phone: phone),
          ),
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
}
