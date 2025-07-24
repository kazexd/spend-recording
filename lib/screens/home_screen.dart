import 'package:flutter/material.dart';
import 'package:vibe_kanban/screens/kanban_board.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Vibe Kanban',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Your productivity dashboard',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 32),
            Card(
              child: ListTile(
                leading: Icon(Icons.dashboard, color: Colors.blue),
                title: Text('Quick Stats'),
                subtitle: Text('View your recent activity'),
              ),
            ),
            SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: Icon(Icons.trending_up, color: Colors.green),
                title: Text('Productivity'),
                subtitle: Text('Track your progress'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
