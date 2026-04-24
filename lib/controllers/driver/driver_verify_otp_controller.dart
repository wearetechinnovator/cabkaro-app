import 'dart:convert';
import 'package:cabkaro/screens/driver/driver_home_screen.dart';
import 'package:cabkaro/widgets/ToastWidget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../utils/constants.dart' as constant;

class DriverVerifyOtpController extends ChangeNotifier {
  String otp = '';
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

 
}