import 'package:inventory_management_system_3/model/inventory.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SQLHelper {
  static final SQLHelper _instance = SQLHelper.internal();
  factory SQLHelper() => _instance;
  SQLHelper.internal();
  static Database? _db;

  Future<Database> createDatabase() async {
    if (_db != null) {
      return _db!;
    }
    String path = join(await getDatabasesPath(), 'inventory3.db');
    _db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) {
      db.execute(
          "CREATE TABLE items(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, description TEXT, quantity REAL, price REAL)");
    });
    return _db!;
  }

  Future<int> createItem(Inventory inventory) async {
    Database db = await createDatabase();
    return db.insert('items', inventory.toMap());
  }

  Future<List<Map<String, dynamic>>> getItems() async {
    Database db = await createDatabase();
    return db.query('items');
  }

  Future<int> deleteItem(int id) async {
    Database db = await createDatabase();
    return db.delete('items', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateItem(Inventory inventory) async {
    Database db = await createDatabase();
    return db.update('items', inventory.toMap(),
        where: 'id = ?', whereArgs: [inventory.id]);
  }
}
