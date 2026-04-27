import 'dart:convert';
import 'dart:io';
import 'package:cabkaro/screens/driver/vendor_home_screen.dart';
import 'package:cabkaro/widgets/Toastwidget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cabkaro/utils/constants.dart' as constant;

class DriverData {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  File? driverImage;
  String? base64Img;
  bool loading = false;

  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    base64Img = null;
  }

  Map<String, dynamic> toJson() {
    return {
      "driver_name": nameController.text.trim(),
      "driver_phone": phoneController.text.trim(),
      "driver_img": base64Img,
    };
  }
}

// Controller here;
class DriverDetailsController extends ChangeNotifier {
  final List<DriverData> drivers = [DriverData()];
  List<dynamic> listedDrivers = [];

  void addNewDriver() {
    drivers.add(DriverData());
    notifyListeners();
  }

  void removeDriver(int index) {
    if (drivers.length > 1) {
      drivers[index].dispose();
      drivers.removeAt(index);
      notifyListeners();
    }
  }

  Future<void> pickImage(int index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      drivers[index].driverImage = File(pickedFile.path);

      final temp = File(pickedFile.path);
      final bytes = await temp.readAsBytes();
      final base64 = base64Encode(bytes);
      drivers[index].base64Img = "data:image/jpeg;base64,$base64";
      notifyListeners();
    }
  }

  Future<void> saveDriver(BuildContext ctx) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString(constant.cabToken);

      final List<Map<String, dynamic>> driverData = drivers
          .map((car) => car.toJson())
          .toList();

      final req = await http.post(
        Uri.parse("${constant.apiUrl}/driver/update-driver"),
        headers: {"Content-Type": "application/json", "x-cab-token": token!},
        body: jsonEncode({"driverDetails": driverData, "token": token}),
      );

      final res = jsonDecode(req.body);
      if (req.statusCode != 200) {
        if (!ctx.mounted) return;
        ToastWidget.show(ctx, message: res['err'], type: ToastType.error);
      } else {
        if (!ctx.mounted) return;
        ToastWidget.show(ctx, message: res['msg'], type: ToastType.error);
        Navigator.push(
          ctx,
          MaterialPageRoute(builder: (context) => const VendorHomeScreen()),
        );
      }
    } catch (err) {
      if (!ctx.mounted) return;
      ToastWidget.show(
        ctx,
        message: 'Something went wrong.',
        type: ToastType.error,
      );
    }
  }

  Future<void> getVendorDrivers(BuildContext ctx) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString(constant.cabToken);

      final req = await http.get(
        Uri.parse("${constant.apiUrl}/driver/vendor/get"),
        headers: {"x-cab-token": token!},
      );

      final res = jsonDecode(req.body);
      if (req.statusCode != 200) {
        if (!ctx.mounted) return;
        ToastWidget.show(ctx, message: res['err'], type: ToastType.error);
      } else {
        print(res['data']);
        listedDrivers = res['data'];
        notifyListeners();
      }
    } catch (er) {
      if (!ctx.mounted) return;
      print("-----------------Er");
      print(er);
      ToastWidget.show(
        ctx,
        message: 'Something went wrong.',
        type: ToastType.error,
      );
    }
  }
}
