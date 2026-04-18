import 'dart:convert';
import 'dart:io';
import 'package:cabkaro/screens/user/otp_screen.dart';
import 'package:cabkaro/services/image_picker_service.dart';
import 'package:cabkaro/widgets/Toastwidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../utils/constants.dart' as constant;

class SignupController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  
  File? _profileImage;
  File? get profileImage => _profileImage;
  
  bool _isLoadingImage = false;
  bool get isLoadingImage => _isLoadingImage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  String? nameValidate(String? value, BuildContext ctx) {
    if (value == null || value.isEmpty) {
      ToastWidget.show(ctx, message: 'Name is required', type: ToastType.error);
      return '';
    }
    return null;
  }

  String? passwordValidate(String? value, BuildContext ctx) {
    if (value == null || value.isEmpty) {
      ToastWidget.show(
        ctx,
        message: 'Password is required',
        type: ToastType.error,
      );
      return '';
    }

    /*
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      ToastWidget.show(
        ctx,
        message: 'Enter a valid email address',
        type: ToastType.error,
      );
      return '';
    }*/

    return null;
  }

  String? phoneValidate(String? value, BuildContext ctx) {
    if (value == null || value.isEmpty) {
      ToastWidget.show(
        ctx,
        message: 'Phone is required',
        type: ToastType.error,
      );
      return '';
    }
    if (value.length != 10) {
      ToastWidget.show(
        ctx,
        message: 'Enter a valid 10-digit number',
        type: ToastType.error,
      );
      return '';
    }

    return null;
  }

  /// Pick profile image from camera or gallery
  Future<void> pickProfileImage(BuildContext context) async {
    _isLoadingImage = true;
    notifyListeners();

    try {
      final file = await ImagePickerService.showImagePickerDialog(context);

      if (file != null) {
        // Validate file size (max 5MB)
        final sizeMB = await ImagePickerService.getFileSizeInMB(file);
        if (sizeMB > 5) {
          if (!context.mounted) return;
          ToastWidget.show(
            context,
            message: 'Image size should be less than 5MB',
            type: ToastType.error,
          );
          _isLoadingImage = false;
          notifyListeners();
          return;
        }

        // Validate file format
        if (!ImagePickerService.isValidImageFile(file)) {
          if (!context.mounted) return;
          ToastWidget.show(
            context,
            message: 'Please select a valid image file',
            type: ToastType.error,
          );
          _isLoadingImage = false;
          notifyListeners();
          return;
        }

        _profileImage = file;
        if (!context.mounted) return;
        ToastWidget.show(
          context,
          message: 'Profile picture selected',
          type: ToastType.success,
        );
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      if (!context.mounted) return;
      ToastWidget.show(
        context,
        message: 'Error picking image',
        type: ToastType.error,
      );
    } finally {
      _isLoadingImage = false;
      notifyListeners();
    }
  }

  /// Remove selected profile image
  void removeProfileImage() {
    _profileImage = null;
    notifyListeners();
  }

  Future<void> signup(BuildContext ctx) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> data = {
        "name": nameController.text.trim(),
        "phone": phoneController.text.trim(),
        "password": passwordController.text.trim(),
      };

      // Add profile image if selected
      if (_profileImage != null) {
        final base64Image =
            await ImagePickerService.fileToBase64(_profileImage!);
        data["profilePicture"] = base64Image;
      }

      Uri url = Uri.parse("${constant.apiUrl}/user/register");
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

      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pushReplacement(
          ctx,
          MaterialPageRoute(
            builder: (ctx) => OTPScreen(phone: phoneController.text),
          ),
        );
      });
    } catch (err) {
      print(err);
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
