import 'dart:convert';
import 'dart:io';
import 'package:cabkaro/screens/common/driver_details_screen.dart';
import 'package:cabkaro/widgets/Toastwidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cabkaro/utils/constants.dart' as constant;

class CarDetails {
  TextEditingController carNumberController = TextEditingController();
  TextEditingController facilitiesController = TextEditingController();
  TextEditingController carModel = TextEditingController();
  File? carImage;
  String? base64Img;
  String isAc = "No";
  String isSos = "No";
  String isFirstAid = "No";
  String? seaterCount;
  String? id;

  void dispose() {
    carNumberController.dispose();
    facilitiesController.dispose();
    carModel.dispose();
    base64Img = null;
    isAc = "No";
    isSos = "No";
    isFirstAid = "No";
    seaterCount = null;
    id = null;
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "vehicle_number": carNumberController.text.trim(),
      "vehicle_img": base64Img,
      "vehicle_model": carModel.text.trim(),
      "is_ac": isAc,
      "is_first_aid_kid": isFirstAid,
      "is_sos": isSos,
      "facilities": facilitiesController.text.trim(),
      "number_of_seats": seaterCount,
    };
  }
}

class CarDetailsController extends ChangeNotifier {
  final List<CarDetails> cars = [CarDetails()];
  List<dynamic> listedVechiles = [];

  void addNewCar() {
    cars.add(CarDetails());
    notifyListeners();
  }

  void removeCar(int index) {
    if (cars.length > 1) {
      cars[index].dispose();
      cars.removeAt(index);
      notifyListeners();
    }
  }

  Future<void> pickImage(int index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      cars[index].carImage = File(pickedFile.path);

      final temp = File(pickedFile.path);
      final bytes = await temp.readAsBytes();
      final base64 = base64Encode(bytes);
      cars[index].base64Img = "data:image/jpeg;base64,$base64";
      notifyListeners();
    }
  }

  Future<void> saveVehicle(BuildContext ctx, {isEdit = false}) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString(constant.cabToken);

      final List<Map<String, dynamic>> carsData = cars
          .map((car) => car.toJson())
          .toList();

      final req = await http.post(
        Uri.parse("${constant.apiUrl}/vehicles/add"),
        headers: {"Content-Type": "application/json", "x-cab-token": token!},
        body: jsonEncode({"vehicleDetails": carsData, "token": token}),
      );

      final res = jsonDecode(req.body);
      if (req.statusCode != 200) {
        if (!ctx.mounted) return;
        ToastWidget.show(ctx, message: res['err'], type: ToastType.error);
      } else {
        if (!ctx.mounted) return;
        ToastWidget.show(ctx, message: res['msg'], type: ToastType.success);
        if (isEdit) {
          Navigator.pop(ctx);
          getVendorVehicles(ctx);
        } else {
          Navigator.push(
            ctx,
            MaterialPageRoute(
              builder: (context) => const DriverDetailsScreen(),
            ),
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

  Future<void> getVendorVehicles(BuildContext ctx) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString(constant.cabToken);

      final req = await http.get(
        Uri.parse("${constant.apiUrl}/vehicles/vendor/get"),
        headers: {"x-cab-token": token!},
      );

      final res = jsonDecode(req.body);
      if (req.statusCode != 200) {
        if (!ctx.mounted) return;
        ToastWidget.show(ctx, message: res['err'], type: ToastType.error);
      } else {
        listedVechiles = res['data'];
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

  Future<void> deleteVehicle(BuildContext ctx, String id) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString(constant.cabToken);

      final req = await http.delete(
        Uri.parse("${constant.apiUrl}/vehicles/delete/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"token": token}),
      );

      final res = jsonDecode(req.body);
      if (req.statusCode != 200) {
        if (!ctx.mounted) return;
        ToastWidget.show(ctx, message: res['err'], type: ToastType.error);
      } else {
        listedVechiles.removeWhere((car) => car['_id'] == id);
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
