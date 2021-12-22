import 'package:attendance/Model/KharchaModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'kharcha.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE kharchas(id INTEGER PRIMARY KEY AUTOINCREMENT, kharchaName TEXT NOT NULL,amount INTEGER NOT NULL)",
        );
      },
      version: 1,
    );
  }
  Future<int> insertKharcha(List<KharchaModel> kharchas) async {
    int result = 0;
    final Database db = await initializeDB();
    for(var kharcha in kharchas){
      result = await db.insert('kharchas', kharcha.toMap());
    }
    return result;
  }
  Future<List<KharchaModel>> retrieveKharcha() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('kharchas');
    return queryResult.map((e) => KharchaModel.fromMap(e)).toList();
  }

  Future<void> deleteKharcha(int id) async {
    final db = await initializeDB();
    await db.delete(
      'kharchas',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
