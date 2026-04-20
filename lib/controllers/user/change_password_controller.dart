import 'dart:convert';

import 'package:cabkaro/widgets/Toastwidget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../utils/constants.dart' as constant;

class ChangePasswordController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Future<void> changePassword(BuildContext ctx) async {
    if(!formKey.currentState!.validate()){
      return;
    }

    try {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      final String token = pref.getString(constant.cabToken)!;
      Uri url = Uri.parse("${constant.apiUrl}/user/change-password");

      Map<String, dynamic> data = {
        "token": token,
        "currentPass": currentPasswordController.text.trim(),
        "newPass": newPasswordController.text.trim(),
      };

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

      ToastWidget.show(ctx, message: res['msg'], type: ToastType.success);

      // Clear the text fields after successful password change
      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
      
    } catch (er) {
      ToastWidget.show(
        ctx,
        message: "An error occurred while changing the password",
        type: ToastType.error,
      );
    }
  }
}
