import 'dart:convert';
<<<<<<< HEAD
import 'package:cabkaro/controllers/edit_profile_controller.dart';
import 'package:cabkaro/providers/socket_provider.dart';
import 'package:flutter/material.dart';
import 'package:cabkaro/screens/common/landing_screen.dart';
import 'package:cabkaro/screens/driver/driver_home_screen.dart';
import 'package:cabkaro/screens/user/car_listing_screen.dart';
=======
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
>>>>>>> a64f8e0 (Edit vendor and user profile)
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cabkaro/utils/constants.dart' as constant;
import 'package:http/http.dart' as http;
<<<<<<< HEAD
import 'package:cabkaro/widgets/Toastwidget.dart';
=======
>>>>>>> a64f8e0 (Edit vendor and user profile)

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
<<<<<<< HEAD
=======
          if (!context.mounted) return;
>>>>>>> a64f8e0 (Edit vendor and user profile)
          final socketProvider = Provider.of<SocketProvider>(
            context,
            listen: false,
          );
<<<<<<< HEAD
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
=======
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
>>>>>>> a64f8e0 (Edit vendor and user profile)
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
<<<<<<< HEAD

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
=======
>>>>>>> a64f8e0 (Edit vendor and user profile)
}
