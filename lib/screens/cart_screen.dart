import 'package:applojavirtual/models/cart_model.dart';
import 'package:applojavirtual/models/user_model.dart';
import 'package:applojavirtual/screens/login_screen.dart';
import 'package:applojavirtual/screens/order_screen.dart';
import 'package:applojavirtual/tiles/cart_tile.dart';
import 'package:applojavirtual/widgets/cart_price.dart';
import 'package:applojavirtual/widgets/custom_circular_progress.dart';
import 'package:applojavirtual/widgets/discount_card.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meu Carrinho'),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 8.0),
            alignment: Alignment.center,
            child: ScopedModelDescendant<CartModel>(
              builder: (context, child, model){
                int countProducts = model.products.length;
                return Text(
                  '${countProducts ?? 0} ${countProducts == 1 ? 'ITEM' : 'ITENS'}',
                  style: TextStyle(fontSize: 17.0),
                );
              },
            )
          ),
        ],
      ),
      body: ScopedModelDescendant<CartModel>(
        builder: (context, child, model){
          if (model.isLoading && UserModel.of(context).isLoggedIn()){
            return CustomCircularProgressIndicator();
          } else if (!UserModel.of(context).isLoggedIn()){
            return Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.remove_shopping_cart,
                    size: 80.0,
                    color: Theme.of(context).primaryColor
                  ),
                  SizedBox(height: 16.0),
                  Text('Faça Login para adicionar produtos',
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
          } else if (model.products == null || model.products.length == 0){
            return Center(
              child: Text('Nenhum produto adicionado',
                maxLines: 2,
                style: TextStyle(fontSize: 20.0,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return ListView(
              children: <Widget>[
                Column(
                  children: model.products.map((product){
                    return CartTile(product);
                  }).toList(),
                ),
                DiscountCard(),
                CartPrice(() async {
                  String orderId = await model.finishOrder();
                  if (orderId != null)
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context)=> OrderScreen(orderId))
                    );
                }),
              ],
            );
          }
        }
      )
    );
  }
}
