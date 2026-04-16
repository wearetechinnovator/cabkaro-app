import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cabkaro/screens/common/landing_screen.dart';
import 'package:cabkaro/screens/driver/driver_home_screen.dart';
import 'package:cabkaro/screens/user/car_listing_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/constants.dart' as constant;
import 'package:http/http.dart' as http;

class AuthCheckController {
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
          if (role == "driver") {
            nextScreen = DriverHomeScreen();
          } else if (role == "user") {
            nextScreen = CarListingScreen();
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
}
