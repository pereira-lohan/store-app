import 'package:applojavirtual/datas/cart_product.dart';
import 'package:applojavirtual/datas/product_data.dart';
import 'package:applojavirtual/models/cart_model.dart';
import 'package:applojavirtual/models/user_model.dart';
import 'package:applojavirtual/screens/login_screen.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'cart_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductData product;
  ProductDetailsScreen(this.product);
  @override
  _ProductDetailsScreenState createState() =>
      _ProductDetailsScreenState(this.product);
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final ProductData product;
  String size;
  _ProductDetailsScreenState(this.product);
  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          AspectRatio(
              aspectRatio: 0.9,
              child: Carousel(
                  images: product.images.map((url) {
                    return NetworkImage(url);
                  }).toList(),
                  dotSize: 5.0,
                  dotSpacing: 15.0,
                  dotBgColor: Colors.transparent,
                  dotColor: primaryColor,
                  autoplay: true,
                  autoplayDuration: Duration(seconds: 20))),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  product.title,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                  maxLines: 3,
                ),
                Text(
                  "R\$ ${product.price.toStringAsFixed(2)}",
                  style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
                SizedBox(height: 16.0),
                Text('Tamanhos',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
                SizedBox(
                    height: 34.0,
                    child: GridView(
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                        scrollDirection: Axis.horizontal,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            mainAxisSpacing: 8.0,
                            childAspectRatio: 0.5),
                        children: product.sizes.map((s) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                //Para remover a seleção
                                size = (size != s) ? s : null;
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0)),
                                  border: Border.all(
                                      color: s == size
                                          ? primaryColor
                                          : Colors.grey[500],
                                      width: 3.0),
                                ),
                                width: 50.0,
                                alignment: Alignment.center,
                                child: Text(s)),
                          );
                        }).toList())),
                SizedBox(height: 16.0),
                SizedBox(
                    height: 44.0,
                    child: RaisedButton(
                      onPressed: size != null
                          ? () {
                              if (UserModel.of(context).isLoggedIn()) {
                                CartProduct cartProduct = CartProduct();
                                cartProduct.size = size;
                                cartProduct.quantity = 1;
                                cartProduct.idProduct = product.id;
                                cartProduct.category = product.category;
                                cartProduct.productData = product;
                                CartModel.of(context).addCartItem(cartProduct);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => CartScreen()));
                              } else {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                              }
                            }
                          : null,
                      //Neste caso, poderia utilizar o ScopedModelDescendant,
                      //Mas estamos repetindo isso para fins de aprendizado
                      child: Text(
                        UserModel.of(context).isLoggedIn()
                            ? 'Adicionar ao Carrinho'
                            : 'Entre para Comprar',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      color: primaryColor,
                      textColor: Colors.white,
                    )),
                SizedBox(height: 16.0),
                Text('Descrição',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
                Text(
                  product.description,
                  style: TextStyle(fontSize: 16.0),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
