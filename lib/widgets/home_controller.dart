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
            new FlatButton(onPressed: (() => ajouter(null)), child: new Text("Ajouter",
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
                trailing: new IconButton(
                  icon: new Icon(Icons.delete),
                  onPressed: (){
                    DatabaseClient().delete(item.id, 'item').then((int) {
                      print("L'int recuperer est : $int");
                      recuperer();
                    });
                  },
                ),
                leading: new IconButton(
                    icon: new Icon(Icons.edit),
                    onPressed: (()=>ajouter(item))
                ),
              );
            }
        )
    );
  }

  Future<Null> ajouter(Item item) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext buildContext) {
          return new AlertDialog(
            title: new Text("Ajouter une liste de souhaits"),
            content: new TextField(
              decoration: new InputDecoration(
                labelText: "Liste:",
                hintText: (item == null) ? "ex: mes prochains jeux videos" : item.nom,
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
              new FlatButton(
                  onPressed: (){
                    // Ajouter le code pour ajouter a la base de données
                    if (nouvelleListe != null){
                      if(item == null){
                        Map<String, dynamic> map = {'nom': nouvelleListe};
                        item = new Item();
                        item.fromMap(map);
                        print("qd item est null : ${item.nom}");
                     } else {
                        item.nom = nouvelleListe;

                        print("qd item est non null : ${item.nom}");
                      }

                      DatabaseClient().upsertItem(item).then((i) => recuperer());
                      nouvelleListe = null;
                     // print(item);
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
