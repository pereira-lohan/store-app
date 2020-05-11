import 'package:applojavirtual/datas/product_data.dart';
import 'package:applojavirtual/tiles/product_tile.dart';
import 'package:applojavirtual/widgets/custom_circular_progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  final DocumentSnapshot snapshot;

  ProductScreen(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(snapshot.data['title']),
            centerTitle: true,
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: <Widget>[
                Tab(icon: Icon(Icons.grid_on)),
                Tab(
                  icon: Icon(Icons.list),
                )
              ],
            ),
          ),
          body: FutureBuilder<QuerySnapshot>(
            future: Firestore.instance
                .collection('products')
                .document(snapshot.documentID)
                .collection('itens')
                .getDocuments(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return CustomCircularProgressIndicator();
              else
                return TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    //Neste caso estamos utilizando o builder para ir adicionando
                    //novos itens no grid ou na lista conforme a necessidade
                    GridView.builder(
                        padding: EdgeInsets.all(4.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 4.0,
                          //Isso é a razão entre Largura para Altura
                          childAspectRatio: 0.65,
                        ),
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          ProductData data = ProductData.fromDocument(
                              snapshot.data.documents[index]);
                          data.category = this.snapshot.documentID;
                          return ProductTile('grid', data);
                        }),
                    ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          ProductData data = ProductData.fromDocument(
                              snapshot.data.documents[index]);
                          data.category = this.snapshot.documentID;
                          return ProductTile('list', data);
                        })
                  ],
                );
            },
          ),
        ));
  }
}
