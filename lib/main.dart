import 'package:flutter/material.dart';
import 'package:vibe_kanban/database/database_helper.dart';
import 'package:vibe_kanban/screens/kanban_board.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;
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
      home: const KanbanBoard(),
    );
  }
}
