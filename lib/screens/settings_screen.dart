import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: Icon(Icons.palette),
                title: Text('Theme'),
                subtitle: Text('Light / Dark mode'),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
            SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: Icon(Icons.language),
                title: Text('Language'),
                subtitle: Text('English'),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
            SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: Icon(Icons.backup),
                title: Text('Backup & Sync'),
                subtitle: Text('Data synchronization'),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
            SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: Icon(Icons.security),
                title: Text('Privacy & Security'),
                subtitle: Text('Manage your privacy settings'),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
