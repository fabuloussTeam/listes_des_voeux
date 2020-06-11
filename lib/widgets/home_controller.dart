import 'package:applicationlistesdessouhait/model/databaseClient.dart';
import 'package:applicationlistesdessouhait/model/item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'donnees_vides.dart';


class HomeController extends StatefulWidget {
  HomeController({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeControllerState createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {

  String nouvelleListe;
  List<Item> items;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    recuperer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          new FlatButton(
            onPressed: ajouter,
            child: new Text(
                "Ajouter",
                style: new TextStyle(color: Colors.white, fontSize: 18.0),
            ),
          )
        ],
      ),
      body: (items == null || items.length == 0 )
       ? new DonneesVides()
          : new ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, i){
            Item item = items[i];
            return new ListTile(
              title: new Text(item.nom),
            );
          }
      )
    );
  }

  Future<Null> ajouter() async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext buildContext) {
          return new AlertDialog(
            title: new Text("Ajouter une liste de souhaits"),
            content: new TextField(
              decoration: new InputDecoration(
                labelText: "Liste:",
                hintText: "ex: mes prochains jeux videos",
              ),
              onChanged: (String str){
                nouvelleListe = str;
              },
            ),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  Navigator.pop(buildContext);
                },
                child: Text(
                  "Annuler",
                ),
              ),
              new FlatButton(onPressed: (){
                // Ajouter le code pour ajouter a la base de données
                if (nouvelleListe != null){
                  Map<String, dynamic> map = {'nom': nouvelleListe};
                  Item item = new Item();
                  item.fromMap(map);
                  DatabaseClient().ajoutItem(item).then((i) => recuperer());
                  nouvelleListe = null;
                }

                Navigator.pop(buildContext);
              }, child: new Text("Valider", style: new TextStyle(color: Colors.blue),))
            ],
          );
        }
    );
  }

  // Recuperation de tous les elements de la BDD 'databaseClient'
  void recuperer(){
    DatabaseClient().allItem().then((items) {
      setState(() {
        this.items = items;
      });
    });
  }

}
