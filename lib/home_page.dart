import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
    const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: CircleAvatar(backgroundColor: Colors.blue),
              title: Text('User $index'),
              subtitle: Text('This is a sample post.'),
            ),
          );
        },
      ),
    );
  }
}
