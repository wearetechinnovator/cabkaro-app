import 'package:cabkaro/screens/user/otp_screen.dart';
import 'package:cabkaro/widgets/Toastwidget.dart';
import 'package:flutter/material.dart';

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
      */
    } catch (e) {
      print("ERROR in login: $e");
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
