import 'dart:typed_data';

class UserProfile {
  final Uint8List image;
  final String description;

  UserProfile(this.image, this.description);
}