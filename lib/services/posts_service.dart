import 'dart:convert';

import 'package:flutter/services.dart';

class PostsService {
  static const sharedPref = MethodChannel('com.sharedpref');


  // save image for the user profile using sharedpref 
  Future<void> saveUserProfile(String username, Uint8List image, String description) async {
    try {
      await sharedPref.invokeMethod('saveUserProfile', {
        'username': username,
        'image': base64Encode(image),
        'description': description,
      });
    } on PlatformException catch (e) {
      print("This is the error, dubi: ${e.message}");
    }
  }

  // get data of user
  Future<Map<String, dynamic>?> getUserProfileData(String username) async {
  try {
    final result = await sharedPref.invokeMethod('getUserProfile', {
      "username": username,
    });
    if (result != null) {
      return {
        'image': base64Decode(result['image']),
        'description': result['description'],
      };
    }
  } on PlatformException catch (e) {
    print("I could not do it,sir, the problem is '${e.message}'.");
  }
  return null;
  }


}
