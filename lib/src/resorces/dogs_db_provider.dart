import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../models/dog_model.dart';

class DogDbProvider {
  DogDbProvider._();

  static final DogDbProvider db = DogDbProvider._();
  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await getDatabaseInstance();
    return _database;
  }

  Future<Database> getDatabaseInstance() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "dogs.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Dogs ("
          "id integer primary key,"
          "name TEXT,"
          "image TEXT"
          ")");
    });
  }

  addDogToDatabase(DogModel dog) async {
    final db = await database;
    var raw = await db.insert(
      "Dogs",
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  Future<List<DogModel>> getAllDogs() async {
    final db = await database;
    var response = await db.query("Dogs");
    List<DogModel> list = response.map((c) => DogModel.fromMap(c)).toList();
    return list;
  }

  deleteDogWithId(int id) async {
    final db = await database;
    return db.delete("Dogs", where: "id = ?", whereArgs: [id]);
  }

  deleteAllDogs() async {
    final db = await database;
    db.delete("Dogs");
  }
}
