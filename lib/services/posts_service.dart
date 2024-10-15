import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class PostsService {

  static const sharedPref = MethodChannel('com.sharedpref');

  // save image for the user profile using sharedpref
  Future<void> saveUserProfile(
      String username, Uint8List image, String description) async {
    try {
      await sharedPref.invokeMethod('saveUserProfile', {
        'username': username,
        'image': base64Encode(image),
        'description': description,
      });
    } on PlatformException catch (e) {
      debugPrint("This is the error, dubi: ${e.message}");
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
      debugPrint("I could not do it,sir, the problem is '${e.message}'.");
    }
    return null;
  }

  // add post
  Future<void> addPost(Uint8List postImage, String postDescription,
      String username, Uint8List userImage) async {
    try {
      await sharedPref.invokeMethod("addPost", {
        'username': username,
        'userImage': base64Encode(userImage),
        'postImage': base64Encode(postImage),
        'postDescription': postDescription,
        'likeCount': 0,
        'comments': [],
      });
    } on PlatformException catch (e) {
      debugPrint("This is the error: ${e.message}");
    }
  }

  // get posts
  Future<Map<String, dynamic>?> getPostsData(String username) async {
    try {
      final result = await sharedPref.invokeMethod("getPostsData", {
        "username": username,
      });
      if (result != null) {
        return {
          'username': result['username'],
          'userImage': base64Decode(result['userImage']),
          'postImage': base64Decode(result['postImage']),
          'postDescription': result['description'],
          'likeCount': result['likeCount'],
          'comments': List<String>.from(result['comments']).isEmpty ? ['First Comment', 'Second one'] : List<String>.from(result['comments']),
        };
      }
    } on PlatformException catch (e) {
      debugPrint("I could not do it,sir, the problem is '${e.message}'.");
    }
    return null;
  }
}
