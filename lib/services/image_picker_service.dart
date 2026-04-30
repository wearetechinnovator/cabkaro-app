<<<<<<< HEAD
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

=======
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


>>>>>>> a64f8e0 (Edit vendor and user profile)
class ImagePickerService {
  static final ImagePicker _imagePicker = ImagePicker();

  /// Pick image from camera
  static Future<File?> pickFromCamera() async {
    try {
<<<<<<< HEAD
      final XFile? pickedFile =
          await _imagePicker.pickImage(source: ImageSource.camera);
=======
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
      );
>>>>>>> a64f8e0 (Edit vendor and user profile)
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
    } catch (e) {
      debugPrint('Error picking from camera: $e');
    }
    return null;
  }

  /// Pick image from gallery
  static Future<File?> pickFromGallery() async {
    try {
<<<<<<< HEAD
      final XFile? pickedFile =
          await _imagePicker.pickImage(source: ImageSource.gallery);
=======
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );
>>>>>>> a64f8e0 (Edit vendor and user profile)
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
    } catch (e) {
      debugPrint('Error picking from gallery: $e');
    }
    return null;
  }

  /// Show dialog to choose between camera and gallery
  static Future<File?> showImagePickerDialog(BuildContext context) async {
<<<<<<< HEAD
    return showDialog<File?>(
      context: context,
      builder: (BuildContext context) {
=======
    return await showDialog<File?>(
      context: context,
      builder: (BuildContext dialogContext) {
>>>>>>> a64f8e0 (Edit vendor and user profile)
        return AlertDialog(
          title: const Text('Choose Profile Picture'),
          content: const Text('Select the source for your profile picture'),
          actions: [
            TextButton(
<<<<<<< HEAD
              onPressed: () => Navigator.pop(context),
=======
              onPressed: () => Navigator.pop(dialogContext),
>>>>>>> a64f8e0 (Edit vendor and user profile)
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
<<<<<<< HEAD
                Navigator.pop(context);
                final image = await pickFromCamera();
                if (context.mounted && image != null) {
                  Navigator.pop(context, image);
=======
                final image = await pickFromCamera();
                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext, image);
>>>>>>> a64f8e0 (Edit vendor and user profile)
                }
              },
              child: const Text('Camera'),
            ),
            TextButton(
              onPressed: () async {
<<<<<<< HEAD
                Navigator.pop(context);
                final image = await pickFromGallery();
                if (context.mounted && image != null) {
                  Navigator.pop(context, image);
=======
                final image = await pickFromGallery();
                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext, image);
>>>>>>> a64f8e0 (Edit vendor and user profile)
                }
              },
              child: const Text('Gallery'),
            ),
          ],
        );
      },
    );
  }

  /// Convert file to base64 string
  static Future<String> fileToBase64(File file) async {
    try {
      final bytes = await file.readAsBytes();
<<<<<<< HEAD
      return base64Encode(bytes);
=======
      final base64 = base64Encode(bytes);
      return "data:image/jpeg;base64,$base64";
>>>>>>> a64f8e0 (Edit vendor and user profile)
    } catch (e) {
      debugPrint('Error converting file to base64: $e');
      return '';
    }
  }

  /// Get file size in MB
  static Future<double> getFileSizeInMB(File file) async {
    try {
      final bytes = await file.readAsBytes();
      return bytes.length / (1024 * 1024);
    } catch (e) {
      debugPrint('Error getting file size: $e');
      return 0;
    }
  }

  /// Check if file is a valid image
  static bool isValidImageFile(File file) {
    final validExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp'];
    final fileName = file.path.toLowerCase();
    return validExtensions.any((ext) => fileName.endsWith(ext));
  }
}
