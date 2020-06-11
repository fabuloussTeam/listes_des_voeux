// A note que ce fichier fait correspondre les elent recu de la BDD
class Item {

  int id;
  String nom;

  Item();

  //recuperation de la BDD objet fromMap puis convertion en toMap pour l'affichage
  void fromMap(Map<String, dynamic> map){
    this.id = map['id'];
    this.nom = map['nom'];
  }


  /* La function ci dessous, on ajoute 'id' dans notre 'map': map['id'] = this.id*.
  cette map doit etre ajouter a la BDD
   */
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'nom': this.nom, //'nom' ici c'est la cléé de map['nom']
    };
    if (id != null){
      map['id'] = this.id;
    }
    return map;
  }
}