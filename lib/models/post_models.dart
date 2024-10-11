class Post {
  final String username;
  final String image;
  final String caption;
  final String description;
  final int likeCount;
  final List<dynamic> comments;

  Post({
    required this.username,
    required this.image,
    required this.caption,
    required this.description,
    required this.likeCount,
    required this.comments,
  });
}
