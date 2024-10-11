import 'package:flutter/material.dart';
import 'package:ws_germany_ae3/navigation/navigation_panel.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.android, size: 100),
              const Text('Please enter your username to login!', style: TextStyle(fontSize: 26), maxLines: 2, textAlign: TextAlign.center,),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey.shade300,
                  border: Border.all(color: Colors.grey.shade500, width: 2)
                ),
                child: TextField(
                  controller: nameController,
                ),
              )
              ,
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  if (nameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Fill the Textfield'))
                    );
                  } else if (nameController.text.isNotEmpty && nameController.text.runtimeType == String) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => NavigationPanel(userName: nameController.text)));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('The form data is not correct'))
                    );
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromARGB(255, 1, 53, 95),
                  ),
                  child: const Text('LOGIN', style: TextStyle(fontSize: 25, color: Colors.white),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}