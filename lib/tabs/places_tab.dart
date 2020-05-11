import 'package:applojavirtual/tiles/place_tile.dart';
import 'package:applojavirtual/widgets/custom_circular_progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PlacesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance.collection('places').getDocuments(),
      builder: (context, snapshot){
        if (!snapshot.hasData){
          return CustomCircularProgressIndicator();
        } else {
          return ListView(
            children: snapshot.data.documents
                .map((doc) => PlaceTile(doc)).toList()
          );
        }
      }
    );
  }
}
