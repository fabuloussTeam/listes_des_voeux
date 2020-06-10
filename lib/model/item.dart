// A note que ce fichier fait correspondre les elent recu de la BDD
class Item {

  int id;
  String nom;

  Item();

  void fromMap(Map<String, dynamic> map){
    this.id = map['id'];
    this.nom = map['nom'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'nom': this.nom, //'nom' ici c'est la cléé de map['nom']
    };
    if (id != null){
      map['id'] = this.id;
    }
  }
}