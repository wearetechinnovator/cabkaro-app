import 'dart:io';
import 'dart:convert';
import 'package:cabkaro/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


class ImagePickerService {
  static final ImagePicker _imagePicker = ImagePicker();

  /// Pick image from camera
  static Future<File?> pickFromCamera() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
      );
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
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );
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
    File? selectedImage;

    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Choose Profile Picture'),
          content: const Text('Select the source for your profile picture'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);
                final image = await pickFromCamera();

                if (image != null && context.mounted) {
                  try {
                    final bytes = await image.readAsBytes();
                    final base64 = base64Encode(bytes);

                    if (!context.mounted) return;
                    Provider.of<UserController>(
                      context,
                      listen: false,
                    ).userProfileBase64 = "data:image/jpeg;base64,$base64";

                    selectedImage = image;
                  } catch (e) {
                    debugPrint('Error processing camera image: $e');
                  }
                }
              },
              child: const Text('Camera'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);
                final image = await pickFromGallery();

                if (image != null && context.mounted) {
                  try {
                    final bytes = await image.readAsBytes();
                    final base64 = base64Encode(bytes);

                    if (!context.mounted) return;
                    Provider.of<UserController>(
                      context,
                      listen: false,
                    ).userProfileBase64 = "data:image/jpeg;base64,$base64";

                    selectedImage = image;
                  } catch (e) {
                    debugPrint('Error processing gallery image: $e');
                  }
                }
              },
              child: const Text('Gallery'),
            ),
          ],
        );
      },
    );

    return selectedImage;
  }

  /// Convert file to base64 string
  static Future<String> fileToBase64(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final base64 = base64Encode(bytes);
      return "data:image/jpeg;base64,$base64";
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
