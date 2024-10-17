import 'package:flutter/material.dart';
import 'package:ws_germany_ae3/components/post_widget.dart';

class UserPostPage extends StatelessWidget {
  const UserPostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: const Text('Your post', style: TextStyle(color: Colors.white, fontSize: 20),),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          
          child: PostWidget(
            likeCount: 0,
            isLikePressed: false,
            onLikePressed: () {},
            onCommentPressed: () {},
            onSharePressed: () {},
          ),
        ),
      ),
    );
  }
}
