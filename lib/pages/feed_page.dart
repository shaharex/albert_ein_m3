import 'package:flutter/material.dart';
import 'package:ws_germany_ae3/components/post_widget.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: ListView.separated(
            itemCount: 1,
            separatorBuilder: (context, index) {
              return SizedBox(height: 20);
            },
            itemBuilder: (context, index) {
            return PostWidget();
          }),
        ),
      ),
    );
  }
}
