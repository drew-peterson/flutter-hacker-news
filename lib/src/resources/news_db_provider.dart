import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io'; // Directory
import 'package:path/path.dart';
import 'dart:async';
import '../models/item_model.dart';
import 'repository.dart';

class NewsDbProvider implements Source, Cache {
  Database db; // from sqflite

  NewsDbProvider() {
    init(); // run init when created
  }

  // cannot do async inside constructor
  void init() async {
    Directory documentsDirectory =
        await getApplicationDocumentsDirectory(); // path_provider returns reference to folder on device
    final path = join(documentsDirectory.path,
        'items5.db'); // reference to db why 4?? because sometimes you have to reset database so increase num

    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database newDb, int version) {
        newDb.execute("""
          CREATE TABLE Items
            (
              id INTEGER PRIMARY KEY,
              type TEXT,
              by TEXT,
              time INTEGER,
              text TEXT,
              parent INTEGER,
              kids BLOB,
              dead INTEGER,
              deleted INTEGER,
              url TEXT,
              score INTEGER,
              title TEXT,
              descendants INTEGER
            )
        """);
      },
    );
  }

  Future<ItemModel> fetchItem(int id) async {
    // called maps because its a list of map objects List<Map<String, dynamic>> = [{'id': 1}]
    final maps = await db.query(
      'Items',
      columns:
          null, // optional ['title', 'id'] get back just the title and id column
      where: 'id = ?', // ? is replaced with first whereArgs
      whereArgs: [id],
    );
    // maps as this point is
    if (maps.length > 0) {
      // what to keep our resrouces return same type so we want to convert to ItemModel type and return
      return ItemModel.fromDb(maps.first);
    }
    return null;
  }

  Future<int> addItem(ItemModel item) {
    // dont care about return of insertion so no async...
    return db.insert(
      'Items',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<int>> fetchTopIds() {
    // TODO: implement fetchTopIds
    return null;
  }

  Future<int> clear() {
    return db.delete('Items');
  }
}

// we want to create only 1 connection to sql db so just reference this var
final newsDbProvider = NewsDbProvider();
