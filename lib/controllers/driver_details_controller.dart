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
  String? id;

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
      "_id": id,
    };
  }
}

// Controller here;
class DriverDetailsController extends ChangeNotifier {
  final List<DriverData> drivers = [];
  List<dynamic> listedDrivers = [];

  // Add new Blank Form set when Vendor register;
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

  void addDriver(DriverData data) {
    drivers.add(data);
    notifyListeners();
  }

  void updateDriver(dynamic id, DriverData data) {
    final index = drivers.indexWhere((d) => d.toJson()['_id'] == id);
    if (index != -1) {
      drivers[index] = data;
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

  Future<void> saveDriver(BuildContext ctx, {isNew = false}) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString(constant.cabToken);

      final List<Map<String, dynamic>> driverData = drivers
          .map((dd) => dd.toJson())
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
        drivers.clear();
        if (!ctx.mounted) return;
        ToastWidget.show(ctx, message: res['msg'], type: ToastType.success);

        if (isNew == true) {
          Navigator.pop(ctx);
          getVendorDrivers(ctx);
        }
        if (isNew == false) {
          Navigator.push(
            ctx,
            MaterialPageRoute(builder: (context) => const VendorHomeScreen()),
          );
        }
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
        listedDrivers = res['data'];
        notifyListeners();
      }
    } catch (er) {
      if (!ctx.mounted) return;
      ToastWidget.show(
        ctx,
        message: 'Something went wrong.',
        type: ToastType.error,
      );
    }
  }

  Future<void> deleteDriver(BuildContext ctx, String id) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString(constant.cabToken);

      final req = await http.delete(
        Uri.parse("${constant.apiUrl}/driver/delete/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"token": token}),
      );

      final res = jsonDecode(req.body);
      if (req.statusCode != 200) {
        if (!ctx.mounted) return;
        ToastWidget.show(ctx, message: res['err'], type: ToastType.error);
      } else {
        listedDrivers.removeWhere((driver) => driver['_id'] == id);
        notifyListeners();
        if (!ctx.mounted) return;
        ToastWidget.show(ctx, message: res['msg'], type: ToastType.success);
      }
    } catch (e) {
      if (!ctx.mounted) return;
      ToastWidget.show(
        ctx,
        message: 'Something went wrong.$e',
        type: ToastType.error,
      );
    }
  }
}
