import 'package:flutter/material.dart';
import 'package:vibe_kanban/database/database_helper.dart';
import 'package:vibe_kanban/models/board.dart';
import 'package:vibe_kanban/models/kanban_list.dart';
import 'package:vibe_kanban/models/card.dart';

class KanbanBoard extends StatefulWidget {
  const KanbanBoard({super.key});

  @override
  State<KanbanBoard> createState() => _KanbanBoardState();
}

class _KanbanBoardState extends State<KanbanBoard> {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  List<Board> boards = [];
  Board? selectedBoard;
  List<KanbanList> lists = [];
  Map<int, List<KanbanCard>> cardsByList = {};

  @override
  void initState() {
    super.initState();
    _loadBoards();
  }

  Future<void> _loadBoards() async {
    final loadedBoards = await _databaseHelper.getAllBoards();
    setState(() {
      boards = loadedBoards;
      if (boards.isNotEmpty && selectedBoard == null) {
        selectedBoard = boards.first;
        _loadBoardData();
      }
    });
  }

  Future<void> _loadBoardData() async {
    if (selectedBoard == null) return;

    final loadedLists = await _databaseHelper.getListsByBoard(selectedBoard!.id!);
    final Map<int, List<KanbanCard>> loadedCards = {};

    for (final list in loadedLists) {
      final cards = await _databaseHelper.getCardsByList(list.id!);
      loadedCards[list.id!] = cards;
    }

    setState(() {
      lists = loadedLists;
      cardsByList = loadedCards;
    });
  }

  Future<void> _createSampleData() async {
    final now = DateTime.now();
    
    // Create a sample board
    final board = Board(
      title: 'Sample Kanban Board',
      description: 'A sample board to test SQLite integration',
      createdAt: now,
      updatedAt: now,
    );
    
    final boardId = await _databaseHelper.insertBoard(board);
    
    // Create sample lists
    final todoList = KanbanList(
      boardId: boardId,
      title: 'To Do',
      position: 0,
      createdAt: now,
      updatedAt: now,
    );
    
    final inProgressList = KanbanList(
      boardId: boardId,
      title: 'In Progress',
      position: 1,
      createdAt: now,
      updatedAt: now,
    );
    
    final doneList = KanbanList(
      boardId: boardId,
      title: 'Done',
      position: 2,
      createdAt: now,
      updatedAt: now,
    );
    
    final todoListId = await _databaseHelper.insertList(todoList);
    final inProgressListId = await _databaseHelper.insertList(inProgressList);
    final doneListId = await _databaseHelper.insertList(doneList);
    
    // Create sample cards
    final cards = [
      KanbanCard(
        listId: todoListId,
        title: 'Implement SQLite support',
        description: 'Add SQLite database integration to the Kanban app',
        position: 0,
        createdAt: now,
        updatedAt: now,
      ),
      KanbanCard(
        listId: todoListId,
        title: 'Create UI components',
        description: 'Design and implement the Kanban board UI',
        position: 1,
        createdAt: now,
        updatedAt: now,
      ),
      KanbanCard(
        listId: inProgressListId,
        title: 'Database models',
        description: 'Create Board, List, and Card models',
        position: 0,
        createdAt: now,
        updatedAt: now,
      ),
      KanbanCard(
        listId: doneListId,
        title: 'Project setup',
        description: 'Initialize Flutter project and add dependencies',
        position: 0,
        createdAt: now,
        updatedAt: now,
      ),
    ];
    
    for (final card in cards) {
      await _databaseHelper.insertCard(card);
    }
    
    await _loadBoards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vibe Kanban'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _createSampleData,
            tooltip: 'Create Sample Data',
          ),
        ],
      ),
      body: selectedBoard == null
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.dashboard, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No boards available'),
                  SizedBox(height: 8),
                  Text('Tap the + button to create sample data'),
                ],
              ),
            )
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    selectedBoard!.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: lists.length,
                    itemBuilder: (context, index) {
                      final list = lists[index];
                      final cards = cardsByList[list.id] ?? [];
                      
                      return Container(
                        width: 300,
                        margin: const EdgeInsets.all(8),
                        child: Card(
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  list.title,
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: cards.length,
                                  itemBuilder: (context, cardIndex) {
                                    final card = cards[cardIndex];
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      child: Card(
                                        elevation: 2,
                                        child: ListTile(
                                          title: Text(card.title),
                                          subtitle: card.description != null
                                              ? Text(card.description!)
                                              : null,
                                          dense: true,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
