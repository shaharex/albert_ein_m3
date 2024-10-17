import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ws_germany_ae3/components/post_widget.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  List<String> commentsList = [
    "This is the banger",
    "Bay city",
    "OutOfmemoryError is the most common problem that occurs in android while especially dealing with bitmaps.So here is how to solve it: https://stackoverflow.com"
    "You're right and it is thrown by JVM when an object cannot be allocated due to lack of memory space",
    "Or teh grabage collector cannot free some space",
    "You can add below enitites to solve this problem:"
  ];

  void addComment(String comment) {
    setState(() {
      commentsList.add(comment);
    });
  }

  // share method
  static const sharePlatform = MethodChannel("com.share");

  // show the Android Share Sheet
  Future<void> _openShareSheet(String text) async {
    try {
      await sharePlatform.invokeMethod('share', {"text": text});
    } on PlatformException catch (e) {
      debugPrint('This is the Error: ${e.message}');
    }
  }

  final TextEditingController _commentsController = TextEditingController();

  // open the comments dialog
  void _showCommentsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          width: double.infinity,
          height: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Comments:',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              Expanded(
                  child: ListView.separated(
                itemCount: commentsList.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      CircleAvatar(
                          radius: 18,
                          child: Image.asset(
                            "assets/Default Profile Picture.png",
                            fit: BoxFit.cover,
                          )),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          commentsList[index],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 5);
                },
              )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Add comment:',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  TextField(
                    controller: _commentsController,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 40,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black,
                                    width: 2,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(5)),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            if (_commentsController.text.isNotEmpty) {
                              addComment(_commentsController.text);
                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pleas write something, God dammit it")));
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 40,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(5)),
                            child: const Text(
                              "Submit",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
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
                return const SizedBox(height: 20);
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
                  onCommentPressed: () {
                    _showCommentsDialog(context);
                  },
                  onSharePressed: () {
                    _openShareSheet("aa anata wo otte tasogare no bay city");
                  },
                );
              }),
        ),
      ),
    );
  }
}
