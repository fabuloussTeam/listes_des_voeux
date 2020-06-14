import 'dart:io';

import 'package:applicationlistesdessouhait/model/databaseClient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:applicationlistesdessouhait/model/article.dart';

class Ajout extends StatefulWidget {
  int id;

  Ajout(int id){
    this.id = id;
    print("l'id recu est ${this.id}");
  }

  @override
  _AjoutState createState() => _AjoutState();

}

class _AjoutState extends State<Ajout> {

  String image;
  String nom;
  String magasin;
  String prix;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Ajouter'),
        actions: <Widget>[
          new FlatButton(
              onPressed: ajouter,
              child: new Text('valider', style: new TextStyle(color: Colors.white),)
          )
        ],
      ),
      body: new SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: new Column(
          children: <Widget>[
            new Text('Article à ajouter', textScaleFactor: 1.4, style: new TextStyle(color: Colors.red, fontStyle: FontStyle.italic)),
            new Card(
              elevation:10.0,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  (image == null)
                  ? new Image.asset('images/avatar-1577909_1280.png') : new Image.file(new File(image)),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new IconButton(icon: new Icon(Icons.camera_enhance), onPressed: null),
                      new IconButton(icon: new Icon(Icons.photo_library), onPressed: null)
                    ],
                  ),
                  textField(TypeTextField.nom, 'Nom de l\'article'),
                  textField(TypeTextField.prix, 'prix'),
                  textField(TypeTextField.magasin, 'Magasin'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  TextField textField(TypeTextField type, String label){
    return new TextField(
      decoration: new InputDecoration(labelText: label),
      onChanged: (String string) {
        switch (type) {
          case TypeTextField.nom:
            nom = string;
            print(nom);
            break;
          case TypeTextField.prix:
            prix = string;
            break;
          case TypeTextField.magasin:
            magasin = string;
            break;
        }
       }
      );
  }


  void ajouter() {
    if (nom != null) {
      Map<String, dynamic> map = { 'nom': nom, 'item': widget.id};
          print("sori de map dans ajout article: $map");
      if (magasin != null) {
        map['magasin'] = magasin;
      }
      if (prix != null) {
        map['prix'] = prix;
      }
      if (image != null) {
        map['image'] = image;
      }

      Article article = new Article();
      article.fromMap(map);
      DatabaseClient().upsertArticle(article).then((value) {
        image = null;
        nom = null;
        magasin = null;
        prix = null;
        Navigator.pop(context);
      });


    }
  }


}

enum TypeTextField { nom, prix, magasin }
