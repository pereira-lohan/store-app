import 'package:applojavirtual/models/user_model.dart';
import 'package:applojavirtual/screens/login_screen.dart';
import 'package:applojavirtual/tiles/order_tile.dart';
import 'package:applojavirtual/widgets/custom_circular_progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrdersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (UserModel.of(context).isLoggedIn()){
      String uid = UserModel.of(context).firebaseUser.uid;
      return FutureBuilder<QuerySnapshot>(
        future: Firestore.instance
            .collection('users')
            .document(uid).collection('orders').getDocuments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CustomCircularProgressIndicator();
          } else {
            return ListView(
              children: snapshot.data.documents
                  .map((doc) => OrderTile(doc.documentID))
                  .toList()
                  .reversed.toList(), //Inverter a Lista
            );
          }
        },
      );
    } else {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.view_list,
                size: 80.0,
                color: Theme.of(context).primaryColor
            ),
            SizedBox(height: 16.0),
            Text('Faça Login para acompanhar os pedidos',
              maxLines: 2,
              style: TextStyle(fontSize: 20.0,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),
            SizedBox(
              height: 44.0,
              child: RaisedButton(
                child: Text('Entrar',
                    style: TextStyle(fontSize: 18.0)),
                textColor: Colors.white,
                color: Theme.of(context).primaryColor,
                onPressed: (){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginScreen())
                  );
                },
              ),
            )
          ],
        ),
      );
    }
  }
}