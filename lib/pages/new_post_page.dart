import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  static const MethodChannel _channel = MethodChannel("image_picker_channel");

  static Future<Uint8List?> pickImageFromGallery() async {
    try {
      final Uint8List? imageBytes = await _channel.invokeMethod('pickImage');
      debugPrint('$imageBytes');
      return imageBytes;
    } catch (e) {
      print('This was the error: $e');
      return null;
    }
  }

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
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 200),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.black, width: 3)),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                // pick the image
                const SizedBox(height: 10),
                Container(
                  alignment: Alignment.center,
                  width: 300,
                  height: 200,
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
                          'Select image',
                          style: TextStyle(fontSize: 18),
                        ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () async {
                    newImage = await pickImageFromGallery();
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
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: const Color.fromARGB(255, 1, 53, 95),
                    ),
                    child: const Text(
                      'Pick Image',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      labelText: 'Description'),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    
                  },
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
        ),
      ),
    );
  }
}
