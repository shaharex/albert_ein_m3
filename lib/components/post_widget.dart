import 'package:flutter/material.dart';

class PostWidget extends StatelessWidget {
  PostWidget({
    super.key,
    required this.likeCount,
    required this.isLikePressed,
    required this.onLikePressed,
    required this.onCommentPressed,
    required this.onSharePressed,
  });
  final int likeCount;
  final bool isLikePressed;
  final Function()? onLikePressed;
  final Function()? onCommentPressed;
  final Function()? onSharePressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: Colors.grey[300], borderRadius: BorderRadius.circular(5)),
      width: double.infinity,
      child: Column(
        children: [
          // account and so on
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 10),
                width: 35,
                height: 35,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.black,
                        width: 1,
                        style: BorderStyle.solid)),
                child: Image.asset(
                  'assets/Default Profile Picture.png',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              const Text(
                'benjamin_frost',
                style: TextStyle(fontSize: 18),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),

          // image for post
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  color: Colors.black, width: 1.5, style: BorderStyle.solid),
            ),
            child: const Text(
              'Image',
              style: TextStyle(fontSize: 30),
            ),
          ),

          // buttons to react and caption
          Container(
            padding: const EdgeInsets.only(top: 5, left: 5),
            child: Row(
              children: [
                IconButton(
                    onPressed: onLikePressed,
                    icon:  Icon(
                      isLikePressed ? Icons.favorite : Icons.favorite_border_outlined,
                      color: isLikePressed ? Colors.red : null,
                    )),
                Text('$likeCount'),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.comment,
                    )),
                IconButton(onPressed: onSharePressed, icon: const Icon(Icons.share)),
                const Text('my first post'),
              ],
            ),
          ),

          // description
          Container(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
            child: const Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam congue aliquam sollicitudin. Ut aliquet dictum tortor. Mauris tellus lorem, vestibulum in lacus vitae, consectetur accumsan neque.'),
          ),
        ],
      ),
    );
  }
}
