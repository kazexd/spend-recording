import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vibe_kanban/database/database_helper.dart';
import 'package:vibe_kanban/screens/main_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize database based on platform
  if (!kIsWeb) {
    await DatabaseHelper.instance.database;
  }
  
  runApp(const VibeKanbanApp());
}

class VibeKanbanApp extends StatelessWidget {
  const VibeKanbanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vibe Kanban',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MainNavigation(),
    );
  }
}
