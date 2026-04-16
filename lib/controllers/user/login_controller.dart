import 'dart:convert';
import 'package:cabkaro/screens/user/otp_screen.dart';
import 'package:cabkaro/widgets/Toastwidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../utils/constants.dart' as constant;

class LoginController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> login(BuildContext ctx) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    print("click...");
    try {
      Map<String, dynamic> data = {
        "phone": phoneController.text.trim(),
        "password": passwordController.text.trim(),
      };
      Uri url = Uri.parse("${constant.apiUrl}/user/login");
      var req = await http.post(
        url,
        body: jsonEncode(data),
        headers: {"Content-Type": "application/json"},
      );

      var res = jsonDecode(req.body);
      print(res);
      if (req.statusCode == 200) {
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
            builder: (context) => OTPScreen(phone: phone),
          ),
        );

        
      } else {
        if (!ctx.mounted) return;
        ToastWidget.show(ctx, message: res['err'], type: ToastType.error);
      }
    } catch (e) {
      print(e);
      if (!ctx.mounted) return;
      ToastWidget.show(
        ctx,
        message: 'Something went wrong.',
        type: ToastType.error,
      );
      return;
    }
  }
}
