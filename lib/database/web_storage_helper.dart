import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibe_kanban/models/board.dart';
import 'package:vibe_kanban/models/kanban_list.dart';
import 'package:vibe_kanban/models/card.dart';

class WebStorageHelper {
  static final WebStorageHelper instance = WebStorageHelper._init();
  WebStorageHelper._init();

  // Keys for local storage
  static const String _boardsKey = 'kanban_boards';
  static const String _listsKey = 'kanban_lists';
  static const String _cardsKey = 'kanban_cards';
  static const String _counterKey = 'kanban_counter';

  // Get next ID for new items
  Future<int> _getNextId() async {
    final prefs = await SharedPreferences.getInstance();
    final currentId = prefs.getInt(_counterKey) ?? 0;
    await prefs.setInt(_counterKey, currentId + 1);
    return currentId + 1;
  }

  // Board operations
  Future<int> insertBoard(Board board) async {
    final prefs = await SharedPreferences.getInstance();
    final id = await _getNextId();
    final boardWithId = Board(
      id: id,
      title: board.title,
      description: board.description,
      createdAt: board.createdAt,
      updatedAt: board.updatedAt,
    );
    
    final boards = await getAllBoards();
    boards.add(boardWithId);
    
    final boardsJson = boards.map((b) => b.toMap()).toList();
    await prefs.setString(_boardsKey, jsonEncode(boardsJson));
    
    return id;
  }

  Future<List<Board>> getAllBoards() async {
    final prefs = await SharedPreferences.getInstance();
    final boardsString = prefs.getString(_boardsKey);
    if (boardsString == null) return [];
    
    final boardsList = jsonDecode(boardsString) as List;
    return boardsList.map((json) => Board.fromMap(json)).toList();
  }

  Future<Board?> getBoard(int id) async {
    final boards = await getAllBoards();
    try {
      return boards.firstWhere((board) => board.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<int> updateBoard(Board board) async {
    final prefs = await SharedPreferences.getInstance();
    final boards = await getAllBoards();
    final index = boards.indexWhere((b) => b.id == board.id);
    
    if (index != -1) {
      boards[index] = board;
      final boardsJson = boards.map((b) => b.toMap()).toList();
      await prefs.setString(_boardsKey, jsonEncode(boardsJson));
      return 1;
    }
    return 0;
  }

  Future<int> deleteBoard(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final boards = await getAllBoards();
    boards.removeWhere((board) => board.id == id);
    
    // Also delete related lists and cards
    final lists = await getListsByBoard(id);
    for (final list in lists) {
      await deleteList(list.id!);
    }
    
    final boardsJson = boards.map((b) => b.toMap()).toList();
    await prefs.setString(_boardsKey, jsonEncode(boardsJson));
    
    return 1;
  }

  // List operations
  Future<int> insertList(KanbanList list) async {
    final prefs = await SharedPreferences.getInstance();
    final id = await _getNextId();
    final listWithId = KanbanList(
      id: id,
      boardId: list.boardId,
      title: list.title,
      position: list.position,
      createdAt: list.createdAt,
      updatedAt: list.updatedAt,
    );
    
    final lists = await _getAllLists();
    lists.add(listWithId);
    
    final listsJson = lists.map((l) => l.toMap()).toList();
    await prefs.setString(_listsKey, jsonEncode(listsJson));
    
    return id;
  }

  Future<List<KanbanList>> _getAllLists() async {
    final prefs = await SharedPreferences.getInstance();
    final listsString = prefs.getString(_listsKey);
    if (listsString == null) return [];
    
    final listsList = jsonDecode(listsString) as List;
    return listsList.map((json) => KanbanList.fromMap(json)).toList();
  }

  Future<List<KanbanList>> getListsByBoard(int boardId) async {
    final allLists = await _getAllLists();
    return allLists.where((list) => list.boardId == boardId).toList()
      ..sort((a, b) => a.position.compareTo(b.position));
  }

  Future<int> updateList(KanbanList list) async {
    final prefs = await SharedPreferences.getInstance();
    final lists = await _getAllLists();
    final index = lists.indexWhere((l) => l.id == list.id);
    
    if (index != -1) {
      lists[index] = list;
      final listsJson = lists.map((l) => l.toMap()).toList();
      await prefs.setString(_listsKey, jsonEncode(listsJson));
      return 1;
    }
    return 0;
  }

  Future<int> deleteList(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final lists = await _getAllLists();
    lists.removeWhere((list) => list.id == id);
    
    // Also delete related cards
    final cards = await getCardsByList(id);
    for (final card in cards) {
      await deleteCard(card.id!);
    }
    
    final listsJson = lists.map((l) => l.toMap()).toList();
    await prefs.setString(_listsKey, jsonEncode(listsJson));
    
    return 1;
  }

  // Card operations
  Future<int> insertCard(KanbanCard card) async {
    final prefs = await SharedPreferences.getInstance();
    final id = await _getNextId();
    final cardWithId = KanbanCard(
      id: id,
      listId: card.listId,
      title: card.title,
      description: card.description,
      position: card.position,
      createdAt: card.createdAt,
      updatedAt: card.updatedAt,
    );
    
    final cards = await _getAllCards();
    cards.add(cardWithId);
    
    final cardsJson = cards.map((c) => c.toMap()).toList();
    await prefs.setString(_cardsKey, jsonEncode(cardsJson));
    
    return id;
  }

  Future<List<KanbanCard>> _getAllCards() async {
    final prefs = await SharedPreferences.getInstance();
    final cardsString = prefs.getString(_cardsKey);
    if (cardsString == null) return [];
    
    final cardsList = jsonDecode(cardsString) as List;
    return cardsList.map((json) => KanbanCard.fromMap(json)).toList();
  }

  Future<List<KanbanCard>> getCardsByList(int listId) async {
    final allCards = await _getAllCards();
    return allCards.where((card) => card.listId == listId).toList()
      ..sort((a, b) => a.position.compareTo(b.position));
  }

  Future<int> updateCard(KanbanCard card) async {
    final prefs = await SharedPreferences.getInstance();
    final cards = await _getAllCards();
    final index = cards.indexWhere((c) => c.id == card.id);
    
    if (index != -1) {
      cards[index] = card;
      final cardsJson = cards.map((c) => c.toMap()).toList();
      await prefs.setString(_cardsKey, jsonEncode(cardsJson));
      return 1;
    }
    return 0;
  }

  Future<int> deleteCard(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final cards = await _getAllCards();
    cards.removeWhere((card) => card.id == id);
    
    final cardsJson = cards.map((c) => c.toMap()).toList();
    await prefs.setString(_cardsKey, jsonEncode(cardsJson));
    
    return 1;
  }

  Future<void> close() async {
    // No cleanup needed for SharedPreferences
  }
}
