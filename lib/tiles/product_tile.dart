import 'package:applojavirtual/datas/product_data.dart';
import 'package:applojavirtual/screens/product_details_screen.dart';
import 'package:applojavirtual/screens/products_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductTile extends StatelessWidget {
  final String type;
  final ProductData product;

  ProductTile(this.type, this.product);

  @override
  Widget build(BuildContext context) {
    //uma das diferenças entre o GestureDetector e o InkWell, é que o InkWell
    //dá um efeito bacana na hora de tocar no widget
    return InkWell(
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ProductDetailsScreen(product))
        );
      },
      child: Card(
          elevation: 2,
          child: this.type == "grid"
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 0.8,
                      child:
                          Image.network(product.images[0], fit: BoxFit.cover),
                    ),
                    Expanded(
                      child: Container(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                product.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                                //Caso de um overflow, vai aparecer "..."
                                //e aí fica sem o Bug visual
                                overflow: TextOverflow.ellipsis,
                                //Forcei uma linha apenas para não cobrir o preço
                                //fora que se deixar duas linhas, ainda dá bug
                                maxLines: 1,
                              ),
                              Text("R\$ ${product.price.toStringAsFixed(2)}",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17.0)),
                            ],
                          )),
                    )
                  ],
                )
              : Row(
                  children: <Widget>[
                    //Para dividirmos igualmente o Card na Horizontal,
                    //utilizamos o Flexible com flex: 1
                    Flexible(
                      flex: 1,
                      child: Image.network(
                        product.images[0],
                        fit: BoxFit.cover,
                        height: 250.0,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                product.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text("R\$ ${product.price.toStringAsFixed(2)}",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17.0)),
                            ],
                          )),
                    ),
                  ],
                )),
    );
  }
}
