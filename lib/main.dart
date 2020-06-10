import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,

      ),
      home: MyHomePage(title: 'Je veux ...'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

   final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String nouvelleListe;

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          new FlatButton(
            onPressed: ajouter,
            child: new Text("Ajouter", style: new TextStyle(color: Colors.white, fontSize: 18.0)),
          )
        ],
      ),
      body: Center(
           child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

          ],
        ),
      ),
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
             FlatButton(
               onPressed: () {
                 Navigator.pop(buildContext);
               },
               child: Text(
                 "Annuler",
               ),
             ),
             new FlatButton(onPressed: (){
               Navigator.pop(buildContext);
             }, child: new Text("Valider", style: new TextStyle(color: Colors.blue),))
           ],
         );
       }
     );
  }

}
