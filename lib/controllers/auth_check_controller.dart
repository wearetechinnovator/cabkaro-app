import 'dart:convert';
import 'package:cabkaro/controllers/user_controller.dart';
import 'package:cabkaro/providers/socket_provider.dart';
import 'package:cabkaro/screens/common/car_details_screen.dart';
import 'package:cabkaro/screens/common/driver_details_screen.dart';
import 'package:cabkaro/screens/common/driver_vendor_details_screen.dart';
import 'package:cabkaro/screens/driver/vendor_home_screen.dart';
import 'package:cabkaro/screens/user/user_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:cabkaro/screens/common/landing_screen.dart';
import 'package:cabkaro/screens/user/user_home_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cabkaro/utils/constants.dart' as constant;
import 'package:http/http.dart' as http;

class AuthCheckController extends ChangeNotifier {
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
          if (!context.mounted) return;
          final socketProvider = Provider.of<SocketProvider>(
            context,
            listen: false,
          );
          if (role == "vendor") {
            final vendorReq = await http.get(
              Uri.parse("${constant.apiUrl}/vendor/get-profile"),
              headers: {"x-cab-token": token},
            );
            var vendorRes = jsonDecode(vendorReq.body);

            if (vendorReq.statusCode != 200) {
              pref.remove("role");
              pref.remove(constant.cabToken);
              nextScreen = LandingScreen();
            } else {
              if (vendorRes['data']['profile_step'] == "0") {
                nextScreen = DriverVendorDetailsScreen();
              } else if (vendorRes['data']['profile_step'] == "1") {
                nextScreen = CarDetailsScreenScreen();
              } else if (vendorRes['data']['profile_step'] == "2") {
                nextScreen = DriverDetailsScreen();
              } else if (vendorRes['data']['profile_step'] == "3") {
                nextScreen = VendorHomeScreen();
              } else {
                nextScreen = DriverVendorDetailsScreen();
              }
            }
            await socketProvider.connect();
          }
          // User rol;
          else if (role == "user") {
            final userReq = await http.get(
              Uri.parse("${constant.apiUrl}/user/get-profile"),
              headers: {"x-cab-token": token},
            );
            var userRes = jsonDecode(userReq.body);

            if (userReq.statusCode != 200) {
              pref.remove("role");
              pref.remove(constant.cabToken);
              nextScreen = LandingScreen();
            } else {
              if (userRes['data']['profile_completed'] == true) {
                nextScreen = UserHomeScreen();

                if (!context.mounted) return;
                Provider.of<UserController>(
                  context,
                  listen: false,
                ).getUserDetails(context);
              } else {
                nextScreen = UserDetailsScreen();
              }
            }
            await socketProvider.connect();
          }
          // No role find;
          else {
            nextScreen = LandingScreen();
          }
        }
        // No Token found;
        else {
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
