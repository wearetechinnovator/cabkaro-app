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
  File? carImage;
  String? base64Img;
  String isAc = "No";
  String isSos = "No";
  String isFirstAid = "No";
  String? seaterCount;

  void dispose() {
    carNumberController.dispose();
    facilitiesController.dispose();
  }

  Map<String, dynamic> toJson() {
    return {
      "vehicle_number": carNumberController.text.trim(),
      "vechicle_img": base64Img,
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

  Future<void> saveVehicle(BuildContext ctx) async {
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
        ToastWidget.show(ctx, message: res['msg'], type: ToastType.error);
        Navigator.push(
          ctx,
          MaterialPageRoute(builder: (context) => const DriverDetailsScreen()),
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
}
