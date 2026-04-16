import 'dart:convert';
import 'package:cabkaro/screens/common/landing_screen.dart';
import 'package:cabkaro/widgets/Toastwidget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../utils/constants.dart' as constant;



// ===================================
// Edit Profile with User's Dashboard |
// ===================================
class EditProfileController extends ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  Map<String, dynamic>? userData;

  void getUserData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? data = pref.getString("user-data");
    if (data != null) {
      userData = jsonDecode(data);

      nameController.text = userData!['name'];
      phoneController.text = userData!['phone'].toString();
    }
  }

  void logout(BuildContext ctx) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove(constant.cabToken);
    pref.remove("role");
    pref.remove("user-data");

    if (!ctx.mounted) return;
    Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (context) {
          return LandingScreen();
        },
      ),
    );
  }

  void update(BuildContext ctx) async {
    try {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      final String token = pref.getString(constant.cabToken)!;
      Map<String, dynamic> data = {
        "name": nameController.text.trim(),
        "phone": phoneController.text.trim(),
        "token": token,
      };

      Uri url = Uri.parse("${constant.apiUrl}/user/update");
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

      userData!["name"] = nameController.text.trim();
      userData!["phone"] = phoneController.text.trim();
      pref.setString("user-data", jsonEncode(userData));
      notifyListeners();

      ToastWidget.show(ctx, message: res['msg'], type: ToastType.success);
    } catch (err) {
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
