import 'dart:io';
import 'package:applicationlistesdessouhait/model/item.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
// Creation de la base de donne et notre table: NB: dart utilise SQL
class DatabaseClient {

  Database _database;

  Future<Database> get database async {
    if(_database != null) {
      return _database;
    } else {
      // Creer cette database si c'est null
      _database = await create();
      return _database;
    }
  }

  // Creation de la DB:
  // recuperation du dossier racine ("directory") de la BD avec la librairie  "path_provider"
  Future create() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String database_directory = join(directory.path, 'database.db'); // librairie path.dart
    var bdd = await openDatabase(database_directory, version: 1, onCreate: _onCreate);
    return bdd;
  }

  // Creation de la table 'item' dans la BDD
  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE item (
      id INTEGER PRIMARY KEY,
      nom TEXT NOT NULL) 
    ''');
  }

  // Fuction d'ajout d'un item dans la table

 Future<Item> ajoutItem(Item item)async {
    Database maDatabase = await database;
    item.id = await maDatabase.insert('item', item.toMap());
    return item;
 }


}
