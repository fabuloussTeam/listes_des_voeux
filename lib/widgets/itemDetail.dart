import 'dart:io';

import 'package:applicationlistesdessouhait/widgets/ajout_article.dart';
import 'package:flutter/material.dart';
import 'package:applicationlistesdessouhait/model/item.dart';
import 'package:applicationlistesdessouhait/model/article.dart';
import 'package:applicationlistesdessouhait/widgets/donnees_vides.dart';
import 'package:applicationlistesdessouhait/model/databaseClient.dart';

class ItemDetail extends StatefulWidget {
  Item item;

  ItemDetail(Item item){
    this.item = item;
  }

  @override
  _ItemDetailState createState() => new _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {

  List<Article> articles;
  bool deleteArticle = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DatabaseClient().allArticles(widget.item.id).then((liste) {
      print("la liste des article de ${widget.item.id} ");
      setState(() {
        articles = liste;
      });
    });
  }

  // Recuperation de tous les elements de la BDD 'databaseClient'
  void recuperer(){
    DatabaseClient().allArticles(widget.item.id).then((articles) {
      setState(() {
        this.articles = articles;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return new Scaffold(
        appBar: new AppBar(
            title: new Text(widget.item.nom),
            actions: <Widget>[
              new FlatButton( onPressed: () {
                    Navigator.push(context, new MaterialPageRoute(
                    builder: (BuildContext buildContext) { return new Ajout(widget.item.id); }
                  )).then((onValue){
                      DatabaseClient().allArticles(widget.item.id).then((liste) {
                        print("la liste des article de ${widget.item.id} ");
                          setState(() {
                            articles = liste;
                          });
                      });
                  });
                },
               child: new Text('ajouter', style: new TextStyle(color: Colors.white) ),
              ),
            ],
    ),
    body: (articles == null || articles.length == 0)
    ? new DonneesVides()
        : new GridView.builder(
    itemCount: articles.length,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
      itemBuilder: (context, i) {
      Article article = articles[i];
        return new SingleChildScrollView(
         //  padding: EdgeInsets.only(top: 10.0, left: 5.0, bottom: 5.0, right: 5.0),
          child: new InkWell(
            onLongPress: (){
              setState(() {
                 deleteArticle = !deleteArticle;
                 print(deleteArticle);
              });
            },
            child:  new Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                (deleteArticle == true)
                    ? new Row(

                      children: <Widget>[
                        new Padding(padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 10, left: 10)),
                        new IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed:(){
                            DatabaseClient().deleteArticle(article.id, 'article').then((int) {
                              print("L'int recuperer est : $int");
                              recuperer();
                            });
                          }
                          ),
                        new Text("Supprimer", style: new TextStyle(color: Colors.red))
                      ],
                    )
                    : new Padding(padding: EdgeInsets.only(top: 0.0)),
                new Text(article.nom),
                new Container(
                  width: width / 1.5,
                  height: height / 2,
                  child:  (article.image == null)
                      ? new Image.asset("images/avatar-1577909_1280.png")
                      : new Image.file(new File(article.image)),
                ),

                new Text((article.image == null) ? 'Aucun prix renseigné' : "Prix: ${article.prix}"),
                new Text((article.magasin == null) ? 'Aucun magasin renseigné' : "Magasin: ${article.magasin}")
              ],
            ),
          )
        );
      },
    )
    );
  }
}