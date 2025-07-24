import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vibe_kanban/models/board.dart';
import 'package:vibe_kanban/models/kanban_list.dart';
import 'package:vibe_kanban/models/card.dart';
import 'package:vibe_kanban/database/web_storage_helper.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('kanban.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
      CREATE TABLE boards (
        id $idType,
        title $textType,
        description TEXT,
        created_at $textType,
        updated_at $textType
      )
    ''');

    await db.execute('''
      CREATE TABLE lists (
        id $idType,
        board_id $integerType,
        title $textType,
        position $integerType,
        created_at $textType,
        updated_at $textType,
        FOREIGN KEY (board_id) REFERENCES boards (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE cards (
        id $idType,
        list_id $integerType,
        title $textType,
        description TEXT,
        position $integerType,
        created_at $textType,
        updated_at $textType,
        FOREIGN KEY (list_id) REFERENCES lists (id) ON DELETE CASCADE
      )
    ''');
  }

  // Board CRUD operations
  Future<int> insertBoard(Board board) async {
    if (kIsWeb) {
      return await WebStorageHelper.instance.insertBoard(board);
    }
    final db = await instance.database;
    return await db.insert('boards', board.toMap());
  }

  Future<List<Board>> getAllBoards() async {
    if (kIsWeb) {
      return await WebStorageHelper.instance.getAllBoards();
    }
    final db = await instance.database;
    final result = await db.query('boards', orderBy: 'created_at DESC');
    return result.map((json) => Board.fromMap(json)).toList();
  }

  Future<Board?> getBoard(int id) async {
    if (kIsWeb) {
      return await WebStorageHelper.instance.getBoard(id);
    }
    final db = await instance.database;
    final maps = await db.query(
      'boards',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Board.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateBoard(Board board) async {
    if (kIsWeb) {
      return await WebStorageHelper.instance.updateBoard(board);
    }
    final db = await instance.database;
    return await db.update(
      'boards',
      board.toMap(),
      where: 'id = ?',
      whereArgs: [board.id],
    );
  }

  Future<int> deleteBoard(int id) async {
    if (kIsWeb) {
      return await WebStorageHelper.instance.deleteBoard(id);
    }
    final db = await instance.database;
    return await db.delete(
      'boards',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // List CRUD operations
  Future<int> insertList(KanbanList list) async {
    if (kIsWeb) {
      return await WebStorageHelper.instance.insertList(list);
    }
    final db = await instance.database;
    return await db.insert('lists', list.toMap());
  }

  Future<List<KanbanList>> getListsByBoard(int boardId) async {
    if (kIsWeb) {
      return await WebStorageHelper.instance.getListsByBoard(boardId);
    }
    final db = await instance.database;
    final result = await db.query(
      'lists',
      where: 'board_id = ?',
      whereArgs: [boardId],
      orderBy: 'position ASC',
    );
    return result.map((json) => KanbanList.fromMap(json)).toList();
  }

  Future<int> updateList(KanbanList list) async {
    if (kIsWeb) {
      return await WebStorageHelper.instance.updateList(list);
    }
    final db = await instance.database;
    return await db.update(
      'lists',
      list.toMap(),
      where: 'id = ?',
      whereArgs: [list.id],
    );
  }

  Future<int> deleteList(int id) async {
    if (kIsWeb) {
      return await WebStorageHelper.instance.deleteList(id);
    }
    final db = await instance.database;
    return await db.delete(
      'lists',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Card CRUD operations
  Future<int> insertCard(KanbanCard card) async {
    if (kIsWeb) {
      return await WebStorageHelper.instance.insertCard(card);
    }
    final db = await instance.database;
    return await db.insert('cards', card.toMap());
  }

  Future<List<KanbanCard>> getCardsByList(int listId) async {
    if (kIsWeb) {
      return await WebStorageHelper.instance.getCardsByList(listId);
    }
    final db = await instance.database;
    final result = await db.query(
      'cards',
      where: 'list_id = ?',
      whereArgs: [listId],
      orderBy: 'position ASC',
    );
    return result.map((json) => KanbanCard.fromMap(json)).toList();
  }

  Future<int> updateCard(KanbanCard card) async {
    if (kIsWeb) {
      return await WebStorageHelper.instance.updateCard(card);
    }
    final db = await instance.database;
    return await db.update(
      'cards',
      card.toMap(),
      where: 'id = ?',
      whereArgs: [card.id],
    );
  }

  Future<int> deleteCard(int id) async {
    if (kIsWeb) {
      return await WebStorageHelper.instance.deleteCard(id);
    }
    final db = await instance.database;
    return await db.delete(
      'cards',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    if (kIsWeb) {
      await WebStorageHelper.instance.close();
      return;
    }
    final db = await instance.database;
    db.close();
  }
}
