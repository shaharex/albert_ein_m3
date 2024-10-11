import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ws_germany_ae3/models/user_profile.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key, required this.userName});

  final String userName;

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  List<UserProfile> userProfile = [];
  TextEditingController _captionController = TextEditingController();
  Uint8List? image;

  bool _userHavePosts = false;
  String captionText = 'Press edit to change the caption text';

  Future<Uint8List> pickImage() async {
    ByteData imageData = await rootBundle.load('assets/starman.jfif');
    return imageData.buffer.asUint8List();
  }

  void addPost(Uint8List image, String description) {
    userProfile.add(UserProfile(image, description));
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  // edit btn
  void editCaptionAndProfilePicture(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 250, horizontal: 40),
              width: 400,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      Uint8List newImage = await pickImage();
                      setState(() {
                        image = newImage;
                      });
                    },
                    child: Container(
                        alignment: Alignment.bottomCenter,
                        clipBehavior: Clip.hardEdge,
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: image != null
                                    ? MemoryImage(image!)
                                    : const AssetImage(
                                        'assets/Default Profile Picture.png')),
                            border: Border.all(
                                color: Colors.black,
                                style: BorderStyle.solid,
                                width: 2.5),
                            shape: BoxShape.circle),
                        child: Container(
                          alignment: Alignment.center,
                          height: 30,
                          width: double.infinity,
                          color: Colors.grey[800],
                          child: const Text(
                            'Tap to edit',
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          ),
                        )),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'New Caption Below:',
                    style: TextStyle(fontSize: 24),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Card(
                      child: TextField(
                        decoration: const InputDecoration(label: Text('Description')),
                        controller: _captionController,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      if (_captionController.text.isNotEmpty && image != null) {
                        setState(() {
                          captionText = _captionController.text;
                          addPost(image!, _captionController.text);
                        });
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Please fill all of the fields')));
                      }
                    },
                    child: Container(
                      height: 40,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 236, 236, 236),
                        border: Border.all(
                            color: Colors.black,
                            width: 1.3,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('Submit'),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          // user data and some options
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // profile picture
                Container(
                  clipBehavior: Clip.hardEdge,
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 2.5),
                      shape: BoxShape.circle),
                  child: image != null
                      ? Image.memory(
                          image!,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/Default Profile Picture.png',
                          fit: BoxFit.cover,
                        ),
                ),

                // info about user and button to follow or block
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.userName,
                      style: const TextStyle(fontSize: 22),
                    ),
                    SizedBox(
                      width: 230,
                      child: Text(
                        captionText,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            editCaptionAndProfilePicture(context);
                          },
                          child: Container(
                            width: 90,
                            height: 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black,
                                    style: BorderStyle.solid,
                                    width: 1.5),
                                borderRadius: BorderRadius.circular(7)),
                            child: const Text('Edit'),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 90,
                            height: 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black,
                                    style: BorderStyle.solid,
                                    width: 1.5),
                                borderRadius: BorderRadius.circular(7)),
                            child: const Text('Sign out'),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),

          // diveder
          Container(
            margin: const EdgeInsets.only(top: 10),
            width: double.infinity,
            height: 1,
            color: Colors.black,
          ),

          // grid with posts and images
          _userHavePosts
              ? Expanded(
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemBuilder: (context, index) {
                        return Container(
                          width: 100,
                          height: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          child: const Text(
                            'Post preview',
                            style: TextStyle(fontSize: 20),
                          ),
                        );
                      }),
                )
              : Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  alignment: Alignment.center,
                  child: const Text(
                    "You don't have posts yet, let's start creating them",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                )
        ],
      ),
    );
  }
}
