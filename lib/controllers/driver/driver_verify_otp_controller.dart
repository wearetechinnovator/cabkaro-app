
import 'package:flutter/material.dart';

class DriverVerifyOtpController extends ChangeNotifier {
  String otp = '';
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

 
}