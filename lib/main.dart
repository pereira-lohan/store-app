import 'package:applojavirtual/models/cart_model.dart';
import 'package:applojavirtual/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'models/user_model.dart';

void main() => runApp(MyStore());

class MyStore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //aqui é para termos acesso ao UserModel
    return ScopedModel<UserModel>(
      model: UserModel(),
      //Aqui o ScopedModel do Cart foi colocado em um Descendant para caso haja
      //modificação no user, seja refletido para todos os outros models existentes
      child: ScopedModelDescendant<UserModel>(
        builder: (context, child, model){
          //O ScopedModel do Cart ficou dentro do User pois precisamos acessar o
          //usuário para carregar seus produtos do cart.
          return ScopedModel<CartModel>(
            model: CartModel(model),
            child: MaterialApp(
              title: 'Retrô Sabor da Vovó',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                primaryColor: Color.fromARGB(255, 4, 125, 141),
              ),
              debugShowCheckedModeBanner: false,
              home: HomeScreen(),
            ),
          );
        },
      )
    );
  }
}
