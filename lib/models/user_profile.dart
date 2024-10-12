import 'dart:convert';
import 'dart:typed_data';

class UserProfile {
  final String username;
  final Uint8List image;
  final String description;

  UserProfile(this.username, this.image, this.description);

  // converting it to the map
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'image': base64Encode(image),
      'description': description,
    };
  }

}