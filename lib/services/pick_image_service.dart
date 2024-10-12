import 'dart:typed_data';

import 'package:flutter/services.dart';

class PickImageService {
  static const MethodChannel _pickImageChannel = MethodChannel("image_picker_channel");

  static Future<Uint8List?> pickImageFromGallery() async {
    try {
      final Uint8List? imageBytes = await _pickImageChannel.invokeMethod("pickImage");
      return imageBytes;
    } catch (e) {
      print('This is the eroor: $e');
      return null;
    }
  }
}