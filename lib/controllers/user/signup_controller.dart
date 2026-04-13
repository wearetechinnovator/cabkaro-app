import 'dart:convert';

import 'package:cabkaro/screens/user/otp_screen.dart';
import 'package:cabkaro/widgets/Toastwidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../utils/constants.dart' as constant;

class SignupController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

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

  Future<void> signup(BuildContext ctx) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      Map<String, dynamic> data = {
        "name": nameController.text.trim(),
        "phone": phoneController.text.trim(),
        "password": passwordController.text.trim(),
      };
      print(data);
      Uri url = Uri.parse("${constant.apiUrl}/user/register");
      var req = await http.post(
        url,
        body: jsonEncode(data),
        headers: {"Content-Type": "application/json"},
      );
      var res = jsonDecode(req.body);
      if (req.statusCode != 201) {
        ToastWidget.show(ctx, message: res['err'], type: ToastType.error);
        return;
      }

      print(res['data']);
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pushReplacement(
          ctx,
          MaterialPageRoute(
            builder: (ctx) => OTPScreen(phone: phoneController.text),
          ),
        );
      });
    } catch (err) {
      print(err);
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
