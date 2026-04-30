import 'dart:convert';
import 'dart:io';
import 'package:cabkaro/screens/driver/driver_otp_screen.dart';
import 'package:cabkaro/widgets/Toastwidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cabkaro/utils/constants.dart' as constant;

class DriverSignupController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController licenseController = TextEditingController();
  final TextEditingController aadharController = TextEditingController();
  final TextEditingController radiusController = TextEditingController();
  final TextEditingController vehicleNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? selectedGender;
  String? selectedLocation;
  File? profileImage;
  final List<String> genderOptions = ['Male', 'Female', 'Others'];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> signup(BuildContext ctx) async {
    _isLoading = true;
    notifyListeners();

    if (profileImage == null) {
      ToastWidget.show(
        ctx,
        message: 'Please upload a profile photo',
        type: ToastType.error,
      );
      return;
    }
    if (formKey.currentState!.validate()) {
      ToastWidget.show(
        ctx,
        message: 'Registration submitted successfully!',
        type: ToastType.success,
      );

      try {
        Map<String, dynamic> data = {
          "name": nameController.text.trim(),
          "email": emailController.text.trim(),
          "phone": phoneController.text.trim(),
          "password": passwordController.text.trim(),
          "gender": selectedGender,
          "driving_license_number": licenseController.text.trim(),
          "adhar_number": aadharController.text.trim(),
          "vehicle_number": vehicleNumberController.text.trim(),
          "service_radius_km": radiusController.text.trim(),
        };

        // Add profile image if selected
        // if (profileImage != null) {
        //   final base64Image =
        //       await ImagePickerService.fileToBase64(profileImage!);
        //   data["profilePicture"] = base64Image;
        // }

        Uri url = Uri.parse("${constant.apiUrl}/driver/register");
        var req = await http.post(
          url,
          body: jsonEncode(data),
          headers: {"Content-Type": "application/json"},
        );
        var res = jsonDecode(req.body);
        if (req.statusCode != 201) {
          ToastWidget.show(ctx, message: res['err'], type: ToastType.error);
          return;
        }

        Navigator.pushReplacement(
          ctx,
          MaterialPageRoute(
            builder: (ctx) => DriverOtpScreen(phone: phoneController.text),
          ),
        );
      } catch (err) {
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
}
