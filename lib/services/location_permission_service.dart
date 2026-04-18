import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationPermissionService {
  static const String _permissionAskedKey = 'location_permission_asked';

  /// Request location permission on app first open
  static Future<bool> requestLocationPermission(BuildContext context) async {
    try {
      // Check if permission was already asked
      final prefs = await SharedPreferences.getInstance();
      final alreadyAsked = prefs.getBool(_permissionAskedKey) ?? false;

      if (alreadyAsked) {
        return await Permission.location.status.isGranted;
      }

      // Show custom dialog before requesting
      final shouldProceed = await _showPermissionDialog(context);

      if (!shouldProceed) {
        // Mark as asked even if user declined
        await prefs.setBool(_permissionAskedKey, true);
        return false;
      }

      // Request the actual permission
      final status = await Permission.location.request();

      // Mark permission as asked
      await prefs.setBool(_permissionAskedKey, true);

      if (status.isDenied) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permission denied'),
              duration: Duration(seconds: 2),
            ),
          );
        }
        return false;
      } else if (status.isGranted) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permission granted'),
              duration: Duration(seconds: 2),
            ),
          );
        }
        return true;
      } else if (status.isDenied) {
        if (context.mounted) {
          _showPermissionDeniedDialog(context);
        }
        return false;
      }

      return status.isGranted;
    } catch (e) {
      debugPrint('Error requesting location permission: $e');
      return false;
    }
  }

  /// Show initial permission request dialog
  static Future<bool> _showPermissionDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Enable Location'),
              content: const Text(
                'Cabkaro needs access to your location to show nearby rides and calculate fares accurately. Your location is only used for ride services.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Later'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text(
                    'Allow',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  /// Show dialog when permission is denied forever
  static Future<void> _showPermissionDeniedDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Permission'),
          content: const Text(
            'Location permission is permanently denied. Please enable it from app settings to use location features.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () {
                openAppSettings();
                Navigator.of(context).pop();
              },
              child: const Text(
                'Open Settings',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Check if location permission is granted
  static Future<bool> isLocationPermissionGranted() async {
    return await Permission.location.isGranted;
  }

  /// Reset permission tracking (for testing purposes)
  static Future<void> resetPermissionTracking() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_permissionAskedKey);
  }
}
