import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ws_germany_ae3/services/pick_image_service.dart';

class NewPostPage extends StatefulWidget {
  const NewPostPage({super.key});

  @override
  State<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  Uint8List? image;
  Uint8List? newImage;

  TextEditingController _descriptionController = TextEditingController();
  String description = '';

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          'Create New Post',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  alignment: Alignment.center,
                  child: const Text('Post Preview:', style: TextStyle(fontSize: 26),),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.black, width: 3)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                      GestureDetector(
                        onTap: () async {
                          newImage =
                              await PickImageService.pickImageFromGallery();
                          if (newImage != null) {
                            debugPrint("Image picked with $newImage bytes.");
                            setState(() {
                              image = newImage;
                            });
                          } else {
                            debugPrint("No image picked.");
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          height: 180,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey,
                              image: image != null
                                  ? DecorationImage(
                                      fit: BoxFit.cover,
                                      image: MemoryImage(image!),
                                    )
                                  : null),
                          child: image != null
                              ? null
                              : const Text(
                                  'Tap to select',
                                  style: TextStyle(fontSize: 20),
                                ),
                        ),
                      ),

                      // buttons to react and caption
                      Container(
                        padding: const EdgeInsets.only(top: 5, left: 5),
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.favorite_border_outlined,
                                )),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.comment)),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.share)),
                            const Text('my first post'),
                          ],
                        ),
                      ),

                      // pick the image
                      TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            labelText: 'Description'),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black,
                          ),
                          child: const Text(
                            'ADD POST',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
