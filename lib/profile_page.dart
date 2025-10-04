// lib/profile_page.dart
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(radius: 40, backgroundColor: Colors.grey),
            SizedBox(height: 10),
            Text('Username', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text('You have 5 posts.'),
          ],
        ),
      ),
    );
  }
}
