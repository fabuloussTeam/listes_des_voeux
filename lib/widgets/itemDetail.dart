import 'package:flutter/material.dart';
import 'package:applicationlistesdessouhait/model/item.dart';

class ItemDetail extends StatefulWidget {
  Item item;

  ItemDetail(Item item){
    this.item = item;

  }

  @override
  _ItemDetailState createState() => new _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.item.nom),
      ),
    );
  }
}