import 'package:applojavirtual/tiles/category_tile.dart';
import 'package:applojavirtual/widgets/custom_circular_progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: Firestore.instance
            .collection("products")
            .orderBy("title")
            .getDocuments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return CustomCircularProgressIndicator();
          else {
            var dividedTiles = ListTile.divideTiles(
              tiles: snapshot.data.documents.map((doc) {
                return CategoryTile(doc);
              }).toList(),
              color: Colors.grey[500],
            ).toList();
            return ListView(children: dividedTiles);
          }
        });
  }
}
