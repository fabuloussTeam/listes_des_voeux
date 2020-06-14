import 'dart:io';
import 'package:applicationlistesdessouhait/model/item.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'item.dart';
import 'article.dart';
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

    await db.execute('''
    CREATE TABLE article (
      id INTEGER PRIMARY KEY,
      nom TEXT NOT NULL,
      item INTEGER,
      prix TEXT,
      magasin TEXT,
      image TEXT )
      ''');
  }

  // LECTURE DES DONNEES: recuperer tous les maps de la table
  Future<List<Item>> allItem() async {
    Database maDatabase = await database;
    List<Map<String, dynamic>> resultat = await maDatabase.rawQuery('SELECT * FROM item');
    List<Item> items = [];
    resultat.forEach((map) {
      Item item = new Item();
      item.fromMap(map);
      items.add(item);
    });
    return items;
  }

  // SUPRIMER UN ELEMENT DANS LA BDD:
  Future<int> delete(int id, String table) async { //  string table:  c'est notre item
    Database maDatabase = await database;
    return await maDatabase.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  /** MISE A JOUR D'UN ITEM */

  /*Future<int> updateItem(Item item) async {
    Database maDatabase = await database;
    return await maDatabase.update('item', item.toMap(), where: 'id = ?', whereArgs: [item.id]);
}*/

  // Fuction d'ajout d'un item dans la table:  ECRITURE DES DONNEES
  /*Future<Item> ajoutItem(Item item)async {
    Database maDatabase = await database; //ici on verifi que la BDD est creer avant d'ajouter
    item.id = await maDatabase.insert('item', item.toMap());
    print("sorti d'ajou un element: ${item.id}");
    return item;
 }*/



  /** Function UpsertItem: ca signifie update ou insert a la fois
   *  Nous avons la function ajoutItem() plus haut qui permetais d'ajouter uniquement
   * **/

  Future<Item> upsertItem(Item item) async {
    Database maDatabase = await database;
    if(item.id == null){
      item.id = await maDatabase.insert('item', item.toMap());
      print("sorti de upsertItem : ${item.id} ");
    } else {
      await maDatabase.update('item', item.toMap(), where: 'id = ?', whereArgs: [item.id]);
    }
    return item;
  }

  /** Fonction d'ajout et de mise a jour d'un article dans la page itemDetail **/
  Future<Article> upsertArticle(Article article) async {
      Database maDatabase = await database;
      if(article.id == null){
        article.id = await maDatabase.insert('article', article.toMap());
        print("sorti de l'ID de l'aricle ${article.id}");

      } else {
        await maDatabase.update('article', article.toMap(), where: 'id = ?', whereArgs: [article.id]);
      }
      return article;
  }




}
