import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vibe_kanban/models/board.dart';
import 'package:vibe_kanban/models/kanban_list.dart';
import 'package:vibe_kanban/models/card.dart';
import 'package:vibe_kanban/models/wallet.dart';
import 'package:vibe_kanban/models/transaction.dart' as model;
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
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
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

    await db.execute('''
      CREATE TABLE wallets (
        id $idType,
        name $textType,
        currency $textType,
        balance REAL NOT NULL DEFAULT 0.0,
        created_at $textType,
        updated_at $textType
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions (
        id $idType,
        wallet_id $integerType,
        title $textType,
        description TEXT,
        amount REAL NOT NULL,
        type $textType,
        category $textType,
        created_at $textType,
        updated_at $textType,
        FOREIGN KEY (wallet_id) REFERENCES wallets (id) ON DELETE CASCADE
      )
    ''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
      const textType = 'TEXT NOT NULL';
      const integerType = 'INTEGER NOT NULL';

      await db.execute('''
        CREATE TABLE wallets (
          id $idType,
          name $textType,
          currency $textType,
          balance REAL NOT NULL DEFAULT 0.0,
          created_at $textType,
          updated_at $textType
        )
      ''');

      await db.execute('''
        CREATE TABLE transactions (
          id $idType,
          wallet_id $integerType,
          title $textType,
          description TEXT,
          amount REAL NOT NULL,
          type $textType,
          category $textType,
          created_at $textType,
          updated_at $textType,
          FOREIGN KEY (wallet_id) REFERENCES wallets (id) ON DELETE CASCADE
        )
      ''');
    }
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

  // Wallet CRUD operations
  Future<int> insertWallet(Wallet wallet) async {
    final db = await instance.database;
    return await db.insert('wallets', wallet.toMap());
  }

  Future<List<Wallet>> getAllWallets() async {
    final db = await instance.database;
    final result = await db.query('wallets', orderBy: 'created_at DESC');
    return result.map((json) => Wallet.fromMap(json)).toList();
  }

  Future<Wallet?> getWallet(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'wallets',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Wallet.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateWallet(Wallet wallet) async {
    final db = await instance.database;
    return await db.update(
      'wallets',
      wallet.toMap(),
      where: 'id = ?',
      whereArgs: [wallet.id],
    );
  }

  Future<int> deleteWallet(int id) async {
    final db = await instance.database;
    return await db.delete(
      'wallets',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Transaction CRUD operations
  Future<int> insertTransaction(model.Transaction transaction) async {
    final db = await instance.database;
    return await db.insert('transactions', transaction.toMap());
  }

  Future<List<model.Transaction>> getTransactionsByWallet(int walletId) async {
    final db = await instance.database;
    final result = await db.query(
      'transactions',
      where: 'wallet_id = ?',
      whereArgs: [walletId],
      orderBy: 'created_at DESC',
    );
    return result.map((json) => model.Transaction.fromMap(json)).toList();
  }

  Future<List<model.Transaction>> getAllTransactions() async {
    final db = await instance.database;
    final result = await db.query('transactions', orderBy: 'created_at DESC');
    return result.map((json) => model.Transaction.fromMap(json)).toList();
  }

  Future<model.Transaction?> getTransaction(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return model.Transaction.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateTransaction(model.Transaction transaction) async {
    final db = await instance.database;
    return await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  Future<int> deleteTransaction(int id) async {
    final db = await instance.database;
    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Helper method to update wallet balance based on transactions
  Future<void> updateWalletBalance(int walletId) async {
    final db = await instance.database;
    final transactions = await getTransactionsByWallet(walletId);
    
    double balance = 0.0;
    for (final transaction in transactions) {
      switch (transaction.type) {
        case model.TransactionType.income:
          balance += transaction.amount;
          break;
        case model.TransactionType.expense:
          balance -= transaction.amount;
          break;
        case model.TransactionType.transfer:
          // For transfers, you might need additional logic
          // depending on whether it's incoming or outgoing
          break;
      }
    }

    await db.update(
      'wallets',
      {'balance': balance, 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [walletId],
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
