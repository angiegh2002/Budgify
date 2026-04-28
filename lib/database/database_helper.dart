import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _db;

  static const String dbName = "budgify.db";

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  static Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), dbName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {



        await db.execute('''
          CREATE TABLE categories (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            type TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE transactions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            amount REAL NOT NULL,
            currency TEXT NOT NULL,
            type TEXT NOT NULL,
            category_id INTEGER,
            notes TEXT,
            date TEXT NOT NULL,
            FOREIGN KEY (category_id) REFERENCES categories(id)
          )
        ''');
      },
    );
  }



  static Future<int> insertCategory(String name, String type) async {
    final db = await database;

    return await db.insert("categories", {
      "name": name,
      "type": type,
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

    return await db.delete(
      "categories",
      where: "id = ?",
      whereArgs: [id],
    );
  }



  static Future<int> insertTransaction({
    required double amount,
    required String currency,
    required String type,
    required int categoryId,
    required String notes,
  }) async {
    final db = await database;

    return await db.insert("transactions", {
      "amount": amount,
      "currency": currency,
      "type": type,
      "category_id": categoryId,
      "notes": notes,
      "date": DateTime.now().toString(),
    });
  }

  static Future<List<Map<String, dynamic>>> getTransactions() async {
    final db = await database;

    return await db.rawQuery('''
    SELECT 
      transactions.*,
      categories.name AS category_name
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



  static Future<double> getIncome() async {
    final db = await database;

    final result = await db.rawQuery(
      "SELECT SUM(amount) as total FROM transactions WHERE type='income'",
    );

    return (result.first["total"] as num?)?.toDouble() ?? 0.0;
  }
  static Future<double> getExpenses() async {
    final db = await database;

    final result = await db.rawQuery(
      "SELECT SUM(amount) as total FROM transactions WHERE type='expense'",
    );

    return (result.first["total"] as num?)?.toDouble() ?? 0.0;
  }


  static Future<double> getBalance() async {
    double income = await getIncome();
    double expenses = await getExpenses();

    return income - expenses;
  }



  static Future<void> insertDefaultCategories() async {
    final db = await database;

    List defaults = [
      {"name": "Salary", "type": "income"},
      {"name": "Freelance", "type": "income"},
      {"name": "Food", "type": "expense"},
      {"name": "Transport", "type": "expense"},
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