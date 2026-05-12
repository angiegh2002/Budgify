import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _db;

  static const String dbName = "budgify.db";

  static const String baseCurrency = "USD";

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  static Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), dbName);

    return await openDatabase(
      path,
      version: 3,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE categories (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          type TEXT NOT NULL,
          color INTEGER NOT NULL,
          icon INTEGER NOT NULL
        )
      ''');

        await db.execute('''
        CREATE TABLE transactions (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          amount REAL NOT NULL,            
          base_amount REAL NOT NULL,       
          currency TEXT NOT NULL,
          type TEXT NOT NULL,
          category_id INTEGER,
          notes TEXT,
          date TEXT NOT NULL,
          FOREIGN KEY (category_id) REFERENCES categories(id)
        )
      ''');
      },

      onUpgrade: (db, oldVersion, newVersion) async {

        await db.transaction((txn) async {
          if (oldVersion < 2) {
            await _safeAddColumn(txn as Database, 'categories', 'color', 'INTEGER DEFAULT 0xFF000000');
            await _safeAddColumn(txn as Database, 'categories', 'icon', 'INTEGER DEFAULT 0');
          }

          if (oldVersion < 3) {
            await _safeAddColumn(txn as Database, 'transactions', 'base_amount', 'REAL DEFAULT 0');
          }
        });
      },

    );
  }
  static Future<void> _safeAddColumn(
      Database db,
      String tableName,
      String columnName,
      String columnDefinition,
      ) async {
    try {
      final info = await db.rawQuery('PRAGMA table_info($tableName)');
      final exists = info.any((col) => col['name'].toString() == columnName);

      if (!exists) {
        await db.execute('ALTER TABLE $tableName ADD COLUMN $columnName $columnDefinition');
      }
    } catch (e) {
      debugPrint(' Migration warning for $tableName.$columnName: $e');
    }
  }
  static Future<int> insertCategory(
      String name,
      String type,
      int color,
      int icon,
      ) async {
    final db = await database;

    return await db.insert("categories", {
      "name": name,
      "type": type,
      "color": color,
      "icon": icon,
    });
  }

  static Future<List<Map<String, dynamic>>> getCategories() async {
    final db = await database;
    return await db.query("categories");
  }

  static Future<List<Map<String, dynamic>>> getCategoriesByType(
      String type) async {
    final db = await database;

    return await db.query(
      "categories",
      where: "type = ?",
      whereArgs: [type],
    );
  }

  static Future<int> deleteCategory(int id) async {
    final db = await database;

    final result = await db.query(
      "transactions",
      where: "category_id = ?",
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      throw Exception("Cannot delete category in use");
    }

    return await db.delete(
      "categories",
      where: "id = ?",
      whereArgs: [id],
    );
  }

  static Future<int> updateCategory(
      int id,
      String newName,
      int color,
      int icon,
      ) async {
    final db = await database;

    return await db.update(
      "categories",
      {
        "name": newName,
        "color": color,
        "icon": icon,
      },
      where: "id = ?",
      whereArgs: [id],
    );
  }

  static Future<int> insertTransaction({
    required double amount,
    required double baseAmount,
    required String currency,
    required String type,
    required int categoryId,
    required String notes,
  }) async {
    final db = await database;

    return await db.insert("transactions", {
      "amount": amount,
      "base_amount": baseAmount,
      "currency": currency,
      "type": type,
      "category_id": categoryId,
      "notes": notes,
      "date": DateTime.now().toIso8601String(),
    });
  }

  static Future<List<Map<String, dynamic>>> getTransactions() async {
    final db = await database;

    return await db.rawQuery('''
    SELECT 
      transactions.*,
      categories.name AS category_name,
      categories.icon AS category_icon,
      categories.color AS category_color
    FROM transactions
    LEFT JOIN categories
    ON transactions.category_id = categories.id
    ORDER BY transactions.id DESC
  ''');
  }

  static Future<int> deleteTransaction(int id) async {
    final db = await database;

    return await db.delete(
      "transactions",
      where: "id = ?",
      whereArgs: [id],
    );
  }

  static Future<void> updateTransaction({
    required int id,
    required double amount,
    required double baseAmount,
    required String type,
    required int categoryId,
    required String notes,
    required String currency,
  }) async {
    final db = await database;

    await db.update(
      "transactions",
      {
        "amount": amount,
        "base_amount": baseAmount,
        "type": type,
        "category_id": categoryId,
        "notes": notes,
        "currency": currency,
      },
      where: "id = ?",
      whereArgs: [id],
    );
  }

  static Future<double> getIncome() async {
    final db = await database;

    final now = DateTime.now();

    final result = await db.rawQuery("""
    SELECT SUM(base_amount) as total
    FROM transactions
    WHERE type = 'income'
    AND strftime('%Y', date) = ?
    AND strftime('%m', date) = ?
  """, [
      now.year.toString(),
      now.month.toString().padLeft(2, '0'),
    ]);

    return (result.first["total"] as num?)?.toDouble() ?? 0.0;
  }

  static Future<double> getExpenses() async {
    final db = await database;

    final now = DateTime.now();

    final result = await db.rawQuery("""
    SELECT SUM(base_amount) as total
    FROM transactions
    WHERE type = 'expense'
    AND strftime('%Y', date) = ?
    AND strftime('%m', date) = ?
  """, [
      now.year.toString(),
      now.month.toString().padLeft(2, '0'),
    ]);

    return (result.first["total"] as num?)?.toDouble() ?? 0.0;
  }

  static Future<double> getBalance() async {
    double income = await getIncome();
    double expenses = await getExpenses();

    return income - expenses;
  }

  static Future<void> insertDefaultCategories() async {
    final db = await database;

    List<Map<String, dynamic>> defaults = [
      {
        "name": "Salary",
        "type": "income",
        "color": 0xFF4CAF50,
        "icon": Icons.attach_money.codePoint,
      },
      {
        "name": "Freelance",
        "type": "income",
        "color": 0xFF2196F3,
        "icon": Icons.work.codePoint,
      },
      {
        "name": "Food",
        "type": "expense",
        "color": 0xFFFF5722,
        "icon": Icons.fastfood.codePoint,
      },
      {
        "name": "Transport",
        "type": "expense",
        "color": 0xFF9C27B0,
        "icon": Icons.directions_car.codePoint,
      },
    ];

    for (var c in defaults) {
      final result = await db.query(
        "categories",
        where: "name = ?",
        whereArgs: [c["name"]],
      );

      if (result.isEmpty) {
        await db.insert("categories", c);
      }
    }
  }
}