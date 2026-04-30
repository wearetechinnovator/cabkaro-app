import 'dart:convert';
<<<<<<< HEAD
import 'package:cabkaro/screens/user/car_listing_screen.dart';
import 'package:cabkaro/widgets/ToastWidget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
=======
import 'package:cabkaro/screens/user/user_home_screen.dart';
import 'package:cabkaro/widgets/ToastWidget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
>>>>>>> a64f8e0 (Edit vendor and user profile)
import '../../utils/constants.dart' as constant;

class VerifyOtpController extends ChangeNotifier {
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
<<<<<<< HEAD
      final SharedPreferences pref = await SharedPreferences.getInstance();

      // Check if widget is still mounted
      if (!ctx.mounted) return;

      // For testing: Save mock token without API call
      // In production, replace this with actual API call
      String mockToken = "test_token_${phone}_${DateTime.now().millisecondsSinceEpoch}";
      
      pref.setString(constant.cabToken, mockToken);
      
      // Mock user data
      Map<String, dynamic> mockUserData = {
        "id": "user_123",
        "name": "Test User",
        "phone": phone,
        "email": "test@example.com",
      };
      pref.setString("user-data", jsonEncode(mockUserData));
      
      print("DEBUG: Mock token saved: $mockToken");
      print("DEBUG: Navigating to CarListingScreen");

      if (!ctx.mounted) return;
      ToastWidget.show(
        ctx,
        message: 'Login successful',
        type: ToastType.success,
      );

      Navigator.pushReplacement(
        ctx,
        MaterialPageRoute(builder: (context) => const CarListingScreen()),
      );
    } catch (e) {
      print("ERROR in verifyOtp: $e");
=======
      Map<String, dynamic> data = {"phone": phone.trim(), "otp": otp.trim()};
      Uri url = Uri.parse("${constant.apiUrl}/user/verify-otp");

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
        pref.setString("user-data", jsonEncode(res['data']));
        Navigator.pushReplacement(
          ctx,
          MaterialPageRoute(builder: (context) => const UserHomeScreen()),
        );
      } else {
        ToastWidget.show(ctx, message: res['err'], type: ToastType.error);
      }
    } catch (e) {
>>>>>>> a64f8e0 (Edit vendor and user profile)
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