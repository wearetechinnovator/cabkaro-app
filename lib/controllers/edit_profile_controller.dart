import 'dart:convert';
<<<<<<< HEAD
import 'package:cabkaro/screens/common/landing_screen.dart';
import 'package:cabkaro/widgets/Toastwidget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../utils/constants.dart' as constant;
=======
import 'dart:io';
import 'package:cabkaro/services/image_picker_service.dart';
import 'package:cabkaro/widgets/Toastwidget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:cabkaro/utils/constants.dart' as constant;
>>>>>>> a64f8e0 (Edit vendor and user profile)

// ===================================
// Edit Profile with User's Dashboard |
// ===================================
class EditProfileController extends ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  Map<String, dynamic>? userData;

<<<<<<< HEAD
=======
  // Gender selection
  String selectedGender = 'male';

  // Profile image — File for new pick, base64 string for existing from server
  File? profileImageFile;       // newly picked image from device
  String profileImageBase64 = ''; // existing image loaded from saved data

  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;

  void setGender(String gender) {
    selectedGender = gender;
    notifyListeners();
  }

>>>>>>> a64f8e0 (Edit vendor and user profile)
  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

<<<<<<< HEAD
  void getUserData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? data = pref.getString("user-data");
    if (data != null) {
      userData = jsonDecode(data);
      notifyListeners();

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
=======
  // ── Load saved user data into all fields ──────────────────────
  void getUserData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? data = pref.getString("data");

    if (data != null) {
      userData = jsonDecode(data);

      nameController.text = userData!['name'] ?? '';
      phoneController.text = userData!['phone']?.toString() ?? '';

      if (userData!['gender'] != null) {
        selectedGender = userData!['gender'];
      }

      // Load existing profile image base64 from saved data
      if (userData!['profile_img'] != null &&
          userData!['profile_img'].toString().isNotEmpty) {
        profileImageBase64 = userData!['profile_img'];
      }

      notifyListeners();
    }
  }

  // ── Pick image from camera ────────────────────────────────────
  Future<void> pickFromCamera(BuildContext ctx) async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 800,
      );
      if (photo != null) {
        profileImageFile = File(photo.path);
        // Convert to base64 for sending to server
        final bytes = await profileImageFile!.readAsBytes();
        profileImageBase64 = base64Encode(bytes);
        notifyListeners();
      }
    } catch (e) {
      if (!ctx.mounted) return;
      ToastWidget.show(ctx,
          message: 'Could not open camera.', type: ToastType.error);
    }
  }

  // ── Pick image from gallery ───────────────────────────────────
  Future<void> pickFromGallery(BuildContext ctx) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 800,
      );
      if (image != null) {
        profileImageFile = File(image.path);
        // Convert to base64 for sending to server
        profileImageBase64 = await ImagePickerService.fileToBase64(File(image.path));
        notifyListeners();
      }
    } catch (e) {
      if (!ctx.mounted) return;
      ToastWidget.show(ctx,
          message: 'Could not pick image. Try again.', type: ToastType.error);
    }
  }

  // ── Update profile ────────────────────────────────────────────
  void update(BuildContext ctx) async {
    isLoading = true;
    notifyListeners();

>>>>>>> a64f8e0 (Edit vendor and user profile)
    try {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      final String token = pref.getString(constant.cabToken)!;
      final String role = pref.getString("role")!;
      late Uri url;
<<<<<<< HEAD
      Map<String, dynamic> data = {
        "name": nameController.text.trim(),
        "phone": phoneController.text.trim(),
        "token": token,
=======

      Map<String, dynamic> data = {
        "name": nameController.text.trim(),
        "phone": phoneController.text.trim(),
        "gender": selectedGender,
        "token": token,
        // Always send base64 — either newly picked or existing
        "profile_img": profileImageBase64,
>>>>>>> a64f8e0 (Edit vendor and user profile)
      };

      if (role == "driver") {
        url = Uri.parse("${constant.apiUrl}/driver/update");
      } else if (role == "user") {
        url = Uri.parse("${constant.apiUrl}/user/update");
      }

      var req = await http.patch(
        url,
        body: jsonEncode(data),
        headers: {"Content-Type": "application/json"},
      );
      var res = jsonDecode(req.body);
<<<<<<< HEAD
=======

>>>>>>> a64f8e0 (Edit vendor and user profile)
      if (req.statusCode != 200) {
        if (!ctx.mounted) return;
        ToastWidget.show(ctx, message: res['err'], type: ToastType.error);
        return;
      }

<<<<<<< HEAD
      userData!["name"] = nameController.text.trim();
      userData!["phone"] = phoneController.text.trim();
      pref.setString("user-data", jsonEncode(userData));
=======
      // Persist updated values back to local cache
      userData!["name"] = nameController.text.trim();
      userData!["phone"] = phoneController.text.trim();
      userData!["gender"] = selectedGender;
      userData!["profile_img"] = profileImageBase64;
      pref.setString("data", jsonEncode(userData));
>>>>>>> a64f8e0 (Edit vendor and user profile)
      notifyListeners();

      if (!ctx.mounted) return;
      ToastWidget.show(ctx, message: res['msg'], type: ToastType.success);
    } catch (err) {
      if (!ctx.mounted) return;
      ToastWidget.show(
        ctx,
        message: 'Something went wrong.',
        type: ToastType.error,
      );
<<<<<<< HEAD
      return;
    }
  }
}
=======
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
>>>>>>> a64f8e0 (Edit vendor and user profile)
