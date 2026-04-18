import 'dart:convert';
import 'package:cabkaro/widgets/Toastwidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../utils/constants.dart' as constant;

class ReviewController extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Submit a review for a driver
  Future<bool> submitReview({
    required BuildContext context,
    required String driverId,
    required String rideId,
    required int rating,
    required String review,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = constant.cabToken; // Get token from SharedPreferences if needed

      Map<String, dynamic> data = {
        "driverId": driverId,
        "rideId": rideId,
        "rating": rating,
        "review": review,
      };

      Uri url = Uri.parse("${constant.apiUrl}/reviews/submit");
      var req = await http.post(
        url,
        body: jsonEncode(data),
        headers: {
          "Content-Type": "application/json",
          // "Authorization": "Bearer $token", // Add if your API requires auth
        },
      );

      var res = jsonDecode(req.body);

      if (req.statusCode != 201 && req.statusCode != 200) {
        if (!context.mounted) return false;
        ToastWidget.show(
          context,
          message: res['message'] ?? 'Failed to submit review',
          type: ToastType.error,
        );
        return false;
      }

      if (!context.mounted) return false;
      ToastWidget.show(
        context,
        message: 'Review submitted successfully',
        type: ToastType.success,
      );

      return true;
    } catch (e) {
      debugPrint('Error submitting review: $e');
      if (!context.mounted) return false;
      ToastWidget.show(
        context,
        message: 'Error submitting review',
        type: ToastType.error,
      );
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get reviews for a driver
  Future<List<Map<String, dynamic>>> getDriverReviews(String driverId) async {
    try {
      Uri url = Uri.parse("${constant.apiUrl}/reviews/driver/$driverId");
      var req = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      if (req.statusCode == 200) {
        var res = jsonDecode(req.body);
        List<Map<String, dynamic>> reviews =
            List<Map<String, dynamic>>.from(res['reviews'] ?? []);
        return reviews;
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching reviews: $e');
      return [];
    }
  }

  /// Get driver rating summary
  Future<Map<String, dynamic>> getDriverRatingSummary(String driverId) async {
    try {
      Uri url =
          Uri.parse("${constant.apiUrl}/reviews/driver/$driverId/summary");
      var req = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      if (req.statusCode == 200) {
        var res = jsonDecode(req.body);
        return res['summary'] ?? {};
      }
      return {};
    } catch (e) {
      debugPrint('Error fetching rating summary: $e');
      return {};
    }
  }
}
