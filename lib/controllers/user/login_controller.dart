<<<<<<< HEAD
import 'package:cabkaro/screens/user/otp_screen.dart';
import 'package:cabkaro/widgets/Toastwidget.dart';
import 'package:flutter/material.dart';
=======
import 'dart:convert';
import 'package:cabkaro/screens/user/otp_screen.dart';
import 'package:cabkaro/widgets/Toastwidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../utils/constants.dart' as constant;
>>>>>>> a64f8e0 (Edit vendor and user profile)

class LoginController extends ChangeNotifier {
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
<<<<<<< HEAD
      String phone = phoneController.text.trim();
      
      // For testing: Skip API call and go directly to OTP screen
      // In production, uncomment the API call below and remove this mock flow
      
      print("DEBUG: Mock login for phone: $phone");
      
      if (!ctx.mounted) return;
      ToastWidget.show(
        ctx,
        message: 'OTP sent to $phone',
        type: ToastType.success,
      );

      phoneController.text = "";
      
      Navigator.pushReplacement(
        ctx,
        MaterialPageRoute(
          builder: (context) => OTPScreen(phone: phone),
        ),
      );

      /* PRODUCTION API CALL - Uncomment when ready to use real backend
      Map<String, dynamic> data = {
        "phone": phoneController.text.trim(),
        // "password": passwordController.text.trim(),
=======
      Map<String, dynamic> data = {
        "phone": phoneController.text.trim(),
        "password": passwordController.text.trim(),
>>>>>>> a64f8e0 (Edit vendor and user profile)
      };
      Uri url = Uri.parse("${constant.apiUrl}/user/login");
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
<<<<<<< HEAD
=======
        passwordController.text = "";
>>>>>>> a64f8e0 (Edit vendor and user profile)

        Navigator.pushReplacement(
          ctx,
          MaterialPageRoute(
            builder: (context) => OTPScreen(phone: phone),
          ),
        );
<<<<<<< HEAD
=======

        
>>>>>>> a64f8e0 (Edit vendor and user profile)
      } else {
        if (!ctx.mounted) return;
        ToastWidget.show(ctx, message: res['err'], type: ToastType.error);
      }
<<<<<<< HEAD
      */
    } catch (e) {
      print("ERROR in login: $e");
=======
    } catch (e) {
      print(e);
>>>>>>> a64f8e0 (Edit vendor and user profile)
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
