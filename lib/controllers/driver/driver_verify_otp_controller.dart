import 'dart:convert';
import 'package:cabkaro/screens/driver/driver_home_screen.dart';
import 'package:cabkaro/widgets/ToastWidget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/constants.dart' as constant;

class DriverVerifyOtpController extends ChangeNotifier {
  String otp = '';
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

<<<<<<< HEAD
 
=======
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
      final SharedPreferences pref = await SharedPreferences.getInstance();

      // Check if widget is still mounted
      if (!ctx.mounted) return;

      // For testing: Save mock token without API call
      // In production, replace this with actual API call
      String mockToken = "test_token_driver_${phone}_${DateTime.now().millisecondsSinceEpoch}";
      
      pref.setString(constant.cabToken, mockToken);
      
      // Mock driver data
      Map<String, dynamic> mockDriverData = {
        "id": "driver_123",
        "name": "Test Driver",
        "phone": phone,
        "email": "driver@example.com",
        "license": "DL123456",
      };
      pref.setString("user-data", jsonEncode(mockDriverData));
      
      print("DEBUG: Mock driver token saved: $mockToken");
      print("DEBUG: Navigating to DriverHomeScreen");

      if (!ctx.mounted) return;
      ToastWidget.show(
        ctx,
        message: 'Login successful',
        type: ToastType.success,
      );

      Navigator.pushReplacement(
        ctx,
        MaterialPageRoute(builder: (context) => const DriverHomeScreen()),
      );
    } catch (e) {
      print("ERROR in verifyOtp: $e");
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
>>>>>>> 5c2a44a (minor changes)
}