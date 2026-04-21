import 'dart:convert';
import 'package:cabkaro/controllers/user/edit_profile_controller.dart';
import 'package:cabkaro/providers/socket_provider.dart';
import 'package:flutter/material.dart';
import 'package:cabkaro/screens/common/landing_screen.dart';
import 'package:cabkaro/screens/driver/driver_home_screen.dart';
import 'package:cabkaro/screens/user/car_listing_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cabkaro/utils/constants.dart' as constant;
import 'package:http/http.dart' as http;
import 'package:cabkaro/widgets/Toastwidget.dart';

class AuthCheckController {
  final formKey = GlobalKey<FormState>();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  static Future<void> auth(BuildContext context) async {
    final pref = await SharedPreferences.getInstance();
    final role = pref.getString("role");
    final token = pref.getString(constant.cabToken);

    Widget nextScreen;

    if (token == null || token.isEmpty) {
      nextScreen = LandingScreen();
    } else {
      try {
        final req = await http.post(
          Uri.parse("${constant.apiUrl}/auth/check-token"),
          body: jsonEncode({"token": token}),
          headers: {"Content-Type": "application/json"},
        );

        if (req.statusCode == 200) {
          final socketProvider = Provider.of<SocketProvider>(
            context,
            listen: false,
          );
          if (role == "driver") {
            nextScreen = DriverHomeScreen();
            await socketProvider.connect();

            if (!context.mounted) return;
            Provider.of<EditProfileController>(
              context,
              listen: false,
            ).getUserData();
          } else if (role == "user") {
            nextScreen = CarListingScreen();
            await socketProvider.connect();

            if (!context.mounted) return;
            Provider.of<EditProfileController>(
              context,
              listen: false,
            ).getUserData();
          } else {
            nextScreen = LandingScreen();
          }
        } else {
          nextScreen = LandingScreen();
        }
      } catch (e) {
        nextScreen = LandingScreen();
      }
    }

    if (!context.mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => nextScreen),
    );
  }

  Future<void> changePassword(BuildContext ctx) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      final String token = pref.getString(constant.cabToken)!;
      final String role = pref.getString("role")!;
      late Uri url;

      if (role == "driver") {
        url = Uri.parse("${constant.apiUrl}/driver/change-password");
      } else if (role == "user") {
        url = Uri.parse("${constant.apiUrl}/user/change-password");
      }

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
        print(res);
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
