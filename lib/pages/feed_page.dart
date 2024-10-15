import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ws_germany_ae3/components/post_widget.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
 static const sharePlatform = MethodChannel("com.share");
  Future<void> _openShareSheet(String text) async {
    try {
      await sharePlatform.invokeMethod('share', {"text": text});
    } on PlatformException catch (e) {
      debugPrint('This is the Error: ${e.message}');
    }
  }

  int likeCount = 0;
  bool isLikePressed = false;
 
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: ListView.separated(
              itemCount: 5,
              separatorBuilder: (context, index) {
                return SizedBox(height: 20);
              },
              itemBuilder: (context, index) {
                return PostWidget(
                  likeCount: likeCount,
                  isLikePressed: isLikePressed,
                  onLikePressed: () {
                    setState(() {
                      isLikePressed = !isLikePressed;
                      likeCount = isLikePressed ? 1 : 0;
                    });
                    debugPrint(
                        "likeCount: $likeCount, isLikePressed: $isLikePressed");
                  },
                  onCommentPressed: () {},
                  onSharePressed: () {
                    _openShareSheet("Check out the Bay City");
                  },
                );
              }),
        ),
      ),
    );
  }
}
