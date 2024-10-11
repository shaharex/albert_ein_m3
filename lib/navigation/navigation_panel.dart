import 'package:flutter/material.dart';
import 'package:ws_germany_ae3/pages/map_page.dart';
import 'package:ws_germany_ae3/pages/new_post_page.dart';
import 'package:ws_germany_ae3/pages/user_profile_page.dart';

import '../pages/feed_page.dart';

class NavigationPanel extends StatefulWidget {
  const NavigationPanel({super.key, required this.userName});
  final String userName;

  @override
  State<NavigationPanel> createState() => _NavigationPanelState();
}

class _NavigationPanelState extends State<NavigationPanel> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        FeedPage(),
        MapPage(),
        UserProfilePage(userName: widget.userName,),
      ][currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedIconTheme: IconThemeData(color: Colors.grey[600], size: 26),
        selectedIconTheme: const IconThemeData(color: Colors.black, size: 26),
        currentIndex: currentPageIndex,
        onTap: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        items: const [
        BottomNavigationBarItem(icon: Icon(Icons.feed), label: 'Feed'),
        BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'User Profile'),
      ],
      
      ),
      floatingActionButtonLocation: currentPageIndex == 1 ? FloatingActionButtonLocation.startFloat : FloatingActionButtonLocation.endFloat,
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => NewPostPage()));
        },
        child: Container(
          width: 120,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20)
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: Colors.white,),
              Text('New Post', style: TextStyle(color: Colors.white),)
            ],
          )
        ),
      ),
    );
  }
}
